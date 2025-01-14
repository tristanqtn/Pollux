# Define the path for the temporary file
$tmpFilePath = "/tmp/pollux/output/updateCheck"

# Ensure the directory exists
if (-not (Test-Path (Split-Path $tmpFile))) {
    New-Item -ItemType Directory -Path (Split-Path $tmpFile) -Force | Out-Null
}

# Initialize the Update Session
$updateSession = New-Object -ComObject Microsoft.Update.Session

# Create an Update Searcher object
$updateSearcher = $updateSession.CreateUpdateSearcher()

# Search for available updates
Write-Output "Checking for updates..." | Tee-Object -FilePath $tmpFile

# Filter the updates for specific categories (e.g., security, feature updates)
$searchResult = $updateSearcher.Search("IsInstalled=0")

if ($searchResult.Updates.Count -eq 0) {
    Write-Output "System is up to date." | Tee-Object -FilePath $tmpFile -Append
} else {
    Write-Output "System is not up to date." | Tee-Object -FilePath $tmpFile -Append
    Write-Output "Available updates:" | Tee-Object -FilePath $tmpFile -Append

    foreach ($update in $searchResult.Updates) {
        # Extract details for each update
        $updateDetails = @"
Title: $($update.Title)
Category: $($update.Categories | ForEach-Object { $_.Name } -join ", ")
Description: $($update.Description)
More Info: $($update.MoreInfoUrls -join ", ")
"@
        Write-Output $updateDetails | Tee-Object -FilePath $tmpFile -Append
    }
}

# Check if the system is configured for WSUS or Windows Update for Business
$regKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
if (Test-Path $regKey) {
    $wsusServer = Get-ItemProperty -Path $regKey -Name "WUServer" -ErrorAction SilentlyContinue
    if ($wsusServer) {
        Write-Output "System is configured to use WSUS server: $($wsusServer.WUServer)" | Tee-Object -FilePath $tmpFile -Append
    } else {
        Write-Output "System is configured to use the default Windows Update service." | Tee-Object -FilePath $tmpFile -Append
    }
} else {
    Write-Output "No WSUS or Windows Update for Business settings found." | Tee-Object -FilePath $tmpFile -Append
}

Write-Output "Check complete. Results written to $tmpFile"
