# Pollux Installers

This directory contains everything to install Pollux on your machine. As explained before multiple dependencies are required to run Pollux. Since this tool is designed to require the least amount of dependencies, we provide you with some installation scripts to install the required dependencies.

## Minimal Requirements

The following dependencies are required to run Pollux installers :

- Python 3.12
- Git : Git is only meant to clone the repository to the machine, it is not required to run the tool.

## Installation Scripts

Find in the following sections the content of the installation scripts.

Each installer will check if python is installed on the machine. If not, the installer will install python. Then using python, the installer will install poetry if it's not present. Finally, the installer will install the required pytho dependencies for the project using poetry.

### 1. Windows Installer

- **`install.ps1`:** A PowerShell script designed to install Pollux for systems running on Windows.

### 2. Linux Installer

- **`install.sh`:** A Bash script designed to install Pollux for systems running on Linux.

### Known Issues

- The installers are designed to work on Windows and Linux. They may not work on MacOS.
- The installer could fail to resolve the poetry binary after installation due to the PATH environment variable. In this case, you can add the poetry binary to the PATH manually. Usually, the poetry binary is located in the `~/.poetry/bin` directory. You can use this ressource to add the poetry binary to the PATH : https://github.com/python-poetry/install.python-poetry.org

## Features

1. Checks if Python is installed on the machine.
2. Installs Python if it's not present.
3. Installs Poetry using Python.
4. Installs the required Python dependencies for the project using Poetry.
