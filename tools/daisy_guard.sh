#!/usr/bin/env bash

DB="$HOME/projeto_daisy/database/daisy.db"
BACKUP_DIR="$HOME/projeto_daisy/backups"

current=$(sqlite3 "$DB" "SELECT COUNT(*) FROM chemistry;")

max_backup=0

for f in "$BACKUP_DIR"/daisy_sqlite_*.db
do
    count=$(sqlite3 "$f" "SELECT COUNT(*) FROM chemistry;" 2>/dev/null)

    if [ "$count" -gt "$max_backup" ]; then
        max_backup="$count"
    fi
done

echo
echo "DAISY GUARD"
echo "Active DB rows : $current"
echo "Max backup rows: $max_backup"

if [ "$current" -lt "$max_backup" ]; then
    echo
    echo "WARNING: active database older than backup!"
    echo
fi
