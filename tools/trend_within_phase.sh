#!/usr/bin/env bash
set -euo pipefail

SQLITE_DB="$HOME/projeto_daisy/database/daisy.db"

if [[ $# -lt 1 ]]; then
    echo "Uso:"
    echo "trend_within_phase.sh ANALYTE"
    exit 1
fi

ANALYTE="$1"

echo
echo "TREND WITHIN CURRENT CLINICAL PHASE"
echo "================================================"
echo "Analyte: $ANALYTE"
echo

DATA=$(sqlite3 "$SQLITE_DB" -separator '|' "
SELECT collection_date,creatinine_umol_L
FROM chemistry
WHERE creatinine_umol_L IS NOT NULL
ORDER BY collection_date
")

BASELINE=$(echo "$DATA" | head -n 8 | awk -F'|' '{sum+=$2} END {print sum/NR}')
AKI_THRESHOLD=$(echo "$BASELINE * 2.5" | bc -l)

PHASE="BASELINE"
PHASE_START=""

while IFS='|' read DATE VALUE
do

if (( $(echo "$VALUE > $AKI_THRESHOLD" | bc -l) )); then
    PHASE="AKI"

elif [[ "$PHASE" == "AKI" ]] && (( $(echo "$VALUE < $AKI_THRESHOLD" | bc -l) )); then
    PHASE="RECOVERY"

elif [[ "$PHASE" == "RECOVERY" ]] && (( $(echo "$VALUE < ($BASELINE * 1.5)" | bc -l) )); then
    PHASE="STABLE"
    PHASE_START="$DATE"
fi

done <<< "$DATA"

if [[ -z "$PHASE_START" ]]; then
    echo "Could not determine stabilization phase"
    exit 0
fi

echo "Current phase: POST-AKI STABILIZATION"
echo "Phase start  : $PHASE_START"
echo

PHASE_DATA=$(sqlite3 "$SQLITE_DB" -separator '|' "
SELECT collection_date,$ANALYTE
FROM chemistry
WHERE collection_date >= '$PHASE_START'
AND $ANALYTE IS NOT NULL
ORDER BY collection_date
")

COUNT=$(echo "$PHASE_DATA" | wc -l)

if [[ $COUNT -lt 3 ]]; then
    echo "Not enough data in this phase"
    exit 0
fi

FIRST=$(echo "$PHASE_DATA" | head -n1 | cut -d'|' -f2)
LAST=$(echo "$PHASE_DATA" | tail -n1 | cut -d'|' -f2)

DELTA=$(echo "$LAST - $FIRST" | bc -l)

THRESHOLD=$(echo "$FIRST * 0.15" | bc -l)

TREND="STABLE"

if (( $(echo "$DELTA > $THRESHOLD" | bc -l) )); then
TREND="RISING"
elif (( $(echo "$DELTA < -$THRESHOLD" | bc -l) )); then
TREND="FALLING"
fi

echo "First value in phase: $FIRST"
echo "Last value in phase : $LAST"
echo "Delta               : $DELTA"
echo

echo "Detected trend in current phase:"
echo "$TREND"

echo
echo "Timeline within phase:"
echo "--------------------------------"

while IFS='|' read DATE VALUE
do
printf "%-12s %10s\n" "$DATE" "$VALUE"
done <<< "$PHASE_DATA"

echo
echo "Analysis complete"
