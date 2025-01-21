#!/bin/bash

# Function to check for non-system scheduled tasks
check_non_system_scheduled_tasks() {
    # Initialize content for the report
    content=(
        "## Checking Non-System Scheduled Tasks"
    )

    # Check if running as root
    if [ "$(id -u)" -eq 0 ]; then
        # Get sudo cron jobs
        tasks=$(sudo crontab -l 2>/dev/null)
        content+=("Sudo Cron Jobs:")
        content+=("$tasks")
        content+=("")
        
        # Get classic cron jobs
        tasks=$(crontab -l 2>/dev/null)
        content+=("Classic Cron Jobs:")
        content+=("$tasks")
        content+=("")
    else
        # Get user cron jobs
        tasks=$(crontab -l 2>/dev/null)
        content+=("User Cron Jobs:")
        content+=("$tasks")
        content+=("")
    fi

    # Write the results to the file
    content+=("***")
    printf "%s\n" "${content[@]}" > "$outputFile"
}

# Parse command line arguments
while getopts "o:" opt; do
    case $opt in
        o) outputFile=$OPTARG ;;
        *) echo "Usage: $0 -o outputFile" >&2; exit 1 ;;
    esac
done

# Check if outputFile parameter is provided
if [ -z "$outputFile" ]; then
    echo "Please provide a log file path using -o option."
    exit 1
fi

# Ensure the directory exists
outputDir=$(dirname "$outputFile")
if [ ! -d "$outputDir" ]; then
    mkdir -p "$outputDir"
fi

# Main Execution
check_non_system_scheduled_tasks