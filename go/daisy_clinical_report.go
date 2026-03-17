package main

import (
        "encoding/json"
        "fmt"
        "os"
        "os/exec"
)

type ClinicalSummary struct {
        RenalSummary     string   `json:"renal_summary"`
        HepaticSummary   string   `json:"hepatic_summary"`
        MetabolicSummary string   `json:"metabolic_summary"`
        WeightSummary    string   `json:"weight_summary"`
        OverallFlags     []string `json:"overall_flags"`
}

type WeightReport struct {
        Records        int     `json:"records"`
        FirstWeight    float64 `json:"first_weight"`
        LastWeight     float64 `json:"last_weight"`
        Delta4Weeks    float64 `json:"delta_4weeks"`
        RecentTrend    string  `json:"recent_trend"`
        RapidLoss      bool    `json:"rapid_loss"`
        RapidGain      bool    `json:"rapid_gain"`
}

func run(path string, args ...string) []byte {

        cmd := exec.Command(path, args...)
        out, _ := cmd.Output()

        return out
}

func main() {

        if len(os.Args) < 2 {
                fmt.Println("usage: daisy_clinical_report <patient_id>")
                os.Exit(1)
        }

        patientID := os.Args[1]

        summaryRaw := run("/home/paulo/projeto_daisy/bin/clinical_summary", patientID)
        weightRaw := run("/home/paulo/projeto_daisy/bin/weight_interpreter", patientID)

        var summary ClinicalSummary
        _ = json.Unmarshal(summaryRaw, &summary)

        var weight WeightReport
        _ = json.Unmarshal(weightRaw, &weight)

        fmt.Println("")
        fmt.Println("DAISY CLINICAL REPORT")
        fmt.Println("================================================")
        fmt.Println("Generated automatically from longitudinal data")
        fmt.Println("")

        fmt.Println("RENAL STATUS")
        fmt.Println(summary.RenalSummary)
        fmt.Println("")

        fmt.Println("HEPATIC STATUS")
        fmt.Println(summary.HepaticSummary)
        fmt.Println("")

        fmt.Println("METABOLIC STATUS")
        fmt.Println(summary.MetabolicSummary)
        fmt.Println("")

        fmt.Println("WEIGHT STATUS")

        if weight.RapidLoss {
                fmt.Printf("recent weight loss detected (%.2f kg last 4 weeks)\n", weight.Delta4Weeks)
        } else if weight.RapidGain {
                fmt.Printf("recent weight gain detected (%.2f kg last 4 weeks)\n", weight.Delta4Weeks)
        } else {
                fmt.Println("weight stable")
        }

        fmt.Println("")

        fmt.Println("CLINICAL FLAGS")

        if len(summary.OverallFlags) == 0 {
                fmt.Println("no major clinical flags")
        } else {

                for _, f := range summary.OverallFlags {
                        fmt.Println("-", f)
                }
        }

        fmt.Println("")
        fmt.Println("================================================")
        fmt.Println("Report complete")
        fmt.Println("================================================")
}
