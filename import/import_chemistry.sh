#!/usr/bin/env bash
set -euo pipefail

DB="$HOME/projeto_daisy/database/daisy.db"
CSV="${1:-$HOME/projeto_daisy/import/chemistry.csv}"

if [[ ! -f "$CSV" ]]; then
  echo "CSV not found: $CSV" >&2
  exit 1
fi

sqlite3 "$DB" <<SQL
-- 1) staging sempre existe
CREATE TABLE IF NOT EXISTS chemistry_staging (
  collection_date          TEXT NOT NULL,
  report_date              TEXT,
  glucose_mmol_L           REAL,
  sdma_ug_dL               REAL,
  creatinine_umol_L        REAL,
  urea_mmol_L              REAL,
  phosphorus_mmol_L        REAL,
  calcium_mmol_L           REAL,
  magnesium_mmol_L         REAL,
  sodium_mmol_L            REAL,
  potassium_mmol_L         REAL,
  chloride_mmol_L          REAL,
  total_protein_g_L        REAL,
  albumin_g_L              REAL,
  globulin_g_L             REAL,
  alt_U_L                  REAL,
  ast_U_L                  REAL,
  alp_U_L                  REAL,
  ggt_U_L                  REAL,
  gldh_U_L                 REAL,
  bilirubin_total_umol_L   REAL,
  cholesterol_mmol_L       REAL,
  triglycerides_mmol_L     REAL,
  amylase_U_L              REAL,
  lipase_U_L               REAL,
  ck_U_L                   REAL,
  fructosamine_umol_L      REAL,
  crp_mg_L                 REAL,
  source                   TEXT,
  notes                    TEXT
);

-- 2) staging limpa
DELETE FROM chemistry_staging;
SQL

# 3) importa CSV para staging (fora do heredoc para expandir caminho)
sqlite3 "$DB" <<SQL
.mode csv
.headers off
.import $CSV chemistry_staging
SQL

# 4) remove header se vier junto + merge idempotente
sqlite3 "$DB" <<'SQL'
DELETE FROM chemistry_staging WHERE collection_date='collection_date';

INSERT OR REPLACE INTO chemistry (
  collection_date, report_date,
  glucose_mmol_L, sdma_ug_dL, creatinine_umol_L, urea_mmol_L,
  phosphorus_mmol_L, calcium_mmol_L, magnesium_mmol_L,
  sodium_mmol_L, potassium_mmol_L, chloride_mmol_L,
  total_protein_g_L, albumin_g_L, globulin_g_L,
  alt_U_L, ast_U_L, alp_U_L, ggt_U_L, gldh_U_L,
  bilirubin_total_umol_L,
  cholesterol_mmol_L, triglycerides_mmol_L,
  amylase_U_L, lipase_U_L, ck_U_L,
  fructosamine_umol_L, crp_mg_L,
  source, notes
)
SELECT
  collection_date, report_date,
  glucose_mmol_L, sdma_ug_dL, creatinine_umol_L, urea_mmol_L,
  phosphorus_mmol_L, calcium_mmol_L, magnesium_mmol_L,
  sodium_mmol_L, potassium_mmol_L, chloride_mmol_L,
  total_protein_g_L, albumin_g_L, globulin_g_L,
  alt_U_L, ast_U_L, alp_U_L, ggt_U_L, gldh_U_L,
  bilirubin_total_umol_L,
  cholesterol_mmol_L, triglycerides_mmol_L,
  amylase_U_L, lipase_U_L, ck_U_L,
  fructosamine_umol_L, crp_mg_L,
  source, notes
FROM chemistry_staging;

-- resultado rápido
SELECT COUNT(*) AS chemistry_rows FROM chemistry;
SQL
