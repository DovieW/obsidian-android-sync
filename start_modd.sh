#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

source /data/data/com.termux/files/usr/etc/bash.bashrc

# Start modd if it's not running
if ! pgrep -x "modd" > /dev/null; then
    cd "$OBSIDIAN_DIR_PATH"
    nohup modd > /dev/null 2>&1 &
fi

