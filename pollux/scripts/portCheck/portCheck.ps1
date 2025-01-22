# Parse command line arguments
param (
    [string]$outputFile
)

# Check if outputFile parameter is provided
if (-not $outputFile) {
    Write-Host "Please provide a log file path using outputFile parameter."
    exit
}

# Ensure the directory exists
if (-not (Test-Path (Split-Path $outputFile))) {
    New-Item -ItemType Directory -Path (Split-Path $outputFile) -Force | Out-Null
}

# Function to list open ports and associated services
function List-OpenPortsAndServices {
    # Initialize content for the report
    $content = @(
        "## Listing Open Ports and Associated Services",
        ""
    )

    # Get open ports
    $ports = Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" }

    # Check each port and gather service information
    foreach ($port in $ports) {
        $content += "Local Address: $($port.LocalAddress)"
        $content += "Local Port: $($port.LocalPort)"

        $serviceName = (Get-NetTCPConnection -LocalPort $port.LocalPort -ErrorAction SilentlyContinue | ForEach-Object {
            (Get-WmiObject Win32_Service | Where-Object { $_.ProcessId -eq $port.OwningProcess }).DisplayName
            }) -join ", "

        if ($serviceName) {
            $content += "Associated Service: $serviceName"
        }
        else {
            $content += "Associated Service: None"
        }

        $content += ""
    }

    # Write the results to the file
    $content += "***"
    $content | Out-File -FilePath $outputFile -Encoding UTF8
}

# Main Execution
List-OpenPortsAndServices
