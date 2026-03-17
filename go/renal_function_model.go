package main

import (
        "encoding/json"
        "fmt"
        "os"
        "os/exec"
        "strconv"
        "strings"
)

type TrendDetail struct {
        Trend    string  `json:"trend"`
        FirstAvg float64 `json:"first_avg"`
        LastAvg  float64 `json:"last_avg"`
        Delta    float64 `json:"delta"`
}

func runCommand(name string, args ...string) string {
        cmd := exec.Command(name, args...)
        out, err := cmd.Output()
        if err != nil {
                return ""
        }
        return string(out)
}

func extractValueAfterEquals(s string) float64 {
        lines := strings.Split(s, "\n")
        for _, line := range lines {
                line = strings.TrimSpace(line)
                if strings.Contains(line, "=") {
                        parts := strings.SplitN(line, "=", 2)
                        if len(parts) == 2 {
                                v, err := strconv.ParseFloat(strings.TrimSpace(parts[1]), 64)
                                if err == nil {
                                        return v
                                }
                        }
                }
        }
        return 0
}

func main() {

        if len(os.Args) < 2 {
                fmt.Println("usage: renal_function_model <patient_id>")
                os.Exit(1)
        }

        patientID := os.Args[1]

        fmt.Println()
        fmt.Println("RENAL FUNCTION MODEL")
        fmt.Println("================================================")

        phaseRaw := runCommand("/home/paulo/projeto_daisy/bin/detect_clinical_phases", patientID)
        baselineOutput := ""
        for _, line := range strings.Split(phaseRaw, "\n") {
                if strings.Contains(line, "BASELINE_UMOL_L") {
                        baselineOutput = line
                        break
                }
        }

        baseline := extractValueAfterEquals(baselineOutput)

        trendOutput := runCommand("/home/paulo/projeto_daisy/bin/trend_analyzer", patientID)

        var trends map[string]TrendDetail
        if err := json.Unmarshal([]byte(trendOutput), &trends); err != nil {
                fmt.Println("Error parsing trend_analyzer JSON")
                os.Exit(1)
        }

        creat, ok := trends["creatinine_umol_L"]
        if !ok {
                fmt.Println("creatinine_umol_L not found in trend_analyzer output")
                os.Exit(1)
        }

        current := creat.LastAvg

        if baseline == 0 || current == 0 {
                fmt.Println("Invalid renal model inputs")
                fmt.Printf("Baseline: %.2f\n", baseline)
                fmt.Printf("Current: %.2f\n", current)
                os.Exit(1)
        }

        gfrFraction := baseline / current
        preserved := gfrFraction * 100
        loss := 100 - preserved

        fmt.Println()
        fmt.Printf("Baseline creatinine: %.2f µmol/L\n", baseline)
        fmt.Printf("Post-AKI plateau: %.2f µmol/L\n", current)

        fmt.Println()
        fmt.Printf("Estimated renal function preserved: %.1f %%\n", preserved)
        fmt.Printf("Estimated nephron loss: %.1f %%\n", loss)

        fmt.Println()
        if preserved > 70 {
                fmt.Println("Interpretation: mild-to-moderate nephron loss with good compensation")
        } else if preserved > 50 {
                fmt.Println("Interpretation: moderate renal functional loss")
        } else {
                fmt.Println("Interpretation: significant nephron loss")
        }

        fmt.Println()
}
