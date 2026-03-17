package main

import (
	"database/sql"
	"encoding/json"
	"flag"
	"fmt"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

const sqliteDB = "/home/paulo/projeto_daisy/database/daisy.db"

type Record struct {
	Date       string
	Creatinine float64
}

type Result struct {
	Baseline        float64 `json:"baseline_umol_L"`
	AKIStart        string  `json:"aki_start"`
	RecoveryStart   string  `json:"recovery_start"`
	Stabilization   string  `json:"stabilization_start"`
	CurrentPhase    string  `json:"current_phase"`
}

func main() {

	jsonOnly := flag.Bool("json", false, "JSON output only")
	flag.Parse()

	data, err := loadChemistryData()
	if err != nil {
		fmt.Fprintf(os.Stderr, "error loading chemistry data: %v\n", err)
		os.Exit(1)
	}

	baselineCount := 8
	if len(data) < baselineCount {
		baselineCount = len(data)
	}

	baseline := calculateBaseline(data[:baselineCount])
	akiThreshold := baseline * 2.5
	stableThreshold := baseline * 1.5

	akiStart := ""
	recoveryStart := ""
	stabilizationStart := ""
	currentPhase := "BASELINE"

	for _, r := range data {

		if r.Creatinine > akiThreshold {

			if currentPhase != "AKI" {
				akiStart = r.Date
				currentPhase = "AKI"
			}

		} else if currentPhase == "AKI" {

			if r.Creatinine < akiThreshold {
				recoveryStart = r.Date
				currentPhase = "RECOVERY"
			}

		} else if currentPhase == "RECOVERY" {

			if r.Creatinine < stableThreshold {
				stabilizationStart = r.Date
				currentPhase = "STABLE"
			}

		}
	}

	result := Result{
		Baseline:      baseline,
		AKIStart:      akiStart,
		RecoveryStart: recoveryStart,
		Stabilization: stabilizationStart,
		CurrentPhase:  currentPhase,
	}

	if *jsonOnly {

		jsonOutput, _ := json.MarshalIndent(result, "", "  ")
		fmt.Println(string(jsonOutput))
		return
	}

	fmt.Println()
	fmt.Println("CLINICAL PHASE DETECTOR")
	fmt.Println("================================================")
	fmt.Println()

	fmt.Println("Baseline creatinine estimate:")
	fmt.Printf("%.2f umol/L\n", baseline)

	fmt.Println()
	fmt.Println("Structured output")
	fmt.Println("------------------------------------------------")
	fmt.Printf("BASELINE_UMOL_L=%.2f\n", result.Baseline)
	fmt.Printf("AKI_START=%s\n", result.AKIStart)
	fmt.Printf("RECOVERY_START=%s\n", result.RecoveryStart)
	fmt.Printf("STABILIZATION_START=%s\n", result.Stabilization)
	fmt.Printf("CURRENT_PHASE=%s\n", result.CurrentPhase)

	fmt.Println()
	fmt.Println("Phase detection complete")
}

func loadChemistryData() ([]Record, error) {

	db, err := sql.Open("sqlite3", sqliteDB)
	if err != nil {
		return nil, err
	}
	defer db.Close()

	query := `
SELECT collection_date, creatinine_umol_L
FROM chemistry
WHERE creatinine_umol_L IS NOT NULL
ORDER BY collection_date;
`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var records []Record

	for rows.Next() {
		var r Record
		rows.Scan(&r.Date, &r.Creatinine)
		records = append(records, r)
	}

	return records, nil
}

func calculateBaseline(records []Record) float64 {

	var sum float64

	for _, r := range records {
		sum += r.Creatinine
	}

	return sum / float64(len(records))
}
