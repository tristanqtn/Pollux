import os

from pollux.config import PolluxConfig
from pollux.wrapper.utils import check_path_exists, dos2unix

# Define the path to the scripts for Windows
WIN_SCRIPT_PATH = {
    "antivirusCheck": "\\pollux\\scripts\\antivirusCheck\\antivirusCheck",
}

# Define the path to the scripts for Linux
LIN_SCRIPT_PATH = {
    "antivirusCheck": "/pollux/scripts/antivirusCheck/antivirusCheck",
}


def execute_script_win(script):
    print(f"Executing script: {script}")
    full_path = (
        f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script)}{PolluxConfig.SCRIPT_EXTENSION}"
    )
    if check_path_exists(full_path):
        print(f"Path to script exists: {full_path}")
    else:
        print(f"Path to script does not exist: {full_path}")
        return
    if full_path is None:
        print(f"Script {script} not found.")
        return

    os.system(f"powershell.exe {full_path}")


def execute_script_lin(script):
    print(f"Executing script: {script}")
    full_path = (
        f"{os.getcwd()}{LIN_SCRIPT_PATH.get(script)}{PolluxConfig.SCRIPT_EXTENSION}"
    )
    if check_path_exists(full_path):
        print(f"Path to script exists: {full_path}")
        dos2unix(full_path)
    else:
        print(f"Path to script does not exist: {full_path}")
        return
    if full_path is None:
        print(f"Script {script} not found.")
        return

    os.system(f"bash {full_path}")
