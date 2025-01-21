#!/bin/bash

# Parse command-line arguments
if [[ -z "$1" ]]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

output_file="$1"

# Ensure the directory exists
output_dir=$(dirname "$output_file")
if [[ ! -d "$output_dir" ]]; then
    mkdir -p "$output_dir"
fi

# Function to audit password policies
function audit_password_policies() {
    # Initialize content for the report
    {
        # Get password aging policies from /etc/login.defs
        echo "## Password Aging Policies (from /etc/login.defs)"
        grep -E "PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE" /etc/login.defs | while read -r line; do
            echo "$line"
        done
        echo ""

        # Check password complexity settings
        echo "## Password Complexity Requirements (PAM)"
        if grep -q "pam_pwquality.so" /etc/pam.d/common-password; then
            grep "pam_pwquality.so" /etc/pam.d/common-password | while read -r line; do
                echo "$line"
            done
        else
            echo "Password complexity requirements are not configured in PAM."
        fi
        echo ""

        # Check account lockout settings
        echo "##  Account Lockout Policies (PAM)"
        if grep -q "pam_tally2.so" /etc/pam.d/common-auth || grep -q "pam_faillock.so" /etc/pam.d/common-auth; then
            grep -E "pam_tally2.so|pam_faillock.so" /etc/pam.d/common-auth | while read -r line; do
                echo "$line"
            done
        else
            echo "Account lockout policies are not configured in PAM."
        fi
        echo ""

        echo "***"
        echo ""
    } > "$output_file"
}

# Main execution
audit_password_policies
echo "Password policy audit completed. Results saved to $output_file."
