alias ll="ls -lAFt --color=auto"
alias ls="ls -F --color=auto"
alias l="ls -1AFt --color=auto"

alias g="git"
alias n="nano"

export PATH="${PATH}:/data/data/com.termux/files/home"

export STORAGE_PATH="/storage/emulated/0" # if modifying, also change line 2 in the setup script
export REPOS_PATH="$STORAGE_PATH/repos" # if modifying, also change line 2 in the setup script
export SCRIPTS_REPO="obsidian-android-sync" # if modifying, also change line 2 in the setup script
export SCRIPTS_REPO_PATH="$REPOS_PATH/$SCRIPTS_REPO"
export OBSIDIAN_DIR="Obsidian"
export OBSIDIAN_DIR_PATH="$REPOS_PATH/$OBSIDIAN_DIR"
export NOTIFICATION_PATH="$STORAGE_PATH/sync-error-notification"
export LAST_SYNC_PATH="$HOME/last_sync.log"

alias sync="$HOME/sync-vaults.sh --skip-pause"
alias bashrc="nano /data/data/com.termux/files/usr/etc/bash.bashrc"
alias sbashrc="source /data/data/com.termux/files/usr/etc/bash.bashrc"
alias repos="cd $REPOS_PATH"
alias csetup="cp $SCRIPTS_REPO_PATH/setup $HOME/"
alias storage="cd $STORAGE_PATH"

cd "$REPOS_PATH"

export RESET="\033[0m"
export GREEN="\033[1;32m"
export RED="\033[1;31m"
export BLUE="\033[1;34m"
export YELLOW="\033[1;33m"
