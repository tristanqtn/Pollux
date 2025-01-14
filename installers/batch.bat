@echo off

echo == Pollux Installer for Windows ==
echo This script will install the dependencies required to run Pollux.

echo Currently running from the directory: %~dp0
echo ==================================

echo ==================================
echo Installing dependencies...

REM Check for Python3
where python3 >nul 2>&1
if %errorlevel% neq 0 (
    echo Python3 is not installed. Installing Python3...
    REM Add your Python3 installation logic here
    REM Example for Windows:
    powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe' -OutFile 'python-installer.exe'"
    start /wait python-installer.exe /quiet InstallAllUsers=1 PrependPath=1
    del python-installer.exe
) else (
    echo Python3 is already installed.
)

REM Check for Poetry
where poetry >nul 2>&1
if %errorlevel% neq 0 (
    echo Poetry is not installed. Installing Poetry...
    REM Add your Poetry installation logic here
    REM Example for Windows:
    powershell -Command "Invoke-WebRequest -Uri 'https://install.python-poetry.org' -OutFile 'install-poetry.py'"
    python3 install-poetry.py
    del install-poetry.py
) else (
    echo Poetry is already installed.
)

echo ==================================

echo ==================================
echo Installing Pollux Python virtual env and dependencies...
poetry install
echo ==================================

echo ==================================
echo Pollux dependencies installed successfully.
echo.
echo To run Pollux, activate the virtual environment by running the following command:
echo     poetry shell
echo.
echo Then run Pollux by executing the following command:
echo     poetry run python -m pollux.main
echo.
echo Don't forget that Pollux requires the configuration file to run.
echo ==================================