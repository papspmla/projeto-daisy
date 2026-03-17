package main

import (
        "encoding/json"
        "fmt"
        "os"
        "os/exec"
        "sort"
        "strings"
)

type TrendDetail struct {
        Trend    string  `json:"trend"`
        FirstAvg float64 `json:"first_avg"`
        LastAvg  float64 `json:"last_avg"`
}

type ClinicalFlags struct {
        RenalCompensationStable bool `json:"renal_compensation_stable"`
        ProgressiveCKDPattern   bool `json:"progressive_ckd_pattern"`
        ElectrolytesPreserved   bool `json:"electrolytes_preserved"`
        HepaticActivePattern    bool `json:"hepatic_active_pattern"`
        MetabolicInstability    bool `json:"metabolic_instability"`
        AKIHistoryPresent       bool `json:"aki_history_present"`

        WeightRapidLoss      bool `json:"weight_rapid_loss"`
        WeightRapidGain      bool `json:"weight_rapid_gain"`
        WeightRecentDecrease bool `json:"weight_recent_decrease"`
        WeightRecentIncrease bool `json:"weight_recent_increase"`
}

type ClinicalSummary struct {
        RenalSummary     string   `json:"renal_summary"`
        HepaticSummary   string   `json:"hepatic_summary"`
        MetabolicSummary string   `json:"metabolic_summary"`
        WeightSummary    string   `json:"weight_summary"`
        OverallFlags     []string `json:"overall_flags"`
}

func run(path string, args ...string) []byte {
        cmd := exec.Command(path, args...)
        out, _ := cmd.Output()
        return out
}

func extractMetabolicSummary(raw []byte) string {

        text := string(raw)
        lines := strings.Split(text, "\n")

        metabolic := ""
        hypothyroid := false

        for _, l := range lines {

                if strings.Contains(l, "Metabolic summary:") {
                        parts := strings.SplitN(l, ":", 2)
                        if len(parts) == 2 {
                                metabolic = strings.TrimSpace(parts[1])
                        }
                }

                if strings.Contains(l, "Hypothyroidism-compatible pattern: YES") {
                        hypothyroid = true
                }
        }

        if metabolic == "" {
                metabolic = "metabolic profile not determined"
        }

        if hypothyroid {
                metabolic = metabolic + ", pattern compatible with hypothyroidism"
        }

        return metabolic
}

func main() {

        if len(os.Args) < 2 {
                fmt.Println("usage: clinical_summary <patient_id>")
                os.Exit(1)
        }

        patientID := os.Args[1]

        trendRaw := run("/home/paulo/projeto_daisy/bin/trend_analyzer", patientID)
        flagsRaw := run("/home/paulo/projeto_daisy/bin/clinical_flags_engine", patientID)
        weightRaw := run("/home/paulo/projeto_daisy/bin/weight_interpreter", patientID)
        metabolicRaw := run("/home/paulo/projeto_daisy/bin/metabolic_interpreter", patientID)

        var trends map[string]TrendDetail
        json.Unmarshal(trendRaw, &trends)

        var flags ClinicalFlags
        json.Unmarshal(flagsRaw, &flags)

        weightSummary := ""

        if len(weightRaw) > 0 {
                weightSummary = "weight analysis available"
        }

        renal := []string{}
        hepatic := []string{}
        flagsList := []string{}

        if t, ok := trends["creatinine_umol_L"]; ok {
                renal = append(renal,
                        fmt.Sprintf("creatinine %s from %.2f to %.2f",
                                t.Trend, t.FirstAvg, t.LastAvg))
        }

        if t, ok := trends["sdma_ug_dL"]; ok {
                renal = append(renal,
                        fmt.Sprintf("SDMA %s from %.2f to %.2f",
                                t.Trend, t.FirstAvg, t.LastAvg))
        }

        if t, ok := trends["alt_U_L"]; ok {
                hepatic = append(hepatic, "ALT "+t.Trend)
        }

        if t, ok := trends["alp_U_L"]; ok {
                hepatic = append(hepatic, "ALP "+t.Trend)
        }

        if flags.AKIHistoryPresent {
                flagsList = append(flagsList, "AKI history present")
        }

        if flags.RenalCompensationStable {
                flagsList = append(flagsList, "renal function stable after AKI recovery")
        }

        if flags.WeightRapidLoss {
                flagsList = append(flagsList, "recent weight loss detected")
        }

        sort.Strings(flagsList)

        summary := ClinicalSummary{
                RenalSummary:     join(renal),
                HepaticSummary:   join(hepatic),
                MetabolicSummary: extractMetabolicSummary(metabolicRaw),
                WeightSummary:    weightSummary,
                OverallFlags:     flagsList,
        }

        out, _ := json.MarshalIndent(summary, "", "  ")

        fmt.Println(string(out))
}

func join(parts []string) string {

        if len(parts) == 0 {
                return "no relevant data"
        }

        s := ""

        for i, p := range parts {

                if i > 0 {
                        s += ", "
                }

                s += p
        }

        return s
}
