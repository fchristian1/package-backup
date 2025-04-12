#!/bin/bash
# ~/update-package-backup-scripts.sh

REPO_URL="https://raw.githubusercontent.com/fchristian1/package-backup/main"
TARGET_DIR="./"
FILES=("backup-installed-packages.sh" "restore-installed-packages.sh")

echo "[*] Lade aktuelle Skripte aus dem GitHub-Repo..."

for FILE in "${FILES[@]}"; do
    curl -fsSL "$REPO_URL/$FILE" -o "$TARGET_DIR/$FILE"
    if [[ $? -eq 0 ]]; then
        chmod +x "$TARGET_DIR/$FILE"
        echo "[✓] $FILE aktualisiert."
    else
        echo "[!] Fehler beim Laden von $FILE"
    fi
done

echo "[✓] Update abgeschlossen."
