#!/bin/bash

# Universal Antivirus Status Checker Script
# Requires root privileges for full functionality.

# Output file
output_file="Antivirus_Linux_report.tmp"

# Clear the output file
> "$output_file"

# Function to check if the script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "ERROR: Script requires root privileges." >> "$output_file"
        exit 1
    fi
}

# Function to handle errors
handle_error() {
    local message=$1
    echo "$message" >> "$output_file"
    exit 1
}

# Function to detect installed antivirus software
detect_antivirus() {
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
            installed_antivirus+=("$av_name")
        fi
    done

    if [ ${#installed_antivirus[@]} -eq 0 ]; then
        handle_error "No antivirus software"
    fi

    echo "Detected Antivirus: ${installed_antivirus[*]}" >> "$output_file"
}

# Function to check the status of antivirus services
check_av_status() {
    for av_name in "${installed_antivirus[@]}"; do
        case $av_name in
            "ClamAV")
                if systemctl is-active --quiet clamav-daemon; then
                    echo "ClamAV: Running" >> "$output_file"
                else
                    echo "ClamAV: Not Running" >> "$output_file"
                fi
                ;;
            "Sophos")
                if systemctl is-active --quiet sav-protect; then
                    echo "Sophos: Running" >> "$output_file"
                else
                    echo "Sophos: Not Running" >> "$output_file"
                fi
                ;;
            "ESET")
                if systemctl is-active --quiet esets; then
                    echo "ESET: Running" >> "$output_file"
                else
                    echo "ESET: Not Running" >> "$output_file"
                fi
                ;;
            "Kaspersky")
                if systemctl is-active --quiet kav4ws; then
                    echo "Kaspersky: Running" >> "$output_file"
                else
                    echo "Kaspersky: Not Running" >> "$output_file"
                fi
                ;;
            "Comodo")
                if systemctl is-active --quiet cmdscan; then
                    echo "Comodo: Running" >> "$output_file"
                else
                    echo "Comodo: Not Running" >> "$output_file"
                fi
                ;;
            "F-Secure")
                if systemctl is-active --quiet fsav; then
                    echo "F-Secure: Running" >> "$output_file"
                else
                    echo "F-Secure: Not Running" >> "$output_file"
                fi
                ;;
            "Trend Micro")
                if systemctl is-active --quiet trendcln; then
                    echo "Trend Micro: Running" >> "$output_file"
                else
                    echo "Trend Micro: Not Running" >> "$output_file"
                fi
                ;;
            "Bitdefender")
                if systemctl is-active --quiet bdscan; then
                    echo "Bitdefender: Running" >> "$output_file"
                else
                    echo "Bitdefender: Not Running" >> "$output_file"
                fi
                ;;
            "Avast")
                if systemctl is-active --quiet avast; then
                    echo "Avast: Running" >> "$output_file"
                else
                    echo "Avast: Not Running" >> "$output_file"
                fi
                ;;
            *)
                echo "$av_name: Status Check Not Implemented" >> "$output_file"
                ;;
        esac
    done
}

# Function to check for antivirus database updates
check_database_updates() {
    for av_name in "${installed_antivirus[@]}"; do
        case $av_name in
            "ClamAV")
                if [ -f /var/lib/clamav/daily.cvd ]; then
                    last_update=$(stat -c %y /var/lib/clamav/daily.cvd 2>/dev/null | cut -d' ' -f1)
                    echo "ClamAV Database Last Update: $last_update" >> "$output_file"
                else
                    echo "ClamAV Database: Not Found" >> "$output_file"
                fi
                ;;
            *)
                # Check system logs for antivirus database updates
                log_check=$(journalctl -u "$av_name" 2>/dev/null | grep -i "update" | tail -n 1)
                if [ -n "$log_check" ]; then
                    echo "$av_name Database Last Update: $log_check" >> "$output_file"
                else
                    echo "$av_name Database Update: Could Not Determine" >> "$output_file"
                fi
                ;;
        esac
    done
}


# Function to check for scheduled scans
check_scheduled_scans() {
    for av_name in "${installed_antivirus[@]}"; do
        # Check user crontab
        if crontab -l 2>/dev/null | grep -i "${av_name,,}" &> /dev/null; then
            echo "$av_name Scheduled Scan: Found in User Crontab" >> "$output_file"
        else
            echo "$av_name Scheduled Scan: Not Found in User Crontab" >> "$output_file"
        fi

        # Check system-wide cron directories
        cron_dirs=("/etc/cron.daily" "/etc/cron.weekly" "/etc/cron.hourly")
        found_in_system_cron=false
        for dir in "${cron_dirs[@]}"; do
            if ls "$dir" 2>/dev/null | grep -i "${av_name,,}" &> /dev/null; then
                echo "$av_name Scheduled Scan: Found in $dir" >> "$output_file"
                found_in_system_cron=true
            fi
        done

        if [ "$found_in_system_cron" = false ]; then
            echo "$av_name Scheduled Scan: Not Found in System-Wide Crons" >> "$output_file"
        fi
    done
}


# Main execution flow
check_root
detect_antivirus
check_av_status
check_database_updates
check_scheduled_scans
