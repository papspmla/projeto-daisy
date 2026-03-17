#!/bin/bash

LINK="$1"

ID=$(echo "$LINK" | sed -n 's#.*/d/\([^/]*\)/.*#\1#p')

TMP="$HOME/projeto_daisy/data/99_inbox/bp_tmp.txt"
DEST="$HOME/projeto_daisy/data/03_pressao"

wget -q -O "$TMP" "https://drive.google.com/uc?export=download&id=$ID"

dos2unix "$TMP" >/dev/null 2>&1

mv "$TMP" "$DEST/bp_$(date +%Y%m%d_%H%M%S).txt"

echo "BP file imported."
