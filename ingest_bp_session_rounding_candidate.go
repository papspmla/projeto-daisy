package main

import (
	"bufio"
	"database/sql"
	"errors"
	"flag"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
	"time"

	_ "github.com/mattn/go-sqlite3"
)

type BPRecord struct {
	CollectionDate  string
	CollectionTime  *string
	Systolic        float64
	Diastolic       *float64
	MAP             *float64
	BodyPosition    *string
	MeasurementSite *string
	Condition       *string
	Source          string
	PatientID       int
	Method          *string
}

type TempRecord struct {
	CollectionDate string
	CollectionTime *string
	TemperatureC   float64
	Context        *string
	Source         string
	PatientID      int
}

func main() {
	dbPath := flag.String("db", "database/daisy.db", "SQLite database path")
	filePath := flag.String("file", "", "input TXT file")
	module := flag.String("module", "", "module: temperature | bp_legacy | bp_session")
	patientID := flag.Int("patient", 1, "patient_id")
	flag.Parse()

	if *filePath == "" {
		fmt.Println("missing -file")
		return
	}
	if *module == "" {
		fmt.Println("missing -module")
		return
	}

	db, err := sql.Open("sqlite3", *dbPath)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	switch *module {
	case "temperature":
		count, err := ingestTemperature(db, *filePath, *patientID)
		if err != nil {
			panic(err)
		}
		fmt.Printf("temperature records inserted: %d\n", count)

	case "bp_legacy":
		count, err := ingestBPLegacy(db, *filePath, *patientID)
		if err != nil {
			panic(err)
		}
		fmt.Printf("bp_legacy records inserted: %d\n", count)

	case "bp_session":
		count, err := ingestBPSession(db, *filePath, *patientID)
		if err != nil {
			panic(err)
		}
		fmt.Printf("bp_session records inserted: %d\n", count)

	default:
		fmt.Println("invalid -module (use temperature, bp_legacy or bp_session)")
	}
}

func ingestTemperature(db *sql.DB, filePath string, patientID int) (int, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return 0, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	inserted := 0

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		rec, ok, err := parseTemperatureLine(line, patientID)
		if err != nil {
			return inserted, err
		}
		if !ok {
			continue
		}

		res, err := db.Exec(`
			INSERT OR IGNORE INTO temperature
			(collection_date, collection_time, temperature_c, context, source, patient_id)
			VALUES (?, ?, ?, ?, ?, ?)
		`,
			rec.CollectionDate,
			nullableStringArg(rec.CollectionTime),
			rec.TemperatureC,
			nullableStringArg(rec.Context),
			rec.Source,
			rec.PatientID,
		)
		if err != nil {
			return inserted, err
		}

		rows, err := res.RowsAffected()
		if err != nil {
			return inserted, err
		}
		inserted += int(rows)
	}

	if err := scanner.Err(); err != nil {
		return inserted, err
	}

	return inserted, nil
}

func parseTemperatureLine(line string, patientID int) (TempRecord, bool, error) {
	lower := strings.ToLower(line)
	if strings.Contains(lower, "data") || strings.Contains(lower, "temperatura") {
		return TempRecord{}, false, nil
	}

	line = strings.ReplaceAll(line, "*", "")
	fields := strings.Fields(line)
	if len(fields) < 3 {
		return TempRecord{}, false, nil
	}

	dateStr := fields[0]
	timeStr := fields[1]
	tempStr := normalizeDecimal(fields[2])

	date, err := time.Parse("02/01/2006", dateStr)
	if err != nil {
		return TempRecord{}, false, nil
	}

	_, err = time.Parse("15:04", timeStr)
	if err != nil {
		return TempRecord{}, false, nil
	}

	temp, err := strconv.ParseFloat(tempStr, 64)
	if err != nil {
		return TempRecord{}, false, nil
	}

	var context *string
	if len(fields) > 3 {
		c := strings.Join(fields[3:], " ")
		context = &c
	}

	t := timeStr

	return TempRecord{
		CollectionDate: date.Format("2006-01-02"),
		CollectionTime: &t,
		TemperatureC:   temp,
		Context:        context,
		Source:         "txt_ingest",
		PatientID:      patientID,
	}, true, nil
}

