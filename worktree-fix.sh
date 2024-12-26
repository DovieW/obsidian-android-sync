#!/bin/bash
set -euo pipefail

# Colors for echo commands
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Source and destination paths
SOURCE_PATH="/storage/emulated/0/repos/Obsidian"
DEST_PATH="$HOME/repos/Obsidian"

# Create the destination directory if it doesn't exist
echo -e "${YELLOW}Creating destination directory at $DEST_PATH if it doesn't exist...${NC}"
mkdir -p "$DEST_PATH"

# Move all repositories from source to destination
for repo in "$SOURCE_PATH"/*; do
  if [ -d "$repo/.git" ]; then

    if [ -f "$repo/.git" ]; then
      echo "$repo is a worktree. Skipping."
      continue
    fi
  
    # Get the name of the repository
    repo_name=$(basename "$repo")

    # Move the repository
    echo -e "${YELLOW}Moving repository $repo_name to $DEST_PATH...${NC}"
    mv "$repo" "$DEST_PATH/"

    # Change to the repository directory
    echo -e "${YELLOW}Changing to the repository directory $DEST_PATH/$repo_name...${NC}"
    cd "$DEST_PATH/$repo_name" || exit

    # Get the current branch name
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    git switch -c empty

    # Remove all files and directories except the .git directory
    echo -e "${YELLOW}Removing all files from the working directory of $repo_name except the .git directory...${NC}"
    find . -mindepth 1 \( -not -path "./.git" -a -not -path "./.git/*" \) -exec rm -rf {} +

    # Create a worktree for the repo back to the original location, checked out to the default branch
    echo -e "${YELLOW}Creating a worktree for $repo_name back to the original location at $SOURCE_PATH/$repo_name, checked out to $current_branch...${NC}"
    mkdir -p "$SOURCE_PATH/$repo_name"
    git worktree add "$SOURCE_PATH/$repo_name" "$current_branch"
  fi
done

echo -e "${GREEN}All repositories have been moved and worktrees created.${NC}"

