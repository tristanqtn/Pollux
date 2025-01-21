#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

OUTPUT_SCRIPT="$1"

> "$OUTPUT_SCRIPT"

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

check_sessions() {
    # Create the report file
    {
        # List user sessions
        echo "## User sessions:"
        who
        echo "***"
        # List user privileges and commands they can run as root
        echo -e "\n## User privileges and sudo commands:"
        for user in $(cut -f1 -d: /etc/passwd); do
            echo -e "\nUser: $user"
            sudo -lU $user
        done
        echo "***"
    } > "$OUTPUT_SCRIPT"
}

# Main Execution
check_sessions