func ingestBPLegacy(db *sql.DB, filePath string, patientID int) (int, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return 0, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	inserted := 0

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		rec, ok, err := parseBPLegacyLine(line, patientID)
		if err != nil {
			return inserted, err
		}
		if !ok {
			continue
		}

		res, err := db.Exec(`
			INSERT OR IGNORE INTO blood_pressure
			(collection_date, collection_time, systolic_mmHg, diastolic_mmHg, map_mmHg, heart_rate_bpm, body_position, measurement_site, condition, source, notes, patient_id, method)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		`,
			rec.CollectionDate,
			nullableStringArg(rec.CollectionTime),
			rec.Systolic,
			nullableFloatArg(rec.Diastolic),
			nullableFloatArg(rec.MAP),
			nil,
			nullableStringArg(rec.BodyPosition),
			nullableStringArg(rec.MeasurementSite),
			nullableStringArg(rec.Condition),
			rec.Source,
			nil,
			rec.PatientID,
			nullableStringArg(rec.Method),
		)
		if err != nil {
			return inserted, err
		}

		rows, err := res.RowsAffected()
		if err != nil {
			return inserted, err
		}
		inserted += int(rows)
	}

	if err := scanner.Err(); err != nil {
		return inserted, err
	}

	return inserted, nil
}

func parseBPLegacyLine(line string, patientID int) (BPRecord, bool, error) {
	lower := strings.ToLower(line)
	if strings.Contains(lower, "pa daisy") ||
		strings.Contains(lower, "sistólica") ||
		strings.Contains(lower, "diastólica") ||
		strings.Contains(lower, "map") {
		return BPRecord{}, false, nil
	}

	fields := strings.Fields(line)
	if len(fields) < 5 {
		return BPRecord{}, false, nil
	}

	dateStr := fields[1]
	systolicStr := normalizeDecimal(fields[2])
	diastolicStr := normalizeDecimal(fields[3])
	mapStr := normalizeDecimal(fields[4])

	date, err := time.Parse("02/01/2006", dateStr)
	if err != nil {
		return BPRecord{}, false, nil
	}

	systolic, err := strconv.ParseFloat(systolicStr, 64)
	if err != nil {
		return BPRecord{}, false, nil
	}

	diastolic, err := strconv.ParseFloat(diastolicStr, 64)
	if err != nil {
		return BPRecord{}, false, nil
	}

	mapValue, err := strconv.ParseFloat(mapStr, 64)
	if err != nil {
		return BPRecord{}, false, nil
	}

	d := diastolic
	m := mapValue

	return BPRecord{
		CollectionDate:  date.Format("2006-01-02"),
		CollectionTime:  nil,
		Systolic:        systolic,
		Diastolic:       &d,
		MAP:             &m,
		BodyPosition:    nil,
		MeasurementSite: nil,
		Condition:       nil,
		Source:          "txt_ingest",
		PatientID:       patientID,
		Method:          nil,
	}, true, nil
}

func ingestBPSession(db *sql.DB, filePath string, patientID int) (int, error) {
	rec, err := parseBPSessionFile(filePath, patientID)
	if err != nil {
		return 0, err
	}

	res, err := db.Exec(`
		INSERT OR IGNORE INTO blood_pressure
		(collection_date, collection_time, systolic_mmHg, diastolic_mmHg, map_mmHg, heart_rate_bpm, body_position, measurement_site, condition, source, notes, patient_id, method)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
	`,
		rec.CollectionDate,
		nullableStringArg(rec.CollectionTime),
		rec.Systolic,
		nullableFloatArg(rec.Diastolic),
		nullableFloatArg(rec.MAP),
		nil,
		nullableStringArg(rec.BodyPosition),
		nullableStringArg(rec.MeasurementSite),
		nullableStringArg(rec.Condition),
		rec.Source,
		nil,
		rec.PatientID,
		nullableStringArg(rec.Method),
	)
	if err != nil {
		return 0, err
	}

	rows, err := res.RowsAffected()
	if err != nil {
		return 0, err
	}

	return int(rows), nil
}

