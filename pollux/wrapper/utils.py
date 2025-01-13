"""
This snippet is a part of the Pollux tool. It contains all the little utils functions.
Please define here the functions that are not needed by the scripts but required by the wrapper.
"""

import os
import sys
import ctypes
import platform


def detect_os():
    """
    Detect the OS type

    return: the OS type
    """
    if sys.platform == "win32":
        return "windows"
    elif sys.platform == "darwin":
        return "macOS"
    elif sys.platform == "linux":
        return "linux"
    else:
        return "unknown"


def detect_os_version():
    """
    Detect the OS version

    return: the OS version
    """
    return platform.version()


def running_as_root():
    """
    Check if the script is running as root

    return: True if the script is running as root, False otherwise
    """
    if os.name == "nt":
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    else:
        return os.geteuid() == 0


def check_path_exists(path):
    """
    Check if a path exists
    """
    return os.path.exists(path)

def dos2unix(path):
    with open(path, 'rb') as f:
        content = f.read()
    with open(path, 'wb') as f:
        f.write(content.replace(b'\r\n', b'\n'))
        