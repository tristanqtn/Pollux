# Pollux Tool

Pollux is made of a Python wrapper that orchestrate the scripts execution. This document describes the Python wrapper and how to use it.

## Technical Stack

### Presentation

Pollux is made of a Python wrapper that orchestrate the scripts execution. The scripts are written inPython, Powershell and Bash. The results of each script are stored in a temporary file. The Python wrapper then reads the results and generates a report in markdown format.

### Technologies

- Python 3.10
- Poetry
- Bash, Powershell scripts

> [!NOTE]
> **Note :** We chose to use Python as the main language for the wrapper because it is a versatile language that can be used on multiple operating systems. The scripts are written in Bash and Powershell to maximize compatibility with the audited devices.

> [!NOTE]
> **Note :** We chose to use Poetry as the dependency manager because it is a simple and efficient tool to manage Python dependencies. Moreover, it allows us to create a virtual environment for the project, which is essential to avoid conflicts with other Python projects. It's also way better than the default Python package manager, pip.

> [!NOTE]
> **Note :** We chose Python in it's version 3.10 to maximaze compatibility with the hosting system since default version of Python is still 3.10 in most Linux distributions.

### Content

The Python wrapper is located in the `pollux` directory. It is composed of the following files:

- `main.py`: the main file that orchestrates the overall Pollux execution.
- `config.py`: the configuration file that needs to be filled by the user who wants to deploy Pollux for auditing its infrastructure.
- `/scripts`: the directory that contains the scripts to be executed on the audited devices.
- `/wrapper`: the directory that contains the Python wrapper.

### Configuration

The `config.py` file is the configuration file that needs to be filled by the user who wants to deploy Pollux for auditing its infrastructure.

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

> [!WARNING]  
> **Important :** Some scripts will require the definition of some configuration constants. Those constants must be defined in the configuration object. It will be explicity mentioned in the script documentation and in the constant documentation.

## Installation

### Note on Poetry

Poetry is a Python dependency management tool that allows you to declare the dependencies of your project in a simple file and then install them in an isolated environment. It is recommended to use Poetry to install Pollux.

### Installation Steps

To install Pollux for development, follow these steps:

1. Clone the Pollux repository:

```bash
git clone https://github.com/tristanqtn/Pollux.git
```

2. Install the Python dependencies:

```bash
cd pollux
poetry install
poetry shell
poetry run python -m pollux.main
```

3. Fill the `config.py` file with the required configuration.

4. Run the Python wrapper:

```bash
poetry shell
poetry run python -m pollux.main
```
