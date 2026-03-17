#!/usr/bin/env bash

# ingest_chem.sh
# Projeto Daisy — Rota B
# Ingestão de bioquímica IDEXX
# Versão inicial estrutural

set -e

DB="$HOME/projeto_daisy/database/daisy.db"
CONFIG_DIR="$HOME/projeto_daisy/config"

usage() {
  echo "Uso:"
  echo "  ingest_chem.sh --date YYYY-MM-DD --raw RAW_FILE --source PDF_NAME --dry-run"
  echo "  ingest_chem.sh --date YYYY-MM-DD --raw RAW_FILE --source PDF_NAME --run"
  exit 1
}

if [[ $# -lt 6 ]]; then
  usage
fi

DATE=""
RAW=""
SOURCE=""
MODE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --date) DATE="$2"; shift 2 ;;
    --raw) RAW="$2"; shift 2 ;;
    --source) SOURCE="$2"; shift 2 ;;
    --dry-run) MODE="dry"; shift ;;
    --run) MODE="run"; shift ;;
    *) usage ;;
  esac
done

if [[ -z "$DATE" || -z "$RAW" || -z "$SOURCE" || -z "$MODE" ]]; then
  usage
fi

echo "Parâmetros recebidos:"
echo "DATE=$DATE"
echo "RAW=$RAW"
echo "SOURCE=$SOURCE"
echo "MODE=$MODE"

# Verifica arquivo raw
if [[ ! -f "$RAW" ]]; then
  echo "ERRO: RAW não encontrado: $RAW" >&2
  exit 2
fi

# Verifica se a data já existe (proteção do UNIQUE antes do INSERT)
EXISTS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM chemistry WHERE collection_date='$DATE';")
if [[ "$EXISTS" != "0" ]]; then
  echo "ERRO: collection_date já existe em chemistry: $DATE" >&2
  exit 3
fi

WL="$CONFIG_DIR/chemistry_whitelist.txt"
BL="$CONFIG_DIR/chemistry_blacklist_urine.txt"

if [[ ! -f "$WL" ]]; then
  echo "ERRO: whitelist não encontrada: $WL" >&2
  exit 4
fi

if [[ ! -f "$BL" ]]; then
  echo "ERRO: blacklist não encontrada: $BL" >&2
  exit 5
fi

# Linhas limpas de bioquímica (pipeline canônico)
CLEAN_LINES=$(grep -F -f "$WL" "$RAW" \
  | grep -E '^[[:space:]]+[A-Za-z]' \
  | grep -v -F -f "$BL" \
  | grep -E '[0-9]' \
  | grep -v 'fasting' \
  | grep -v 'Both SDMA')

if [[ -z "$CLEAN_LINES" ]]; then
  echo "ERRO: nenhuma linha de bioquímica encontrada após limpeza." >&2
  exit 6
fi

