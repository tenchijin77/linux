#!/bin/bash
pkill -9 -f "mnm_launcher"
pkill -9 -f "WebKitWebProcess"

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
fi

# Launch patcher using environment variable for home dir
"$HOME/Games/MnM/MonstersAndMemories_amd64.AppImage"
