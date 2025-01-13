# This file contains the configuration for the Pollux tool.

## Configuration
class PolluxConfig:

    # Current OS type
    # Type: string
    # Mandatory: Yes
    # Default:  OS = 'windows'  
    #           OS = 'linux'
    OS = 'linux'

    # The path for the temporary files (outputs of scripts)
    # Type: string
    # Mandatory: Yes
    # Default : TEMPORARY_FILE_LOCATION = '/tmp/pollux/'
    #           TEMPORARY_FILE_LOCATION = 'C:\\Temp\\pollux\\'
    TEMPORARY_FILE_LOCATION = '/tmp/pollux/'