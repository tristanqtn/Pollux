# Pollux Scripts

This directory contains scripts that to be executed on the audited device. Those scripts are written in Powershell, Bash or Python. They can be independent or depend on each other. The results of the scripts are stored in a temporary file. The Python wrapper then reads the results and generates a report in markdown format.

## Scripts List & Description

|  Script Name   |                                                      Description                                                      |                    Link                    |
| :------------: | :-------------------------------------------------------------------------------------------------------------------: | :----------------------------------------: |
| antivirusCheck | This script checks if an antivirus is installed on the device, if an update is available and if AV scans are running. | [antivirusCheck](antivirusCheck/README.md) |
| sessionsCheck  |  This script checks the active user sessions on the device and searches for sessions with administrative privileges.  |  [sessionsCheck](sessionsCheck/README.md)  |
|  envvarCheck   |          This script checks the environment variables on the device and searches for sensitive information.           |    [envvarCheck](envvarCheck/README.md)    |
|  updateCheck   |                 This script checks if the device is up to date and if there are any pending updates.                  |    [updateCheck](updateCheck/README.md)    |
