#!/data/data/com.termux/files/usr/bin/bash
source /data/data/com.termux/files/usr/etc/bash.bashrc

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

source "$HOME/log_helper.sh"
log_file="$HOME/sync.log"
setup_logging "$log_file"

# Create directory to store individual sync logs
temp_dir="${HOME}/obsidian_sync_$$"
mkdir -p "$temp_dir"

cmd () {
  printf "\n\033[0;34m%s\033[0m\n" "$(basename "$PWD")"
  # We run git-sync and capture output. In a parallel scenario,
  # we redirect to a file, so we won't "live watch" it in this function.
  $HOME/git-sync -ns 2>&1
  if [ $? -ne 0 ]; then
    # If there was an error, append the output to NOTIFICATION_PATH
    cat "$1" >> "$NOTIFICATION_PATH"
  fi
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

msg="You can try running 'setup' to see if it helps."

# Exit if no Git repos are found
if [ ${#git_repos[@]} -eq 0 ]; then
  echo -e "${YELLOW}No Git repositories found in the Obsidian folder.\n${msg}${RESET}"
  exit 1
fi

if [[ -n "$1" && "$1" != "$skip_pause_val" ]]; then # Sync a single repo
  if [[ " ${git_repos[@]} " =~ " $OBSIDIAN_DIR_PATH/$1 " ]]; then
    repo="$OBSIDIAN_DIR_PATH/$1"
    repo_name="$(basename "$repo")"
    tmp_log="$temp_dir/${repo_name}.log"
    (cd "$repo" && cmd "$tmp_log" > "$tmp_log" 2>&1)
    cat "$tmp_log" >> "$log_file"
  else
    echo -e "${RED}Specified directory doesn't exist or is not a Git repository.\n${msg}${RESET}"
    rm -f "$LOCK_FILE"
    exit 1
  fi
else
  # Sync all Git repos in parallel
  pids=()
  for repo in "${git_repos[@]}"; do
    repo_name="$(basename "$repo")"
    tmp_log="$temp_dir/${repo_name}.log"

    (
      cd "$repo" && cmd "$tmp_log" > "$tmp_log" 2>&1
    ) &
    pids+=($!)
  done

  # Wait for all background syncs to complete
  for pid in "${pids[@]}"; do
    wait "$pid"
  done

  # Append all temp logs to the main log file
  cat "$temp_dir"/*.log >> "$log_file"
fi

# Cleanup temp logs
rm -rf "$temp_dir"

log_cleanup "$log_file"

# Pause if no repo was specified and skip_pause was not used
if [[ -z "$1" ]]; then
  bypass_log "echo -e '\n\033[44;97mPress enter to finish...\033[0m' && read none"
fi

rm -f "$LOCK_FILE"
exit 0
