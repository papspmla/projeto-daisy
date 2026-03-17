package main

import (
	"database/sql"
	"fmt"
	"math"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

type ChemistryRow struct {
	Date          string
	Cholesterol   float64
	Triglycerides float64
	Glucose       float64
	Fructosamine  float64
}

type BiomarkerConfig struct {
	Key       string
	Label     string
	Unit      string
	HighLimit float64
	LowLimit  float64
}

type BiomarkerSeries struct {
	Config BiomarkerConfig
	Values []float64
	Dates  []string
}

type BiomarkerStats struct {
	Label       string
	Unit        string
	Valid       int
	High        int
	Low         int
	Mean        float64
	Min         float64
	Max         float64
	FirstMean   float64
	LastMean    float64
	Trend       string
	PercentHigh float64
	PercentLow  float64
}

type MetabolicInterpretation struct {
	LipidPattern      string
	GlucosePattern    string
	MetabolicSummary  string
	MetabolicSyndrome bool
	HypothyroidFlag   bool
	Alerts            []string
}

func loadChemistryRows(db *sql.DB, patientID string) ([]ChemistryRow, error) {
	query := `
	SELECT
		collection_date,
		cholesterol_mmol_L,
		triglycerides_mmol_L,
		glucose_mmol_L,
		fructosamine_umol_L
	FROM chemistry
	WHERE patient_id = ?
	ORDER BY collection_date;
	`

	rows, err := db.Query(query, patientID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []ChemistryRow

	for rows.Next() {
		var r ChemistryRow
		var chol sql.NullFloat64
		var trig sql.NullFloat64
		var glu sql.NullFloat64
		var fru sql.NullFloat64

		if err := rows.Scan(&r.Date, &chol, &trig, &glu, &fru); err != nil {
			return nil, err
		}

		if chol.Valid {
			r.Cholesterol = chol.Float64
		}
		if trig.Valid {
			r.Triglycerides = trig.Float64
		}
		if glu.Valid {
			r.Glucose = glu.Float64
		}
		if fru.Valid {
			r.Fructosamine = fru.Float64
		}

		out = append(out, r)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return out, nil
}

func buildSeries(rows []ChemistryRow, cfg BiomarkerConfig, extractor func(ChemistryRow) float64) BiomarkerSeries {
	s := BiomarkerSeries{
		Config: cfg,
		Values: []float64{},
		Dates:  []string{},
	}

	for _, r := range rows {
		v := extractor(r)
		if v > 0 {
			s.Values = append(s.Values, v)
			s.Dates = append(s.Dates, r.Date)
		}
	}

	return s
}

func mean(values []float64) float64 {
	if len(values) == 0 {
		return 0
	}

	var sum float64
	for _, v := range values {
		sum += v
	}

	return sum / float64(len(values))
}

func meanFirstN(values []float64, n int) float64 {
	if len(values) == 0 {
		return 0
	}
	if len(values) < n {
		return mean(values)
	}
	return mean(values[:n])
}

func meanLastN(values []float64, n int) float64 {
	if len(values) == 0 {
		return 0
	}
	if len(values) < n {
		return mean(values)
	}
	return mean(values[len(values)-n:])
}

func computeTrend(values []float64) string {
	if len(values) < 4 {
		return "insufficient data"
	}

	firstMean := meanFirstN(values, 2)
	lastMean := meanLastN(values, 2)

	diff := lastMean - firstMean
	tolerance := math.Abs(firstMean) * 0.02

	if tolerance < 0.000001 {
		tolerance = 0.000001
	}

	if diff > tolerance {
		return "increasing"
	}
	if diff < -tolerance {
		return "decreasing"
	}
	return "stable"
}

func computeStats(series BiomarkerSeries) BiomarkerStats {
	stats := BiomarkerStats{
		Label: series.Config.Label,
		Unit:  series.Config.Unit,
		Valid: len(series.Values),
	}

	if len(series.Values) == 0 {
		stats.Trend = "insufficient data"
		return stats
	}

	stats.Min = series.Values[0]
	stats.Max = series.Values[0]

	for _, v := range series.Values {
		if series.Config.HighLimit > 0 && v > series.Config.HighLimit {
			stats.High++
		}
		if series.Config.LowLimit > 0 && v < series.Config.LowLimit {
			stats.Low++
		}
		if v < stats.Min {
			stats.Min = v
		}
		if v > stats.Max {
			stats.Max = v
		}
	}

	stats.Mean = mean(series.Values)
	stats.FirstMean = meanFirstN(series.Values, 2)
	stats.LastMean = meanLastN(series.Values, 2)
	stats.Trend = computeTrend(series.Values)

	if stats.Valid > 0 {
		stats.PercentHigh = float64(stats.High) / float64(stats.Valid) * 100
		stats.PercentLow = float64(stats.Low) / float64(stats.Valid) * 100
	}

	return stats
}

func interpretMetabolic(chol BiomarkerStats, trig BiomarkerStats, glu BiomarkerStats, fru BiomarkerStats) MetabolicInterpretation {
	out := MetabolicInterpretation{
		LipidPattern:      "normal lipid profile",
		GlucosePattern:    "normal glucose metabolism",
		MetabolicSummary:  "no metabolic abnormality detected",
		MetabolicSyndrome: false,
		HypothyroidFlag:   false,
		Alerts:            []string{},
	}

	hasLipidAbnormality := chol.High > 0 || trig.High > 0
	hasGlucoseAbnormality := glu.High > 0 || fru.High > 0

	if chol.High > 0 && trig.High == 0 {
		out.LipidPattern = "isolated hypercholesterolemia"
		out.MetabolicSummary = "isolated hypercholesterolemia"
	}

	if trig.High > 0 && chol.High == 0 {
		out.LipidPattern = "isolated hypertriglyceridemia"
		out.MetabolicSummary = "isolated hypertriglyceridemia"
	}

	if chol.High > 0 && trig.High > 0 {
		out.LipidPattern = "combined dyslipidemia"
		out.MetabolicSummary = "combined dyslipidemia"
	}

	if hasGlucoseAbnormality {
		out.GlucosePattern = "glucose metabolism alteration"
		out.MetabolicSummary = "glucose metabolism alteration"
	}

	if glu.High > 0 && fru.High == 0 {
		out.GlucosePattern = "stress hyperglycemia possible"
		out.Alerts = append(out.Alerts, "glucose elevation without fructosamine support")
	}

	if hasLipidAbnormality && hasGlucoseAbnormality {
		out.MetabolicSyndrome = true
		out.Alerts = append(out.Alerts, "metabolic syndrome suspicion")
	}

	if chol.High > 0 && trig.High == 0 && glu.High == 0 && fru.High == 0 {
		out.HypothyroidFlag = true
		out.Alerts = append(out.Alerts, "lipid pattern compatible with hypothyroidism")
	}

	if chol.High > 0 && trig.High == 0 && !hasGlucoseAbnormality {
		out.MetabolicSummary = "isolated hypercholesterolemia"
	}

	return out
}

func printBiomarkerStats(stats BiomarkerStats) {
	fmt.Printf("%s elevations: %d / %d (%.1f%%)\n",
		stats.Label, stats.High, stats.Valid, stats.PercentHigh)
	fmt.Printf("%s mean: %.3f %s\n", stats.Label, stats.Mean, stats.Unit)
	fmt.Printf("%s trend: %s\n", stats.Label, stats.Trend)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("usage: metabolic_interpreter <patient_id>")
		os.Exit(1)
	}

	patientID := os.Args[1]
	dbPath := os.Getenv("HOME") + "/projeto_daisy/database/daisy.db"

	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		fmt.Println("database error:", err)
		os.Exit(1)
	}
	defer db.Close()

	rows, err := loadChemistryRows(db, patientID)
	if err != nil {
		fmt.Println("query error:", err)
		os.Exit(1)
	}

	cholSeries := buildSeries(rows, BiomarkerConfig{
		Key:       "cholesterol",
		Label:     "Cholesterol",
		Unit:      "mmol/L",
		HighLimit: 8.3,
	}, func(r ChemistryRow) float64 {
		return r.Cholesterol
	})

	trigSeries := buildSeries(rows, BiomarkerConfig{
		Key:       "triglycerides",
		Label:     "Triglycerides",
		Unit:      "mmol/L",
		HighLimit: 2.3,
	}, func(r ChemistryRow) float64 {
		return r.Triglycerides
	})

	gluSeries := buildSeries(rows, BiomarkerConfig{
		Key:       "glucose",
		Label:     "Glucose",
		Unit:      "mmol/L",
		HighLimit: 7.5,
	}, func(r ChemistryRow) float64 {
		return r.Glucose
	})

	fruSeries := buildSeries(rows, BiomarkerConfig{
		Key:       "fructosamine",
		Label:     "Fructosamine",
		Unit:      "µmol/L",
		HighLimit: 374,
	}, func(r ChemistryRow) float64 {
		return r.Fructosamine
	})

	cholStats := computeStats(cholSeries)
	trigStats := computeStats(trigSeries)
	gluStats := computeStats(gluSeries)
	fruStats := computeStats(fruSeries)

	interp := interpretMetabolic(cholStats, trigStats, gluStats, fruStats)

	fmt.Println()
	fmt.Println("Daisy metabolic interpreter")
	fmt.Println("---------------------------")
	fmt.Println("Records:", len(rows))

	fmt.Println()
	fmt.Println("Lipid pattern:", interp.LipidPattern)
	fmt.Println("Glucose pattern:", interp.GlucosePattern)
	fmt.Println("Metabolic summary:", interp.MetabolicSummary)

	fmt.Println()
	printBiomarkerStats(cholStats)
	fmt.Println()
	printBiomarkerStats(trigStats)
	fmt.Println()
	printBiomarkerStats(gluStats)
	fmt.Println()
	printBiomarkerStats(fruStats)

	fmt.Println()
	if interp.MetabolicSyndrome {
		fmt.Println("Metabolic syndrome suspicion: YES")
	} else {
		fmt.Println("Metabolic syndrome suspicion: NO")
	}

	if interp.HypothyroidFlag {
		fmt.Println("Hypothyroidism-compatible pattern: YES")
	} else {
		fmt.Println("Hypothyroidism-compatible pattern: NO")
	}

	if len(interp.Alerts) > 0 {
		fmt.Println()
		fmt.Println("Alerts:")
		for _, a := range interp.Alerts {
			fmt.Println("-", a)
		}
	}
}
