#!/usr/bin/env bash
set -euo pipefail

DB="$HOME/projeto_daisy/database/daisy.db"
PATIENT_ID=1

PDF="$1"

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

pdftotext -layout "$PDF" "$TMP"

dor_line="$(grep -m1 'Date of receipt:' "$TMP" || true)"
dor="$(echo "$dor_line" | sed -nE 's/.*Date of receipt:[[:space:]]*([0-9]{2})\.([0-9]{2})\.([0-9]{4}).*/\3-\2-\1/p')"

if [[ -z "$dor" ]]; then
  echo "Date not found in $PDF"
  exit 1
fi

exists="$(sqlite3 "$DB" "SELECT 1 FROM urine_culture WHERE patient_id=$PATIENT_ID AND collection_date='$dor' LIMIT 1;")"

if [[ -n "$exists" ]]; then
  echo "Already exists: $dor"
  exit 0
fi

sqlite3 "$DB" "
INSERT INTO urine_culture
(patient_id,collection_date,source,notes)
VALUES
($PATIENT_ID,'$dor','PDF: $(basename "$PDF")','Urine culture');
"

echo "Inserted culture $dor"
