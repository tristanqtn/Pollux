# Parse command line arguments
param (
    [string]$ReportFile
)

# Check if outputFile parameter is provided
if (-not $ReportFile) {
    Write-Host "Please provide a log file path using the outputFile parameter."
    exit
}

# Ensure the directory exists
if (-not (Test-Path (Split-Path $ReportFile))) {
    New-Item -ItemType Directory -Path (Split-Path $ReportFile) -Force | Out-Null
}

# Helper function to scan directories for sensitive files
function Scan-ForSensitiveFiles {
    param (
        [string]$dir,
        [string[]]$patterns
    )

    $message = "### $dir"
    Add-Content -Path $ReportFile -Value $message

    foreach ($pattern in $patterns) {
        $message = "Pattern: $pattern"
        Add-Content -Path $ReportFile -Value $message

        try {
            $files = Get-ChildItem -Path $dir -Recurse -File -Filter $pattern -ErrorAction SilentlyContinue
            if ($files) {
                $message = "Sensitive files found with pattern: $pattern"
                Add-Content -Path $ReportFile -Value $message
                foreach ($file in $files) {
                    $message = "$($file.FullName)"
                    Add-Content -Path $ReportFile -Value $message
                }
            }
        }
        catch {
            $message = "Error scanning $dir with pattern $pattern"
            Add-Content -Path $ReportFile -Value $message
        }
    }
}

# Helper function to check for backup files
function Check-ForBackupFiles {
    param (
        [string]$dir,
        [string[]]$patterns
    )

    $message = "### $dir"
    Add-Content -Path $ReportFile -Value $message

    foreach ($pattern in $patterns) {
        $message = "Pattern: $pattern"
        Add-Content -Path $ReportFile -Value $message

        try {
            $files = Get-ChildItem -Path $dir -Recurse -File -Filter $pattern -ErrorAction SilentlyContinue
            if ($files) {
                $message = "Backup files found with pattern: $pattern"
                Add-Content -Path $ReportFile -Value $message
                foreach ($file in $files) {
                    $message = "$($file.FullName)"
                    Add-Content -Path $ReportFile -Value $message
                }
            }
        }
        catch {
            $message = "Error scanning $dir for backup files"
            Add-Content -Path $ReportFile -Value $message
        }
    }
}

function Check-ForSuspiciousPermissions {
    param (
        [string]$dir
    )

    $message = "### $dir..."
    Add-Content -Path $ReportFile -Value $message

    try {
        # Define directories and file patterns that may be problematic if permissions are misconfigured
        $criticalDirectories = @(
            "C:\Windows\System32", 
            "C:\Windows",
            "C:\Program Files",
            "C:\Program Files (x86)",
            "C:\Users",
            "C:\ProgramData",
            "C:\Windows\security",
            "C:\Windows\System32\drivers",
            "C:\Windows\Logs",
            "C:\Windows\System32\Tasks"
        )

        # File patterns to target for suspicious permissions (e.g., backup, config, and key files)
        $criticalFilePatterns = @(
            "*.bak", "*.backup", "*.swp", "*.log", "*.old", 
            "id_rsa", "config.php", "credentials", 
            "system.ini", "win.ini", "*.reg", "*.ps1", "*.bat"
        )

        # Only proceed if the directory is critical or contains critical files
        if ($criticalDirectories -contains $dir -or ($criticalFilePatterns | Where-Object { $dir -like "*$_" })) {
            # Get all files recursively
            $files = Get-ChildItem -Path $dir -Recurse -File -ErrorAction SilentlyContinue

            # Get the list of all users with potential suspicious permissions (Everyone and BUILTIN\Users)
            $suspectUsers = @("Everyone", "BUILTIN\Users")

            $foundSuspicious = $false
            foreach ($file in $files) {
                # Only check critical files matching the patterns
                foreach ($pattern in $criticalFilePatterns) {
                    if ($file.Name -like $pattern) {

                        # Get AccessControl data using GetAccessControl() method (faster than Get-Acl)
                        $acl = $file.GetAccessControl()

                        # Collect the permissions as a hash table
                        $userRights = @{ }
                        $acl.Access | ForEach-Object {
                            $userName = $_.IdentityReference -replace ".+\\", "" # Simplify the user name
                            $userRights[$userName] = $_.FileSystemRights
                        }

                        # Compare against suspicious users
                        $matchedUsers = Compare-Object -ReferenceObject $suspectUsers -DifferenceObject $userRights.Keys -IncludeEqual -ExcludeDifferent

                        if ($matchedUsers) {
                            foreach ($user in $matchedUsers.InputObject) {
                                $message = "$user has suspicious rights: $($userRights[$user]) on file $($file.FullName)"
                                Add-Content -Path $ReportFile -Value $message
                            }
                            $foundSuspicious = $true
                        }
                    }
                }
            }

            if (-not $foundSuspicious) {
                $message = "No suspicious permissions found in $dir."
                Add-Content -Path $ReportFile -Value $message
            }
        }
        else {
            $message = "Skipping non-critical directory: $dir"
            Add-Content -Path $ReportFile -Value $message
        }
    }
    catch {
        # Verbose error handling
        $message = "Error occurred in directory: $dir"
        $errorMessage = $_.Exception.Message
        $errorLine = $_.InvocationInfo.ScriptLineNumber
        $errorDetails = "Error Message: $errorMessage`nLine Number: $errorLine"
        
        Add-Content -Path $ReportFile -Value "$message`n$errorDetails"
    }
}

# Define directory and patterns for scanning
$directories = @(
    "C:\Windows", # System files
    "C:\Windows\System32"     # Core system files
)
$filePatterns = @(
    "id_rsa", "config.php", "credentials"
)
$backupPatterns = @("*.bak", "*.backup", "*.swp", "*.old"
)

# Start the audit
Add-Content -Path $ReportFile -Value "## Sensitive files"
foreach ($dir in $directories) {
    Scan-ForSensitiveFiles -dir $dir -patterns $filePatterns
}
Add-Content -Path $ReportFile -Value "***"

Add-Content -Path $ReportFile -Value "## Backup files"
foreach ($dir in $directories) {
    Check-ForBackupFiles -dir $dir -patterns $backupPatterns
}
Add-Content -Path $ReportFile -Value "***"

Add-Content -Path $ReportFile -Value "## Suspicious permissions files"
foreach ($dir in $directories) {
    Check-ForSuspiciousPermissions -dir $dir
}
Add-Content -Path $ReportFile -Value "***"