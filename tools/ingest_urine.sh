#!/usr/bin/env bash
set -euo pipefail

DB="$HOME/projeto_daisy/database/daisy.db"
PATIENT_ID=1

usage() {
  echo "Uso:"
  echo "  ingest_urine.sh <PDF> --dry-run"
  echo "  ingest_urine.sh <PDF> --run"
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
trap 'rm -f "$TMP"' EXIT

pdftotext -layout "$PDF" "$TMP"

line_for() {
  grep -F "$1" "$TMP" | head -n1 || true
}

extract_first_number() {
  sed -nE 's/.*[[:space:]]([0-9]+([.][0-9]+)?).*/\1/p' <<< "$1"
}

extract_usg() {
  local n
  n="$(sed -nE 's/.*Spec\. gravity Refractometry[[:space:]]*([0-9]{4}).*/\1/p' <<< "$1")"
  if [[ -n "$n" ]]; then
    echo "scale=3; $n/1000" | bc
  fi
}

extract_token() {
  sed -nE 's/.*[[:space:]](None Seen|Positive|Negative|Marked|Moderate|Mild|Clear|Turbid|Amber|Light Yellow|Yellow|~|>50|[0-9]+[[:space:]]*-[[:space:]]*[0-9]+|[0-9]+-[0-9]+|[0-9]+(\.[0-9]+)?|[0-9]+\+).*/\1/p' <<< "$1"
}

dor_line="$(line_for 'Date of receipt:')"
dor="$(sed -nE 's/.*Date of receipt:[[:space:]]*([0-9]{2})\.([0-9]{2})\.([0-9]{4}).*/\3-\2-\1/p' <<< "$dor_line")"

report_line="$(line_for 'Report created on')"
report_date="$(sed -nE 's/.*Report created on[[:space:]]*([0-9]{2})\.([0-9]{2})\.([0-9]{4}).*/\3-\2-\1/p' <<< "$report_line")"

usg="$(extract_usg "$(line_for 'Spec. gravity Refractometry')")"
ph="$(extract_first_number "$(line_for 'Reaction: pH Urine Test Strip')")"
protein_strip="$(extract_token "$(line_for 'Protein Urine Test Strip')")"
blood_strip="$(extract_token "$(line_for 'Blood Urine Test Strip')")"
glucose_strip="$(extract_token "$(line_for 'Glucose Urine Test Strip')")"
ketones_strip="$(extract_token "$(line_for 'Ketone bodies Urine Test Strip')")"
nitrite_strip="$(extract_token "$(line_for 'Nitrite Urine Test Strip')")"

leukocytes_sediment_hpf="$(extract_token "$(line_for 'Leucocytes Microscopy')")"
erythrocytes_sediment_hpf="$(extract_token "$(line_for 'Erythrocytes Microscopy')")"
bacteria_present="$(extract_token "$(line_for 'Bacteria Microscopy')")"
epithelial_cells="$(extract_token "$(line_for 'Epithelial cells Microscopy')")"
casts_present="$(extract_token "$(line_for 'Casts Microscopy')")"
crystals_present="$(extract_token "$(line_for 'Crystals Microscopy')")"

cystatin_b_ng_mL="$(extract_first_number "$(line_for 'IDEXX Cystatin B (Urine) Immunoturbidimetry')")"
urine_creatinine_umol_L="$(extract_first_number "$(line_for 'Creatinine in urine')")"
urine_protein_mg_L="$(extract_first_number "$(line_for 'Total protein in urine')")"
upc_ratio="$(extract_first_number "$(line_for 'Protein/creatinine ratio')")"

echo "collection_date = $dor"
echo "report_date = $report_date"
echo "usg = $usg"
echo "ph = $ph"
echo "protein_strip = $protein_strip"
echo "blood_strip = $blood_strip"
echo "glucose_strip = $glucose_strip"
echo "ketones_strip = $ketones_strip"
echo "nitrite_strip = $nitrite_strip"
echo "leukocytes_sediment_hpf = $leukocytes_sediment_hpf"
echo "erythrocytes_sediment_hpf = $erythrocytes_sediment_hpf"
echo "bacteria_present = $bacteria_present"
echo "epithelial_cells = $epithelial_cells"
echo "casts_present = $casts_present"
echo "crystals_present = $crystals_present"
echo "cystatin_b_ng_mL = ${cystatin_b_ng_mL:-NULL}"
echo "urine_creatinine_umol_L = ${urine_creatinine_umol_L:-NULL}"
echo "urine_protein_mg_L = ${urine_protein_mg_L:-NULL}"
echo "upc_ratio = ${upc_ratio:-NULL}"

SQL="
INSERT INTO urine (
  patient_id,
  collection_date,
  report_date,
  usg,
  ph,
  protein_strip,
  blood_strip,
  glucose_strip,
  ketones_strip,
  nitrite_strip,
  leukocytes_sediment_hpf,
  erythrocytes_sediment_hpf,
  bacteria_present,
  epithelial_cells,
  casts_present,
  crystals_present,
  cystatin_b_ng_mL,
  urine_creatinine_umol_L,
  urine_protein_mg_L,
  upc_ratio,
  source
) VALUES (
  $PATIENT_ID,
  '$dor',
  '$report_date',
  ${usg:-NULL},
  ${ph:-NULL},
  '$protein_strip',
  '$blood_strip',
  '$glucose_strip',
  '$ketones_strip',
  '$nitrite_strip',
  '$leukocytes_sediment_hpf',
  '$erythrocytes_sediment_hpf',
  '$bacteria_present',
  '$epithelial_cells',
  '$casts_present',
  '$crystals_present',
  ${cystatin_b_ng_mL:-NULL},
  ${urine_creatinine_umol_L:-NULL},
  ${urine_protein_mg_L:-NULL},
  ${upc_ratio:-NULL},
  'IDEXX'
)
ON CONFLICT(patient_id, collection_date)
DO UPDATE SET
  report_date = excluded.report_date,
  usg = COALESCE(excluded.usg, urine.usg),
  ph = COALESCE(excluded.ph, urine.ph),
  protein_strip = COALESCE(excluded.protein_strip, urine.protein_strip),
  blood_strip = COALESCE(excluded.blood_strip, urine.blood_strip),
  glucose_strip = COALESCE(excluded.glucose_strip, urine.glucose_strip),
  ketones_strip = COALESCE(excluded.ketones_strip, urine.ketones_strip),
  nitrite_strip = COALESCE(excluded.nitrite_strip, urine.nitrite_strip),
  leukocytes_sediment_hpf = COALESCE(excluded.leukocytes_sediment_hpf, urine.leukocytes_sediment_hpf),
  erythrocytes_sediment_hpf = COALESCE(excluded.erythrocytes_sediment_hpf, urine.erythrocytes_sediment_hpf),
  bacteria_present = COALESCE(excluded.bacteria_present, urine.bacteria_present),
  epithelial_cells = COALESCE(excluded.epithelial_cells, urine.epithelial_cells),
  casts_present = COALESCE(excluded.casts_present, urine.casts_present),
  crystals_present = COALESCE(excluded.crystals_present, urine.crystals_present),
  cystatin_b_ng_mL = COALESCE(excluded.cystatin_b_ng_mL, urine.cystatin_b_ng_mL),
  urine_creatinine_umol_L = COALESCE(excluded.urine_creatinine_umol_L, urine.urine_creatinine_umol_L),
  urine_protein_mg_L = COALESCE(excluded.urine_protein_mg_L, urine.urine_protein_mg_L),
  upc_ratio = COALESCE(excluded.upc_ratio, urine.upc_ratio),
  source = excluded.source;
"

if [[ "$MODE" == "--dry-run" ]]; then
  echo "---- DRY RUN ----"
  echo "$SQL"
  exit 0
fi

echo "---- RUN ----"
sqlite3 "$DB" "$SQL"
echo "Upsert concluído (patient_id=$PATIENT_ID, collection_date=$dor)"
