# Parse command line arguments
param (
    [string]$outputFile
)

# Check if LogFile parameter is provided
if (-not $outputFile) {
    Write-Host "Please provide a log file path using outputFile parameter."
    exit
}

# Ensure the directory exists
if (-not (Test-Path (Split-Path $outputFile))) {
    New-Item -ItemType Directory -Path (Split-Path $outputFile) -Force | Out-Null
}

# Function to check environment variables for abnormalities
function Check-EnvVariables {
    # Initialize content for the report
    $content = @(
        "# Checking Environment Variables",
        "Generated on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
        ""
    )

    # Get environment variables
    $envVars = Get-ChildItem Env:

    # Check each variable
    foreach ($envVar in $envVars) {
        $name = $envVar.Name
        $value = $envVar.Value

        # Check for abnormalities in the variable name or value
        if ($name -match "password|secret|key|user|pw|id" -or $value -match "password|secret|key|user|pw|id") {
            $content += "Abnormal variable detected: $name"
            $content += "Value: $value"
            $content += ""
        }
    }

    # Write the results to the file
    $content += "***"
    $content | Out-File -FilePath $outputFile -Encoding UTF8
    Write-Host "Environment variable check completed. Results saved to: $outputFile"
}

# Main Execution
Check-EnvVariables
