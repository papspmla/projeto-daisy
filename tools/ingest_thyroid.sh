#!/usr/bin/env bash
set -euo pipefail

DB="$HOME/projeto_daisy/database/daisy.db"
PATIENT_ID=1

usage() {
  echo "Uso:"
  echo "  ingest_thyroid.sh <PDF> --dry-run"
  echo "  ingest_thyroid.sh <PDF> --run"
}

if [[ $# -ne 2 ]]; then
  usage
  exit 1
fi

PDF="$1"
MODE="$2"

if [[ "$MODE" != "--dry-run" && "$MODE" != "--run" ]]; then
  echo "Modo inválido: $MODE"
  usage
  exit 1
fi

if [[ ! -f "$PDF" ]]; then
  echo "PDF não encontrado: $PDF"
  exit 1
fi

TMP="$(mktemp)"
cleanup() { rm -f "$TMP"; }
trap cleanup EXIT

pdftotext -layout "$PDF" "$TMP"

# Date of receipt -> YYYY-MM-DD
dor_line="$(grep -m1 'Date of receipt:' "$TMP" || true)"
dor="$(echo "$dor_line" | sed -nE 's/.*Date of receipt:[[:space:]]*([0-9]{2})\.([0-9]{2})\.([0-9]{4}).*/\3-\2-\1/p')"
if [[ -z "$dor" ]]; then
  echo "Date of receipt não encontrada ou não parseável."
  exit 1
fi

extract_value_sql() {
  local label="$1"
  local line rest value

  line="$(grep -F "$label" -m1 "$TMP" || true)"
  if [[ -z "$line" ]]; then
    echo "NULL"
    return
  fi

  rest="${line#*$label}"
  rest="$(echo "$rest" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
  value="$(echo "$rest" | awk '{print $1}')"

  if [[ "$value" == \<* || "$value" == \>* ]]; then
    echo "NULL"
    return
  fi

  if echo "$value" | grep -Eq '^[0-9]+([.][0-9]+)?$'; then
    echo "$value"
  else
    echo "NULL"
  fi
}

t4_total="$(extract_value_sql 'T4 (total T4) EIA')"
ft4="$(extract_value_sql 'Free T4 CLIA')"
tsh="$(extract_value_sql 'TSH, canine CLIA')"

echo "collection_date = $dor"
echo "t4_total = $t4_total"
echo "ft4 = $ft4"
echo "tsh = $tsh"
echo

exists="$(sqlite3 "$DB" "SELECT 1 FROM thyroid WHERE patient_id=$PATIENT_ID AND collection_date='$dor' LIMIT 1;")"

if [[ -n "$exists" ]]; then
  echo "Registro já existe para essa data (patient_id=$PATIENT_ID, collection_date=$dor)."
  exit 1
fi

SQL="
INSERT INTO thyroid
(patient_id, collection_date, report_date, t4_total, tsh, t3_total, ft4, ft3, source, notes)
VALUES
($PATIENT_ID, '$dor', NULL, $t4_total, $tsh, NULL, $ft4, NULL, 'PDF: $(basename "$PDF")', NULL);
"

if [[ "$MODE" == "--dry-run" ]]; then
  echo "---- DRY RUN ----"
  echo "$SQL"
  exit 0
fi

echo "---- RUN ----"
sqlite3 "$DB" "$SQL"
echo "Inserido com sucesso (patient_id=$PATIENT_ID, collection_date=$dor)."
