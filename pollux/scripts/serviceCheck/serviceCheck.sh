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

check_services() {
    {
        # List all running services and include the service description
        echo "## Running Services:"
        systemctl list-units --type=service --state=running --no-pager | awk 'NR>1 {print $1}' | while read service; do
            # Get the description for each service, with error handling
            description=$(systemctl show -p Description "$service" 2>/dev/null | sed 's/Description=//')
            if [ -z "$description" ]; then
                description="No description available"
            fi
            printf "%-40s %s\n" "$service" "$description"
        done
        echo "***"
        
        # Check for services running as root
        echo -e "\n## Services Running as Root:"
        ps -eo user,cmd | grep '^root.*systemd' | awk '{print $2}' | sort -u
        echo "***"
    } > "$OUTPUT_SCRIPT"
}

# Main Execution
check_services
