#!/usr/bin/env python3
import re
import csv
from pathlib import Path
from pypdf import PdfReader

FIELDS = [
    "collection_date","report_date",
    "glucose_mmol_L","sdma_ug_dL","creatinine_umol_L","urea_mmol_L",
    "phosphorus_mmol_L","calcium_mmol_L","magnesium_mmol_L",
    "sodium_mmol_L","potassium_mmol_L","chloride_mmol_L",
    "total_protein_g_L","albumin_g_L","globulin_g_L",
    "alt_U_L","ast_U_L","alp_U_L","ggt_U_L","gldh_U_L",
    "bilirubin_total_umol_L",
    "cholesterol_mmol_L","triglycerides_mmol_L",
    "amylase_U_L","lipase_U_L","ck_U_L",
    "fructosamine_umol_L","crp_mg_L",
    "source","notes"
]

ANALYTES = {
    "glucose_mmol_L": ["GLUCOSE","GLU"],
    "sdma_ug_dL": ["SDMA"],
    "creatinine_umol_L": ["CREATININE","CREA"],
    "urea_mmol_L": ["UREA","BUN"],
    "phosphorus_mmol_L": ["PHOSPHORUS","PHOS"],
    "calcium_mmol_L": ["CALCIUM","CA"],
    "magnesium_mmol_L": ["MAGNESIUM","MG"],
    "sodium_mmol_L": ["SODIUM","NA"],
    "potassium_mmol_L": ["POTASSIUM","K"],
    "chloride_mmol_L": ["CHLORIDE","CL"],
    "total_protein_g_L": ["TOTAL PROTEIN","TP"],
    "albumin_g_L": ["ALBUMIN","ALB"],
    "globulin_g_L": ["GLOBULIN","GLOB"],
    "alt_U_L": ["ALT"],
    "ast_U_L": ["AST"],
    "alp_U_L": ["ALKALINE PHOSPHATASE","ALP"],
    "ggt_U_L": ["GGT"],
    "gldh_U_L": ["GLDH"],
    "bilirubin_total_umol_L": ["BILIRUBIN"],
    "cholesterol_mmol_L": ["CHOLESTEROL","CHOL"],
    "triglycerides_mmol_L": ["TRIGLYCERIDES","TRIG"],
    "amylase_U_L": ["AMYLASE","AMYL"],
    "lipase_U_L": ["LIPASE"],
    "ck_U_L": ["CK"],
    "fructosamine_umol_L": ["FRUCTOSAMINE"],
    "crp_mg_L": ["CRP"]
}

NUM_RE = re.compile(r"(-?\d+(?:[.,]\d+)?)")
DATE_RE = re.compile(r"(\d{4}-\d{2}-\d{2})")

def extract_text(pdf_path):
    reader = PdfReader(str(pdf_path))
    text = ""
    for page in reader.pages:
        t = page.extract_text()
        if t:
            text += t + "\n"
    return text

def extract_value(text, aliases):
    for line in text.splitlines():
        upper = line.upper()
        if any(alias in upper for alias in aliases):
            m = NUM_RE.search(line)
            if m:
                return m.group(1).replace(",", ".")
    return ""

def main():
    pdf_dir = Path.home() / "projeto_daisy/import/pdfs/chemistry"
    out_csv = Path.home() / "projeto_daisy/import/chemistry_backfill_auto.csv"

    rows = []

    for pdf in sorted(pdf_dir.glob("*.pdf")):
        text = extract_text(pdf)
        if not text:
            continue

        row = {k: "" for k in FIELDS}
        row["source"] = "IDEXX"
        row["notes"] = pdf.name

        date_match = DATE_RE.search(text)
        if date_match:
            row["collection_date"] = date_match.group(1)

        for field, aliases in ANALYTES.items():
            row[field] = extract_value(text, aliases)

        rows.append(row)

    with open(out_csv, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(rows)

if __name__ == "__main__":
    main()
