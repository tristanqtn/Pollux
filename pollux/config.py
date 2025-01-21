# This file contains the configuration for the Pollux tool.

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
    RUNNING_AS_ADMIN = 1

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
    TEMPORARY_FILE_LIST = [] # Leave it empty, it will be set in the code

    # Deta file location list
    # Type: list[str]
    # Mandatory: Yes
    # Default: DELTA_FILE_LIST = []
    DELTA_FILE_LIST = [] # Leave it empty, it will be set in the code

    # The path for the final audit report file
    # Type: string
    # Mandatory: Yes
    # Default : LIN_REPORT_FILE_LOCATION = '/tmp/pollux/'
    #           WIN_REPORT_FILE_LOCATION = 'C:\\Temp\\pollux\\'
    REPORT_FILE_LOCATION = ""  # Leave it empty, it will be set in the code
    LIN_REPORT_FILE_LOCATION = "/home/"
    WIN_REPORT_FILE_LOCATION = "C:\\"

    # List of scripts to run
    # Type: list[str]
    # Mandatory: Yes
    # Example:     SCRIPT_LIST = ['firewallCheck', 'antivirusCheck', 'filesystemCheck', 'SessionCheck', 'PasswordPolicyCheck', 'PlannedTaskCheck', 'UpdateCheck']
    SCRIPT_LIST = ["antivirusCheck", "updateCheck", "envvarCheck", "sessionCheck"]

    # Extension of the script files
    # Type: string
    # Mandatory: No
    # Default: SCRIPT_EXTENSION = ""
    SCRIPT_EXTENSION = ""  # Leave it empty, it will be set in the code
