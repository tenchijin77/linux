rwilkinson@fedora:~ % cat ./play_mnm_home.sh 
#!/bin/bash

GAME_DIR="/home/rwilkinson/Games/MnM/mnm"
PROTON_PATH="/home/rwilkinson/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Proton - Experimental"
PFX_DIR="/home/rwilkinson/.local/share/mnm/pfx"
DB_PATH="$HOME/.local/share/com.monstersandmemories.launcher/launcher.db"

# Pull exact token string directly from SQLite database
TOKEN=$(python3 -c "
import sqlite3, os
db_path = os.path.expanduser('$DB_PATH')
if os.path.exists(db_path):
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute(\"SELECT value FROM settings WHERE variable='token';\")
    row = c.fetchone()
    print(row[0] if row else '')
    conn.close()
")

if [ -z "$TOKEN" ]; then
    echo "Error: No token found in launcher.db!"
    exit 1
fi

mkdir -p "$PFX_DIR"
cd "$GAME_DIR" || exit 1

export STEAM_COMPAT_CLIENT_INSTALL_PATH="/home/rwilkinson/.var/app/com.valvesoftware.Steam/.local/share/Steam"
export STEAM_COMPAT_DATA_PATH="$PFX_DIR"

echo "Injecting session token into Monsters and Memories..."

# Passing the JWT token explicitly via -token and --token without quotes wrapping the argument key
"$PROTON_PATH/proton" run ./mnm.exe -patchme -token "$TOKEN"
rwilkinson@fedora:~ % 
