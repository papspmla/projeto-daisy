package main

import (
        "encoding/json"
        "fmt"
        "os"
        "os/exec"
)

type TrendDetail struct {
        Trend    string  `json:"trend"`
        FirstAvg float64 `json:"first_avg"`
        LastAvg  float64 `json:"last_avg"`
        Delta    float64 `json:"delta"`
}

type ClinicalFlags struct {
        RenalCompensationStable bool `json:"renal_compensation_stable"`
        ProgressiveCKDPattern   bool `json:"progressive_ckd_pattern"`
        ElectrolytesPreserved   bool `json:"electrolytes_preserved"`
        HepaticActivePattern    bool `json:"hepatic_active_pattern"`
        MetabolicInstability    bool `json:"metabolic_instability"`
        AKIHistoryPresent       bool `json:"aki_history_present"`
}

func run(path string, args ...string) []byte {
        cmd := exec.Command(path, args...)
        out, _ := cmd.Output()
        return out
}

func main() {

        if len(os.Args) < 2 {
                fmt.Println("usage: renal_interpreter <patient_id>")
                os.Exit(1)
        }

        patientID := os.Args[1]

        flagsRaw := run("/home/paulo/projeto_daisy/bin/clinical_flags_engine", patientID)
        trendRaw := run("/home/paulo/projeto_daisy/bin/trend_analyzer", patientID)
        renalModelRaw := string(run("/home/paulo/projeto_daisy/bin/renal_function_model", patientID))

        var flags ClinicalFlags
        _ = json.Unmarshal(flagsRaw, &flags)

        var trends map[string]TrendDetail
        _ = json.Unmarshal(trendRaw, &trends)

        fmt.Println()
        fmt.Println("RENAL INTERPRETATION")
        fmt.Println("================================================")
        fmt.Println()

        if flags.AKIHistoryPresent {
                fmt.Println("AKI history detected")
        }

        fmt.Print(renalModelRaw)

        fmt.Println("Current state:")

        if flags.RenalCompensationStable && !flags.ProgressiveCKDPattern {
                fmt.Println("compensated renal function")
        } else if flags.ProgressiveCKDPattern {
                fmt.Println("possible progressive CKD pattern")
        } else {
                fmt.Println("renal status indeterminate")
        }

        fmt.Println()
        fmt.Println("Evidence:")

        if t, ok := trends["creatinine_umol_L"]; ok {
                fmt.Printf("- creatinine %s (%.2f -> %.2f)\n", t.Trend, t.FirstAvg, t.LastAvg)
        }

        if t, ok := trends["sdma_ug_dL"]; ok {
                fmt.Printf("- SDMA %s (%.2f -> %.2f)\n", t.Trend, t.FirstAvg, t.LastAvg)
        }

        if t, ok := trends["phosphorus_mmol_L"]; ok {
                fmt.Printf("- phosphorus %s\n", t.Trend)
        }

        if t, ok := trends["potassium_mmol_L"]; ok {
                fmt.Printf("- potassium %s\n", t.Trend)
        }

        fmt.Println()
        fmt.Println("Interpretation:")

        if flags.RenalCompensationStable && flags.ElectrolytesPreserved && !flags.ProgressiveCKDPattern {
                fmt.Println("stable renal compensation without progressive CKD pattern")
        } else if flags.ProgressiveCKDPattern {
                fmt.Println("renal pattern may suggest progression and deserves closer review")
        } else {
                fmt.Println("renal interpretation remains conservative")
        }

        fmt.Println()
}
