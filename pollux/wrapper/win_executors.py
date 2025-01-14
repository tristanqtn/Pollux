import os

from pollux.config import PolluxConfig
from pollux.wrapper.utils import check_path_exists

# Define the path to the scripts for Windows
WIN_SCRIPT_PATH = {
    "antivirusCheck": "\\pollux\\scripts\\antivirusCheck\\antivirusCheck",
}


def execute_antivirus_check_win(script_name="antivirusCheck"):
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        print("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    if check_path_exists(full_path):
        print(f"Path to script exists: {full_path}")
    else:
        print(f"Path to script does not exist: {full_path}")
        return
    if full_path is None:
        print(f"Script {script_name} not found.")
        return
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    os.system(f"powershell.exe {full_path} {Logfile}")
