#!/usr/bin/env bash
set -euo pipefail

SQLITE_DB="$HOME/projeto_daisy/database/daisy.db"

echo
echo "RENAL EVENT DETECTOR"
echo "=============================================="
echo

DATA=$(sqlite3 "$SQLITE_DB" -separator '|' "
SELECT collection_date,creatinine_umol_L
FROM chemistry
WHERE creatinine_umol_L IS NOT NULL
ORDER BY collection_date
")

BASELINE=$(echo "$DATA" | head -n 8 | awk -F'|' '{sum+=$2} END {print sum/NR}')

echo "Estimated baseline creatinine:"
printf "%.2f umol/L\n" "$BASELINE"

echo
echo "Scanning timeline"
echo "----------------------------------------------"

AKI_FLAG=0
RECOVERY_FLAG=0

echo "$DATA" | while IFS='|' read DATE VALUE
do

THRESHOLD=$(echo "$BASELINE * 2.5" | bc -l)

if (( $(echo "$VALUE > $THRESHOLD" | bc -l) )); then

    if [[ $AKI_FLAG -eq 0 ]]; then
        echo "$DATE   AKI DETECTED   creatinine=$VALUE"
        AKI_FLAG=1
    fi

elif [[ $AKI_FLAG -eq 1 ]]; then

    if (( $(echo "$VALUE < $THRESHOLD" | bc -l) )); then

        if [[ $RECOVERY_FLAG -eq 0 ]]; then
            echo "$DATE   RECOVERY PHASE   creatinine=$VALUE"
            RECOVERY_FLAG=1
        fi

    fi

fi

done

echo
echo "Scan complete"
