# Print a message to the console to indicate that the script is installing dependencies
Write-Output "== Pollux Installer for Windows =="
Write-Output "This script will install the dependencies required to run Pollux."
$pwd = Get-Location
Write-Output "Currently running from the directory: $pwd"

Write-Output "==================================`n"

Write-Output "=================================="
Write-Output "Installing dependencies..."
# Check for Python3
$python = Get-Command python3 -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Output "Python3 is not installed. Installing Python3..."
    # Add your Python3 installation logic here
    # Example for Windows:
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe" -OutFile "python-installer.exe"
    Start-Process -FilePath "python-installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    Remove-Item -Path "python-installer.exe"
}
else {
    Write-Output "Python3 is already installed."
}

# Check for Poetry
$poetry = Get-Command poetry -ErrorAction SilentlyContinue
if (-not $poetry) {
    Write-Output "Poetry is not installed or not available in PATH. Installing Poetry..."
    # Add your Poetry installation logic here
    # Example for Windows:
    Invoke-WebRequest -Uri "https://install.python-poetry.org" -OutFile "install-poetry.py"
    python3 install-poetry.py
    Remove-Item -Path "install-poetry.py"
    $env:Path += ";$env:APPDATA\Python\Scripts"
}
else {
    Write-Output "Poetry is already installed."
}

Write-Output "==================================`n"

Write-Output "=================================="
Write-Output "Installing Pollux Python virtual env and dependencies..."
poetry install
Write-Output "==================================`n"

Write-Output "=================================="
Write-Output "Pollux dependencies installed successfully."
Write-Output "`nTo run Pollux, activate the virtual environment by running the following command:"
Write-Output "`tpoetry shell"
Write-Output "`nThen run Pollux by executing the following command:"
Write-Output "`tpoetry run python -m pollux.main"
Write-Output "`nDon't forget that Pollux requires the configuration file to run."
Write-Output "==================================`n"