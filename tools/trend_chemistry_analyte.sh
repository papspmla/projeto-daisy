#!/usr/bin/env bash
set -euo pipefail

SQLITE_DB="$HOME/projeto_daisy/database/daisy.db"

PG_HOST="127.0.0.1"
PG_DB="daisy_pg"
PG_USER="daisy"

LAB_ID=1
SPECIES="canine"

if [[ $# -lt 1 ]]; then
    echo "Uso:"
    echo "trend_chemistry_analyte.sh ANALYTE"
    exit 1
fi

ANALYTE="$1"

echo
echo "Trend for $ANALYTE"
echo "-------------------------------------------"

sqlite3 "$SQLITE_DB" -separator '|' "
SELECT collection_date,$ANALYTE
FROM chemistry
WHERE $ANALYTE IS NOT NULL
ORDER BY collection_date
" | while IFS="|" read DATE VALUE
do

UNIT=$(psql -h "$PG_HOST" -U "$PG_USER" -d "$PG_DB" -At -c "
SELECT unit
FROM daisy.reference_ranges
WHERE analyte='$ANALYTE'
LIMIT 1;
")

RANGE=$(psql -h "$PG_HOST" -U "$PG_USER" -d "$PG_DB" -At -c "
SELECT min_value||'|'||max_value
FROM daisy.get_reference_range('$ANALYTE',$LAB_ID,'$SPECIES','$UNIT',DATE '$DATE');
")

MIN=$(echo "$RANGE" | cut -d'|' -f1)
MAX=$(echo "$RANGE" | cut -d'|' -f2)

CLASS="NORMAL"

if (( $(echo "$VALUE < $MIN" | bc -l) )); then
CLASS="LOW"
elif (( $(echo "$VALUE > $MAX" | bc -l) )); then
CLASS="HIGH"
fi

printf "%-12s %10s %6s -> %s\n" "$DATE" "$VALUE" "$UNIT" "$CLASS"

done
