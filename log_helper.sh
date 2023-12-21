#!/data/data/com.termux/files/usr/bin/bash

function setup_logging() {
  LOG_FILE=$1
  
  echo -e "\n\033[1;33m$(date) \033[0m" >> "$LOG_FILE"
  
  exec > >(tee -a "$LOG_FILE") 2>&1
}

function log_cleanup() {
  LOG_FILE=$1
  
  LOG_LINES_LIMIT=${LOG_LINES_LIMIT:-1500}
  
  if [[ -e "$LOG_FILE" ]]; then
    current_lines=$(wc -l < "$LOG_FILE")

    if [[ $current_lines -gt $LOG_LINES_LIMIT ]]; then
      lines_to_remove=$((current_lines - LOG_LINES_LIMIT))
      
      sed -i "1,${lines_to_remove}d" "$LOG_FILE"
    fi
  fi
}

function bypass_log() {
  # Temporarily disable logging
  exec > /dev/tty 2>&1

  # Execute the command
  eval "$1"

  # Re-enable logging
  exec > >(tee -a "$LOG_FILE") 2>&1
}