VALUES_CSV=$(echo "$CLEAN_LINES" | awk '
function norm(s){ gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
function val_or_null(v){
  v=norm(v)
  if (v ~ /^</ || v ~ /^>/) return "NULL"
  if (v == "") return "NULL"
  return v
}
BEGIN{
  v["glucose_mmol_L"]="NULL"
  v["sdma_ug_dL"]="NULL"
  v["creatinine_umol_L"]="NULL"
  v["urea_mmol_L"]="NULL"
  v["phosphorus_mmol_L"]="NULL"
  v["calcium_mmol_L"]="NULL"
  v["magnesium_mmol_L"]="NULL"
  v["sodium_mmol_L"]="NULL"
  v["potassium_mmol_L"]="NULL"
  v["chloride_mmol_L"]="NULL"
  v["total_protein_g_L"]="NULL"
  v["albumin_g_L"]="NULL"
  v["globulin_g_L"]="NULL"
  v["alt_U_L"]="NULL"
  v["ast_U_L"]="NULL"
  v["alp_U_L"]="NULL"
  v["ggt_U_L"]="NULL"
  v["gldh_U_L"]="NULL"
  v["bilirubin_total_umol_L"]="NULL"
  v["cholesterol_mmol_L"]="NULL"
  v["triglycerides_mmol_L"]="NULL"
  v["amylase_U_L"]="NULL"
  v["lipase_U_L"]="NULL"
  v["ck_U_L"]="NULL"
  v["fructosamine_umol_L"]="NULL"
  v["crp_mg_L"]="NULL"
}
{
  line=$0
  sub(/^[ \t]+/, "", line)
  n=split(line, a, /[ \t]{2,}/)
  if (n < 2) next
  test=norm(a[1])
  val=val_or_null(a[2])

  if (test=="Glucose") v["glucose_mmol_L"]=val
  else if (test=="SDMA (EIA)" || test=="SDMA" || test=="IDEXX SDMA™ EIA" || test=="IDEXX SDMA EIA") v["sdma_ug_dL"]=val
  else if (test=="Creatinine") v["creatinine_umol_L"]=val
  else if (test=="Urea (BUN)") v["urea_mmol_L"]=val
  else if (test=="Inorganic Phosphate" || test=="Phosphate") v["phosphorus_mmol_L"]=val
  else if (test=="Calcium") v["calcium_mmol_L"]=val
  else if (test=="Magnesium") v["magnesium_mmol_L"]=val
  else if (test=="Sodium") v["sodium_mmol_L"]=val
  else if (test=="Potassium") v["potassium_mmol_L"]=val
  else if (test=="Chloride") v["chloride_mmol_L"]=val
  else if (test=="Total protein") v["total_protein_g_L"]=val
  else if (test=="Albumin") v["albumin_g_L"]=val
  else if (test=="Globulin") v["globulin_g_L"]=val
  else if (test=="ALT (GPT)") v["alt_U_L"]=val
  else if (test=="AST (GOT)") v["ast_U_L"]=val
  else if (test=="Alkaline phosphatase") v["alp_U_L"]=val
  else if (test=="GGT") v["ggt_U_L"]=val
  else if (test=="GLDH") v["gldh_U_L"]=val
  else if (test=="Total Bilirubin" || test=="Bilirubin (total)") v["bilirubin_total_umol_L"]=val
  else if (test=="Cholesterol") v["cholesterol_mmol_L"]=val
  else if (test=="Triglycerides") v["triglycerides_mmol_L"]=val
  else if (test=="a-Amylase") v["amylase_U_L"]=val
  else if (test=="Lipase") v["lipase_U_L"]=val
  else if (test=="CK") v["ck_U_L"]=val
  else if (test=="Fructosamine") v["fructosamine_umol_L"]=val
  else if (test=="CRP" || test=="CRP (C-reactive protein)") v["crp_mg_L"]=val
}
END{
  printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
    v["glucose_mmol_L"],
    v["sdma_ug_dL"],
    v["creatinine_umol_L"],
    v["urea_mmol_L"],
    v["phosphorus_mmol_L"],
    v["calcium_mmol_L"],
    v["magnesium_mmol_L"],
    v["sodium_mmol_L"],
    v["potassium_mmol_L"],
    v["chloride_mmol_L"],
    v["total_protein_g_L"],
    v["albumin_g_L"],
    v["globulin_g_L"],
    v["alt_U_L"],
    v["ast_U_L"],
    v["alp_U_L"],
    v["ggt_U_L"],
    v["gldh_U_L"],
    v["bilirubin_total_umol_L"],
    v["cholesterol_mmol_L"],
    v["triglycerides_mmol_L"],
    v["amylase_U_L"],
    v["lipase_U_L"],
    v["ck_U_L"],
    v["fructosamine_umol_L"],
    v["crp_mg_L"]
}
')

# Escapa aspas simples para SQL
SOURCE_SQL=${SOURCE//\'/\'\'}



SQL="INSERT INTO chemistry (collection_date,report_date,glucose_mmol_L,sdma_ug_dL,creatinine_umol_L,urea_mmol_L,phosphorus_mmol_L,calcium_mmol_L,magnesium_mmol_L,sodium_mmol_L,potassium_mmol_L,chloride_mmol_L,total_protein_g_L,albumin_g_L,globulin_g_L,alt_U_L,ast_U_L,alp_U_L,ggt_U_L,gldh_U_L,bilirubin_total_umol_L,cholesterol_mmol_L,triglycerides_mmol_L,amylase_U_L,lipase_U_L,ck_U_L,fructosamine_umol_L,crp_mg_L,source) VALUES ('$DATE','$DATE',$VALUES_CSV,'$SOURCE_SQL');"

echo ""
echo "=== SQL (uma linha) ==="
echo "$SQL"

if [[ "$MODE" == "dry" ]]; then
  exit 0
fi

sqlite3 "$DB" "$SQL"
echo "OK: inserido em chemistry: $DATE"
