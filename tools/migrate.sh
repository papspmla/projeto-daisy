#!/usr/bin/env bash
set -euo pipefail

DB="$HOME/projeto_daisy/database/daisy.db"
MIGRATIONS="$HOME/projeto_daisy/migrations"

sqlite3 "$DB" "
CREATE TABLE IF NOT EXISTS schema_migrations (
  version TEXT PRIMARY KEY,
  applied_at TEXT NOT NULL
);
"

for file in "$MIGRATIONS"/V*.sql; do
  [ -e "$file" ] || continue

  version=$(basename "$file" | cut -d'_' -f1)

  applied=$(sqlite3 "$DB" "SELECT COUNT(*) FROM schema_migrations WHERE version='$version';")

  if [ "$applied" = "0" ]; then
    echo "Applying $file"
    sqlite3 "$DB" < "$file"

    sqlite3 "$DB" "
    INSERT INTO schema_migrations (version, applied_at)
    VALUES ('$version', datetime('now'));
    "
  else
    echo "Skipping $file (already applied)"
  fi
done
