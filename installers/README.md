# Pollux Installers

This directory contains everything to install Pollux on your machine. As explained before multiple dependencies are required to run Pollux. Since this tool is designed to require the least amount of dependencies, we provide you with some installation scripts to install the required dependencies.

## Minimal Requirements

The following dependencies are required to run Pollux installers :

- Python 3.12
- Git : git is only meant to clone the repository to the machine, it is not required to run the tool.

## Installation Scripts

Find in the following sections the content of the installation scripts.

Each installer will check if python is installed on the machine. If not, the installer will install python. Then using python, the installer will install poetry if it's not present. Finally, the installer will install the required pytho dependencies for the project using poetry.
