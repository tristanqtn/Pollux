# Parse command line arguments
param (
    [string]$tmpFilePath
)

# Check if LogFile parameter is provided
if (-not $tmpFilePath) {
    Write-Host "Please provide a log file path using tmpFilePath parameter."
    exit
}

# Ensure the directory exists
if (-not (Test-Path (Split-Path $tmpFilePath))) {
    New-Item -ItemType Directory -Path (Split-Path $tmpFilePath) -Force | Out-Null
}

# Function to generate the update report
function Generate-UpdateReport {
    $content = @()

    # Add title to the report
    $content += "## Windows update report"

    # Initialize the Update Session
    $updateSession = New-Object -ComObject Microsoft.Update.Session

    # Create an Update Searcher object
    $updateSearcher = $updateSession.CreateUpdateSearcher()

    # Filter the updates for specific categories (e.g., security, feature updates)
    $searchResult = $updateSearcher.Search("IsInstalled=0")

    if ($searchResult.Updates.Count -eq 0) {
        $content += "System is up to date."
    }
    else {
        $content += "System is not up to date."
        $content += "Available updates:"

        foreach ($update in $searchResult.Updates) {
            # Extract details for each update
            $updateDetails = @"
Title: $($update.Title)
Category: $(($update.Categories | ForEach-Object { $_.Name } | Out-String).Trim() -join ", ")
Description: $($update.Description)
More Info: $($update.MoreInfoUrls -join ", ")
"@
            $content += $updateDetails
        }
    }

    # Check if the system is configured for WSUS or Windows Update for Business
    $regKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    if (Test-Path $regKey) {
        $wsusServer = Get-ItemProperty -Path $regKey -Name "WUServer" -ErrorAction SilentlyContinue
        if ($wsusServer) {
            $content += "System is configured to use WSUS server: $($wsusServer.WUServer)"
        }
        else {
            $content += "System is configured to use the default Windows Update service."
        }
    }
    else {
        $content += "No WSUS or Windows Update for Business settings found."
    }

    # Add footer to the report
    $content += "***"

    # Write the results to the file
    $content | Out-File -FilePath $tmpFilePath -Encoding UTF8
}

# Main Execution
Generate-UpdateReport
