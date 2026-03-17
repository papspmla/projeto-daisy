#!/usr/bin/env bash

DB="$HOME/projeto_daisy/database/daisy.db"

echo
echo "--------------------------------"
echo "DAISY DATABASE STATUS"
echo "--------------------------------"

sqlite3 "$DB" "
SELECT
'chemistry rows', COUNT(*)
FROM chemistry;

SELECT
'first exam', MIN(collection_date),
'last exam', MAX(collection_date)
FROM chemistry;
"

echo "--------------------------------"
echo
