import os
import logging

from pollux.config import PolluxConfig
from pollux.wrapper.utils.utils import check_path_exists

# Define the path to the scripts for Windows
WIN_SCRIPT_PATH = {
    "antivirusCheck": "\\pollux\\scripts\\antivirusCheck\\antivirusCheck",
    "updateCheck": "\\pollux\\scripts\\updateCheck\\updateCheck",
    "envvarCheck": "\\pollux\\scripts\\envvarCheck\\envvarCheck",
    "sessionCheck": "\\pollux\\scripts\\sessionCheck\\sessionCheck",
    "plannedtaskCheck": "\\pollux\\scripts\\plannedtaskCheck\\plannedtaskCheck",
    "filesystemCheck": "\\pollux\\scripts\\filesystemCheck\\filesystemCheck",
    "passwordCheck": "\\pollux\\scripts\\passwordCheck\\passwordCheck",
    "portCheck": "\\pollux\\scripts\\portCheck\\portCheck",
    "firewallCheck": "\\pollux\\scripts\\firewallCheck\\firewallCheck",
    "serviceCheck": "\\pollux\\scripts\\serviceCheck\\serviceCheck",
}

# Configure logging
logging.basicConfig(
    format="[%(asctime)s] [%(levelname)s] | %(message)s",
    level=logging.DEBUG,  # You can change this to INFO, WARNING, ERROR, etc.
)


def execute_antivirus_check_win(script_name="antivirusCheck"):
    """
    Execute the antivirus check script for Windows.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: antivirusCheck
    :type script_name: str
    :return: None
    """
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    os.system(f"powershell.exe {full_path} {Logfile}")


def execute_updates_check_win(script_name="updateCheck"):
    """
    Execute the updates check script for Windows.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: updateCheck
    :type script_name: str
    :return: None
    """
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    os.system(f"powershell.exe {full_path} {Logfile}")


def execute_envvar_check_win(script_name="envvarCheck"):
    """
    Execute the environment variables check script for Windows.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: envvarCheck
    :type script_name: str
    :return: None
    """
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    os.system(f"powershell.exe {full_path} {Logfile}")


def execute_session_check_win(script_name="sessionCheck"):
    """
    Execute the session privileges check script for Windows.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: sessionCheck
    :type script_name: str
    :return: None
    """

    # Check if the script is running as root
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    os.system(f"powershell.exe {full_path} {Logfile}")


def execute_planned_task_check_win(script_name="plannedtaskCheck"):
    """
    Execute the planned task check script for Windows.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: plannedtaskCheck
    :type script_name: str
    :return: None
    """

    # Check if the script is running as root
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    os.system(f"powershell.exe {full_path} {Logfile}")


def execute_file_system_check_win(script_name="filesystemCheck"):
    """
    Execute the file system check script for Windows.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: filesystemCheck
    :type script_name: str
    :return: None
    """

    # Check if the script is running as root
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    os.system(f"powershell.exe {full_path} {Logfile}")


def execute_password_check_win(script_name="passwordCheck"):
    """
    Execute the password policy check script for Windows.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: passwordCheck
    :type script_name: str
    :return: None
    """

    # Check if the script is running as root
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    os.system(f"powershell.exe {full_path} {Logfile}")


def execute_port_check_win(script_name="portCheck"):
    """
    Execute the port scanning check script for Windows.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: portCheck
    :type script_name: str
    :return: None
    """

    # Check if the script is running as root
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    os.system(f"powershell.exe {full_path} {Logfile}")


def execute_firewall_check_win(script_name="firewallCheck"):
    """
    Execute the firewall check script for Windows.

    :param script_name: name of the script to execute
    :default script_name: firewallCheck
    :type script_name: str
    :return: None
    """

    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    port_table = ",".join(map(str, PolluxConfig.WIN_PORT_TABLE))
    trusted_subnets = ",".join(
        f'"{subnet}"' for subnet in PolluxConfig.WIN_TRUSTED_SUBNETS
    )
    command = (
        f'powershell.exe -File "{full_path}" -LogFile "{Logfile}" '
        f"-PortTable {port_table} "
        f"-TrustedSubnets {trusted_subnets}"
    )
    if PolluxConfig.RUNNING_AS_ADMIN == 1:
        command += f" -RunLevel {PolluxConfig.WIN_FIREWALL_AUDIT_LEVEL}"
    os.system(command)


def execute_service_check_win(script_name="serviceCheck"):
    """
    Execute the service check script for Windows.
    This script requires root privileges to run.

    :param script_name: name of the script to execute
    :default script_name: serviceCheck
    :type script_name: str
    :return: None
    """

    # Check if the script is running as root
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        logging.error(f"Path to script does not exist : {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    os.system(f"powershell.exe {full_path} -outputFile {Logfile}")


"""
def template(script_name="scriptName"):
    
    Template for a new script executor.
    
    :param script_name: name of the script to execute
    :default script_name: scriptName
    :type script_name: str
    :return: None
    
    
    # Check if the script is running as root
    if PolluxConfig.RUNNING_AS_ADMIN == 0:
        logging.error("Please run the script as an administrator.")
        return
    print(f"Executing script: {script_name}")
    full_path = f"{os.getcwd()}{WIN_SCRIPT_PATH.get(script_name)}{PolluxConfig.SCRIPT_EXTENSION}"
    # Check if the path to the script exists
    if check_path_exists(full_path):
        logging.info(f"Path to script exists : {full_path}")
    else:
        print(f"Path to script does not exist: {full_path}")
        return
    if full_path is None:
        logging.error(f"Script {script_name} not found.")
        return
    # Define the logfile
    Logfile = PolluxConfig.TEMPORARY_FILE_LOCATION + script_name + ".tmp"
    PolluxConfig.TEMPORARY_FILE_LIST.append(Logfile)
    # Execute the script
    os.system(f"powershell.exe {full_path} {Logfile}")
"""
