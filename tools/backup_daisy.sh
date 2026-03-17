#!/usr/bin/env bash
set -euo pipefail
umask 077

PROJECT_DIR="$HOME/projeto_daisy"
BACKUP_DIR="$PROJECT_DIR/backups"
LOG_DIR="$PROJECT_DIR/logs/backup"
SQLITE_DB="$PROJECT_DIR/database/daisy.db"

DATE="$(date +%Y-%m-%d)"
DOW="$(date +%u)"  # 1=Mon ... 7=Sun
HOSTNAME="$(hostname -s)"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

LOG_FILE="$LOG_DIR/backup_${DATE}_${HOSTNAME}.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "== Daisy Backup 시작 =="
echo "Date: $DATE  Host: $HOSTNAME  DOW: $DOW"
echo "Backup dir: $BACKUP_DIR"
echo

# Simple lock to avoid overlapping runs
LOCKDIR="/tmp/daisy_backup.lock"
if ! mkdir "$LOCKDIR" 2>/dev/null; then
  echo "ERROR: Backup already running (lock exists: $LOCKDIR). Exiting."
  exit 1
fi
trap 'rmdir "$LOCKDIR" >/dev/null 2>&1 || true' EXIT

echo "[1/5] SQLite backup (daily) ..."
SQLITE_OUT="$BACKUP_DIR/daisy_sqlite_${DATE}.db"
cp -f "$SQLITE_DB" "$SQLITE_OUT"

# Basic integrity check (non-destructive)
if command -v sqlite3 >/dev/null 2>&1; then
  echo "SQLite integrity_check ..."
  sqlite3 "$SQLITE_OUT" "PRAGMA integrity_check;" | head -n 5
fi

sha256sum "$SQLITE_OUT" > "${SQLITE_OUT}.sha256"
ls -lh "$SQLITE_OUT"

echo
echo "[2/5] Weekly items (Postgres + filesystem) ..."
if [[ "$DOW" == "7" ]]; then
  echo "Today is Sunday -> running weekly backups."

  echo "Postgres dump ..."
  PG_OUT="$BACKUP_DIR/daisy_postgres_${DATE}.sql"
  # Force TCP to avoid peer auth; relies on ~/.pgpass (or will prompt in interactive runs)
  pg_dump -h 127.0.0.1 -U daisy -d daisy_pg > "$PG_OUT"
  sha256sum "$PG_OUT" > "${PG_OUT}.sha256"
  ls -lh "$PG_OUT"

  echo "Filesystem tar.gz ..."
  FS_OUT="$BACKUP_DIR/daisy_filesystem_${DATE}.tar.gz"
  tar -czf "$FS_OUT" --exclude='projeto_daisy/backups' -C "$HOME" projeto_daisy
  sha256sum "$FS_OUT" > "${FS_OUT}.sha256"
  ls -lh "$FS_OUT"
else
  echo "Not Sunday -> skipping weekly backups."
fi

echo
echo "[3/5] Retention policy ..."
echo "SQLite: delete > 30 days"
find "$BACKUP_DIR" -maxdepth 1 -type f -name 'daisy_sqlite_*.db' -mtime +30 -print -delete || true
find "$BACKUP_DIR" -maxdepth 1 -type f -name 'daisy_sqlite_*.db.sha256' -mtime +30 -print -delete || true

echo "Postgres/filesystem: delete > 84 days (12 weeks)"
find "$BACKUP_DIR" -maxdepth 1 -type f -name 'daisy_postgres_*.sql' -mtime +84 -print -delete || true
find "$BACKUP_DIR" -maxdepth 1 -type f -name 'daisy_postgres_*.sql.sha256' -mtime +84 -print -delete || true
find "$BACKUP_DIR" -maxdepth 1 -type f -name 'daisy_filesystem_*.tar.gz' -mtime +84 -print -delete || true
find "$BACKUP_DIR" -maxdepth 1 -type f -name 'daisy_filesystem_*.tar.gz.sha256' -mtime +84 -print -delete || true

echo
echo "[4/5] Recent backups summary:"
ls -lh "$BACKUP_DIR" | tail -n 25

echo
echo "[5/5] Done."
echo "Log: $LOG_FILE"
