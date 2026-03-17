package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"math"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

const sqliteDB = "/home/paulo/projeto_daisy/database/daisy.db"

type WeightReport struct {
	Records        int     `json:"records"`
	FirstWeight    float64 `json:"first_weight"`
	LastWeight     float64 `json:"last_weight"`
	FirstAvg       float64 `json:"first_avg"`
	LastAvg        float64 `json:"last_avg"`
	DeltaTotal     float64 `json:"delta_total"`
	Delta4Weeks    float64 `json:"delta_4weeks"`
	StdDev         float64 `json:"std_dev"`
	LongTermTrend  string  `json:"long_term_trend"`
	RecentTrend    string  `json:"recent_trend"`
	RapidLoss      bool    `json:"rapid_loss"`
	RapidGain      bool    `json:"rapid_gain"`
	MetabolicStable bool   `json:"metabolic_stable"`
}

func main() {

	if len(os.Args) < 2 {
		fmt.Println("usage: weight_interpreter <patient_id>")
		os.Exit(1)
	}

	patientID := os.Args[1]

	db, err := sql.Open("sqlite3", sqliteDB)
	if err != nil {
		fmt.Println("Database error:", err)
		os.Exit(1)
	}

	defer db.Close()

	values := loadWeights(db, patientID)

	if len(values) == 0 {
		fmt.Println("No weight data")
		return
	}

	report := analyzeWeights(values)

	j, _ := json.MarshalIndent(report, "", "  ")
	fmt.Println(string(j))
}

func loadWeights(db *sql.DB, patientID string) []float64 {

	query := `
SELECT weight_kg
FROM weight
WHERE patient_id=?
ORDER BY collection_date;
`

	rows, err := db.Query(query, patientID)
	if err != nil {
		return nil
	}

	defer rows.Close()

	var values []float64

	for rows.Next() {

		var w float64

		if err := rows.Scan(&w); err != nil {
			continue
		}

		values = append(values, w)
	}

	return values
}

func analyzeWeights(values []float64) WeightReport {

	n := len(values)

	firstWeight := values[0]
	lastWeight := values[n-1]

	firstAvg := average(values[:min(5, n)])

	lastAvg := average(values[max(0, n-5):])

	deltaTotal := lastAvg - firstAvg

	recentWindow := min(4, n)

	recentDelta := values[n-1] - values[n-recentWindow]

	stdDev := stddev(values)

	longTrend := "stable"

	if deltaTotal > 0.5 {
		longTrend = "increasing"
	} else if deltaTotal < -0.5 {
		longTrend = "decreasing"
	}

	recentTrend := "stable"

	if recentDelta > 0.5 {
		recentTrend = "increasing"
	} else if recentDelta < -0.5 {
		recentTrend = "decreasing"
	}

	rapidLoss := recentDelta < -1.0
	rapidGain := recentDelta > 1.0

	metabolicStable := math.Abs(deltaTotal) < 1.0 && stdDev < 2.0

	return WeightReport{
		Records:         n,
		FirstWeight:     round2(firstWeight),
		LastWeight:      round2(lastWeight),
		FirstAvg:        round2(firstAvg),
		LastAvg:         round2(lastAvg),
		DeltaTotal:      round2(deltaTotal),
		Delta4Weeks:     round2(recentDelta),
		StdDev:          round2(stdDev),
		LongTermTrend:   longTrend,
		RecentTrend:     recentTrend,
		RapidLoss:       rapidLoss,
		RapidGain:       rapidGain,
		MetabolicStable: metabolicStable,
	}
}

func average(v []float64) float64 {

	if len(v) == 0 {
		return 0
	}

	var sum float64

	for _, x := range v {
		sum += x
	}

	return sum / float64(len(v))
}

func stddev(v []float64) float64 {

	if len(v) == 0 {
		return 0
	}

	avg := average(v)

	var sum float64

	for _, x := range v {
		d := x - avg
		sum += d * d
	}

	return math.Sqrt(sum / float64(len(v)))
}

func round2(v float64) float64 {
	return math.Round(v*100) / 100
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
