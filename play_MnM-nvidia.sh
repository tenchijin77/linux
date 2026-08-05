#!/bin/bash

GAME_DIR="$HOME/Games/MnM/mnm"
PFX_DIR="$HOME/.local/share/mnm/pfx"
DB_PATH="$HOME/.local/share/com.monstersandmemories.launcher/launcher.db"

# Dynamically locate native Steam path
if [ -d "$HOME/.local/share/Steam" ]; then
    STEAM_PATH="$HOME/.local/share/Steam"
elif [ -d "$HOME/.steam/steam" ]; then
    STEAM_PATH="$HOME/.steam/steam"
elif [ -d "$HOME/.steam/root" ]; then
    STEAM_PATH="$HOME/.steam/root"
else
    echo "Error: Native Steam installation path not found."
    exit 1
fi

PROTON_PATH="$STEAM_PATH/steamapps/common/Proton - Experimental"

if [ ! -f "$PROTON_PATH/proton" ]; then
    echo "Error: 'Proton - Experimental' not found at $PROTON_PATH"
    echo "Please ensure 'Proton - Experimental' is installed in your Steam library."
    exit 1
fi

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

# Proton Steam Context Setup
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_PATH"
export STEAM_COMPAT_DATA_PATH="$PFX_DIR"
export SteamAppId="29300"

# Nvidia Offload & Vulkan Directives for Laptop
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.x86_64.json

echo "Injecting session token into Monsters and Memories..."

# Execute game via Proton
"$PROTON_PATH/proton" run ./mnm.exe -patchme -token "$TOKEN"
