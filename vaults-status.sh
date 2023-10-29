#!/data/data/com.termux/files/usr/bin/bash
source /data/data/com.termux/files/usr/etc/bash.bashrc

cmd() {
  printf "\n\033[0;34m%s\033[0m\n" "$(basename "$PWD")"
  git fetch
  git status
}

for dir in "$OBSIDIAN_DIR_PATH"/*; do
  if [ -d "$dir" ]; then
    (cd "$dir" && cmd)
  fi
done

echo

echo -e '\033[44;97mPress enter to finish...\033[0m'
read none