func parseBPSessionFile(filePath string, patientID int) (BPRecord, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return BPRecord{}, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var lines []string

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}
		lines = append(lines, line)
	}

	if err := scanner.Err(); err != nil {
		return BPRecord{}, err
	}

	if len(lines) < 8 {
		return BPRecord{}, errors.New("BP_SESSION file incomplete")
	}

	if lines[0] != "BP_SESSION" {
		return BPRecord{}, errors.New("missing BP_SESSION header")
	}

	dateValue, err := time.Parse("2006-01-02", lines[1])
	if err != nil {
		return BPRecord{}, fmt.Errorf("invalid BP_SESSION date: %w", err)
	}

	if _, err := time.Parse("15:04", lines[2]); err != nil {
		return BPRecord{}, fmt.Errorf("invalid BP_SESSION time: %w", err)
	}

	methodValue := strings.ToLower(strings.TrimSpace(lines[3]))
	if methodValue != "oscillometric" && methodValue != "doppler" {
		return BPRecord{}, fmt.Errorf("invalid BP_SESSION method: %s", lines[3])
	}

	measurementSite := lines[4]
	bodyPosition := lines[5]
	condition := lines[6]
	readingLines := lines[7:]

	if len(readingLines) == 0 {
		return BPRecord{}, errors.New("BP_SESSION has no readings")
	}

	systolicAvg, diastolicAvg, mapAvg, err := aggregateBPReadings(readingLines, methodValue)
	if err != nil {
		return BPRecord{}, err
	}

	timeValue := lines[2]
	method := methodValue

	return BPRecord{
		CollectionDate:  dateValue.Format("2006-01-02"),
		CollectionTime:  &timeValue,
		Systolic:        systolicAvg,
		Diastolic:       diastolicAvg,
		MAP:             mapAvg,
		BodyPosition:    &bodyPosition,
		MeasurementSite: &measurementSite,
		Condition:       &condition,
		Source:          "txt_ingest",
		PatientID:       patientID,
		Method:          &method,
	}, nil
}

func aggregateBPReadings(lines []string, method string) (float64, *float64, *float64, error) {
	var systolicValues []float64
	var diastolicValues []float64
	var mapValues []float64

	for _, line := range lines {
		fields := strings.Fields(line)
		if len(fields) == 0 {
			continue
		}

		switch method {
		case "oscillometric":
			if len(fields) != 3 {
				return 0, nil, nil, fmt.Errorf("oscillometric reading must have 3 values: %s", line)
			}
		case "doppler":
			if len(fields) < 1 || len(fields) > 3 {
				return 0, nil, nil, fmt.Errorf("doppler reading must have 1 to 3 values: %s", line)
			}
		default:
			return 0, nil, nil, fmt.Errorf("unsupported method: %s", method)
		}

		systolic, err := strconv.ParseFloat(normalizeDecimal(fields[0]), 64)
		if err != nil {
			return 0, nil, nil, fmt.Errorf("invalid systolic value in line: %s", line)
		}
		systolicValues = append(systolicValues, systolic)

		if len(fields) >= 2 {
			diastolic, err := strconv.ParseFloat(normalizeDecimal(fields[1]), 64)
			if err != nil {
				return 0, nil, nil, fmt.Errorf("invalid diastolic value in line: %s", line)
			}
			diastolicValues = append(diastolicValues, diastolic)
		}

		if len(fields) >= 3 {
			mapValue, err := strconv.ParseFloat(normalizeDecimal(fields[2]), 64)
			if err != nil {
				return 0, nil, nil, fmt.Errorf("invalid MAP value in line: %s", line)
			}
			mapValues = append(mapValues, mapValue)
		}
	}

	if len(systolicValues) == 0 {
		return 0, nil, nil, errors.New("no valid systolic readings found")
	}

	systolicAvg := roundToNearestInt(averageFloat64(systolicValues))

	var diastolicAvg *float64
	if len(diastolicValues) > 0 {
		v := roundToNearestInt(averageFloat64(diastolicValues))
		diastolicAvg = &v
	}

	var mapAvg *float64
	if len(mapValues) > 0 {
		v := roundToNearestInt(averageFloat64(mapValues))
		mapAvg = &v
	}

	if method == "oscillometric" {
		if diastolicAvg == nil || mapAvg == nil {
			return 0, nil, nil, errors.New("oscillometric session requires diastolic and MAP averages")
		}
	}

	return systolicAvg, diastolicAvg, mapAvg, nil
}

func averageFloat64(values []float64) float64 {
	total := 0.0
	for _, v := range values {
		total += v
	}
	return total / float64(len(values))
}

func roundToNearestInt(value float64) float64 {
	return math.Round(value)
}

func normalizeDecimal(s string) string {
	return strings.ReplaceAll(s, ",", ".")
}

func nullableStringArg(s *string) interface{} {
	if s == nil {
		return nil
	}
	return *s
}

func nullableFloatArg(f *float64) interface{} {
	if f == nil {
		return nil
	}
	return *f
}
