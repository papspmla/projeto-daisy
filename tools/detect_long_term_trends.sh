#!/usr/bin/env bash
set -euo pipefail

SQLITE_DB="$HOME/projeto_daisy/database/daisy.db"

if [[ $# -lt 1 ]]; then
    echo "Uso:"
    echo "detect_long_term_trends.sh ANALYTE"
    exit 1
fi

ANALYTE="$1"

echo
echo "LONG TERM TREND ANALYSIS"
echo "======================================="
echo "Analyte: $ANALYTE"
echo

DATA=$(sqlite3 "$SQLITE_DB" -separator '|' "
SELECT collection_date,$ANALYTE
FROM chemistry
WHERE $ANALYTE IS NOT NULL
ORDER BY collection_date
")

COUNT=$(echo "$DATA" | wc -l)

if [[ $COUNT -lt 5 ]]; then
    echo "Not enough data for trend analysis"
    exit 0
fi

FIRST=$(echo "$DATA" | head -n1 | cut -d'|' -f2)
LAST=$(echo "$DATA" | tail -n1 | cut -d'|' -f2)

DELTA=$(echo "$LAST - $FIRST" | bc -l)

echo "First value: $FIRST"
echo "Last value : $LAST"
echo "Delta      : $DELTA"
echo

THRESHOLD=$(echo "$FIRST * 0.15" | bc -l)

TREND="STABLE"

if (( $(echo "$DELTA > $THRESHOLD" | bc -l) )); then
TREND="RISING"
elif (( $(echo "$DELTA < -$THRESHOLD" | bc -l) )); then
TREND="FALLING"
fi

echo "Detected trend:"
echo "$TREND"

echo
echo "Timeline:"
echo "--------------------------------"

echo "$DATA" | while IFS='|' read DATE VALUE
do
printf "%-12s %10s\n" "$DATE" "$VALUE"
done

echo
echo "Analysis complete"
