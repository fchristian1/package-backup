#!/bin/bash
# ~/restore-installed-packages.sh

BACKUP_DIR="$HOME/package-backup"
APT_LIST="$BACKUP_DIR/apt-packages.list"
SNAP_LIST="$BACKUP_DIR/snap-packages.list"
SOURCES_LIST="$BACKUP_DIR/sources.list"
SOURCES_DIR="$BACKUP_DIR/sources.list.d"

CURRENT_CODENAME=$(lsb_release -cs)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

check_repo_url() {
    local url="$1"
    if curl -fsI --max-time 5 "$url" | grep -q "200 OK"; then
        return 0
    else
        return 1
    fi
}

echo "[*] System-Codename erkannt: $CURRENT_CODENAME"

# Sicherstellen, dass die notwendigen Dateien vorhanden sind
if [[ ! -f "$APT_LIST" ]] || [[ ! -f "$SNAP_LIST" ]]; then
    echo "❌ Fehler: Paketlisten fehlen im Verzeichnis $BACKUP_DIR"
    exit 1
fi

echo "[*] Wiederherstellung der APT-Repositories..."

# sources.list behandeln
if [[ -f "$SOURCES_LIST" ]]; then
    echo "    - Sicherung von /etc/apt/sources.list nach /etc/apt/sources.list.bak.$TIMESTAMP"
    sudo cp /etc/apt/sources.list "/etc/apt/sources.list.bak.$TIMESTAMP"

    echo "    - Prüfe URLs in sources.list..."
    TMP_FILE=$(mktemp)
    while read -r line; do
        if [[ "$line" =~ ^deb ]]; then
            MODIFIED_LINE=$(echo "$line" | sed "s/\b[a-z]\+\b/$CURRENT_CODENAME/g")
            URL=$(echo "$MODIFIED_LINE" | awk '{print $2}')
            if check_repo_url "$URL"; then
                echo "$MODIFIED_LINE" >>"$TMP_FILE"
            else
                echo "      ⚠️  Repo übersprungen (nicht erreichbar): $URL"
            fi
        else
            echo "$line" >>"$TMP_FILE"
        fi
    done <"$SOURCES_LIST"
    sudo cp "$TMP_FILE" /etc/apt/sources.list
    rm "$TMP_FILE"
fi

# sources.list.d behandeln
if [[ -d "$SOURCES_DIR" ]]; then
    echo "    - Sicherung von /etc/apt/sources.list.d nach /etc/apt/sources.list.d.bak.$TIMESTAMP"
    sudo cp -r /etc/apt/sources.list.d "/etc/apt/sources.list.d.bak.$TIMESTAMP"
    sudo mkdir -p /etc/apt/sources.list.d

    for file in "$SOURCES_DIR"/*.list; do
        echo "    - Prüfe $(basename "$file")..."
        TMP_FILE=$(mktemp)
        while read -r line; do
            if [[ "$line" =~ ^deb ]]; then
                MODIFIED_LINE=$(echo "$line" | sed "s/\b[a-z]\+\b/$CURRENT_CODENAME/g")
                URL=$(echo "$MODIFIED_LINE" | awk '{print $2}')
                if check_repo_url "$URL"; then
                    echo "$MODIFIED_LINE" >>"$TMP_FILE"
                else
                    echo "      ⚠️  Repo übersprungen (nicht erreichbar): $URL"
                fi
            else
                echo "$line" >>"$TMP_FILE"
            fi
        done <"$file"
        sudo cp "$TMP_FILE" "/etc/apt/sources.list.d/$(basename "$file")"
        rm "$TMP_FILE"
    done
fi

echo "[*] Update der Paketquellen..."
sudo apt update

echo "[*] Installiere APT-Pakete..."
xargs -a "$APT_LIST" sudo apt install -y

echo "[*] Installiere Snap-Pakete..."
xargs -a "$SNAP_LIST" sudo snap install

echo "[✓] Wiederherstellung abgeschlossen!"
