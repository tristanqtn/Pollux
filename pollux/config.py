# This file contains the configuration for the Pollux tool.

import logging

from datetime import datetime

## Logging - DO NOT CHANGE
logging.basicConfig(
    format="[%(asctime)s] [%(levelname)s] | %(message)s",
    level=logging.DEBUG,  # You can change this to INFO, WARNING, ERROR, etc.
)


## Configuration
class PolluxConfig:
    # Version of Pollux
    VERSION = "1.0.0"

    # Current OS type
    # Type: string
    # Mandatory: Yes
    # Default:  OS = 'windows'
    #           OS = 'linux'
    OS = "windows"

    # Type of session running Pollux
    # Type: boolean
    # Mandatory: Yes
    # Default: RUNNING_AS_ADMIN = 1; true running as root
    #          RUNNING_AS_ADMIN = 0; false running as user
    # Preferable: 1
    RUNNING_AS_ADMIN = 0

    # The path for the temporary files (outputs of scripts)
    # Type: string
    # Mandatory: Yes
    # Default : LIN_TEMPORARY_FILE_LOCATION = '/tmp/pollux/'
    #           WIN_TEMPORARY_FILE_LOCATION = 'C:\\Temp\\pollux\\'
    TEMPORARY_FILE_LOCATION = ""  # Leave it empty, it will be set in the code
    LIN_TEMPORARY_FILE_LOCATION = "/tmp/pollux/"
    WIN_TEMPORARY_FILE_LOCATION = "C:\\Temp\\pollux\\"

    # Temporary file location list
    # Type: list[str]
    # Mandatory: Yes
    # Default: TEMPORARY_FILE_LIST = []
    TEMPORARY_FILE_LIST = []  # Leave it empty, it will be set in the code

    # Deta file location list
    # Type: list[str]
    # Mandatory: Yes
    # Default: DELTA_FILE_LIST = []
    DELTA_FILE_LIST = []  # Leave it empty, it will be set in the code

    # The path for the final audit report file
    # Type: string
    # Mandatory: Yes
    # Default : LIN_REPORT_FILE_LOCATION = '/tmp/pollux/'
    #           WIN_REPORT_FILE_LOCATION = 'C:\\Temp\\pollux\\'
    REPORT_FILE_LOCATION = ""  # Leave it empty, it will be set in the code
    LIN_REPORT_FILE_LOCATION = "/home/"
    WIN_REPORT_FILE_LOCATION = "C:\\"

    # Name of the final audit report file
    # Type: string
    # Mandatory: Yes
    # Default: REPORT_FILE_NAME = 'pollux_report_<timestamp>.md'
    ts = datetime.now().strftime("%Y%m%d%H%M%S")
    REPORT_FILE_NAME = f"pollux_report_{ts}.md"

    # List of services that are legitimate
    # Type: list[str]
    # Mandatory: Yes
    # Default: LEGITIMATE_SERVICES = []
    # Example: LEGITIMATE_SERVICES = ['mysql', 'apache2', 'nginx', 'httpd']
    LEGITIMATE_SERVICES = [
        "mysql",
        "apache2",
        "nginx",
        "httpd",
    ]

    # List of scripts to run
    # Type: list[str]
    # Mandatory: Yes
    # Example:     SCRIPT_LIST = ['firewallCheck', 'antivirusCheck', 'filesystemCheck']
    # Scripts available in default Pollux:
    #   - antivirusCheck
    #   - envvarCheck
    #   - filesystemCheck
    #   - firewallCheck
    #   - passwordCheck
    #   - plannedtaskCheck
    #   - portCheck
    #   - serviceCheck
    #   - sessionCheck
    #   - updateCheck

    SCRIPT_LIST = [
        "antivirusCheck",
        "passwordCheck",
        "envvarCheck",
        "sessionCheck",
        "plannedtaskCheck",
        "serviceCheck",
    ]

    # Extension of the script files
    # Type: string
    # Mandatory: No
    # Default: SCRIPT_EXTENSION = ""
    SCRIPT_EXTENSION = ""  # Leave it empty, it will be set in the code

    # =========================================================
    # ================== DO NOT CHANGE BELOW ==================
    # =========================================================
    # Display the Pollux configuration
    @staticmethod
    def display_config():
        logging.info("============")
        logging.info(f"OS: {PolluxConfig.OS}")
        if PolluxConfig.RUNNING_AS_ADMIN == 1:
            logging.info("Running as admin: True")
        else:
            logging.warning("Running as admin: False")
        logging.info("============")
        logging.info(f"Temporary file location: {PolluxConfig.TEMPORARY_FILE_LOCATION}")
        logging.info(f"Report file location: {PolluxConfig.REPORT_FILE_LOCATION}")
        logging.info(f"Report file name: {PolluxConfig.REPORT_FILE_NAME}")
        logging.info("============")
        logging.info(f"Script extension: {PolluxConfig.SCRIPT_EXTENSION}")
        logging.info("Audit to conduct :")
        for script in PolluxConfig.SCRIPT_LIST:
            logging.info(f"\t{script}")
        logging.info("============\n")
