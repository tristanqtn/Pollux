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

# Function to list running services
function Get-RunningServices {
    # Initialize content for the report
    $content = @(
        "## Services running as User:",
        ""
    )

    # Add table header
    $content += "{0,-50} {1}" -f "Services", "Description"
    $content += "------------------------------------------------------------"

    # Get all running services and categorize them
    $allServices = Get-Service | Where-Object { $_.Status -eq "Running" }
    $services = @()
    $adminServices = @()

    foreach ($service in $allServices) {
        $serviceInfo = Get-WmiObject -Class Win32_Service | Where-Object { $_.Name -eq $service.Name }
        if ($serviceInfo.StartName -eq "LocalSystem") {
            $adminServices += $serviceInfo
        } else {
            $services += $serviceInfo
        }
    }

    # List non-admin services
    foreach ($service in $services) {
        $description = if ($service.Description) {
            if ($service.Description.Length -gt 50) { $service.Description.Substring(0, 50) + "..." } else { $service.Description }
        } else {
            "No description available"
        }

        # Format service name and description with alignment
        $content += "{0,-50} {1}" -f $service.DisplayName, $description
    }

    # Add separator for admin services
    $content += "***"
    $content += ""
    $content += "## Services running as Admin:"
    $content += ""
    $content += "{0,-50} {1}" -f "Services", "Description"
    $content += "------------------------------------------------------------"

    # List admin services
    foreach ($service in $adminServices) {
        $description = if ($service.Description) {
            if ($service.Description.Length -gt 50) { $service.Description.Substring(0, 50) + "..." } else { $service.Description }
        } else {
            "No description available"
        }

        # Format service name and description with alignment
        $content += "{0,-50} {1}" -f $service.DisplayName, $description
    }

    # Add final separator
    $content += "***"

    # Write the results to the file
    $content | Out-File -FilePath $outputFile -Encoding UTF8
}

# Main Execution
Get-RunningServices
