#!/bin/bash

# Kill any existing launcher processes
pkill -9 -f "mnm_launcher" 2>/dev/null
pkill -9 -f "WebKitWebProcess" 2>/dev/null

# Clear WebKit, GPU caches, and local app database state
rm -rf ~/.local/share/com.monstersandmemories.launcher/GPUCache
rm -rf ~/.local/share/com.monstersandmemories.launcher/Cache
rm -rf ~/.local/share/com.monstersandmemories.launcher/WebKitCache
rm -f ~/.local/share/com.monstersandmemories.launcher/*.db*

# Disable WebKit hardware acceleration
export WEBKIT_DISABLE_COMPOSITING_MODE=1
export WEBKIT_DISABLE_DMABUF_RENDERER=1
export LIBGL_ALWAYS_SOFTWARE=1

# Dynamically locate libwayland-client.so.0 across Fedora and Debian/Ubuntu
if [ -f "/usr/lib64/libwayland-client.so.0" ]; then
    export LD_PRELOAD=/usr/lib64/libwayland-client.so.0
elif [ -f "/usr/lib/x86_64-linux-gnu/libwayland-client.so.0" ]; then
    export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libwayland-client.so.0
else
    echo "Warning: libwayland-client.so.0 not found, launching without LD_PRELOAD."
fi

# Verify AppImage exists
if [ ! -f "$HOME/Games/MnM/MonstersAndMemories_amd64.AppImage" ]; then
    echo "Error: AppImage not found at ~/Games/MnM/MonstersAndMemories_amd64.AppImage"
    exit 1
fi

# Launch patcher
echo "Launching MnM updater..."
"$HOME/Games/MnM/MonstersAndMemories_amd64.AppImage"

# Check for corrupted assets after patching
echo "Checking for corrupted assets..."
for f in "$HOME/Games/MnM/mnm/mnm_Data/"*.assets; do
    if [ ! -s "$f" ]; then
        echo "Warning: $f appears empty and may be corrupted."
    fi
done

echo "Update complete. Run play_MnM.sh to launch."
