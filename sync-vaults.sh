#!/data/data/com.termux/files/usr/bin/bash
source /data/data/com.termux/files/usr/etc/bash.bashrc

source "$HOME/log_helper.sh"
log_file="$HOME/sync.log"
setup_logging $log_file

LOCK_FILE="$HOME/sync-vaults.lock"

# Function to remove lock file
cleanup() {
    rm -f "$LOCK_FILE"
    exit 1
}

# Trap to catch interruptions
trap cleanup INT TERM

# Function to wait for lock release
wait_for_lock_release() {
    while [ -e "$LOCK_FILE" ]; do
        sleep 1
    done
}

if [ -e "$LOCK_FILE" ]; then # check if the lock file exists
    if [ -z "$(ps -p $(cat "$LOCK_FILE") -o pid=)" ]; then # Check if the process that created the lockfile is still running
        echo "Removing stale lock file."
        rm -f "$LOCK_FILE"
    else
        wait_for_lock_release
    fi
fi

# Store the PID in the lock file
echo $$ > "$LOCK_FILE"

skip_pause_val="--skip-pause"

cmd () {
  printf "\n\033[0;34m%s\033[0m\n" "$(basename "$PWD")"
  $HOME/git-sync -ns
}

git_repos=()

# Populate the array with Git repos from the Obsidian folder
for dir in "$OBSIDIAN_DIR_PATH"/*; do
  if [ -d "$dir" ]; then
    cd "$dir"
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      git_repos+=("$dir")
    fi
  fi
done

msg="You can try running 'setup' to see if it helps".

# Exit if no Git repos are found
if [ ${#git_repos[@]} -eq 0 ]; then
  echo -e "${YELLOW}No Git repositories found in the Obsidian folder.\n${msg}${RESET}"
  exit 1
fi

if [[ -n "$1" && "$1" != "$skip_pause_val" ]]; then # Sync a single repo
  if [[ " ${git_repos[@]} " =~ " $OBSIDIAN_DIR_PATH/$1 " ]]; then
    (cd "$OBSIDIAN_DIR_PATH/$1" && cmd)
  else
    echo -e "${RED}Specified directory doesn't exist or is not a Git repository.\n${msg}${RESET}"
    exit 1
  fi
else  # Sync all Git repos
  for repo in "${git_repos[@]}"; do
    (cd "$repo" && cmd)
  done
fi

log_cleanup $log_file

if [[ -z "$1" ]]; then
  bypass_log "echo -e '\n\033[44;97mPress enter to finish...\033[0m' && read none"
fi


rm -f "$LOCK_FILE"
exit 0
