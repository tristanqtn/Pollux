# This file contains the configuration for the Pollux tool.

## Configuration
class PolluxConfig:
    # Current OS type
    # Type: string
    # Mandatory: Yes
    # Default:  OS = 'windows'
    #           OS = 'linux'
    OS = "linux"

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

    # List of scripts to run
    # Type: list[str]
    # Mandatory: Yes
    # Example:     SCRIPT_LIST = ['firewallCheck', 'antivirusCheck', 'filesystemCheck', 'SessionCheck', 'PasswordPolicyCheck', 'PlannedTaskCheck', 'UpdateCheck']
    SCRIPT_LIST = [
        "antivirusCheck",
    ]

    # Extension of the script files
    # Type: string
    # Mandatory: No
    # Default: SCRIPT_EXTENSION = ""
    SCRIPT_EXTENSION = ""  # Leave it empty, it will be set in the code
