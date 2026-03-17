#!/usr/bin/env bash
set -euo pipefail

SQLITE_DB="$HOME/projeto_daisy/database/daisy.db"

echo
echo "CLINICAL PHASE DETECTOR"
echo "================================================"
echo

DATA=$(sqlite3 "$SQLITE_DB" -separator '|' "
SELECT collection_date,creatinine_umol_L
FROM chemistry
WHERE creatinine_umol_L IS NOT NULL
ORDER BY collection_date
")

BASELINE=$(echo "$DATA" | head -n 8 | awk -F'|' '{sum+=$2} END {print sum/NR}')

AKI_THRESHOLD=$(echo "$BASELINE * 2.5" | bc -l)
STABLE_THRESHOLD=$(echo "$BASELINE * 1.5" | bc -l)

AKI_START=""
RECOVERY_START=""
STABILIZATION_START=""
CURRENT_PHASE="BASELINE"

echo "Baseline creatinine estimate:"
printf "%.2f umol/L\n" "$BASELINE"

echo
echo "Phase detection"
echo "------------------------------------------------"

while IFS='|' read DATE VALUE
do

if (( $(echo "$VALUE > $AKI_THRESHOLD" | bc -l) )); then

    if [[ "$CURRENT_PHASE" != "AKI" ]]; then
        echo
        echo "Phase: AKI EVENT"
        echo "Start: $DATE"
        AKI_START="$DATE"
        CURRENT_PHASE="AKI"
    fi

elif [[ "$CURRENT_PHASE" == "AKI" ]]; then

    if (( $(echo "$VALUE < $AKI_THRESHOLD" | bc -l) )); then
        echo
        echo "Phase: RECOVERY"
        echo "Start: $DATE"
        RECOVERY_START="$DATE"
        CURRENT_PHASE="RECOVERY"
    fi

elif [[ "$CURRENT_PHASE" == "RECOVERY" ]]; then

    if (( $(echo "$VALUE < $STABLE_THRESHOLD" | bc -l) )); then
        echo
        echo "Phase: POST-AKI STABILIZATION"
        echo "Start: $DATE"
        STABILIZATION_START="$DATE"
        CURRENT_PHASE="STABLE"
    fi

fi

done <<< "$DATA"

echo
echo "Structured output"
echo "------------------------------------------------"

printf "BASELINE_UMOL_L=%.2f\n" "$BASELINE"
echo "AKI_START=$AKI_START"
echo "RECOVERY_START=$RECOVERY_START"
echo "STABILIZATION_START=$STABILIZATION_START"
echo "CURRENT_PHASE=$CURRENT_PHASE"

echo
echo "Phase detection complete"
