#!/bin/bash

# Check if output file parameter is provided
if [ -z "$1" ]; then
    echo "Please provide a log file path as the first argument."
    exit 1
fi

output_file="$1"

# Ensure the directory exists
dirname="$(dirname "$output_file")"
if [ ! -d "$dirname" ]; then
    mkdir -p "$dirname"
fi

# Function to list open ports and associated services
list_open_ports_and_services() {
    echo "## Listening Ports" > "$output_file"
    ss -lntp >> "$output_file"
    echo "" >> "$output_file"
    echo "***" >> "$output_file"
    echo "" >> "$output_file"

    #echo "## Established Connections" >> "$output_file"
    #ss -anp | grep ESTAB >> "$output_file"
    #echo "" >> "$output_file"
    #echo "***" >> "$output_file"
}

# Main execution
list_open_ports_and_services
