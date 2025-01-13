import os
import sys

from pollux.config import PolluxConfig
from pollux.wrapper.utils import detect_os, running_as_root


def logo():
    print(r"""
__/\\\\\\\\\\\\\__________________/\\\\\\_____/\\\\\\________________________________
 _\/\\\/////////\\\_______________\////\\\____\////\\\________________________________
  _\/\\\_______\/\\\__________________\/\\\_______\/\\\________________________________
   _\/\\\\\\\\\\\\\/______/\\\\\_______\/\\\_______\/\\\_____/\\\____/\\\__/\\\____/\\\_
    _\/\\\/////////______/\\\///\\\_____\/\\\_______\/\\\____\/\\\___\/\\\_\///\\\/\\\/__
     _\/\\\______________/\\\__\//\\\____\/\\\_______\/\\\____\/\\\___\/\\\___\///\\\/____
      _\/\\\_____________\//\\\__/\\\_____\/\\\_______\/\\\____\/\\\___\/\\\____/\\\/\\\___
       _\/\\\______________\///\\\\\/____/\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\\___/\\\/\///\\\_
        _\///_________________\/////_____\/////////__\/////////___\/////////___\///____\///__
    """)
    print("======================== Pollux Wrapper ========================")
    print("Welcome to Pollux wrapper !")
    print("Current directory:", os.getcwd())
    print("Python version:", sys.version)
    print("=================================================================\n")


def check_config():
    print("======================== Pollux Config ==========================")
    print("Pollux configuration:\n")
    if PolluxConfig.OS != detect_os():
        print("The current OS is different from the one configured in Pollux.")
        exit(1)
    else:
        if PolluxConfig.RUNNING_AS_ADMIN != running_as_root():
            print(
                "The current user privileges are different from the one configured in Pollux."
            )
            exit(1)
        else:
            if PolluxConfig.RUNNING_AS_ADMIN == 0:
                print(
                    "IMPORTANT : \tPollux is running as a user. This tool as been designed to run as root.\n\t\tScripts will be executed with limited privileges and won't very accurate.\n"
                )
            if PolluxConfig.TEMPORARY_FILE_LOCATION == "":
                if PolluxConfig.OS == "windows":
                    PolluxConfig.TEMPORARY_FILE_LOCATION = (
                        PolluxConfig.WIN_TEMPORARY_FILE_LOCATION
                    )
                    PolluxConfig.SCRIPT_EXTENSION = ".ps1"
                elif PolluxConfig.OS == "linux":
                    PolluxConfig.TEMPORARY_FILE_LOCATION = (
                        PolluxConfig.LIN_TEMPORARY_FILE_LOCATION
                    )
                    PolluxConfig.SCRIPT_EXTENSION = ".sh"
                print(
                    "Temporary file location set to :",
                    PolluxConfig.TEMPORARY_FILE_LOCATION,
                )
            else:
                print(
                    "Temporary file location (make sure to match your OS filesystem):",
                    PolluxConfig.TEMPORARY_FILE_LOCATION,
                )
            print("\nThe current environment matches the one configured in Pollux.")
            print("Everything OK, Pollux is ready to run.")
    print("=================================================================\n")


def audit_to_conduct():
    print("======================== Pollux Audit ===========================")
    print("Audit to conduct:")
    for script in PolluxConfig.SCRIPT_LIST:
        print(script)

    print("\nTemporary file location :", PolluxConfig.TEMPORARY_FILE_LOCATION)
    print("=================================================================\n")
