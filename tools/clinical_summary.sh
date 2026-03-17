#!/usr/bin/env bash

TOOLS="$HOME/projeto_daisy/tools"

get_last_line() {
    local analyte="$1"
    "$TOOLS/trend_chemistry_analyte.sh" "$analyte" | tail -n 1
}

get_status() {
    local line="$1"
    echo "$line" | awk '{print $NF}'
}

print_status_sentence() {
    local label="$1"
    local status="$2"

    if [[ "$status" == "NORMAL" ]]; then
        echo "$label currently within reference range."
    elif [[ "$status" == "HIGH" ]]; then
        echo "$label currently above reference range."
    elif [[ "$status" == "LOW" ]]; then
        echo "$label currently below reference range."
    fi
}

PHASE_DATA=$("$TOOLS/detect_clinical_phases.sh" | grep -E '^[A-Z_]+=')
eval "$PHASE_DATA"

echo
echo "CLINICAL SUMMARY"
echo "================================"
echo

echo "Renal history"
echo "-------------"
echo "AKI detected: $AKI_START"
echo "Recovery phase: $RECOVERY_START"
echo "Post-AKI stabilization: $STABILIZATION_START"
echo
echo "Current phase: $CURRENT_PHASE"
echo
echo "Baseline creatinine: $BASELINE_UMOL_L µmol/L"
echo

echo "Current renal panel status"
echo "---------------------------"

CREAT_LAST=$(get_last_line creatinine_umol_L)
SDMA_LAST=$(get_last_line sdma_ug_dL)
PHOS_LAST=$(get_last_line phosphorus_mmol_L)
UREA_LAST=$(get_last_line urea_mmol_L)
K_LAST=$(get_last_line potassium_mmol_L)

echo "Creatinine : $CREAT_LAST"
echo "SDMA       : $SDMA_LAST"
echo "Phosphorus : $PHOS_LAST"
echo "Urea       : $UREA_LAST"
echo "Potassium  : $K_LAST"

echo
echo "Current extended chemistry status"
echo "---------------------------------"

CA_LAST=$(get_last_line calcium_mmol_L)
MG_LAST=$(get_last_line magnesium_mmol_L)
NA_LAST=$(get_last_line sodium_mmol_L)
CL_LAST=$(get_last_line chloride_mmol_L)
TG_LAST=$(get_last_line triglycerides_mmol_L)
ALT_LAST=$(get_last_line alt_U_L)
AST_LAST=$(get_last_line ast_U_L)
ALP_LAST=$(get_last_line alp_U_L)

echo "Calcium       : $CA_LAST"
echo "Magnesium     : $MG_LAST"
echo "Sodium        : $NA_LAST"
echo "Chloride      : $CL_LAST"
echo "Triglycerides : $TG_LAST"
echo "ALT           : $ALT_LAST"
echo "AST           : $AST_LAST"
echo "ALP           : $ALP_LAST"

echo
echo "Clinical interpretation"
echo "-----------------------"

CREAT_STATUS=$(get_status "$CREAT_LAST")
SDMA_STATUS=$(get_status "$SDMA_LAST")
PHOS_STATUS=$(get_status "$PHOS_LAST")
UREA_STATUS=$(get_status "$UREA_LAST")
K_STATUS=$(get_status "$K_LAST")

CA_STATUS=$(get_status "$CA_LAST")
MG_STATUS=$(get_status "$MG_LAST")
NA_STATUS=$(get_status "$NA_LAST")
CL_STATUS=$(get_status "$CL_LAST")
TG_STATUS=$(get_status "$TG_LAST")
ALT_STATUS=$(get_status "$ALT_LAST")
AST_STATUS=$(get_status "$AST_LAST")
ALP_STATUS=$(get_status "$ALP_LAST")

CHOL_TREND=$("$TOOLS/trend_chemistry_analyte.sh" cholesterol_mmol_L)

if [[ "$CURRENT_PHASE" == "STABLE" && "$CREAT_STATUS" == "NORMAL" && "$SDMA_STATUS" == "NORMAL" ]]; then
    echo "Renal function stable since AKI recovery."
    echo "No progressive CKD pattern detected."
fi

if [[ "$CREAT_STATUS" == "HIGH" ]]; then
    echo "Creatinine currently above reference range."
fi

if [[ "$SDMA_STATUS" == "HIGH" ]]; then
    echo "SDMA currently above reference range."
fi

print_status_sentence "Phosphorus" "$PHOS_STATUS"
print_status_sentence "Urea" "$UREA_STATUS"
print_status_sentence "Potassium" "$K_STATUS"

echo

if [[ "$NA_STATUS" == "NORMAL" && "$K_STATUS" == "NORMAL" && "$CL_STATUS" == "NORMAL" ]]; then
    echo "Electrolytes are currently within reference range."
else
    print_status_sentence "Sodium" "$NA_STATUS"
    print_status_sentence "Chloride" "$CL_STATUS"
fi

print_status_sentence "Calcium" "$CA_STATUS"
print_status_sentence "Magnesium" "$MG_STATUS"
print_status_sentence "Triglycerides" "$TG_STATUS"

echo

if [[ "$ALT_STATUS" == "NORMAL" && "$AST_STATUS" == "NORMAL" && "$ALP_STATUS" == "NORMAL" ]]; then
    echo "Liver enzymes are currently within reference range."
else
    print_status_sentence "ALT" "$ALT_STATUS"
    print_status_sentence "AST" "$AST_STATUS"
    print_status_sentence "ALP" "$ALP_STATUS"
fi

if echo "$CHOL_TREND" | grep -q "HIGH"; then
    echo "Cholesterol intermittently elevated."
fi

echo
