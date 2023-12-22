#!/data/data/com.termux/files/usr/bin/bash
source /data/data/com.termux/files/usr/etc/bash.bashrc

log="$HOME/sync.log"

# Start an infinite loop
while true; do
    clear # Clear the screen

    # Check if log file exists
    if [[ -f $log ]]; then
        \cat $HOME/sync.log
    else
        echo "No log yet..."
    fi

    # Prompt the user
    echo -e '\n\033[44;97mPress R to reload or Enter to exit...\033[0m'
    read -r -n 1 -s input # Read a single character in silent mode

    # Check if the input is Enter (empty)
    if [[ -z $input ]]; then
        break # Exit the loop (and the script)
    elif [[ $input == "r" ]] || [[ $input == "R" ]]; then
        continue # Continue the loop (reload)
    fi
done

