"""
    This snippet is a part of the Pollux tool. It contains all the little utils functions.
    Please define here the functions that are not needed by the scripts but required by the wrapper. 
"""

import sys 
import platform

def detect_os():
    """
    Detect the OS type

    return: the OS type
    """
    if sys.platform == 'win32':
        return 'windows'
    elif sys.platform == 'darwin':
        return 'macOS'
    elif sys.platform == 'linux':
        return 'linux'
    else:
        return 'unknown'
    
def detect_os_version():
    """
    Detect the OS version

    return: the OS version
    """
    return platform.version()