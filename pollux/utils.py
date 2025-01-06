import sys 
import platform

def detect_os():
    # Detect the current OS
    if sys.platform == 'win32':
        return 'windows'
    elif sys.platform == 'darwin':
        return 'macOS'
    elif sys.platform == 'linux':
        return 'linux'
    else:
        return 'unknown'
    
def detect_os_version():
    # Detect the OS version
    return platform.version()