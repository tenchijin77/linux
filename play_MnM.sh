#!/bin/bash

GAME_DIR="$HOME/Games/MnM/mnm"
WINEPREFIX="$HOME/.local/share/mnm/mnm/pfx"
PROTON_PATH="$HOME/.local/share/Steam/steamapps/common/Proton - Experimental"

# Safety checks
if [ ! -d "$GAME_DIR" ]; then
    echo "Error: Could not find MnM at $GAME_DIR"
    exit 1
fi

if [ ! -f "$PROTON_PATH/proton" ]; then
    echo "Error: Proton - Experimental not found at $PROTON_PATH"
    exit 1
fi

if ! command -v umu-run &>/dev/null; then
    echo "Error: umu-run not found. Please install umu-launcher."
    exit 1
fi

# GPU detection
if lspci | grep -qi nvidia; then
    echo "NVIDIA GPU detected, enabling prime offload..."
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.x86_64.json
elif lspci | grep -qi amd; then
    echo "AMD GPU detected..."
    export RADV_PERFTEST=gpl
    export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
fi

cd "$GAME_DIR" || exit 1

echo "Launching Monsters and Memories..."
WINEPREFIX="$WINEPREFIX" \
PROTONPATH="$PROTON_PATH" \
STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam" \
GAMEID=mnm \
WINEARCH=win64 \
umu-run ./mnm.exe --patchme
