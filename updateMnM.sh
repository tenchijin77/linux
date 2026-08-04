#!/bin/bash
pkill -9 -f "mnm_launcher"
pkill -9 -f "WebKitWebProcess"

# Clear WebKit/GPU caches
rm -rf ~/.local/share/com.monstersandmemories.launcher/GPUCache
rm -rf ~/.local/share/com.monstersandmemories.launcher/Cache
rm -rf ~/.local/share/com.monstersandmemories.launcher/WebKitCache

# Disable WebKit hardware acceleration to stop WebKitWebProcess from aborting
export WEBKIT_DISABLE_COMPOSITING_MODE=1
export WEBKIT_DISABLE_DMABUF_RENDERER=1
export LIBGL_ALWAYS_SOFTWARE=1
export LD_PRELOAD=/usr/lib64/libwayland-client.so.0

# Launch patcher
/home/rwilkinson/Games/MnM/MonstersAndMemories_amd64.AppImage
