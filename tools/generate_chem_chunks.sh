#!/usr/bin/env bash
set -euo pipefail

# generate_chem_chunks.sh
# Gera 8 chunks fixos (v1.0) para um exame de chemistry no Postgres,
# lendo valores do SQLite (source of truth).
#
# Pré-requisito: documents já tem uma linha com collection_date = DATA.
# Autenticação Postgres recomendada via ~/.pgpass (chmod 600).
#
# Uso:
#   ~/projeto_daisy/tools/generate_chem_chunks.sh YYYY-MM-DD

DATE="${1:-}"
[[ -z "$DATE" ]] && { echo "Uso: $0 YYYY-MM-DD" >&2; exit 1; }

SQLITE_DB="${SQLITE_DB:-$HOME/projeto_daisy/database/daisy.db}"
PG_DB="${PG_DB:-daisy_pg}"
PG_USER="${PG_USER:-daisy}"
PG_HOST="${PG_HOST:-localhost}"

[[ -f "$SQLITE_DB" ]] || { echo "SQLite DB não encontrado: $SQLITE_DB" >&2; exit 1; }

nz(){ [[ -z "${1:-}" ]] && echo "(NULL)" || echo "$1"; }

sep='|'
q(){ sqlite3 -noheader -separator "$sep" "$SQLITE_DB" "$1"; }

# ---------- Lê do SQLite (source of truth) ----------
renal="$(q "SELECT creatinine_umol_L, sdma_ug_dL, urea_mmol_L, phosphorus_mmol_L FROM chemistry WHERE collection_date='$DATE';")"
[[ -n "$renal" ]] || { echo "SQLite: chemistry.collection_date='$DATE' não encontrado." >&2; exit 1; }
IFS='|' read -r creat sdma urea phos <<<"$renal"

met="$(q "SELECT glucose_mmol_L, total_protein_g_L, albumin_g_L, globulin_g_L FROM chemistry WHERE collection_date='$DATE';")"
IFS='|' read -r glucose tprot alb glob <<<"${met:-|||}"

elec="$(q "SELECT sodium_mmol_L, potassium_mmol_L, chloride_mmol_L, magnesium_mmol_L, calcium_mmol_L FROM chemistry WHERE collection_date='$DATE';")"
IFS='|' read -r na k cl mg ca <<<"${elec:-||||}"

liv="$(q "SELECT alt_U_L, ast_U_L, alp_U_L, ggt_U_L, gldh_U_L, bilirubin_total_umol_L FROM chemistry WHERE collection_date='$DATE';")"
IFS='|' read -r alt ast alp ggt gldh bili <<<"${liv:-|||||}"

lip="$(q "SELECT cholesterol_mmol_L, triglycerides_mmol_L FROM chemistry WHERE collection_date='$DATE';")"
IFS='|' read -r chol trig <<<"${lip:-|}"

pan="$(q "SELECT amylase_U_L, lipase_U_L FROM chemistry WHERE collection_date='$DATE';")"
IFS='|' read -r amyl lipa <<<"${pan:-|}"

ck="$(q "SELECT ck_U_L FROM chemistry WHERE collection_date='$DATE';")"
crp="$(q "SELECT crp_mg_L FROM chemistry WHERE collection_date='$DATE';")"

# ---------- Monta os 8 chunks fixos v1.0 ----------
c0="Creatinine: $(nz "$creat") µmol/L; SDMA: $(nz "$sdma") µg/dL; Urea: $(nz "$urea") mmol/L; Phosphorus: $(nz "$phos") mmol/L."
c1="Glucose: $(nz "$glucose") mmol/L; Total Protein: $(nz "$tprot") g/L; Albumin: $(nz "$alb") g/L; Globulin: $(nz "$glob") g/L."
c2="Sodium: $(nz "$na") mmol/L; Potassium: $(nz "$k") mmol/L; Chloride: $(nz "$cl") mmol/L; Magnesium: $(nz "$mg") mmol/L; Calcium: $(nz "$ca") mmol/L."
c3="ALT: $(nz "$alt") U/L; AST: $(nz "$ast") U/L; ALP: $(nz "$alp") U/L; GGT: $(nz "$ggt") U/L; GLDH: $(nz "$gldh") U/L; Total Bilirubin: $(nz "$bili") µmol/L."
c4="Cholesterol: $(nz "$chol") mmol/L; Triglycerides: $(nz "$trig") mmol/L."
c5="Amylase: $(nz "$amyl"); Lipase: $(nz "$lipa") U/L."
c6="CK: $(nz "$ck") U/L."
c7="CRP: $(nz "$crp") mg/L."

# ---------- Resolve document_id no Postgres (determinístico) ----------
DID="$(psql -t -A "postgresql://${PG_USER}@${PG_HOST}/${PG_DB}" -v ON_ERROR_STOP=1 \
  -c "SELECT id FROM documents WHERE collection_date = DATE '$DATE' ORDER BY id ASC LIMIT 1;")"

[[ -n "$DID" ]] || { echo "Postgres: nenhum documents para collection_date=$DATE (insira primeiro em documents)" >&2; exit 1; }

# ---------- Escreve chunks (idempotente) ----------
psql "postgresql://${PG_USER}@${PG_HOST}/${PG_DB}" -v ON_ERROR_STOP=1 \
  -v did="$DID" -v d="$DATE" \
  -v c0="$c0" -v c1="$c1" -v c2="$c2" -v c3="$c3" -v c4="$c4" -v c5="$c5" -v c6="$c6" -v c7="$c7" <<'SQL'
BEGIN;

DELETE FROM chunks WHERE document_id = :did;

INSERT INTO chunks (document_id, chunk_index, collection_date, chunk_type, content) VALUES
  (:did, 0, DATE :'d', 'chemistry_renal',        :'c0'),
  (:did, 1, DATE :'d', 'chemistry_metabolic',    :'c1'),
  (:did, 2, DATE :'d', 'chemistry_electrolytes', :'c2'),
  (:did, 3, DATE :'d', 'chemistry_liver',        :'c3'),
  (:did, 4, DATE :'d', 'chemistry_lipids',       :'c4'),
  (:did, 5, DATE :'d', 'chemistry_pancreas',     :'c5'),
  (:did, 6, DATE :'d', 'chemistry_muscle',       :'c6'),
  (:did, 7, DATE :'d', 'chemistry_inflammation', :'c7');

COMMIT;
SQL

echo "OK: chunks chemistry v1.0 gerados para $DATE (document_id=$DID)"
