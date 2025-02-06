# Pollux Desinstallers

This directory contains everything to uninstall Pollux from your machine.

## Uninstallation Scripts

Find in the following sections the content of the uninstallation scripts. Those scripts will remove files related to Pollux but will not remove Python or Poetry from your machine. The script will also show you how to remove the Pollux repo from your machine.

### Manual Uninstallation of Python and Poetry

If you want to remove Python and Poetry from your machine, you can follow the following steps :

1. Remove the Pollux repository from your machine.

2. Remove the Python installation directory. Usually, Python is installed in the `C:\Python3x` directory on Windows and in the `/usr/bin/python3x` directory on Linux.

3. Remove the Poetry installation directory. Usually, Poetry is installed in the `~/.poetry` directory on Linux and in the `C:\Users\<username>\AppData\Roaming\poetry` directory on Windows.

### 1. Windows Uninstaller

- **`uninstall.ps1`:** A PowerShell script designed to uninstall Pollux for systems running on Windows.

### 2. Linux Uninstaller

- **`uninstall.sh`:** A Bash script designed to uninstall Pollux for systems running on Linux.
