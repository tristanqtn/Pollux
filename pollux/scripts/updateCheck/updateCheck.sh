#!/bin/bash

# Define the temporary file path
# Hardcoded for now, will be changed to a more dynamic path
TMP_FILE="/tmp/pollux/output/updateCheck.tmp"

# Ensure the temporary directory exists
mkdir -p "$(dirname "$TMP_FILE")"

# Start the file with the title
echo "## Linux update report" > "$TMP_FILE"

# Check for updates and write the results to the temporary file
if command -v apt &> /dev/null; then
    # For Debian/Ubuntu-based systems
    UPDATES=$(apt update 2>/dev/null | grep "packages can be upgraded")
    if [ -z "$UPDATES" ]; then
        echo "System is up to date." >> "$TMP_FILE"
    else
        echo "System is not up to date." >> "$TMP_FILE"
        echo "Available updates:" >> "$TMP_FILE"
        apt list --upgradable 2>/dev/null | grep -v "Listing..." >> "$TMP_FILE"
    fi
elif command -v yum &> /dev/null; then
    # For RHEL/CentOS-based systems
    UPDATES=$(yum check-update 2>/dev/null | grep -v "Loaded plugins")
    if [ -z "$UPDATES" ]; then
        echo "System is up to date." >> "$TMP_FILE"
    else
        echo "System is not up to date." >> "$TMP_FILE"
        echo "Available updates:" >> "$TMP_FILE"
        yum check-update 2>/dev/null >> "$TMP_FILE"
    fi
elif command -v dnf &> /dev/null; then
    # For newer RHEL/CentOS/Fedora systems
    UPDATES=$(dnf check-update 2>/dev/null | grep -v "Last metadata expiration")
    if [ -z "$UPDATES" ]; then
        echo "System is up to date." >> "$TMP_FILE"
    else
        echo "System is not up to date." >> "$TMP_FILE"
        echo "Available updates:" >> "$TMP_FILE"
        dnf check-update 2>/dev/null >> "$TMP_FILE"
    fi
elif command -v zypper &> /dev/null; then
    # For openSUSE/SLES systems
    UPDATES=$(zypper lu 2>/dev/null | grep -E "No updates found|Available updates")
    if [[ "$UPDATES" =~ "No updates found" ]]; then
        echo "System is up to date." >> "$TMP_FILE"
    else
        echo "System is not up to date." >> "$TMP_FILE"
        echo "Available updates:" >> "$TMP_FILE"
        zypper lu 2>/dev/null >> "$TMP_FILE"
    fi
else
    echo "Package manager not supported by this script." >> "$TMP_FILE"
fi

# Add footer to the file
echo "***" >> "$TMP_FILE"

# Output the result
echo "Check complete. Results written to $TMP_FILE"
