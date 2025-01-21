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

check_filesystem() {
    # Create the report file
    {
        # Find files with admin permissions
        echo "## Files with admin permissions:"
        find / -path /mnt/c -prune -o -type f \( -perm -4000 -o -perm -2000 \) -exec ls -ld {} \; 2>/dev/null
        echo "***"
        # Find files in unusual locations (e.g., /tmp, /var/tmp)
        echo -e "\n## Files in unusual locations:"
        find /tmp /var/tmp -path /mnt/c -prune -o -type f -exec ls -ld {} \; 2>/dev/null
        echo "***"
        # Find files with SUID permissions
        echo -e "\n## Files with SUID permissions:"
        find / -path /mnt/c -prune -o -type f -perm /4000 -exec ls -ld {} \; 2>/dev/null
        echo "***"
    } > "$OUTPUT_SCRIPT"
}

# Main Execution
check_filesystem
# Audit global filesystem configuration
audit_filesystem_config() {
    {
        # List mounted filesystems
        echo -e "\n## Mounted Filesystems:"
        mount
        echo "***"
        # List filesystem disk usage
        echo -e "\n## Filesystem Disk Usage:"
        df -h
        echo "***"
        # List filesystem inodes usage
        echo -e "\n## Filesystem Inodes Usage:"
        df -i
        echo "***"
        # List current swap usage
        echo -e "\n## Swap Usage:"
        swapon --show
        echo "***"
    } >> "$OUTPUT_SCRIPT"
}

# Main Execution
check_filesystem
audit_filesystem_config