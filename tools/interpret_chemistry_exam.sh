#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# interpret_chemistry_exam.sh
# Projeto Daisy
#
# Interpretação automática de exame chemistry
# com suporte a:
#  - ordenação clínica (HIGH / LOW / NORMAL)
#  - modo abnormal
#  - geração JSON
#  - geração CSV
# ------------------------------------------------------------

SQLITE_DB="$HOME/projeto_daisy/database/daisy.db"

PG_HOST="127.0.0.1"
PG_DB="daisy_pg"
PG_USER="daisy"

LAB_ID=1
SPECIES="canine"

MODE="${2:-full}"

if [[ $# -lt 1 ]]; then
    echo "Uso:"
    echo "interpret_chemistry_exam.sh YYYY-MM-DD [abnormal]"
    exit 1
fi

EXAM_DATE="$1"

echo
echo "Interpretando exame chemistry"
echo "Data da coleta: $EXAM_DATE"
echo

if ! sqlite3 "$SQLITE_DB" "SELECT 1 FROM chemistry WHERE collection_date='$EXAM_DATE' LIMIT 1;" | grep -q 1; then
    echo "ERRO: exame não encontrado."
    exit 1
fi

ANALYTES=(
glucose_mmol_L
sdma_ug_dL
creatinine_umol_L
urea_mmol_L
phosphorus_mmol_L
calcium_mmol_L
magnesium_mmol_L
sodium_mmol_L
potassium_mmol_L
chloride_mmol_L
total_protein_g_L
albumin_g_L
globulin_g_L
alt_U_L
ast_U_L
alp_U_L
ggt_U_L
gldh_U_L
bilirubin_total_umol_L
cholesterol_mmol_L
triglycerides_mmol_L
amylase_U_L
lipase_U_L
ck_U_L
fructosamine_umol_L
crp_mg_L
)

declare -A UNIT_MAP

UNIT_MAP[glucose_mmol_L]="mmol/L"
UNIT_MAP[sdma_ug_dL]="ug/dL"
UNIT_MAP[creatinine_umol_L]="umol/L"
UNIT_MAP[urea_mmol_L]="mmol/L"
UNIT_MAP[phosphorus_mmol_L]="mmol/L"
UNIT_MAP[calcium_mmol_L]="mmol/L"
UNIT_MAP[magnesium_mmol_L]="mmol/L"
UNIT_MAP[sodium_mmol_L]="mmol/L"
UNIT_MAP[potassium_mmol_L]="mmol/L"
UNIT_MAP[chloride_mmol_L]="mmol/L"
UNIT_MAP[total_protein_g_L]="g/L"
UNIT_MAP[albumin_g_L]="g/L"
UNIT_MAP[globulin_g_L]="g/L"
UNIT_MAP[alt_U_L]="U/L"
UNIT_MAP[ast_U_L]="U/L"
UNIT_MAP[alp_U_L]="U/L"
UNIT_MAP[ggt_U_L]="U/L"
UNIT_MAP[gldh_U_L]="U/L"
UNIT_MAP[bilirubin_total_umol_L]="umol/L"
UNIT_MAP[cholesterol_mmol_L]="mmol/L"
UNIT_MAP[triglycerides_mmol_L]="mmol/L"
UNIT_MAP[amylase_U_L]="U/L"
UNIT_MAP[lipase_U_L]="U/L"
UNIT_MAP[ck_U_L]="U/L"
UNIT_MAP[fructosamine_umol_L]="umol/L"
UNIT_MAP[crp_mg_L]="mg/L"

HIGH_BLOCK=""
LOW_BLOCK=""
NORMAL_BLOCK=""

JSON_OUT="$HOME/projeto_daisy/logs/interpret_chemistry_${EXAM_DATE}.json"
CSV_OUT="$HOME/projeto_daisy/logs/interpret_chemistry_${EXAM_DATE}.csv"

mkdir -p "$HOME/projeto_daisy/logs"

echo "analyte,value,unit,min,max,class" > "$CSV_OUT"

{
echo "{"
echo "  \"exam_date\": \"$EXAM_DATE\","
echo "  \"lab_id\": $LAB_ID,"
echo "  \"species\": \"$SPECIES\","
echo "  \"analytes\": ["
} > "$JSON_OUT"

FIRST=1

for ANALYTE in "${ANALYTES[@]}"; do

VALUE=$(sqlite3 "$SQLITE_DB" "
SELECT $ANALYTE
FROM chemistry
WHERE collection_date='$EXAM_DATE';
")

if [[ -z "$VALUE" ]]; then
    continue
fi

UNIT="${UNIT_MAP[$ANALYTE]}"

RANGE=$(psql -h "$PG_HOST" -U "$PG_USER" -d "$PG_DB" -At -c "
SELECT min_value||'|'||max_value
FROM daisy.get_reference_range('$ANALYTE',$LAB_ID,'$SPECIES','$UNIT',DATE '$EXAM_DATE');
")

MIN=$(echo "$RANGE" | cut -d'|' -f1)
MAX=$(echo "$RANGE" | cut -d'|' -f2)

CLASS="NORMAL"

if (( $(echo "$VALUE < $MIN" | bc -l) )); then
    CLASS="LOW"
elif (( $(echo "$VALUE > $MAX" | bc -l) )); then
    CLASS="HIGH"
fi

LINE=$(printf "%-25s %10s %6s (%s - %s) -> %s" "$ANALYTE" "$VALUE" "$UNIT" "$MIN" "$MAX" "$CLASS")

case "$CLASS" in
HIGH)
HIGH_BLOCK+="$LINE"$'\n'
;;
LOW)
LOW_BLOCK+="$LINE"$'\n'
;;
NORMAL)
NORMAL_BLOCK+="$LINE"$'\n'
;;
esac

echo "$ANALYTE,$VALUE,$UNIT,$MIN,$MAX,$CLASS" >> "$CSV_OUT"

if [[ $FIRST -eq 0 ]]; then
echo "," >> "$JSON_OUT"
fi

printf '    {"analyte":"%s","value":%s,"unit":"%s","min":%s,"max":%s,"class":"%s"}' \
"$ANALYTE" "$VALUE" "$UNIT" "$MIN" "$MAX" "$CLASS" >> "$JSON_OUT"

FIRST=0

done

{
echo
echo "  ]"
echo "}"
} >> "$JSON_OUT"

echo
echo "Interpretação clínica"
echo "------------------------------------------------"

if [[ "$MODE" == "abnormal" ]]; then
printf "%s" "$HIGH_BLOCK"
printf "%s" "$LOW_BLOCK"
else
printf "%s" "$HIGH_BLOCK"
printf "%s" "$LOW_BLOCK"
printf "%s" "$NORMAL_BLOCK"
fi

echo
echo "JSON:"
echo "$JSON_OUT"

echo
echo "CSV:"
echo "$CSV_OUT"
