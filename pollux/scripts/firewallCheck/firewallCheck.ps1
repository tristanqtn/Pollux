# Check if output file parameter is provided
param (
    [Parameter(Mandatory = $true)]
    [string]$OutputFile
)

# Ensure the output directory exists
$OutputDir = Split-Path -Path $OutputFile
if (!(Test-Path -Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Function to list firewall rules using Get-NetFirewallRule
function List-NetFirewallRules {
    Write-Output "## Windows Firewall Rules (Get-NetFirewallRule)" >> $OutputFile
    Write-Output "" >> $OutputFile

    try {
        $rules = Get-NetFirewallRule | ForEach-Object {
            $properties = @{
                Name          = $_.Name
                DisplayName   = $_.DisplayName
                Enabled       = $_.Enabled
                Direction     = $_.Direction
                Action        = $_.Action
                LocalAddress  = $_.LocalAddress
                LocalPort     = $_.LocalPort
                RemoteAddress = $_.RemoteAddress
                RemotePort    = $_.RemotePort
                Profile       = $_.Profile
            }
            New-Object PSObject -Property $properties
        }
        $rules | Format-Table -AutoSize | Out-String | Out-File -Append -FilePath $OutputFile
    }
    catch {
        Write-Output "Error retrieving firewall rules with Get-NetFirewallRule: $_" >> $OutputFile
    }

    Write-Output "" >> $OutputFile
}

# Function to list firewall rules using netsh
function List-NetshFirewallRules {
    Write-Output "## Firewall Rules (netsh)" >> $OutputFile
    Write-Output "" >> $OutputFile

    try {
        netsh advfirewall firewall show rule name=all | Out-File -Append -FilePath $OutputFile
    }
    catch {
        Write-Output "Error retrieving firewall rules with netsh: $_" >> $OutputFile
    }

    Write-Output "" >> $OutputFile
}

# Main execution
Write-Output "## Firewall Rules Enumeration" > $OutputFile
Write-Output "" >> $OutputFile

List-NetFirewallRules
List-NetshFirewallRules

Write-Output "***" >> $OutputFile
