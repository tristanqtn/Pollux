param (
    [string]$OutputScript
)

if (-not $OutputScript) {
    Write-Host "Usage: .\sessionCheck.ps1 <output_file>"
    exit 1
}

# Check if the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run as Administrator"
    exit 1
}

# Function to get all local users
function Get-LocalUsers {
    Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount=True" |
    Where-Object { $_.Disabled -eq $false -and $_.Lockout -eq $false }
}

# Function to check if a user is an administrator
function Is-Administrator {
    param (
        [string]$UserName
    )
    
    $adminGroup = [ADSI]("WinNT://./Administrators,group")
    $isAdmin = $false
    
    foreach ($member in $adminGroup.Invoke("Members")) {
        if ($member.GetType().InvokeMember("Name", 'GetProperty', $null, $member, $null) -eq $UserName) {
            $isAdmin = $true
            break
        }
    }
    return $isAdmin
}

# Main logic
$admins = @()
$users = @()

# Get all local users
$localUsers = Get-LocalUsers

foreach ($user in $localUsers) {
    $userName = $user.Name

    if (Is-Administrator -UserName $userName) {
        $admins += $userName
    }
    else {
        $users += $userName
    }
}




function Get-Sessions {
    $output = @()

    # List user sessions
    $output += "## Administrators sessions:"
    $output += ($admins | ForEach-Object { Write-Output "- $_" })
    $output += "***"

    # List user privileges and commands they can run as Administrator
    $output += "`n## Standard User Sessions:"
    $output += ($users | ForEach-Object { Write-Output "- $_" })
    $output += "***"

    $output | Out-File -FilePath $OutputScript -Encoding utf8
}

# Main Execution
Get-Sessions