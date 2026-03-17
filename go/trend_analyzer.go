package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"math"
	"os"
	"strings"

	_ "github.com/mattn/go-sqlite3"
)

const dbPath = "/home/paulo/projeto_daisy/database/daisy.db"

type TrendDetail struct {
	Trend    string  `json:"trend"`
	FirstAvg float64 `json:"first_avg"`
	LastAvg  float64 `json:"last_avg"`
	Delta    float64 `json:"delta"`
}

func main() {

	patientID := "1"

	if len(os.Args) > 1 {
		patientID = os.Args[1]
	}

	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		fmt.Println("database error:", err)
		os.Exit(1)
	}
	defer db.Close()

	columns := getAnalyteColumns(db)

	results := map[string]TrendDetail{}

	for _, col := range columns {

		values := loadValues(db, patientID, col)

		if len(values) < 2 {
			continue
		}

		results[col] = detectTrend(values)
	}

	out, _ := json.MarshalIndent(results, "", "  ")

	fmt.Println(string(out))
}

func getAnalyteColumns(db *sql.DB) []string {

	rows, _ := db.Query(`PRAGMA table_info(chemistry);`)
	defer rows.Close()

	skip := map[string]bool{
		"id":              true,
		"collection_date": true,
		"report_date":     true,
		"lab_id":          true,
		"sample_id":       true,
		"patient_id":      true,
		"source":          true,
		"notes":           true,
	}

	var columns []string

	for rows.Next() {

		var cid int
		var name string
		var ctype string
		var notnull int
		var dflt sql.NullString
		var pk int

		rows.Scan(&cid, &name, &ctype, &notnull, &dflt, &pk)

		if skip[name] {
			continue
		}

		ctype = strings.ToUpper(strings.TrimSpace(ctype))

		if !strings.Contains(ctype, "REAL") &&
			!strings.Contains(ctype, "FLOAT") &&
			!strings.Contains(ctype, "DOUBLE") &&
			!strings.Contains(ctype, "NUMERIC") &&
			!strings.Contains(ctype, "DECIMAL") &&
			!strings.Contains(ctype, "INT") {
			continue
		}

		columns = append(columns, name)
	}

	return columns
}

func loadValues(db *sql.DB, patientID string, column string) []float64 {

	query := fmt.Sprintf(`
SELECT %s
FROM chemistry
WHERE %s IS NOT NULL
AND patient_id = ?
ORDER BY collection_date
`, column, column)

	rows, err := db.Query(query, patientID)

	if err != nil {
		return nil
	}

	defer rows.Close()

	var values []float64

	for rows.Next() {

		var v float64

		err := rows.Scan(&v)

		if err == nil {
			values = append(values, v)
		}
	}

	return values
}

func detectTrend(values []float64) TrendDetail {

	window := 3

	if len(values) < 6 {
		window = 2
	}

	first := average(values[:window])
	last := average(values[len(values)-window:])

	delta := last - first

	threshold := math.Abs(first) * 0.10

	if threshold < 5 {
		threshold = 5
	}

	trend := "stable"

	if delta > threshold {
		trend = "increasing"
	}

	if delta < -threshold {
		trend = "decreasing"
	}

	return TrendDetail{
		Trend:    trend,
		FirstAvg: round(first),
		LastAvg:  round(last),
		Delta:    round(delta),
	}
}

func average(v []float64) float64 {

	sum := 0.0

	for _, x := range v {
		sum += x
	}

	return sum / float64(len(v))
}

func round(v float64) float64 {

	return math.Round(v*100) / 100
}
