#!/data/data/com.termux/files/usr/bin/sh
set -euo pipefail
# Move to your git repository directory
cd $1

# Check for untracked files
if [[ -n $(git ls-files --others --exclude-standard) ]]; then
    echo "Untracked files found. Adding and committing them..."
    
    # Add all untracked files
    git add .

    # Commit with a message
    git commit -m "Automatically added untracked files"
else
    echo "No untracked files found."
fi
