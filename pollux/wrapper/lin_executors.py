import os

from pollux.config import PolluxConfig
from pollux.wrapper.utils import check_path_exists, dos2unix

# Define the path to the scripts for Linux
LIN_SCRIPT_PATH = {
    "antivirusCheck": "/pollux/scripts/antivirusCheck/antivirusCheck",
    "updateCheck": "/pollux/scripts/updateCheck/updateCheck",
    "envvarCheck": "/pollux/scripts/envvarCheck/envvarCheck",
}


def execute_antivirus_check_lin(script_name="antivirusCheck"):
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        print("Please run the script as an administrator.")
        return
    print(f"Executing script: {script_name}")
    full_path = f"{os.getcwd()}{LIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    if check_path_exists(full_path):
        print(f"Path to script exists: {full_path}")
        dos2unix(full_path)
    else:
        print(f"Path to script does not exist: {full_path}")
        return
    if full_path is None:
        print(f"Script {script_name} not found.")
        return
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    os.system(f"bash {full_path} {Logfile}")


def execute_update_check_lin(script_name="updateCheck"):
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        print("Please run the script as an administrator.")
        return
    print(f"Executing script: {script_name}")
    full_path = f"{os.getcwd()}{LIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    if check_path_exists(full_path):
        print(f"Path to script exists: {full_path}")
        dos2unix(full_path)
    else:
        print(f"Path to script does not exist: {full_path}")
        return
    if full_path is None:
        print(f"Script {script_name} not found.")
        return
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    os.system(f"bash {full_path} {Logfile}")


def execute_envvar_check_lin(script_name="envvarCheck"):
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        print("Please run the script as an administrator.")
        return
    print(f"Executing script: {script_name}")
    full_path = f"{os.getcwd()}{LIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    if check_path_exists(full_path):
        print(f"Path to script exists: {full_path}")
        dos2unix(full_path)
    else:
        print(f"Path to script does not exist: {full_path}")
        return
    if full_path is None:
        print(f"Script {script_name} not found.")
        return
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    os.system(f"bash {full_path} {Logfile}")
