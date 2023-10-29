#!/data/data/com.termux/files/usr/bin/bash
source /data/data/com.termux/files/usr/etc/bash.bashrc

log="$HOME/sync.log"

if [[ -f $log ]]; then
    cat $HOME/sync.log
else
    echo "No log yet..."
fi

echo -e '\n\033[44;97mPress enter to finish...\033[0m'
read none
