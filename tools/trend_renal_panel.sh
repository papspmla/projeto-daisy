#!/usr/bin/env bash
set -euo pipefail

TOOLS="$HOME/projeto_daisy/tools"

echo
echo "RENAL PANEL TREND"
echo "================================================"
echo

echo "CREATININE"
echo "-------------------------------------------"
"$TOOLS/trend_chemistry_analyte.sh" creatinine_umol_L
echo

echo "SDMA"
echo "-------------------------------------------"
"$TOOLS/trend_chemistry_analyte.sh" sdma_ug_dL
echo

echo "PHOSPHORUS"
echo "-------------------------------------------"
"$TOOLS/trend_chemistry_analyte.sh" phosphorus_mmol_L
echo

echo "UREA"
echo "-------------------------------------------"
"$TOOLS/trend_chemistry_analyte.sh" urea_mmol_L
echo

echo "POTASSIUM"
echo "-------------------------------------------"
"$TOOLS/trend_chemistry_analyte.sh" potassium_mmol_L
echo
