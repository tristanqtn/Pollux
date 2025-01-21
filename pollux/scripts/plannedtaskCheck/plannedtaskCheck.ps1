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

# Function to check for non-system scheduled tasks
function Check-NonSystemScheduledTasks {
    # Initialize content for the report
    $content = @(
        "## Checking Non-System Scheduled Tasks",
        ""
    )

    # Get scheduled tasks
    $tasks = Get-ScheduledTask | Where-Object { $_.TaskPath -notlike "\Microsoft\*" }

    # Check each task
    foreach ($task in $tasks) {
        $content += "Task Name: $($task.TaskName)"
        $content += "Task Path: $($task.TaskPath)"
        $content += "Task State: $($task.State)"
        $content += ""
    }

    # Write the results to the file
    $content += "***"
    $content | Out-File -FilePath $outputFile -Encoding UTF8
}

# Main Execution
Check-NonSystemScheduledTasks