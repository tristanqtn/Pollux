#!/bin/bash

# Require sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root (sudo)." 
    exit 1
fi

# Default parameter values
LOGFILE="firewall_report.log"
PORT_TABLE=()
TRUSTED_SUBNETS=("0.0.0.0/0")

# Parse script arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --LogFile)
            LOGFILE="$2"
            shift; shift;;
        --PortTable)
            IFS=',' read -ra PORT_TABLE <<< "$2"
            shift; shift;;
        --TrustedSubnets)
            IFS=',' read -ra USER_SUBNETS <<< "$2"
            TRUSTED_SUBNETS+=("${USER_SUBNETS[@]}")
            shift; shift;;
        *)
            echo "Unknown parameter: $1"
            exit 1;;
    esac
done

# Log file initialization
echo "## Firewall Report" > "$LOGFILE"

# Function to log data
log_data() {
    echo "$1" >> "$LOGFILE" 2>&1
}

# Function to check and log iptables rules
check_iptables() {
    log_data "Firewall: iptables"
    
    # Default policies
    log_data "iptables Default Policies:"
    sudo iptables -L -n | grep -i "policy" >> "$LOGFILE" 2>&1

    # NAT Rules
    log_data "iptables NAT Rules:"
    sudo iptables -t nat -L -n >> "$LOGFILE" 2>&1
    
    # Iterate through the port and provide detailed info for INPUT and OUTPUT chains
    for port in "${PORT_TABLE[@]}"; do
        for chain in INPUT OUTPUT; do
            result=$(sudo iptables -L $chain -v -n | grep -- "dpt:$port")

            if [ ! -z "$result" ]; then
                protocol=$(echo "$result" | awk '{print $2}')
                if [ "$protocol" == "0" ]; then
                    protocol="Any"
                fi
                packets=$(echo "$result" | awk '{print $3}')
                bytes=$(echo "$result" | awk '{print $5}')
                service=$(echo "$result" | awk '{print $8}')
                log_data "$chain Chain - Port $port: ALLOWED, Protocol: $protocol, Packets: $packets, Bytes: $bytes, Service: $service"
            else
                log_data "$chain Chain - Port $port: BLOCKED"
            fi
        done
    done

    # Checking for subnets that are NOT trusted
    for subnet in $(sudo iptables -L -n | grep -oP '\d+\.\d+\.\d+\.\d+/\d+' | sort | uniq); do
        if [[ ! " ${TRUSTED_SUBNETS[@]} " =~ " ${subnet} " ]]; then
            log_data "Subnet $subnet: NOT TRUSTED"
            # Get additional info about the subnet
            log_data "Fetching additional info for subnet $subnet..."
            # Whois lookup
            whois_info=$(whois $subnet | grep -E 'OrgName|NetName|Country' || echo "No whois info found.")
            log_data "WHOIS Info for $subnet: $whois_info"
            # Nmap scan for live hosts
            nmap_info=$(nmap -sn $subnet | grep 'Nmap scan report for')
            log_data "Nmap Info for $subnet: $nmap_info"
            # DNS lookup (if there's a DNS server)
            dns_info=$(dig +short $subnet)
            log_data "DNS Info for $subnet: $dns_info"
        fi
    done
}

# Function to check and log nftables rules
check_nftables() {
    log_data "Firewall: nftables"
    
    # Default policies
    log_data "nftables Default Policies:"
    sudo nft list ruleset | grep "policy" >> "$LOGFILE" 2>&1

    # NAT Rules
    log_data "nftables NAT Rules:"
    sudo nft list ruleset | grep "nat" >> "$LOGFILE" 2>&1
    
    # Iterate through the port and provide detailed info for INPUT and OUTPUT chains
    for port in "${PORT_TABLE[@]}"; do
        for chain in input output; do
            result=$(sudo nft list ruleset | grep -- "dport $port" | grep -i $chain)
            if [ ! -z "$result" ]; then
                log_data "$chain Chain - Port $port: ALLOWED"
            else
                log_data "$chain Chain - Port $port: BLOCKED"
            fi
        done
    done

    # Checking for subnets that are NOT trusted
    for subnet in $(sudo nft list ruleset | grep -oP '\d+\.\d+\.\d+\.\d+/\d+' | sort | uniq); do
        if [[ ! " ${TRUSTED_SUBNETS[@]} " =~ " ${subnet} " ]]; then
            log_data "Subnet $subnet: NOT TRUSTED"
            # Get additional info about the subnet
            log_data "Fetching additional info for subnet $subnet..."
            # Whois lookup
            whois_info=$(whois $subnet | grep -E 'OrgName|NetName|Country' || echo "No whois info found.")
            log_data "WHOIS Info for $subnet: $whois_info"
            # Nmap scan for live hosts
            nmap_info=$(nmap -sn $subnet | grep 'Nmap scan report for')
            log_data "Nmap Info for $subnet: $nmap_info"
            # DNS lookup (if there's a DNS server)
            dns_info=$(dig +short $subnet)
            log_data "DNS Info for $subnet: $dns_info"
        fi
    done
}

