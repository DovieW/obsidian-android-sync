#!/data/data/com.termux/files/usr/bin/bash
source /data/data/com.termux/files/usr/etc/bash.bashrc

cmd() {
  printf "\n\033[0;34m%s\033[0m\n" "$(basename "$PWD")"
  GIT_PAGER= git fetch
  GIT_PAGER= git -c color.ui=always status
}

if [ -z "${OBSIDIAN_DIR_PATH:-}" ] || [ ! -d "$OBSIDIAN_DIR_PATH" ]; then
  echo "OBSIDIAN_DIR_PATH is not set or does not point to a directory."
  exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/vault-status.XXXXXX")"
lock_file="$tmp_dir/lock"
touch "$lock_file"
trap 'rm -rf "$tmp_dir"' EXIT

if command -v flock >/dev/null 2>&1; then
  has_flock=1
else
  has_flock=0
fi

is_tty=0
if [ -t 1 ]; then
  is_tty=1
fi

emit_output() {
  local file="$1"
  if [ "$is_tty" -eq 1 ]; then
    printf '\033[1A\033[2K'
  fi
  cat "$file"
  printf '\n'
  if [ "$is_tty" -eq 1 ]; then
    printf '\033[0;34mLoading...\033[0m\n'
  fi
}

if [ "$is_tty" -eq 1 ]; then
  printf '\033[0;34mLoading...\033[0m\n'
fi

# Run each vault status concurrently and print its full output only after it finishes.
pids=()
ran_job=0
for dir in "$OBSIDIAN_DIR_PATH"/*; do
  if [ -d "$dir" ]; then
    ran_job=1
    (
      tmp_file="$(mktemp "$tmp_dir/output.XXXXXX")"
      if cd "$dir"; then
        cmd >"$tmp_file" 2>&1 || printf '[WARN] Status command failed for %s\n' "$(basename "$dir")" >>"$tmp_file"
      else
        printf 'Could not enter %s\n' "$dir" >"$tmp_file"
      fi

      if [ "$has_flock" -eq 1 ]; then
        (
          flock -x 9
          emit_output "$tmp_file"
        ) 9>"$lock_file"
      else
        emit_output "$tmp_file"
      fi

      rm -f "$tmp_file"
    ) &
    pids+=($!)
  fi
done

status=0
for pid in "${pids[@]}"; do
  if ! wait "$pid"; then
    status=1
  fi
done

if [ "$is_tty" -eq 1 ]; then
  printf '\033[1A\033[2K'
fi

if [ "$ran_job" -eq 0 ]; then
  echo "No vault directories found to check."
fi

echo

echo -e '\033[44;97mPress enter to exit...\033[0m'
read none

exit $status
