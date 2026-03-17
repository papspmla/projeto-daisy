#!/usr/bin/env bash
set -euo pipefail

DB="$HOME/projeto_daisy/database/daisy.db"

usage() {
  echo "Usage:"
  echo "ingest_antibiogram.sh <PDF> <isolate_id> --dry-run"
  echo "ingest_antibiogram.sh <PDF> <isolate_id> --run"
}

if [[ $# -ne 3 ]]; then
  usage
  exit 1
fi

PDF="$1"
ISOLATE_ID="$2"
MODE="$3"

if [[ "$MODE" != "--dry-run" && "$MODE" != "--run" ]]; then
  usage
  exit 1
fi

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

pdftotext -layout "$PDF" - \
| sed -n '/^Antibiogram$/,/^   Report created on/p' \
| sed '1,/Interp\.\s\+MIC μg\/mL/d' \
| sed '/^   Report created on/,$d' \
| sed '/^[[:space:]]*$/d' \
| perl -ne '
if (/^(.+?)\s{2,}(S|I|R)\s{2,}((?:<=|>=|>|<)?\d+(?:\.\d+)?)\b(?:\s+.*)?$/) {
  print "$1|$2|$3\n"
}
elsif (/^(.+?)\s{2,}(S|I|R)\s{2,}\S.*$/) {
  print "$1|$2|NULL\n"
}
elsif (/^(.+?)\s{2,}(S|I|R)\s*$/) {
  print "$1|$2|NULL\n"
}
' > "$TMP"

echo "---- PARSED ----"
cat "$TMP"

SQL_TMP=$(mktemp)

if [[ "$MODE" == "--run" ]]; then
  echo "DELETE FROM antibiogram WHERE isolate_id = $ISOLATE_ID;" >> "$SQL_TMP"
fi

while IFS="|" read -r antibiotic interp mic; do

  if [[ "$mic" == "NULL" ]]; then
    mic_sql="NULL"
  else
    mic_sql="'$mic'"
  fi

  cat >> "$SQL_TMP" <<EOF
INSERT INTO antibiogram (
  isolate_id,
  antibiotic,
  interpretation,
  mic
) VALUES (
  $ISOLATE_ID,
  '$antibiotic',
  '$interp',
  $mic_sql
);
EOF

done < "$TMP"

echo "---- SQL ----"
cat "$SQL_TMP"

if [[ "$MODE" == "--run" ]]; then
  sqlite3 "$DB" < "$SQL_TMP"
  echo "Antibiogram loaded for isolate_id=$ISOLATE_ID"
fi
