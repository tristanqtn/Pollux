# Pollux Script Executors

## Overview

The `lin_executors.py` and `win_executors.py` files are responsible for executing security audit scripts on **Linux** and **Windows** systems, respectively. These scripts help small IT businesses audit their infrastructure configurations using **Pollux**, an open-source security auditing tool.

The execution of the scripts is triggered when the corresponding function is called by the **main program**. The scripts cover different security aspects, including **antivirus status, firewall settings, system services, environment variables, password policies**, and more.

---

## Files & Purpose

### 1. lin_executors.py (Linux Executor)

This file contains functions to execute **Bash** scripts that audit various security aspects of a Linux system. The scripts are executed using the **Bash shell**, and results are stored in temporary log files.

- **Main Features:**

  - Executes predefined security audit scripts located in `/pollux/scripts/`.
  - Ensures that scripts are executed with **administrator privileges**.
  - Converts script files to UNIX format (`dos2unix`) before execution.
  - Logs execution details, errors, and paths.
  - Uses `os.system()` to run Bash scripts.

- **Example Checks Available:**
  - Antivirus Configuration (`antivirusCheck`)
  - System Updates (`updateCheck`)
  - Environment Variables (`envvarCheck`)
  - User Sessions (`sessionCheck`)
  - Scheduled Tasks (`plannedtaskCheck`)
  - File System Integrity (`filesystemCheck`)
  - Password Policies (`passwordCheck`)
  - Open Ports (`portCheck`)
  - Firewall Rules (`firewallCheck`)
  - Running Services (`serviceCheck`)

### 2. win_executors.py (Windows Executor)

This file executes **PowerShell** scripts for auditing security aspects of a **Windows** system. The execution method is similar to `lin_executors.py`, but scripts are executed via **PowerShell** instead of Bash.

- **Main Features:**

  - Executes PowerShell scripts stored in `\pollux\scripts\`.
  - Ensures the script is run with **administrator privileges**.
  - Logs execution paths, errors, and results.
  - Uses `os.system()` to execute PowerShell commands.

- **Example Checks Available:**
  - Antivirus Configuration (`antivirusCheck`)
  - System Updates (`updateCheck`)
  - Environment Variables (`envvarCheck`)
  - User Sessions (`sessionCheck`)
  - Scheduled Tasks (`plannedtaskCheck`)
  - File System Integrity (`filesystemCheck`)
  - Password Policies (`passwordCheck`)
  - Open Ports (`portCheck`)
  - Firewall Rules (`firewallCheck`)
  - Running Services (`serviceCheck`)

---

## Usage

### Prerequisites

- **Linux:** Ensure the required audit scripts are present in `/pollux/scripts/` and that the user has administrator/root privileges.
- **Windows:** Ensure the audit scripts are in `\pollux\scripts\` and the user has administrator privileges.

### Executing a Script

Each function follows a similar pattern for execution. Below is an example of calling an audit function from **Python**:

#### Linux (Bash Execution)

```python
from lin_executors import execute_firewall_check_lin

# Execute the firewall check script
execute_firewall_check_lin()
```

#### Windows (PowerShell Execution)

```python
from win_executors import execute_firewall_check_win

# Execute the firewall check script
execute_firewall_check_win()
```

---

## Logging & Debugging

Both executors use **logging** to track execution status, errors, and debugging information. Logs include:

- Path existence checks
- Administrator privilege verification
- Execution errors and script failures

If a script is missing or execution fails, logs will indicate the issue.

---

## Extending the Executors

To add a new script for execution:

1. Place the script in the appropriate folder (`/pollux/scripts/` for Linux, `\pollux\scripts\` for Windows).
2. Add an entry in `LIN_SCRIPT_PATH` (Linux) or `WIN_SCRIPT_PATH` (Windows).
3. Create a new function following the existing format.
4. Ensure **administrator permissions** are required for execution.

Example **template** for adding a new script execution function:

#### Linux Template

```python
def execute_new_script_lin(script_name="newScript"):
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{LIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    if check_path_exists(full_path):
        logging.info(f"Path to script exists: {full_path}")
        dos2unix(full_path)
    else:
        logging.error(f"Path to script does not exist: {full_path}")
        return
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    os.system(f"bash {full_path} {Logfile}")
```

#### Windows Template

```python
def execute_new_script_win(script_name="newScript"):
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    if check_path_exists(full_path):
        logging.info(f"Path to script exists: {full_path}")
    else:
        logging.error(f"Path to script does not exist: {full_path}")
        return
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    os.system(f"powershell.exe {full_path} {Logfile}")
```

---
