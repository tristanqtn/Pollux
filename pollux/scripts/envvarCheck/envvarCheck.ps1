# Paths
$outputDir = "C:\Temp\pollux\output"
$outputFile = Join-Path -Path $outputDir -ChildPath "envvarCheck.tmp"

# Create the output directory if it doesn't exist
if (-not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory | Out-Null
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
            $content += "***"
        }
    }

    # Write the results to the file
    $content | Out-File -FilePath $outputFile -Encoding UTF8
    Write-Host "Environment variable check completed. Results saved to: $outputFile"
}

# Main Execution
Check-EnvVariables
