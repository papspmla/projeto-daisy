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
                fmt.Println("usage: clinical_consistency_engine <patient_id>")
                os.Exit(1)
        }

        patientID := os.Args[1]

        trendRaw := runCommand("/home/paulo/projeto_daisy/bin/trend_analyzer", patientID)
        flagsRaw := runCommand("/home/paulo/projeto_daisy/bin/clinical_flags_engine", patientID)

        var trends map[string]TrendDetail
        _ = json.Unmarshal(trendRaw, &trends)

        var flags ClinicalFlags
        _ = json.Unmarshal(flagsRaw, &flags)

        findings := []string{}

        if c, ok := trends["creatinine_umol_L"]; ok {
                if s, ok := trends["sdma_ug_dL"]; ok {
                        if p, ok := trends["phosphorus_mmol_L"]; ok {
                                if c.Trend == "increasing" && s.Trend == "stable" && p.Trend == "stable" {
                                        findings = append(findings, "creatinine rise with stable SDMA and phosphorus suggests post-AKI functional plateau rather than active progression")
                                }
                        }
                }
        }

        if alp, ok := trends["alp_U_L"]; ok {
                if alt, ok := trends["alt_U_L"]; ok {
                        if alp.Trend == "increasing" && alt.Trend == "decreasing" {
                                findings = append(findings, "ALP increasing with ALT decreasing does not suggest active hepatocellular injury pattern")
                        }
                }
        }

        if c, ok := trends["cholesterol_mmol_L"]; ok {
                if t, ok := trends["triglycerides_mmol_L"]; ok {
                        if g, ok := trends["glucose_mmol_L"]; ok {
                                if c.Trend == "stable" && t.Trend == "stable" && g.Trend == "stable" && !flags.MetabolicInstability {
                                        findings = append(findings, "lipid and glucose profile remains metabolically stable overall")
                                }
                        }
                }
        }

        if flags.RenalCompensationStable && flags.ElectrolytesPreserved && !flags.ProgressiveCKDPattern {
                findings = append(findings, "renal profile is internally consistent with stable compensation")
        }

        if len(findings) == 0 {
                findings = append(findings, "no major cross-domain consistency findings")
        }

        out, _ := json.MarshalIndent(findings, "", "  ")
        fmt.Println(string(out))
}
