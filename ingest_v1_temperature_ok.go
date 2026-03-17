package main

import (
	"bufio"
	"database/sql"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	_ "github.com/mattn/go-sqlite3"
)

func parseLine(line string) (string, string, float64, string, error) {

	line = strings.ReplaceAll(line, "*", "")
	fields := strings.Fields(line)

	if len(fields) < 3 {
		return "", "", 0, "", fmt.Errorf("linha inválida")
	}

	dateStr := fields[0]
	timeStr := fields[1]
	tempStr := fields[2]

	context := ""
	if len(fields) > 3 {
		context = strings.Join(fields[3:], " ")
	}

	date, err := time.Parse("02/01/2006", dateStr)
	if err != nil {
		return "", "", 0, "", err
	}

	tempStr = strings.ReplaceAll(tempStr, ",", ".")
	temp, err := strconv.ParseFloat(tempStr, 64)
	if err != nil {
		return "", "", 0, "", err
	}

	return date.Format("2006-01-02"), timeStr, temp, context, nil
}

func main() {

	dbPath := flag.String("db", "database/daisy.db", "database")
	filePath := flag.String("file", "", "input file")
	flag.Parse()

	if *filePath == "" {
		fmt.Println("missing -file")
		return
	}

	db, err := sql.Open("sqlite3", *dbPath)
	if err != nil {
		panic(err)
	}

	file, err := os.Open(*filePath)
	if err != nil {
		panic(err)
	}

	scanner := bufio.NewScanner(file)

	inserted := 0

	for scanner.Scan() {

		line := strings.TrimSpace(scanner.Text())

		if line == "" {
			continue
		}

		date, t, temp, context, err := parseLine(line)
		if err != nil {
			continue
		}

		_, err = db.Exec(`
		INSERT OR IGNORE INTO temperature
		(collection_date, collection_time, temperature_c, context, source, patient_id)
		VALUES (?, ?, ?, ?, ?, ?)
		`,
			date,
			t,
			temp,
			context,
			"txt_ingest",
			1,
		)

		if err != nil {
			panic(err)
		}

		inserted++
	}

	fmt.Printf("records inserted: %d\n", inserted)

}
