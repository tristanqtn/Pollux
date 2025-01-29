# Parameter block to accept inputs
param (
    [string]$LogFile,
    [array]$PortTable,         # Array of ports to check
    [array]$TrustedSubnets,    # Array of trusted subnets
    [int]$RunLevel = 0         # Run level: 0 = full, 1 = skip Check-OpenPorts, 2 = skip TrustedSubnets, 3 = skip both
)

# Ensure a log file path is provided
if (-not $LogFile) {
    Write-Host "Please provide a log file path using --LogFile"
    exit
}

# Ensure the directory exists
if (-not (Test-Path (Split-Path $LogFile))) {
    New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force | Out-Null
}

# Function to log data
function Log-Data {
    param (
        [string]$Data
    )
    Add-Content -Path $LogFile -Value $Data
}

Log-Data "## Firewall & ACLs"
# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Log-Data "This script is not running with administrative privileges."
    Log-Data "Some functionality will be limited. Please run as Administrator for full functionality."
    $IsAdmin = $false
} else {
    Log-Data "Running with administrative privileges."
    $IsAdmin = $true
}

# Function to handle error messages
function Handle-Error {
    param (
        [string]$Message,
        [object]$Error
    )
    Log-Data "[Error] $Message"
    Log-Data "Details: $($Error.Exception.Message)"
}

# Function to check firewall status
function Check-FirewallStatus {
    try {
        Log-Data "Checking Windows Firewall profiles"
        $profiles = Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction, LogAllowed, LogDroppedPackets, LogFilePath

        foreach ($profile in $profiles) {
            Log-Data "Profile Name: $($profile.Name)"
            Log-Data "Enabled: $($profile.Enabled)"
            Log-Data "Default Inbound Action: $($profile.DefaultInboundAction)"
            Log-Data "Default Outbound Action: $($profile.DefaultOutboundAction)"
            Log-Data "Log Allowed Connections: $($profile.LogAllowed)"
            Log-Data "Log Dropped Packets: $($profile.LogDroppedPackets)"
            Log-Data "Log File Path: $($profile.LogFilePath)"
        }
    } catch {
        Handle-Error "An error occurred while checking firewall profiles." $_
    }
}

# Function to check open ports
function Check-OpenPorts {
    if (-not $IsAdmin) {
        Log-Data "Skipping Check-OpenPorts: Administrative privileges required."
    }
    else {
        try {
            Log-Data " "
            Log-Data "Check-OpenPorts: "
            $openPorts = Get-NetFirewallRule |
                Where-Object { $_.Enabled -eq $true -and $_.Direction -eq "Inbound" } |
                Get-NetFirewallPortFilter

            if ($openPorts.Count -eq 0) {
                Log-Data "No active firewall rules (ACLs) found."
                return
            }

            foreach ($port in $openPorts) {
                Log-Data "Rule Name: $($port.InstanceID)"
                Log-Data "Local Port: $($port.LocalPort)"
                Log-Data "Protocol: $($port.Protocol)"
                Log-Data "Remote Port: $($port.RemotePort)"
            }

            Log-Data "End Check-OpenPorts. "
        } catch {
            Handle-Error "An error occurred while checking open ports." $_
        }
    }
}

# Function to check blocked traffic rules
function Check-BlockedTrafficRules {
    if (-not $IsAdmin) {
        Log-Data "Skipping Check-BlockedTrafficRules: Administrative privileges required."
    }
    else {
         try {
            Log-Data " "
            Log-Data "Check-BlockedTrafficRules: "
            $blockedRules = Get-NetFirewallRule | Where-Object { $_.Action -eq "Block" -and $_.Enabled -eq $true }

            foreach ($rule in $blockedRules) {
                Log-Data "Blocked Rule Name: $($rule.Name)"
                Log-Data "Direction: $($rule.Direction)"
            }

            Log-Data "End Check-BlockedTrafficRules. "
        } catch {
            Handle-Error "An error occurred while checking blocked traffic rules." $_
        }
    }
   
}

# Function to display filtered firewall rules
function Check-FirewallRules {
    if (-not $IsAdmin) {
        Log-Data "Skipping Check-FirewallRules: Administrative privileges required."
    }
    else {
        try {
            Log-Data " "
            Log-Data "Check-FirewallRules: "
            Log-Data "  Port table: "

            # Ensure the PortTable and TrustedSubnets parameters are provided
            if (-not $PortTable -or -not $TrustedSubnets) {
                Log-Data "PortTable or TrustedSubnets parameters are missing."
                return
            }

            # Retrieve and filter rules based on provided port table
            $filteredRules = Get-NetFirewallRule |
                Where-Object { $_.Enabled -eq $true -and $_.Direction -eq "Inbound" } |
                Get-NetFirewallPortFilter |
                Where-Object { $_.LocalPort -in $PortTable }

            foreach ($rule in $filteredRules) {
                Log-Data "Local Ports: $($rule.LocalPort -join ', ')"
            }

            # Log rules matching the provided port table
            if ($filteredRules.Count -eq 0) {
                Log-Data "No firewall rules matching the specified ports found."
            } else {
                foreach ($rule in $filteredRules) {
                    Log-Data "Rule Name: $($rule.InstanceID)"
                    Log-Data "Local Ports: $($rule.LocalPort)"
                    Log-Data "Remote Ports: $($rule.RemotePort)"
                    Log-Data "Protocol: $($rule.Protocol)"
                    Log-Data "-----------------------------"
                }
            }

            Log-Data " "
            Log-Data "  Trusted subnet: "
            # Additional check for trusted subnets
            $subnetRules = Get-NetFirewallRule |
                Where-Object { $_.Enabled -eq $true } |
                Get-NetFirewallAddressFilter |
                Where-Object { $_.RemoteAddress -notin $TrustedSubnets }

            # Log rules violating trusted subnet policies
            if ($subnetRules.Count -eq 0) {
                Log-Data "No firewall rules violating trusted subnet policies found."
            } else {
                foreach ($rule in $subnetRules) {
                    Log-Data "Rule Name: $($rule.InstanceID)"
                    Log-Data "Remote Address: $($rule.RemoteAddress)"
                    Log-Data "Direction: $($rule.Direction)"
                    Log-Data "-----------------------------"
                }
            }

            Log-Data "End Check-FirewallRules. "
        } catch {
            Log-Data "An error occurred while fetching rules: $($_.Exception.Message)"
        }
    }
}

# Run checks based on RunLevel
Check-FirewallStatus
if ($RunLevel -ne 1 -and $RunLevel -ne 3) {
    Check-OpenPorts
}
Check-BlockedTrafficRules
if ($RunLevel -ne 2 -and $RunLevel -ne 3) {
    Check-FirewallRules
}

Log-Data "***"