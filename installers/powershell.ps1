# Check for Python3
$python = Get-Command python3 -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Output "Python3 is not installed. Installing Python3..."
    # Add your Python3 installation logic here
    # Example for Windows:
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe" -OutFile "python-installer.exe"
    Start-Process -FilePath "python-installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    Remove-Item -Path "python-installer.exe"
} else {
    Write-Output "Python3 is already installed."
}

# Check for Poetry
$poetry = Get-Command poetry -ErrorAction SilentlyContinue
if (-not $poetry) {
    Write-Output "Poetry is not installed. Installing Poetry..."
    # Add your Poetry installation logic here
    # Example for Windows:
    Invoke-WebRequest -Uri "https://install.python-poetry.org" -OutFile "install-poetry.py"
    python3 install-poetry.py
    Remove-Item -Path "install-poetry.py"
} else {
    Write-Output "Poetry is already installed."
}