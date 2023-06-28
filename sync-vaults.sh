#!/data/data/com.termux/files/usr/bin/sh

# remove this line when possible
export GIT_SSH_COMMAND='ssh -i ~/.ssh2/id_ed25519 -F ~/.ssh2/ssh_config'

sync="$HOME/git-sync"
repo="$HOME/storage/shared/repos/Obsidian"
(cd "$repo/General" && $sync)
(cd "$repo/B&H" && $sync)
(cd "$repo/Personal" && $sync)
