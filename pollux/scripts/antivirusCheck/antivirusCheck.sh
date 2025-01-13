#!/bin/bash

# Universal Antivirus Status Checker Script
# Requires root privileges for full functionality.

# Function to check if the script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[Error] Please run this script as root."
        exit 1
    fi
}

# Function to handle errors
handle_error() {
    local message=$1
    echo "[Error] $message"
    exit 1
}

# Function to detect installed antivirus software
detect_antivirus() {
    echo "[Info] Detecting installed antivirus software..."
    declare -A antivirus_list

    # Known antivirus detection commands
    antivirus_list["ClamAV"]="clamscan"
    antivirus_list["Sophos"]="sav-protect"
    antivirus_list["ESET"]="esets_scan"
    antivirus_list["Kaspersky"]="kav4ws-kavscanner"
    antivirus_list["Comodo"]="cmdscan"
    antivirus_list["F-Secure"]="fsav"
    antivirus_list["Trend Micro"]="trendcln"
    antivirus_list["Bitdefender"]="bdscan"
    antivirus_list["Avast"]="avast"

    installed_antivirus=()

    for av_name in "${!antivirus_list[@]}"; do
        if command -v "${antivirus_list[$av_name]}" &> /dev/null; then
            echo "[Detected] $av_name is installed."
            installed_antivirus+=("$av_name")
        fi
    done

    if [ ${#installed_antivirus[@]} -eq 0 ]; then
        handle_error "No antivirus software detected."
    fi
}

# Function to check the status of antivirus services
check_av_status() {
    echo "[Info] Checking antivirus service statuses..."
    for av_name in "${installed_antivirus[@]}"; do
        case $av_name in
            "ClamAV")
                if systemctl is-active --quiet clamav-daemon; then
                    echo "[ClamAV] Service is running."
                else
                    echo "[ClamAV] Service is not running. Start it with 'sudo systemctl start clamav-daemon'."
                fi
                ;;
            "Sophos")
                if systemctl is-active --quiet sav-protect; then
                    echo "[Sophos] Service is running."
                else
                    echo "[Sophos] Service is not running. Start it with 'sudo systemctl start sav-protect'."
                fi
                ;;
            "ESET")
                if systemctl is-active --quiet esets; then
                    echo "[ESET] Service is running."
                else
                    echo "[ESET] Service is not running. Start it with 'sudo systemctl start esets'."
                fi
                ;;
            "Kaspersky")
                if systemctl is-active --quiet kav4ws; then
                    echo "[Kaspersky] Service is running."
                else
                    echo "[Kaspersky] Service is not running. Start it with 'sudo systemctl start kav4ws'."
                fi
                ;;
            *)
                echo "[$av_name] Status check not implemented yet."
                ;;
        esac
    done
}

# Function to check for antivirus database updates
check_database_updates() {
    echo "[Info] Checking antivirus database updates..."
    for av_name in "${installed_antivirus[@]}"; do
        case $av_name in
            "ClamAV")
                if [ -f /var/lib/clamav/daily.cvd ]; then
                    last_update=$(stat -c %y /var/lib/clamav/daily.cvd 2>/dev/null | cut -d' ' -f1)
                    echo "[ClamAV] Database last updated on: $last_update"
                else
                    echo "[ClamAV] Database not found. Update with 'sudo freshclam'."
                fi
                ;;
            "Sophos")
                echo "[Sophos] Checking database updates requires Sophos-specific tools."
                ;;
            *)
                echo "[$av_name] Database update check not implemented yet."
                ;;
        esac
    done
}

# Function to check for scheduled scans
check_scheduled_scans() {
    echo "[Info] Checking scheduled scans..."
    for av_name in "${installed_antivirus[@]}"; do
        case $av_name in
            "ClamAV")
                if crontab -l | grep -i "clamscan" &> /dev/null; then
                    echo "[ClamAV] Scheduled scan found in user crontab."
                else
                    echo "[ClamAV] No scheduled scan found in user crontab."
                fi
                ;;
            "Sophos")
                echo "[Sophos] Checking scheduled scans requires specific tools."
                ;;
            *)
                echo "[$av_name] Scheduled scan check not implemented yet."
                ;;
        esac
    done

    # System-wide cron directories
    echo "[Info] Checking system-wide scheduled tasks..."
    cron_dirs=("/etc/cron.daily" "/etc/cron.weekly" "/etc/cron.hourly")
    for dir in "${cron_dirs[@]}"; do
        if ls "$dir" | grep -i "clam" &> /dev/null; then
            echo "[Scheduled Scan] Found in $dir."
        else
            echo "[No Scheduled Scan] Found in $dir."
        fi
    done
}

# Main execution flow
check_root
detect_antivirus
check_av_status
check_database_updates
check_scheduled_scans
