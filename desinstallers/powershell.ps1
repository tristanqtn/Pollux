Write-Host "== Pollux Installer for Windows =="
Write-Host "This script will install the dependencies required to run Pollux."
$pwd = Get-Location
Write-Host "Currently running from the directory: $pwd"

Write-Host "=================================="
Write-Host ""

Write-Host "=================================="
Write-Host "Removing Pollux files..."
Remove-Item -Recurse -Force "C:\Temp\pollux"
Write-Host ""
Write-Host "To delete this repository, run the following command:"
Write-Host "Remove-Item -Recurse -Force $pwd"
Write-Host "=================================="

Write-Host "Pollux has been uninstalled."
Write-Host "Thank you for using Pollux!"