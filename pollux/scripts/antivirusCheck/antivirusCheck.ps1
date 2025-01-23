# Parse command line arguments
param (
    [string]$LogFile
)

# Check if LogFile parameter is provided
if (-not $LogFile) {
    Write-Host "Please provide a log file path using --LogFile"
    exit
}

# Ensure the directory exists
if (-not (Test-Path (Split-Path $LogFile))) {
    New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force | Out-Null
}

# Function to check Windows Defender status
function Check-WindowsDefender {
    try {
        $content = @(
            "## Windows Defender Information",
            ""
        )

        # Check if Windows Defender is running
        $defenderStatus = Get-Service -Name "WinDefend" -ErrorAction Stop
        if ($defenderStatus.Status -ne "Running") {
            $content += "Windows Defender: Installed but not running."
            $content += "***"
            $content += ""
            $content | Out-File -FilePath $LogFile -Append -Encoding UTF8
            return
        }

        $content += "Windows Defender: Running"
        $signatureVersion = (Get-MpComputerStatus -ErrorAction Stop).AMEngineVersion
        $content += "Version: $signatureVersion"

        # Check for ongoing scans
        $scanStatus = Get-MpComputerStatus -ErrorAction Stop | Select-Object -Property QuickScanInProgress, FullScanInProgress
        $scanInProgress = if ($scanStatus.QuickScanInProgress -or $scanStatus.FullScanInProgress) { "Yes" } else { "No" }

        $content += "Scan in Progress: $scanInProgress"
        $content += "***"
        $content += ""
        $content | Out-File -FilePath $LogFile -Append -Encoding UTF8
    }
    catch {
        "ERROR: Unable to retrieve Windows Defender status." | Out-File -FilePath $LogFile -Append -Encoding UTF8
    }
}

# Function to check antivirus information
function Check-AntivirusStatus {
    try {
        $content = @(
            "## Antivirus Information",
            ""
        )
        # Retrieve antivirus information
        $antivirusInfo = Get-CimInstance -Namespace "root/SecurityCenter2" -ClassName "AntivirusProduct" -ErrorAction Stop

        if (!$antivirusInfo) {
            $content += "Antivirus: Not Detected."
            $content | Out-File -FilePath $LogFile -Append -Encoding UTF8
            return
        }

        foreach ($av in $antivirusInfo) {
            $content += "Antivirus: $($av.displayName)"
            $content += "Product Status: $($av.productState)"
        }
        $content += "***"
        $content += ""
        $content | Out-File -FilePath $LogFile -Append -Encoding UTF8
    }
    catch {
        "ERROR: Unable to retrieve antivirus information." | Out-File -FilePath $LogFile -Append -Encoding UTF8
    }
}

# Function to check recent antivirus scans
function Check-AntivirusScans {
    try {
        $content = @(
            "## Recent Antivirus Scans",
            ""
        )
        # Retrieve recent scan logs
        $scanLogs = Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" `
            -FilterXPath "*[System[(EventID=1000 or EventID=1001)]]" `
            -MaxEvents 5

        if (-not $scanLogs) {
            $content += "Recent Scans: None found."
            $content | Out-File -FilePath $LogFile -Append -Encoding UTF8
            return
        }

        foreach ($log in $scanLogs) {
            $scanType = $log.Properties[1].Value
            $scanResult = $log.Properties[3].Value
            $scanTime = $log.TimeCreated

            $content += "Scan Type: $scanType"
            $content += "Scan Result: $scanResult"
            $content += "Scan Time: $scanTime"
        }
        $content += "***"
        $content | Out-File -FilePath $LogFile -Append -Encoding UTF8
    }
    catch {
        "ERROR: Unable to retrieve scan logs." | Out-File -FilePath $LogFile -Append -Encoding UTF8
    }
}

# Run the checks
Check-WindowsDefender
Check-AntivirusStatus
Check-AntivirusScans
