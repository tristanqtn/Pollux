# Pollux - 1.7.2

```plaintext
__/\\\\\\\\\\\\\__________________/\\\\\\_____/\\\\\\________________________________
 _\/\\\/////////\\\_______________\////\\\____\////\\\________________________________
  _\/\\\_______\/\\\__________________\/\\\_______\/\\\________________________________
   _\/\\\\\\\\\\\\\/______/\\\\\_______\/\\\_______\/\\\_____/\\\____/\\\__/\\\____/\\\_
    _\/\\\/////////______/\\\///\\\_____\/\\\_______\/\\\____\/\\\___\/\\\_\///\\\/\\\/__
     _\/\\\______________/\\\__\//\\\____\/\\\_______\/\\\____\/\\\___\/\\\___\///\\\/____
      _\/\\\_____________\//\\\__/\\\_____\/\\\_______\/\\\____\/\\\___\/\\\____/\\\/\\\___
       _\/\\\______________\///\\\\\/____/\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\\___/\\\/\///\\\_
        _\///_________________\/////_____\/////////__\/////////___\/////////___\///____\///__
```

## Table of Contents

- [Description](#description)
  - [Context](#context)
  - [Objectives](#objectives)
- [Technical Stack](#technical-stack)
  - [Presentation](#presentation)
  - [Detailed Presentation](#detailed-presentation)
    - [Audit Process with Pollux](#audit-process-with-pollux)
    - [Pollux Configuration](#pollux-configuration)
    - [Pollux Scripts](#pollux-scripts)
    - [Pollux Report](#pollux-report)
  - [Repository Structure](#repository-structure)
  - [Infrastructures](#infrastructures)
- [Installation](#installation)
  - [Minimal Requirements](#minimal-requirements)
  - [Usage Installation](#usage-installation)
  - [Development Installation](#development-installation)
    - [Additional Requirements](#additional-requirements)
    - [Installation](#installation-1)
- [Usage](#usage)
- [Authors](#authors)
  - [Team](#team)
  - [Our Credo](#our-credo)

## Description

Pollux is a cybersecurity tool that allows small and medium-sized businesses to perform security audits on their infrastructure. It is a simple and automated solution that does not require advanced computer or cybersecurity skills. The tool scans the company's servers and identifies potential vulnerabilities, misconfigurations, and security weaknesses. It provides a detailed report of the audit results, including recommendations for improving the security of the infrastructure.

### Context

In 2022, 347,000 cyberattacks were recorded against companies, of which approximately 330,000 targeted SMEs. These small and medium-sized enterprises are often vulnerable due to the lack of specialized cybersecurity resources. A study conducted by ANSSI reveals that 72% of SMEs do not have a formalized cybersecurity strategy. The lack of accessible and easy-to-deploy tools makes it difficult for these companies to continuously assess the security of their servers. It is therefore crucial to develop a solution that allows SMEs to perform security audits in an automated manner and without requiring advanced computer or cybersecurity skills.

### Objectives

The main objective of Pollux is to provide a simple and automated solution for small and medium-sized businesses to perform security audits on their infrastructure. The tool should be easy to deploy and use, and should not require advanced computer or cybersecurity skills. The tool should be able to scan the company's servers and identify potential vulnerabilities, misconfigurations, and security weaknesses. The tool should provide a detailed report of the audit results, including recommendations for improving the security of the infrastructure.

---

## Technical Stack

### Presentation

Pollux is made of a Python wrapper that orchestrate the scripts execution. The scripts are written in Python, Powershell and Bash. The results of each script are stored in a temporary file. The Python wrapper then reads the results and generates a report in markdown format.

### Detailed Presentation

In this part of the documentation we will cover in details each part of the Pollux tool.

#### Audit Process with Pollux

Pollux audits can either be scheduled using CRON or planned tasks, or exectued manually. But the audit process is always the same. The audit process with Pollux is divided into several steps:

1. **Integrity:** The Python wrapper checks the integrity of the configuration object and the scripts and checks the overall environment to check if it can be executed safely.
2. **Configuration:** From the configuration object, the Python wrapper will load the configuration constants and the scripts to run.
3. **Flush Temporary Files:** The Python wrapper will flush the temporary files.
4. **Scripts Execution:** The Python wrapper will execute the scripts in the correct order and pass them the needed configuration constants. Those scripts will generate temporary files containing the results in a special format. This format is meant to be read by the Python wrapper in order to generate the final audit report.
5. **Report Production:** The Python wrapper will read the temporary files generated by the scripts and generate from them the final report in markdown format.

#### Pollux Configuration

The Pollux configuration is stored in a Python class object containing all configuration constants. This object is used by the Python wrapper to configure the tool.
Each element that could vary depending on the execution context must be stored in the configuration object. Some of those configuration are mandatory, some are optional. The mandatory configuration must be explicitly defined and have a default value. The optional configuration can be defined if needed. Each configuration constant must be defined as follows:

```python
class PolluxConfig:
    # The list of legitimate services
    # Type: List[str]
    # Mandatory: No
    # Example: ['mysql', 'postgresql', 'apache2', 'nginx', 'httpd', 'ssh', 'ftp', 'smb', 'rdp', 'vnc', 'telnet']
    LEGITIMATE_SERVICES = []
```

The scripts to run are also stored in the configuration object. The Python wrapper will use this list to execute the scripts in the correct order.

```python
class PolluxConfig:
    # List of scripts to run
    # Type: list[str]
    # Mandatory: Yes
    # Example:     SCRIPT_LIST = ['firewallCheck', 'antivirusCheck', 'filesystemCheck', 'SessionCheck', 'PasswordPolicyCheck', 'PlannedTaskCheck', 'UpdateCheck']
    SCRIPT_LIST = ["antivirusCheck", "updateCheck", "envvarCheck"]
```

> [!IMPORTANT]
> Some scripts will require the definition of some configuration constants. Those constants must be defined in the configuration object. It will be explicity mentioned in the script documentation and in the constant documentation.

#### Pollux Scripts

Those scripts are the core of the Pollux tool. They are meant to scan for a defined perimeter and gather information about the server. The scripts are written in Python, Powershell or Bash. They can be independent or depend on each other. The results of the scripts are stored in a temporary file. Here's a list of the scripts:

- [x] Open ports information
- [x] Firewall & ACL configuration
- [x] Antivirus check
- [x] Filesystem permissions
- [x] Session permissions
- [x] Password policy
- [x] Planned tasks
- [x] Security and package updates
- [x] Environment variables
- [x] Running services

All scripts should produce a consistant output in order to easily produce the final report. The temporary file containing the result of the script should have the name of the script and the extension `.tmp`. For a same script multiple piece of information can be gathered. The output format is the following one:

```plaintext
## Piece of information
data
data
data
...
***
```

An example of a script output is the following one:

```plaintext
## Files with 777 permissions
/etc/passwd
/etc/shadow
...
***

## Files with 755 permissions
/usr/bin/python3
/usr/bin/python3.12
...
***
```

The temporary file are stored by default in the following path depending on your OS:

- Linux: `/tmp/pollux/`
- Windows: `C:\Temp\pollux\`

This value can be modified in the configuration object.

#### Pollux Report

This report is a technical report gathering all the information from the different scans. The report is written in markdown format. The report is divided into several sections, each corresponding to a script. Each section contains the results of the script and a summary of the findings. The report is generated by the Python wrapper from the temporary files generated by the scripts. This report is intended to be read by the user to understand the security status of the server.

### Repository Structure

The Pollux repository is structured as follows:

```plaintext
pollux/
├── installers/         # everything related to the installation of the tool
│   ├── bash.sh
│   └── powershell.ps1
├── pollux/             # the main package of the tool
│   ├── config.py       # the configuration object
│   ├── main.py         # the main script of the tool
│   ├── ...
│   ├── scripts/        # script collection
│   │   ├── antivirusCheck/
│   │   │   ├── antivirusCheck.sh
│   │   │   ├── antivirusCheck.ps1
│   │   ├── passwordCheck/
│   │   │   ├── passwordCheck.sh
│   │   │   ├── passwordCheck.ps1
│   │   └── ...
│   └── wrapper/
│       ├── initialize.py  # file responsible for the initialization of the tool
│       ├── wrapper.py     # file responsible for the orchestration of the scripts
│       ├── executors/
│       │   ├── lin_executors.py  # file responsible for the execution of the scripts on Linux
│       │   └── win_executors.py  # file responsible for the execution of the scripts on Windows
│       ├── utils/
│       │   └── utils.py  # file containing utility functions
│       └── report/
│           └── report.py  # file responsible for the audit generation of the report
├── .gitignore          # the gitignore file
├── pyproject.toml      # the poetry configuration file
├── LICENSE             # the license file
└── README.md           # the main documentation file
```

### Infrastructures

For developing Pollux we needed to create multiple test environments to test the tool in different contexts. We make those environments available at: https://github.com/tristanqtn/Pollux-Infras. Since this content is not needed by the solution to run, we decided to put it in a separate repository, so that someone who wants to use Pollux doesn't have to download all the infrastructures.

## Installation

There are two ways to install Pollux: usage installation and development installation. The usage installation is intended for users who want to use Pollux to perform security audits on their infrastructure. The development installation is intended for developers who want to contribute to the development of Pollux.

### Minimal Requirements

The Pollux tool is ment to be used on Windows and Linux servers. The installation scripts should handle most of the dependencie management for you. But some of theme should be installed before deploying Pollux. The following requirements are needed to run the tool:

> [!IMPORTANT]  
> Ensure that you have the following prerequisites installed on your system before installing Pollux:

- Python 3.10
- Git (for installation only)

### Usage Installation

To install Pollux for usage, follow these steps:

1. Clone the Pollux repository:

```bash
git clone https://github.com/tristanqtn/Pollux.git
```

2. Navigate to the Pollux directory:

```bash
cd pollux
```

3. **For Linux** - Change the permissions of the installation script:

```bash
chmod +x installers/bash.sh
```

4. Run the installation script:

```bash
# (Linux)
./installers/bash.sh

# (Windows)
./installers/powershell.ps1
```

Those scripts will make sure that all dependencies (Python3 & Poetry) are installed and that the Python wrapper is correctly set up. Then it installs the python dependencies.

> [!WARNING]
> Those script are generic and may suffer from unusual environment configuration. If you encounter any issue, please refer to the manual installation of dependencies. The main encoutered issue is the adding Poetry to the PATH because the installation location of the binary may vary.

> [!TIP]
> Pollux has been designed to be executed and managed with Poetry. Note that it's totally possible to use the tool without Poetry and simply with pip. But it's highly recommended to use it to manage the dependencies of the project.

### Development Installation

#### Additional Requirements

To install Pollux for development, you will need to install the following additional requirements:

- Poetry : poetry is a Python dependency management tool that will help you manage the dependencies of the project.

```bash
# (Linux)
curl -sSL https://install.python-poetry.org | python3 -

# (Windows)
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
```

> **Note :** You may have to update your environment variables to make sure that Poetry is correctly resolved.

#### Installation

To install Pollux for development, follow these steps:

1. Clone the Pollux repository:

```bash
git clone https://github.com/tristanqtn/Pollux.git
```

2. Run the development installation script:

```bash
cd pollux
poetry install
poetry shell
```

## Usage

To use Pollux, you need to follow these steps:

1. Configure the Pollux configuration object in the `config.py` file. This file is self-explanatory and contains all the configuration constants needed to run the tool. Please fill in the mandatory configuration constants and the optional ones if needed. If the file is configured wrongly, the Python wrapper will raise an error and stop the execution.

2. Enable the python execution environment:

```bash
poetry shell
```

3. Run the main script:

```bash
poetry run python -m pollux.main
```

4. The script will generate a report in markdown format in the directory specified in the config object. This report will contain the results of the security audit.

> [!TIP]
> Add-ons: You can schedule the execution of the script using CRON or planned tasks. You can also modify the configuration object to add new scripts or modify the existing ones.

## Authors

### Team

|        Name         |    GitHub     |             Mail             |
| :-----------------: | :-----------: | :--------------------------: |
|   Tristan Querton   |  tristanqtn   |  tristan.querton@edu.ece.fr  |
| Xavier de la Chaise |    Hioav2     | xavier.delachaise@edu.ece.fr |
|  Lucie Lagarrigue   |    Luxlag     | lucie.lagarrigue@edu.ece.fr  |
|   Antoine Herman    | AntoineHerman |  antoine.herman@edu.ece.fr   |
|     Evan Debray     |    EvanDbr    |    evan.debray@edu.ece.fr    |
|  Théophile Broqua   |  TheoLeDozo   | theophile.broqua@edu.ece.fr  |

### Our Credo

In addition to helping small businesses by offering them a security solution, we also want to make a contribution to the open-source community. We're all very attached to the values of sharing, exchange and community learning that this community embodies. Most of us learned to code on our own, in our bedrooms, on open-source dev forums. Now it's time for us to give back to the community that has given us so much by making the Pollux project 100% transparent, reusable and documented. This is our little contribution to the community dev edifice.
