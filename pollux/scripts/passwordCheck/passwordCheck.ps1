# Parse command line arguments
param (
    [string]$outputFile
)

# Check if outputFile parameter is provided
if (-not $outputFile) {
    Write-Host "Please provide a log file path using the outputFile parameter."
    exit
}

# Ensure the directory exists
if (-not (Test-Path (Split-Path $outputFile))) {
    New-Item -ItemType Directory -Path (Split-Path $outputFile) -Force | Out-Null
}

# Function to check password policies
function Audit-PasswordPolicies {
    # Initialize content for the report
    $content = @(
        "## Password Policies Audit Report",
        ""
    )

    # Get local password policy settings
    $passwordPolicy = Get-LocalUser | Select-Object -First 1 | ForEach-Object {
        @{
            "Maximum Password Age"    = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").MaximumPasswordAge
            "Minimum Password Age"    = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").MinimumPasswordAge
            "Minimum Password Length" = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").MinimumPasswordLength
            "Password Complexity"     = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").PasswordComplexity
            "Lockout Threshold"       = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").LockoutThreshold
            "Lockout Duration"        = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").LockoutDuration
        }
    }

    # Format password policy information
    foreach ($policy in $passwordPolicy) {
        $content += "Policy: $($policy.Key)"
        $content += "Value: $($policy.Value)"
        $content += ""
    }

    # Add a separator
    $content += "***"
    $content += ""

    # Write the results to the file
    $content | Out-File -FilePath $outputFile -Encoding UTF8
}

# Main Execution
Audit-PasswordPolicies
