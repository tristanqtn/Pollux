import os
import sys
import logging

from colorama import Fore

from pollux.config import PolluxConfig
from pollux.wrapper.utils.utils import detect_os, running_as_root

# Configure logging
logging.basicConfig(
    format="[%(asctime)s] [%(levelname)s] | %(message)s",
    level=logging.DEBUG,  # You can change this to INFO, WARNING, ERROR, etc.
)


def logo():
    """
    Print the Pollux logo. And base information about the tool.
    """
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
    logging.info("======================== Pollux Wrapper ========================")
    logging.info("Welcome to Pollux wrapper !")
    logging.info(
        "Pollux is a tool to conduct security audits on Windows and Linux systems."
    )
    logging.info(
        f"You are currently running Pollux in its version: {PolluxConfig.VERSION}"
    )
    logging.info(f"Current directory: {os.getcwd()}")
    logging.info(f"Python version: {sys.version}")
    logging.info("=================================================================\n")


def check_config():
    """
    Check that the configuration of Pollux matches the execution environment.
    If any mismatch is found, the script will exit.

    :param: None
    :return: None
    """
    logging.info("======================== Pollux Config ==========================")
    logging.info("Pollux configuration :\n")
    if PolluxConfig.OS != detect_os():
        logging.critical(
            "The current OS is different from the one configured in Pollux."
        )
        exit(1)
    else:
        if PolluxConfig.RUNNING_AS_ADMIN != running_as_root():
            logging.critical(
                "The current user privileges are different from the one configured in Pollux."
            )
            exit(1)
        else:
            if PolluxConfig.RUNNING_AS_ADMIN == 0:
                logging.warning(
                    "IMPORTANT : \tPollux is running as a user. This tool as been designed to run as root.\n\t\tScripts will be executed with limited privileges and won't very accurate.\n"
                )
            if PolluxConfig.TEMPORARY_FILE_LOCATION == "":
                if PolluxConfig.OS == "windows":
                    PolluxConfig.TEMPORARY_FILE_LOCATION = (
                        PolluxConfig.WIN_TEMPORARY_FILE_LOCATION
                    )
                    PolluxConfig.SCRIPT_EXTENSION = ".ps1"
                    PolluxConfig.REPORT_FILE_LOCATION = (
                        PolluxConfig.WIN_REPORT_FILE_LOCATION
                    )
                elif PolluxConfig.OS == "linux":
                    PolluxConfig.TEMPORARY_FILE_LOCATION = (
                        PolluxConfig.LIN_TEMPORARY_FILE_LOCATION
                    )
                    PolluxConfig.SCRIPT_EXTENSION = ".sh"
                    PolluxConfig.REPORT_FILE_LOCATION = (
                        PolluxConfig.LIN_REPORT_FILE_LOCATION
                    )
            else:
                logging.info(
                    "Temporary file location (make sure to match your OS filesystem):",
                    PolluxConfig.TEMPORARY_FILE_LOCATION,
                )

            PolluxConfig.display_config()

            logging.info(
                "The current environment matches the one configured in Pollux."
            )
            logging.info("Everything OK, Pollux is ready to run.")
    logging.info("=================================================================\n")


def flush_temporary_files():
    """
    Flush the temporary files in the temporary file location.
    """
    logging.info("======================== Pollux Cleanup =========================")
    if PolluxConfig.TEMPORARY_FILE_LOCATION == "":
        logging.info("Temporary file location not set. Exiting.")
    elif PolluxConfig.RUNNING_AS_ADMIN == 0 and PolluxConfig.OS == "linux":
        logging.error(
            f"Need to be root to flush temporary files in : {PolluxConfig.TEMPORARY_FILE_LOCATION}"
        )
    else:
        logging.info(
            "Flushing temporary files from previous runs in :",
            PolluxConfig.TEMPORARY_FILE_LOCATION,
        )
        for file in os.listdir(PolluxConfig.TEMPORARY_FILE_LOCATION):
            logging.info(f"Deleting : {file}")
            os.remove(PolluxConfig.TEMPORARY_FILE_LOCATION + file)
        logging.info("Temporary files flushed.")
    logging.info("=================================================================\n")


def flush_old_temporary_files():
    """
    Flush the temporary files in the temporary file location.
    """
    logging.info("======================== Pollux Cleanup =========================")
    if PolluxConfig.TEMPORARY_FILE_LOCATION == "":
        logging.info("Temporary file location not set. Exiting.")
    elif PolluxConfig.RUNNING_AS_ADMIN == 0 and PolluxConfig.OS == "linux":
        logging.error(
            f"Need to be root to flush temporary files in : {PolluxConfig.TEMPORARY_FILE_LOCATION}"
        )
    else:
        logging.info(
            f"Flushing temporary files from previous runs in : {PolluxConfig.TEMPORARY_FILE_LOCATION}"
        )
        for file in os.listdir(PolluxConfig.TEMPORARY_FILE_LOCATION):
            if file.startswith("old_"):
                logging.info(f"Deleting : {file}")
                os.remove(PolluxConfig.TEMPORARY_FILE_LOCATION + file)
    logging.info("=================================================================\n")


def stash_temporary_file():
    """
    Transform all the temporary files in the temporary file location to old ones.
    """
    logging.info("======================== Pollux Delta ===========================")
    if PolluxConfig.TEMPORARY_FILE_LOCATION == "":
        logging.info("Temporary file location not set. Exiting.")
    elif PolluxConfig.RUNNING_AS_ADMIN == 0 and PolluxConfig.OS == "linux":
        logging.error(
            f"Need to be root to stash temporary files in : {PolluxConfig.TEMPORARY_FILE_LOCATION}"
        )
    else:
        logging.info(
            f"Stashing temporary files from previous runs in : {PolluxConfig.TEMPORARY_FILE_LOCATION}"
        )
        for file in os.listdir(PolluxConfig.TEMPORARY_FILE_LOCATION):
            logging.info(f"Stashing : {file}")
            os.rename(
                PolluxConfig.TEMPORARY_FILE_LOCATION + file,
                PolluxConfig.TEMPORARY_FILE_LOCATION + "old_" + file,
            )
    logging.info("=================================================================\n")
