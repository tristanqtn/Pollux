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

# Add title to the report
"## Windows update report" | Out-File -FilePath $tmpFilePath

# Initialize the Update Session
$updateSession = New-Object -ComObject Microsoft.Update.Session

# Create an Update Searcher object
$updateSearcher = $updateSession.CreateUpdateSearcher()

# Search for available updates
"Checking for updates..." | Tee-Object -FilePath $tmpFilePath -Append

# Filter the updates for specific categories (e.g., security, feature updates)
$searchResult = $updateSearcher.Search("IsInstalled=0")

if ($searchResult.Updates.Count -eq 0) {
    "System is up to date." | Tee-Object -FilePath $tmpFilePath -Append
} else {
    "System is not up to date." | Tee-Object -FilePath $tmpFilePath -Append
    "Available updates:" | Tee-Object -FilePath $tmpFilePath -Append

    foreach ($update in $searchResult.Updates) {
        # Extract details for each update
        $updateDetails = @"
Title: $($update.Title)
Category: $(($update.Categories | ForEach-Object { $_.Name } | Out-String).Trim() -join ", ")
Description: $($update.Description)
More Info: $($update.MoreInfoUrls -join ", ")
"@
        $updateDetails | Tee-Object -FilePath $tmpFilePath -Append
    }
}

# Check if the system is configured for WSUS or Windows Update for Business
$regKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
if (Test-Path $regKey) {
    $wsusServer = Get-ItemProperty -Path $regKey -Name "WUServer" -ErrorAction SilentlyContinue
    if ($wsusServer) {
        "System is configured to use WSUS server: $($wsusServer.WUServer)" | Tee-Object -FilePath $tmpFilePath -Append
    } else {
        "System is configured to use the default Windows Update service." | Tee-Object -FilePath $tmpFilePath -Append
    }
} else {
    "No WSUS or Windows Update for Business settings found." | Tee-Object -FilePath $tmpFilePath -Append
}

# Add footer to the report
"***" | Tee-Object -FilePath $tmpFilePath -Append

"Check complete. Results written to $tmpFilePath"
