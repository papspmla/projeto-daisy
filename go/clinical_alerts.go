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

func getTrends(patientID string) map[string]TrendDetail {

        cmd := exec.Command("trend_analyzer", patientID)
        out, err := cmd.Output()

        if err != nil {
                fmt.Println("Error running trend_analyzer")
                return nil
        }

        var trends map[string]TrendDetail
        json.Unmarshal(out, &trends)

        return trends
}

func main() {

        if len(os.Args) < 2 {
                fmt.Println("usage: clinical_alerts <patient_id>")
                os.Exit(1)
        }

        patientID := os.Args[1]

        trends := getTrends(patientID)

        alerts := []string{}

        if c, ok := trends["creatinine_umol_L"]; ok {
                if c.Trend == "increasing" {
                        alerts = append(alerts, "creatinine increasing")
                }
        }

        if a, ok := trends["alp_U_L"]; ok {
                if a.Trend == "increasing" {
                        alerts = append(alerts, "ALP increasing")
                }
        }

        if l, ok := trends["lipase_U_L"]; ok {
                if l.Trend == "increasing" {
                        alerts = append(alerts, "lipase increasing")
                }
        }

        if len(alerts) == 0 {
                alerts = append(alerts, "no active alerts")
        }

        out, _ := json.MarshalIndent(alerts, "", "  ")

        fmt.Println(string(out))
}
