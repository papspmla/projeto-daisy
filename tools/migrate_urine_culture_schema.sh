#!/usr/bin/env bash
set -euo pipefail

DB="$HOME/projeto_daisy/database/daisy.db"

echo "Starting urine culture schema migration..."

sqlite3 "$DB" <<'SQL'

PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

DROP INDEX IF EXISTS idx_urine_culture_patient_date;
DROP INDEX IF EXISTS idx_antibiogram_culture;

ALTER TABLE urine_culture RENAME TO urine_culture_old;
ALTER TABLE antibiogram RENAME TO antibiogram_old;

CREATE TABLE urine_culture (
  id INTEGER PRIMARY KEY,
  patient_id INTEGER,
  collection_date TEXT NOT NULL,
  report_date TEXT,
  specimen TEXT,
  source TEXT,
  notes TEXT
);

CREATE UNIQUE INDEX idx_urine_culture_patient_date
ON urine_culture(patient_id, collection_date);

CREATE TABLE culture_isolate (
  id INTEGER PRIMARY KEY,
  culture_id INTEGER NOT NULL,
  organism TEXT,
  growth TEXT,
  FOREIGN KEY(culture_id) REFERENCES urine_culture(id)
);

CREATE INDEX idx_culture_isolate_culture
ON culture_isolate(culture_id);

CREATE TABLE antibiogram (
  id INTEGER PRIMARY KEY,
  isolate_id INTEGER NOT NULL,
  antibiotic TEXT,
  interpretation TEXT,
  mic TEXT,
  FOREIGN KEY(isolate_id) REFERENCES culture_isolate(id)
);

CREATE INDEX idx_antibiogram_isolate
ON antibiogram(isolate_id);

INSERT INTO urine_culture (
  id,
  patient_id,
  collection_date,
  report_date,
  specimen,
  source,
  notes
)
SELECT
  id,
  patient_id,
  collection_date,
  report_date,
  specimen,
  source,
  notes
FROM urine_culture_old;

INSERT INTO culture_isolate (
  id,
  culture_id,
  organism,
  growth
)
SELECT
  id,
  id,
  organism,
  growth_result
FROM urine_culture_old
WHERE COALESCE(TRIM(organism),'') <> ''
   OR COALESCE(TRIM(growth_result),'') <> '';

INSERT INTO antibiogram (
  id,
  isolate_id,
  antibiotic,
  interpretation,
  mic
)
SELECT
  a.id,
  a.culture_id,
  a.antibiotic,
  a.interpretation,
  a.mic
FROM antibiogram_old a
JOIN culture_isolate ci
  ON ci.culture_id = a.culture_id;

DROP TABLE antibiogram_old;
DROP TABLE urine_culture_old;

COMMIT;
PRAGMA foreign_keys=ON;

SQL

echo "Migration completed."
