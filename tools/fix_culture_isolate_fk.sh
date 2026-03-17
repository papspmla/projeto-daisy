#!/usr/bin/env bash
set -euo pipefail

DB="$HOME/projeto_daisy/database/daisy.db"

sqlite3 "$DB" <<'SQL'
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

DROP INDEX IF EXISTS idx_culture_isolate_culture;

ALTER TABLE culture_isolate RENAME TO culture_isolate_bad;

CREATE TABLE culture_isolate (
  id INTEGER PRIMARY KEY,
  culture_id INTEGER NOT NULL,
  organism TEXT,
  growth TEXT,
  FOREIGN KEY(culture_id) REFERENCES urine_culture(id)
);

CREATE INDEX idx_culture_isolate_culture
ON culture_isolate(culture_id);

INSERT INTO culture_isolate (id, culture_id, organism, growth)
SELECT id, culture_id, organism, growth
FROM culture_isolate_bad;

DROP TABLE culture_isolate_bad;

COMMIT;
PRAGMA foreign_keys=ON;
SQL

echo "culture_isolate foreign key fixed."
