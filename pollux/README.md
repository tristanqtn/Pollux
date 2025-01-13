# Pollux Tool

Pollux is made of a Python wrapper that orchestrate the scripts execution. This document describes the Python wrapper and how to use it.

## Technical Stack

### Presentation

Pollux is made of a Python wrapper that orchestrate the scripts execution. The scripts are written inPython, Powershell and Bash. The results of each script are stored in a temporary file. The Python wrapper then reads the results and generates a report in markdown format.

### Technologies

- Python 3.12
- Poetry
- Bash, Powershell scripts

### Content

The Python wrapper is located in the `pollux` directory. It is composed of the following files:

- `main.py`: the main file that orchestrates the overall Pollux execution.
- `config.py`: the configuration file that needs to be filled by the user who wants to deploy Pollux for auditing its infrastructure.
- `/scripts`: the directory that contains the scripts to be executed on the audited devices.
- `/wrapper`: the directory that contains the Python wrapper.

## Installation

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
