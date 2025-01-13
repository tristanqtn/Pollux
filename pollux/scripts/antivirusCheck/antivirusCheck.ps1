# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "This script is not running with administrative privileges."
    Write-Output "Some functionality will be limited. Please run as Administrator for full functionality."
    $IsAdmin = $false
} else {
    Write-Output "Running with administrative privileges."
    $IsAdmin = $true
}

# Function to handle error messages
function Handle-Error {
    param (
        [string]$Message,
        [object]$Error
    )
    Write-Output "[Error] $Message"
    Write-Output "Details: $($Error.Exception.Message)"
}

# Function to check Windows Defender status
function Check-WindowsDefender {
    try {
        if ($IsAdmin) {
            Write-Output "Checking Windows Defender status (admin mode)..."

            # Check if Windows Defender is installed
            $defenderStatus = Get-Service -Name "WinDefend" -ErrorAction Stop

            if ($defenderStatus.Status -ne "Running") {
                Write-Output "Windows Defender is installed but not running."
                return
            }

            Write-Output "Windows Defender is running."

            # Check antivirus definition status
            Write-Output "Checking antivirus definitions..."
            $definitions = Get-MpComputerStatus -ErrorAction Stop | Select-Object -Property AntivirusSignatureLastUpdated, AntivirusSignatureVersion

            if ($definitions.AntivirusSignatureLastUpdated -lt (Get-Date).AddDays(-1)) {
                Write-Output "Antivirus definitions are outdated. Last updated: $($definitions.AntivirusSignatureLastUpdated)"
            } else {
                Write-Output "Antivirus definitions are up to date. Last updated: $($definitions.AntivirusSignatureLastUpdated)"
            }

            Write-Output "Antivirus signature version: $($definitions.AntivirusSignatureVersion)"

            # Check for ongoing or scheduled scans
            Write-Output "Checking for active or scheduled scans..."
            $scanStatus = Get-MpComputerStatus -ErrorAction Stop | Select-Object -Property QuickScanInProgress, FullScanInProgress

            if ($scanStatus.QuickScanInProgress -or $scanStatus.FullScanInProgress) {
                Write-Output "A scan is currently in progress."
            } else {
                Write-Output "No scan is currently running. Please schedule or run a scan."
            }
        } else {
            Write-Output "Checking Windows Defender status (limited without admin rights)..."

            # Use WMI to query the WinDefend service
            $defenderStatus = Get-WmiObject -Class Win32_Service -Filter "Name='WinDefend'" -ErrorAction Stop

            if ($defenderStatus.State -ne "Running") {
                Write-Output "Windows Defender is installed but not running."
            } else {
                Write-Output "Windows Defender is running."
            }

            Write-Output "Note: Antivirus definitions and scans cannot be checked without admin rights."
        }
    } catch {
        Handle-Error "An error occurred while checking Windows Defender status." $_
    }
}

# Function to check antivirus information
function Check-AntivirusStatus {
    try {
        if ($IsAdmin) {
            Write-Output "Retrieving antivirus information from Windows Security Center (admin mode)..."

            # Query antivirus details using WMI
            $antivirusInfo = Get-CimInstance -Namespace "root/SecurityCenter2" -ClassName "AntivirusProduct" -ErrorAction Stop

            if (!$antivirusInfo) {
                Write-Output "No antivirus software is detected on this system."
                return
            }

            foreach ($av in $antivirusInfo) {
                Write-Output "Antivirus Name: $($av.displayName)"
                Write-Output "Path to Executable: $($av.pathToSignedProductExe)"

                # Decode product state
                $status = switch ($av.productState) {
                    266240 {"Up to date and enabled"}
                    262144 {"Out of date but enabled"}
                    266256 {"Up to date but disabled"}
                    default {"Unknown or not registered"}
                }
                Write-Output "Antivirus Status: $status"
            }
        } else {
            Write-Output "Retrieving antivirus information (limited without admin rights)..."

            # Use WMI to query antivirus details
            $antivirusInfo = Get-WmiObject -Namespace "root/SecurityCenter2" -ClassName "AntivirusProduct" -ErrorAction Stop

            if (!$antivirusInfo) {
                Write-Output "No antivirus software detected, or permissions are insufficient."
                return
            }

            foreach ($av in $antivirusInfo) {
                Write-Output "Antivirus Name: $($av.displayName)"
            }

            Write-Output "Note: Full antivirus status cannot be retrieved without admin rights."
        }
    } catch {
        Handle-Error "An error occurred while retrieving antivirus information." $_
    }
}

# Function to check recent antivirus scans
function Check-AntivirusScans {
    try {
        if ($IsAdmin) {
            Write-Output "Checking recent antivirus scans (admin mode)..."

            # For Windows Defender (or fallback for 3rd-party AVs logged in Event Viewer)
            $scanLogs = Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" -FilterXPath "*[System[(EventID=1000 or EventID=1001)]]" -MaxEvents 5

            if ($scanLogs.Count -eq 0) {
                Write-Output "No recent scan logs found. Scans might not be performed or logged."
                return
            }

            foreach ($log in $scanLogs) {
                Write-Output "Scan Type: $($log.Properties[1].Value)"
                Write-Output "Scan Result: $($log.Properties[3].Value)"
                Write-Output "Scan Time: $($log.TimeCreated)"
            }

            Write-Output "Checking for scheduled antivirus scans..."
            Get-ScheduledTask | Where-Object { $_.TaskName -match "Scan|Antivirus" } | 
                Select-Object TaskName, State, LastRunTime
        } else {
            Write-Output "Checking recent antivirus scans (limited without admin rights)..."
            Write-Output "Unable to access scan logs or scheduled tasks without administrative privileges."
            Write-Output "Please run this script with elevated rights for full functionality."
        }
    } catch {
        Handle-Error "An error occurred while checking antivirus scans." $_
    }
}

# Run the checks
Check-WindowsDefender
Check-AntivirusStatus
Check-AntivirusScans
