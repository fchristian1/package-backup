#!/bin/bash
# ~/backup-installed-packages.sh

BACKUP_DIR="$HOME/package-backup"
mkdir -p "$BACKUP_DIR"

echo "[*] Speichere manuell installierte APT-Pakete..."
comm -23 <(apt-mark showmanual | sort) \
    <(gzip -cd /var/log/installer/initial-status.gz | grep ^Package | cut -d ' ' -f 2 | sort) \
    >"$BACKUP_DIR/apt-packages.list"

echo "[*] Speichere installierte Snap-Pakete..."
snap list | awk 'NR>1 {print $1}' >"$BACKUP_DIR/snap-packages.list"

echo "[*] Speichere APT-Repositories..."

# Sichere alle zusätzlichen Repositories
cp -r /etc/apt/sources.list.d "$BACKUP_DIR/sources.list.d"
cp /etc/apt/sources.list "$BACKUP_DIR/sources.list"

echo "[✓] Backup abgeschlossen in: $BACKUP_DIR"
