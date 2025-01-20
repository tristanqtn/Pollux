import os

from pollux.config import PolluxConfig
from pollux.wrapper.utils.utils import check_path_exists, dos2unix

# Define the path to the scripts for Linux
LIN_SCRIPT_PATH = {
    "antivirusCheck": "/pollux/scripts/antivirusCheck/antivirusCheck",
    "updateCheck": "/pollux/scripts/updateCheck/updateCheck",
    "envvarCheck": "/pollux/scripts/envvarCheck/envvarCheck",
    "sessionCheck": "/pollux/scripts/sessionCheck/sessionCheck",
}


def execute_antivirus_check_lin(script_name="antivirusCheck"):
    """
    Execute the antivirus check script for Linux.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: antivirusCheck
    :type script_name: str
    :return: None
    """
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        print("Please run the script as an administrator.")
        return
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
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    os.system(f"bash {full_path} {Logfile}")


def execute_update_check_lin(script_name="updateCheck"):
    """
    Execute the updates check script for Linux.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: updateCheck
    :type script_name: str
    :return: None
    """
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        print("Please run the script as an administrator.")
        return
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
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    os.system(f"bash {full_path} {Logfile}")


def execute_envvar_check_lin(script_name="envvarCheck"):
    """
    Execute the environment variables check script for Linux.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: envvarCheck
    :type script_name: str
    :return: None
    """
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        print("Please run the script as an administrator.")
        return
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
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    os.system(f"bash {full_path} {Logfile}")



def execute_session_check_lin(script_name="sessionCheck"):
    """
    Execute the session privileges check script for Linux.
    This script requires root privileges to run.
    
    :param script_name: name of the script to execute
    :default script_name: sessionCheck
    :type script_name: str
    :return: None
    """
    
    # Check if the script is running as root
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        print("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{LIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        print(f"Path to script exists: {full_path}")
        dos2unix(full_path)
    else:
        print(f"Path to script does not exist: {full_path}")
        return
    if full_path is None:
        print(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    os.system(f"bash {full_path} {Logfile}")


"""
def template(script_name="scriptName"):
    
    Template for a new script executor.
    
    :param script_name: name of the script to execute
    :default script_name: scriptName
    :type script_name: str
    :return: None
    
    
    # Check if the script is running as root
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        print("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{LIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        print(f"Path to script exists: {full_path}")
        dos2unix(full_path)
    else:
        print(f"Path to script does not exist: {full_path}")
        return
    if full_path is None:
        print(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    os.system(f"bash {full_path} {Logfile}")
"""
