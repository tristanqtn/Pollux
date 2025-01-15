# Parse command line arguments
param (
    [string]$LogFile
)

# Check if LogFile parameter is provided
if (-not $LogFile) {
    Write-Host "Please provide a log file path using --LogFile"
    exit
}

# Clear the log file if it exists
if (Test-Path $LogFile) { Remove-Item $LogFile }

# Function to log essential data
function Log-Data {
    param (
        [string]$Data
    )
    $Data | Out-File -FilePath $LogFile -Append
}

# Function to check Windows Defender status
function Check-WindowsDefender {
    try {
        # Check if Windows Defender is running
        $defenderStatus = Get-Service -Name "WinDefend" -ErrorAction Stop
        if ($defenderStatus.Status -ne "Running") {
            Log-Data "Windows Defender: Installed but not running."
            return
        }

        Log-Data "Windows Defender: Running."

        # Check antivirus definition status
        $definitions = Get-MpComputerStatus -ErrorAction Stop | Select-Object -Property AntivirusSignatureLastUpdated, AntivirusSignatureVersion
        $lastUpdated = $definitions.AntivirusSignatureLastUpdated
        $signatureVersion = $definitions.AntivirusSignatureVersion

        Log-Data "Last Updated: $lastUpdated"
        Log-Data "Version: $signatureVersion"

        # Check for ongoing scans
        $scanStatus = Get-MpComputerStatus -ErrorAction Stop | Select-Object -Property QuickScanInProgress, FullScanInProgress
        $scanInProgress = if ($scanStatus.QuickScanInProgress -or $scanStatus.FullScanInProgress) { "Yes" } else { "No" }

        Log-Data "Scan in Progress: $scanInProgress"
    } catch {
        Log-Data "ERROR: Unable to retrieve Windows Defender status."
    }
}

# Function to check antivirus information
function Check-AntivirusStatus {
    try {
        # Retrieve antivirus information
        $antivirusInfo = Get-CimInstance -Namespace "root/SecurityCenter2" -ClassName "AntivirusProduct" -ErrorAction Stop

        if (!$antivirusInfo) {
            Log-Data "Antivirus: Not Detected."
            return
        }

        foreach ($av in $antivirusInfo) {
            Log-Data "Antivirus: $($av.displayName)"
            Log-Data "Product Status: $($av.productState)"
        }
    } catch {
        Log-Data "ERROR: Unable to retrieve antivirus information."
    }
}

# Function to check recent antivirus scans
function Check-AntivirusScans {
    try {
        # Retrieve recent scan logs
        $scanLogs = Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" `
                                 -FilterXPath "*[System[(EventID=1000 or EventID=1001)]]" `
                                 -MaxEvents 5

        if (-not $scanLogs) {
            Log-Data "Recent Scans: None found."
            return
        }

        foreach ($log in $scanLogs) {
            $scanType = $log.Properties[1].Value
            $scanResult = $log.Properties[3].Value
            $scanTime = $log.TimeCreated

            Log-Data "Scan Type: $scanType"
            Log-Data "Scan Result: $scanResult"
            Log-Data "Scan Time: $scanTime"
        }
    } catch {
        Log-Data "ERROR: Unable to retrieve scan logs."
    }
}

# Run the checks
Check-WindowsDefender
Check-AntivirusStatus
Check-AntivirusScans
