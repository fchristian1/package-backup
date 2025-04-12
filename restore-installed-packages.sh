#!/bin/bash
# ~/restore-installed-packages.sh

BACKUP_DIR="$HOME/package-backup"

APT_LIST="$BACKUP_DIR/apt-packages.list"
SNAP_LIST="$BACKUP_DIR/snap-packages.list"

if [[ ! -f "$APT_LIST" ]] || [[ ! -f "$SNAP_LIST" ]]; then
    echo "[x] Fehler: Backup-Dateien fehlen im Verzeichnis $BACKUP_DIR"
    exit 1
fi

echo "[*] Update der APT-Paketlisten..."
sudo apt update

echo "[*] Installiere APT-Pakete..."
xargs -a "$APT_LIST" sudo apt install -y

echo "[*] Installiere Snap-Pakete..."
xargs -a "$SNAP_LIST" sudo snap install

echo "[✓] Wiederherstellung abgeschlossen!"
