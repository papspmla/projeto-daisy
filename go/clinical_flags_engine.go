package main

import (
        "encoding/json"
        "fmt"
        "os"
        "os/exec"
        "strings"
)

type TrendDetail struct {
        Trend    string  `json:"trend"`
        FirstAvg float64 `json:"first_avg"`
        LastAvg  float64 `json:"last_avg"`
        Delta    float64 `json:"delta"`
}

type WeightReport struct {
        RapidLoss     bool   `json:"rapid_loss"`
        RapidGain     bool   `json:"rapid_gain"`
        RecentTrend   string `json:"recent_trend"`
        LongTermTrend string `json:"long_term_trend"`
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

func runCommand(path string, args ...string) []byte {
        c := exec.Command(path, args...)
        out, _ := c.Output()
        return out
}

func main() {

        if len(os.Args) < 2 {
                fmt.Println("usage: clinical_flags_engine <patient_id>")
                os.Exit(1)
        }

        patientID := os.Args[1]

        phaseRaw := runCommand("/home/paulo/projeto_daisy/bin/detect_clinical_phases", patientID)
        trendRaw := runCommand("/home/paulo/projeto_daisy/bin/trend_analyzer", patientID)
        weightRaw := runCommand("/home/paulo/projeto_daisy/bin/weight_interpreter", patientID)

        var trends map[string]TrendDetail
        _ = json.Unmarshal(trendRaw, &trends)

        var weight WeightReport
        _ = json.Unmarshal(weightRaw, &weight)

        flags := ClinicalFlags{}

        phaseStr := string(phaseRaw)
        if strings.Contains(phaseStr, "CURRENT_PHASE") {
                flags.AKIHistoryPresent = true
        }

        creat, creatOK := trends["creatinine_umol_L"]
        sdma, sdmaOK := trends["sdma_ug_dL"]
        phos, phosOK := trends["phosphorus_mmol_L"]
        k, kOK := trends["potassium_mmol_L"]
        alt, altOK := trends["alt_U_L"]
        alp, alpOK := trends["alp_U_L"]
        bili, biliOK := trends["bilirubin_total_umol_L"]
        chol, cholOK := trends["cholesterol_mmol_L"]
        glu, gluOK := trends["glucose_mmol_L"]
        trig, trigOK := trends["triglycerides_mmol_L"]

        if creatOK && sdmaOK {

                if creat.Trend == "increasing" && sdma.Trend == "stable" {
                        flags.RenalCompensationStable = true
                }

                if creat.Trend == "increasing" && sdma.Trend == "increasing" {
                        flags.ProgressiveCKDPattern = true
                }
        }

        if phosOK && kOK {

                if phos.Trend == "stable" && k.Trend == "stable" {
                        flags.ElectrolytesPreserved = true
                }
        }

        if altOK && alpOK && biliOK {

                if (alt.Trend == "increasing" || alp.Trend == "increasing") && bili.Trend != "stable" {
                        flags.HepaticActivePattern = true
                }
        }

        if cholOK && gluOK && trigOK {

                if chol.Trend == "increasing" || glu.Trend == "increasing" || trig.Trend == "increasing" {
                        flags.MetabolicInstability = true
                }
        }

        if weight.RapidLoss {
                flags.WeightRapidLoss = true
        }

        if weight.RapidGain {
                flags.WeightRapidGain = true
        }

        if weight.RecentTrend == "decreasing" {
                flags.WeightRecentDecrease = true
        }

        if weight.RecentTrend == "increasing" {
                flags.WeightRecentIncrease = true
        }

        out, _ := json.MarshalIndent(flags, "", "  ")
        fmt.Println(string(out))
}
