#!/usr/bin/env python3

import csv
import sqlite3
from datetime import datetime
from pathlib import Path

DB_PATH = "/home/paulo/projeto_daisy/database/daisy.db"
CSV_PATH = "/home/paulo/projeto_daisy/media/stool/2026/stool_images_decimal.csv"
MEDIA_BASE = "/home/paulo/projeto_daisy/media/stool/2026"
PATIENT_ID = 1
MAX_GAP_SECONDS = 600  # 10 minutos


def parse_dt(v):
    return datetime.strptime(v.strip(), "%Y:%m:%d %H:%M:%S")


rows = []

with open(CSV_PATH) as f:
    reader = csv.DictReader(f)
    for r in reader:
        rows.append({
            "filename": r["FileName"].strip(),
            "dt": parse_dt(r["DateTimeOriginal"])
        })

rows.sort(key=lambda x: x["dt"])

groups = []
current = [rows[0]]

for r in rows[1:]:
    gap = (r["dt"] - current[-1]["dt"]).total_seconds()
    if gap <= MAX_GAP_SECONDS:
        current.append(r)
    else:
        groups.append(current)
        current = [r]

groups.append(current)

conn = sqlite3.connect(DB_PATH)
conn.execute("PRAGMA foreign_keys = ON")
cur = conn.cursor()

stool_insert = """
INSERT INTO stool (
    patient_id,
    collection_date,
    collection_time,
    source,
    notes
) VALUES (?, ?, ?, ?, ?)
"""

image_insert = """
INSERT INTO stool_images (
    stool_id,
    patient_id,
    file_path,
    captured_at,
    original_filename,
    source
) VALUES (?, ?, ?, ?, ?, ?)
"""

for group in groups:

    first = group[0]["dt"]

    collection_date = first.strftime("%Y-%m-%d")
    collection_time = first.strftime("%H:%M:%S")

    cur.execute(
        stool_insert,
        (
            PATIENT_ID,
            collection_date,
            collection_time,
            "stool_image_import",
            "created from grouped image metadata (10min rule)"
        )
    )

    stool_id = cur.lastrowid

    for img in group:

        file_path = str(Path(MEDIA_BASE) / img["filename"])

        captured_at = img["dt"].strftime("%Y-%m-%d %H:%M:%S")

        cur.execute(
            image_insert,
            (
                stool_id,
                PATIENT_ID,
                file_path,
                captured_at,
                img["filename"],
                "stool_image_import"
            )
        )

conn.commit()
conn.close()

print("Ingestão concluída.")
print(f"Eventos stool criados: {len(groups)}")
print(f"Imagens inseridas: {len(rows)}")
