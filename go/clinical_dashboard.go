package main

import (
        "encoding/json"
        "fmt"
        "os"
        "os/exec"
        "strings"
)

type Summary struct {
        RenalSummary     string   `json:"renal_summary"`
        HepaticSummary   string   `json:"hepatic_summary"`
        MetabolicSummary string   `json:"metabolic_summary"`
        OverallFlags     []string `json:"overall_flags"`
}

func runCommand(name string, args ...string) []byte {
        cmd := exec.Command(name, args...)
        out, _ := cmd.Output()
        return out
}

func cleanPhase(s string) string {
        s = strings.TrimSpace(s)
        s = strings.TrimPrefix(s, "CURRENT_PHASE=")
        return s
}

func main() {

        if len(os.Args) < 2 {
                fmt.Println("usage: clinical_dashboard <patient_id>")
                os.Exit(1)
        }

        patientID := os.Args[1]

        fmt.Println()
        fmt.Println("DAISY CLINICAL STATUS")
        fmt.Println("================================================")

        phaseRaw := runCommand("/home/paulo/projeto_daisy/bin/detect_clinical_phases", patientID)
        renalModel := runCommand("/home/paulo/projeto_daisy/bin/renal_function_model", patientID)
        alerts := runCommand("/home/paulo/projeto_daisy/bin/clinical_alerts", patientID)
        summaryJSON := runCommand("/home/paulo/projeto_daisy/bin/clinical_summary", patientID)

        phaseLine := ""
        for _, line := range strings.Split(string(phaseRaw), "\n") {
                if strings.Contains(line, "CURRENT_PHASE") {
                        phaseLine = line
                        break
                }
        }

        var alertList []string
        _ = json.Unmarshal(alerts, &alertList)

        var summary Summary
        _ = json.Unmarshal(summaryJSON, &summary)

        fmt.Println()
        fmt.Println("PHASE")
        fmt.Println(cleanPhase(phaseLine))
        fmt.Println()

        fmt.Println("RENAL")
        fmt.Println(summary.RenalSummary)
        fmt.Println()

        fmt.Println("RENAL MODEL")
        fmt.Print(string(renalModel))
        fmt.Println()

        fmt.Println("HEPATIC")
        fmt.Println(summary.HepaticSummary)
        fmt.Println()

        fmt.Println("METABOLIC")
        fmt.Println(summary.MetabolicSummary)
        fmt.Println()

        fmt.Println("ALERTS")
        for _, a := range alertList {
                fmt.Println("-", a)
        }

        fmt.Println()
}
