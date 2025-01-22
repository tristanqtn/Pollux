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

# Function to list iptables rules
list_iptables_rules() {
    if command -v iptables >/dev/null 2>&1; then
        echo "## iptables Rules" >> "$output_file"
        echo "" >> "$output_file"
        iptables -L -v -n >> "$output_file" 2>/dev/null
        echo "" >> "$output_file"
    else
        echo "iptables is not installed or not available." >> "$output_file"
    fi
        echo "***" >> "$output_file"
}

# Function to list nftables rules
list_nftables_rules() {
    if command -v nft >/dev/null 2>&1; then
        echo "## nftables Rules" >> "$output_file"
        echo "" >> "$output_file"
        nft list ruleset >> "$output_file" 2>/dev/null
        echo "" >> "$output_file"
    else
        echo "nftables is not installed or not available." >> "$output_file"
    fi
        echo "***" >> "$output_file"
}

# Main execution
list_iptables_rules
list_nftables_rules
