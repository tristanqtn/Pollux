import os

from pollux.config import PolluxConfig
from pollux.wrapper.utils import check_path_exists
from pollux.wrapper.win_executors import execute_antivirus_check_win
from pollux.wrapper.lin_executors import execute_antivirus_check_lin


def verify_output_path():
    if not check_path_exists(PolluxConfig.TEMPORARY_FILE_LOCATION):
        print("Temporary file location does not exist.")
        print(
            f"Creating temporary file location: {PolluxConfig.TEMPORARY_FILE_LOCATION}\n"
        )
        os.makedirs(PolluxConfig.TEMPORARY_FILE_LOCATION)


def execute_script_list_win(script_list):
    print(f"Executing all scripts in list: {script_list}")
    if "antivirusCheck" in script_list:
        execute_antivirus_check_win()
    else:
        print(f"Script {script_list} not available.")


def execute_script_list_lin(script_list):
    print(f"Executing all scripts in list: {script_list}")
    if "antivirusCheck" in script_list:
        execute_antivirus_check_lin()
    else:
        print(f"Script {script_list} not available.")
