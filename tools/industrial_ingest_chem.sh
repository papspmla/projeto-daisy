#!/usr/bin/env bash
set -euo pipefail
umask 077

# ------------------------------------------------------------
# industrial_ingest_chem.sh (FINAL)
#
# Pipeline completo para 1 PDF de CHEMISTRY:
#  1) pdftotext -layout -> RAW
#  2) detecta collection_date (SQLite é autoridade se já existir pelo source)
#  3) ingest_chem.sh --dry-run
#     - se já existir: SKIP ingestão (não falha)
#     - se novo: faz --run
#  4) registra documento no Postgres (documents) se faltar
#  5) gera chunks (sempre) no Postgres
#
# SQLite = Source of Truth
# Postgres = documents + chunks
# ------------------------------------------------------------

PROJECT_ROOT="/home/paulo/projeto_daisy"

PDF_DIR="${PROJECT_ROOT}/import/pdfs/chemistry"
RAW_DIR="${PROJECT_ROOT}/import/raw"
TOOLS_DIR="${PROJECT_ROOT}/tools"
LOG_DIR="${PROJECT_ROOT}/logs/industrial_ingest"

SQLITE_DB="${PROJECT_ROOT}/database/daisy.db"

INGEST="${TOOLS_DIR}/ingest_chem.sh"
CHUNKS="${TOOLS_DIR}/generate_chem_chunks.sh"

PG_HOST="127.0.0.1"
PG_USER="daisy"
PG_DB="daisy_pg"
PG_SCHEMA="daisy"

LOCK="/tmp/daisy_industrial_ingest_chem.lock"

die() { echo "ERROR: $*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }

timestamp() { date +"%Y-%m-%d_%H%M%S"; }

ensure_dirs() {
  mkdir -p "$RAW_DIR" "$LOG_DIR"
}

acquire_lock() {
  exec 9>"$LOCK"
  flock -n 9 || die "another ingestion already running"
}

# Heurística conservadora: primeira data dd.mm.yyyy encontrada
extract_date_from_raw() {
  local raw="$1"
  grep -aoE '[0-9]{2}\.[0-9]{2}\.[0-9]{4}' "$raw" \
    | head -n1 \
    | awk -F. '{printf "%04d-%02d-%02d\n",$3,$2,$1}'
}

# SQLite é autoridade quando já existe row com esse source
sqlite_date_by_source() {
  local src="$1"
  sqlite3 -noheader "$SQLITE_DB" \
    "SELECT collection_date FROM chemistry WHERE source='$src' LIMIT 1;" 2>/dev/null || true
}

insert_pg_document_if_missing() {
  local date="$1"
  local src="$2"

  psql -h "$PG_HOST" -U "$PG_USER" -d "$PG_DB" -v ON_ERROR_STOP=1 >/dev/null <<SQL
INSERT INTO ${PG_SCHEMA}.documents (collection_date, source_type, source_path)
SELECT DATE '$date', 'pdf', '$src'
WHERE NOT EXISTS (
  SELECT 1 FROM ${PG_SCHEMA}.documents
  WHERE collection_date = DATE '$date'
    AND source_type = 'pdf'
);
SQL
}

main() {
  [[ $# -eq 1 ]] || die "usage: industrial_ingest_chem.sh <PDF filename or full path>"

  need pdftotext
  need sqlite3
  need psql
  need flock

  [[ -f "$SQLITE_DB" ]] || die "SQLite DB not found: $SQLITE_DB"
  [[ -x "$INGEST" ]] || die "ingest_chem.sh not executable: $INGEST"
  [[ -x "$CHUNKS" ]] || die "generate_chem_chunks.sh not executable: $CHUNKS"

  ensure_dirs
  acquire_lock

  local arg="$1"
  local pdf pdf_name ts log raw raw_date sql_date date

  if [[ "$arg" == /* ]]; then
    pdf="$arg"
  else
    pdf="${PDF_DIR}/$arg"
  fi

  [[ -f "$pdf" ]] || die "pdf not found: $pdf"

  pdf_name="$(basename "$pdf")"
  ts="$(timestamp)"
  log="${LOG_DIR}/ingest_${ts}.log"
  raw="${RAW_DIR}/${ts}__${pdf_name// /_}__raw.txt"

  {
    echo "--------------------------------------------------"
    echo "industrial_ingest_chem.sh"
    echo "timestamp: $ts"
    echo "pdf: $pdf_name"
    echo "--------------------------------------------------"
    echo "[1] pdftotext -layout -> raw"
  } | tee -a "$log"

  pdftotext -layout "$pdf" "$raw"

  echo "[2] detect collection_date" | tee -a "$log"

  raw_date="$(extract_date_from_raw "$raw" || true)"
  sql_date="$(sqlite_date_by_source "$pdf_name" || true)"

  if [[ -n "$sql_date" ]]; then
    date="$sql_date"
    echo "date from SQLite (authoritative): $date" | tee -a "$log"
  else
    [[ -n "$raw_date" ]] || die "could not detect date from raw and not present in SQLite"
    date="$raw_date"
    echo "date from raw (new PDF): $date" | tee -a "$log"
  fi

  echo "[3] ingest_chem.sh --dry-run" | tee -a "$log"

  set +e
  DRY_OUT="$("$INGEST" --date "$date" --raw "$raw" --source "$pdf_name" --dry-run 2>&1)"
  DRY_RC=$?
  set -e

  echo "$DRY_OUT" | tee -a "$log"

  # Regra: "já existe" => SKIP ingestão (não é erro)
  if echo "$DRY_OUT" | grep -qi "já existe em chemistry"; then
    echo "SKIP: chemistry already has collection_date=$date (no --run needed)" | tee -a "$log"
  else
    [[ $DRY_RC -eq 0 ]] || die "dry-run failed (see log: $log)"

    echo "[4] ingest_chem.sh --run" | tee -a "$log"
    "$INGEST" --date "$date" --raw "$raw" --source "$pdf_name" --run | tee -a "$log"
  fi

  echo "[5] Postgres documents (insert if missing)" | tee -a "$log"
  insert_pg_document_if_missing "$date" "$pdf_name"
  echo "documents: OK" | tee -a "$log"

  echo "[6] chunks" | tee -a "$log"
  "$CHUNKS" "$date" | tee -a "$log"

  echo "--------------------------------------------------" | tee -a "$log"
  echo "DONE: $date" | tee -a "$log"
  echo "LOG:  $log" | tee -a "$log"
  echo
  echo "DATABASE STATUS"
      "$TOOLS_DIR/daisy_status.sh"
}

main "$@"
