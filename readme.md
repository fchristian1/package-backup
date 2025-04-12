
# 🗃️ package-backup

Ein simples Backup- und Wiederherstellungs-Tool für Ubuntu, das installierte APT- und Snap-Pakete sowie APT-Repository-Quellen automatisch sichert und nach einer Neuinstallation wiederherstellt – inklusive Repositories, Versionserkennung und Sicherheitsprüfung.

## 🚀 Features

- Sichert:
  - Manuell installierte APT-Pakete
  - Installierte Snap-Pakete
  - Alle aktiven APT-Repositories (`sources.list` & `sources.list.d/`)
- Erkennt automatisch deine Ubuntu-Version (`jammy`, `noble`, etc.)
- Ersetzt veraltete Distribution-Codenames in Repos
- Prüft Repository-URLs vor der Wiederherstellung
- Überspringt nicht erreichbare Quellen automatisch
- Erstellt Sicherheitskopien bestehender Systemdateien
- Unterstützt automatisches Update der Skripte aus diesem Repository

## 📁 Backup-Skript

### `backup-installed-packages.sh`

Sichert alles in den Ordner `~/package-backup`.

```bash
./backup-installed-packages.sh
```

Gespeichert wird:

- `apt-packages.list`: Manuelle APT-Pakete
- `snap-packages.list`: Installierte Snap-Pakete
- `sources.list`: APT-Hauptquellen
- `sources.list.d/`: Zusätzliche Fremdquellen (PPAs etc.)

---

## ♻️ Restore-Skript

### `restore-installed-packages.sh`

Wiederherstellung mit automatischer Prüfung:

```bash
./restore-installed-packages.sh
```

Funktionen:

- Passt `.list`-Dateien an deine aktuelle Ubuntu-Version an
- Prüft jede Repository-URL per HTTP (`curl`)
- Überspringt ungültige oder veraltete Quellen
- Erstellt Backups von `/etc/apt/sources.list*` vor Änderungen
- Installiert alle Pakete aus den gesicherten Listen

---

## 🔄 Skripte aktualisieren

### `update-package-backup-scripts.sh`

Lädt die aktuelle Version der Skripte direkt aus diesem Repository:

```bash
./update-package-backup-scripts.sh
```

---

## 🧰 Voraussetzungen

- Ubuntu/Debian-basiertes System
- `curl`, `sudo`, `xargs`, `lsb_release`
- Snap muss installiert sein (`sudo apt install snapd`)

---

## 🛡️ Sicherheit & Hinweise

- Repositories werden mit deiner aktuellen Ubuntu-Version (`lsb_release -cs`) abgeglichen.
- Vorhandene Systemdateien werden **nicht überschrieben**, sondern gesichert (`.bak.YYYYMMDD-HHMMSS`)
- Wenn ein Repo nicht erreichbar ist, wird es **übersprungen**, nicht importiert.

---

## 📝 Lizenz

MIT License – frei verwendbar, bitte mit Hinweis auf dieses Repo.

---

## 💡 Idee oder Fehler?

Pull Requests und Issues sind willkommen! 🎉  
👉 [https://github.com/fchristian1/package-backup](https://github.com/fchristian1/package-backup)
```