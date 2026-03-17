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

func runCommand(name string, args ...string) []byte {
        cmd := exec.Command(name, args...)
        out, _ := cmd.Output()
        return out
}

func main() {

        if len(os.Args) < 2 {
                fmt.Println("usage: hepatic_interpreter <patient_id>")
                os.Exit(1)
        }

        patientID := os.Args[1]

        flagsRaw := runCommand("/home/paulo/projeto_daisy/bin/clinical_flags_engine", patientID)
        trendRaw := runCommand("/home/paulo/projeto_daisy/bin/trend_analyzer", patientID)

        var flags ClinicalFlags
        _ = json.Unmarshal(flagsRaw, &flags)

        var trends map[string]TrendDetail
        _ = json.Unmarshal(trendRaw, &trends)

        fmt.Println()
        fmt.Println("HEPATIC INTERPRETATION")
        fmt.Println("================================================")
        fmt.Println()

        fmt.Println("Current state:")

        if flags.HepaticActivePattern {
                fmt.Println("possible active hepatic pattern")
        } else {
                fmt.Println("no active hepatic injury pattern detected")
        }

        fmt.Println()
        fmt.Println("Evidence:")

        if t, ok := trends["alt_U_L"]; ok {
                fmt.Printf("- ALT %s (%.2f -> %.2f)\n", t.Trend, t.FirstAvg, t.LastAvg)
        }

        if t, ok := trends["alp_U_L"]; ok {
                fmt.Printf("- ALP %s (%.2f -> %.2f)\n", t.Trend, t.FirstAvg, t.LastAvg)
        }

        if t, ok := trends["bilirubin_total_umol_L"]; ok {
                fmt.Printf("- bilirubin %s (%.2f -> %.2f)\n", t.Trend, t.FirstAvg, t.LastAvg)
        }

        if t, ok := trends["ggt_U_L"]; ok {
                fmt.Printf("- GGT %s (%.2f -> %.2f)\n", t.Trend, t.FirstAvg, t.LastAvg)
        }

        fmt.Println()
        fmt.Println("Interpretation:")

        if !flags.HepaticActivePattern {
                fmt.Println("current hepatic profile does not support active hepatocellular injury or cholestatic progression")
        } else {
                fmt.Println("hepatic pattern deserves closer review")
        }

        fmt.Println()
}