# Function to check and log ufw status
check_ufw() {
    log_data "Firewall: UFW"
    sudo ufw status verbose | awk '
    /Status:/ {print "Status:", $2}
    /To/ {print "Rule:", $0}' >> "$LOGFILE" 2>&1

    # Iterating over port and providing detailed info for INPUT and OUTPUT
    for port in "${PORT_TABLE[@]}"; do
        for chain in INPUT OUTPUT; do
            result=$(sudo ufw status | grep -- "$port")
            if [ ! -z "$result" ]; then
                log_data "$chain Chain - Port $port: ALLOWED"
            else
                log_data "$chain Chain - Port $port: BLOCKED"
            fi
        done
    done

    # Checking for subnets that are NOT trusted
    for subnet in $(sudo ufw status | grep -oP '\d+\.\d+\.\d+\.\d+/\d+' | sort | uniq); do
        if [[ ! " ${TRUSTED_SUBNETS[@]} " =~ " ${subnet} " ]]; then
            log_data "Subnet $subnet: NOT TRUSTED"
            # Get additional info about the subnet
            log_data "Fetching additional info for subnet $subnet..."
            # Whois lookup
            whois_info=$(whois $subnet | grep -E 'OrgName|NetName|Country' || echo "No whois info found.")
            log_data "WHOIS Info for $subnet: $whois_info"
            # Nmap scan for live hosts
            nmap_info=$(nmap -sn $subnet | grep 'Nmap scan report for')
            log_data "Nmap Info for $subnet: $nmap_info"
            # DNS lookup (if there's a DNS server)
            dns_info=$(dig +short $subnet)
            log_data "DNS Info for $subnet: $dns_info"
        fi
    done
}

# Function to check and log firewalld rules
check_firewalld() {
    log_data "Firewall: firewalld"
    sudo firewall-cmd --list-all | awk '
    /services:/ {print "Services:", $2}
    /ports:/ {print "Ports:", $2}' >> "$LOGFILE" 2>&1

    # Iterating over port and providing detailed info for INPUT and OUTPUT
    for port in "${PORT_TABLE[@]}"; do
        for chain in INPUT OUTPUT; do
            result=$(sudo firewall-cmd --list-ports | grep -- "$port")
            if [ ! -z "$result" ]; then
                log_data "$chain Chain - Port $port: ALLOWED"
            else
                log_data "$chain Chain - Port $port: BLOCKED"
            fi
        done
    done

    # Checking for subnets that are NOT trusted
    for subnet in $(sudo firewall-cmd --list-sources | grep -oP '\d+\.\d+\.\d+\.\d+/\d+' | sort | uniq); do
        if [[ ! " ${TRUSTED_SUBNETS[@]} " =~ " ${subnet} " ]]; then
            log_data "Subnet $subnet: NOT TRUSTED"
            # Get additional info about the subnet
            log_data "Fetching additional info for subnet $subnet..."
            # Whois lookup
            whois_info=$(whois $subnet | grep -E 'OrgName|NetName|Country' || echo "No whois info found.")
            log_data "WHOIS Info for $subnet: $whois_info"
            # Nmap scan for live hosts
            nmap_info=$(nmap -sn $subnet | grep 'Nmap scan report for')
            log_data "Nmap Info for $subnet: $nmap_info"
            # DNS lookup (if there's a DNS server)
            dns_info=$(dig +short $subnet)
            log_data "DNS Info for $subnet: $dns_info"
        fi
    done
}

# Detect and report active firewalls
log_data "Detecting active firewalls..."
if command -v ufw &> /dev/null && systemctl is-active --quiet ufw; then
    check_ufw
fi

if command -v firewall-cmd &> /dev/null && systemctl is-active --quiet firewalld; then
    check_firewalld
fi

if command -v nft &> /dev/null && sudo nft list ruleset &> /dev/null; then
    check_nftables
fi

if command -v iptables &> /dev/null; then
    check_iptables
fi

# End of the report
log_data "***"