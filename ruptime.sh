#!/bin/bash

# Function to convert a date/time string to seconds since epoch
function date_to_epoch() {
    local date_str="$1"
    local format="$2"
    date -d "${date_str}" +"${format}" 2>/dev/null || date -jf "${format}" "${date_str}" +%s 2>/dev/null
}

# Get the target time from the user
read -p "Enter the target time (day/month/year hours:minutes:seconds): " target_time_str

# Convert the target time to seconds since epoch
target_time=$(date_to_epoch "${target_time_str}" "%d/%m/%Y %H:%M:%S")

# Get the text to listen for from the user
read -p "Enter the text to listen for: " target_text

# Start the timer
start_time=$(date +%s)
elapsed_time=0

while true; do
    # Calculate the elapsed time
    current_time=$(date +%s)
    elapsed_time=$((current_time - start_time))

    # Check if the target text has been read
    if dunstctl history | grep -q "${target_text}"; then
        echo "Target text has been read."
        break
    fi

    # Check if the target time has been reached
    if ((current_time >= target_time)); then
        echo "Target time has been reached."
        break
    fi

    # Wait for 1 second
    sleep 1
done

# Print the elapsed time
echo "Elapsed time: $(date -u -d@${elapsed_time} +%H:%M:%S)"
