# Pollux Scripts

This directory contains scripts that to be executed on the audited device. Those scripts are written in Powershell, Bash or Python. They can be independent or depend on each other. The results of the scripts are stored in a temporary file. The Python wrapper then reads the results and generates a report in markdown format.

## Scripts List & Description

|   Script Name    |                                                        Description                                                         |                      Link                      |
| :--------------: | :------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------: |
|  antivirusCheck  |   This script checks if an antivirus is installed on the device, if an update is available and if AV scans are running.    |   [antivirusCheck](antivirusCheck/README.md)   |
|  sessionsCheck   |    This script checks the active user sessions on the device and searches for sessions with administrative privileges.     |    [sessionsCheck](sessionsCheck/README.md)    |
|   envvarCheck    |             This script checks the environment variables on the device and searches for sensitive information.             |      [envvarCheck](envvarCheck/README.md)      |
|   updateCheck    |                    This script checks if the device is up to date and if there are any pending updates.                    |      [updateCheck](updateCheck/README.md)      |
| filesystemCheck  | This script checks the filesystem of the device and searches for files with sensitive information or unusual permissions.  |  [filesystemCheck](filesystemCheck/README.md)  |
|  passwordCheck   |                   This script checks the password policy of the device and searches for weak passwords.                    |    [passwordCheck](passwordCheck/README.md)    |
| plannedTaskCheck |    This script checks the planned tasks on the device and searches for tasks that could be used for malicious purposes.    | [plannedTaskCheck](plannedTaskCheck/README.md) |
|  firewallCheck   |   This script checks the firewall rules on the device and searches for rules that could be used for malicious purposes.    |    [firewallCheck](firewallCheck/README.md)    |
|    portCheck     |     This script checks the open ports on the device and searches for ports that could be used for malicious purposes.      |        [portCheck](portCheck/README.md)        |
|   serviceCheck   | This script checks the running services on the device and searches for services that could be used for malicious purposes. |     [serviceCheck](serviceCheck/README.md)     |

## Adding scripts

To add a new script, create a new directory in the `scripts` directory. The directory name must be the name of the script. The directory must contain the script file and a `README.md` file that describes the script and its features.

The script must be executable and must write its results in a temporary file. The Python wrapper will read the results from this file and generate the report. We strongly recommand to use Powershell or Bash to maximize the compatibility with the audited devices and to avoid the installation of additional dependencies.

Scripts are designed to receive the configuration object as an argument. The configuration object contains the configuration constants that are needed for the script execution. The configuration object is defined in the `config.py` file.

## Running scripts

If you need to run the script outside the Python wrapper you can use the following command:

```bash
# For Linux
./<script_name>.sh <output_file> <config_elements (optional)>
```

```powershell
# For Windows
.\<script_name>.ps1 <output_file> <config_elements (optional)>
```
