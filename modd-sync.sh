#!/data/data/com.termux/files/usr/bin/bash

if [ $# -gt 1 ]; then # Handle modd's first run which spits out all dirs
   exit 0
fi

path=$(realpath $1)
$HOME/sync-vaults.sh $(groot "$path") > ~/log5 2>&1

