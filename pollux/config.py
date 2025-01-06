# This file contains the configuration for the Pollux tool.

## Configuration
class PolluxConfig:

    # Current OS type
    # Example: 'windows' or 'linux'
    OS = 'windows'

    # The list of legitimate open ports
    # Example: [80, 443, 22, 21, 25, 53, 110, 143, 3306, 5432, 8080, 8443]
    LEGITIMATE_OPEN_PORTS = []

    # The list of legitimate processes
    # Example: ['chrome.exe', 'firefox.exe', 'explorer.exe', 'opera.exe', 'safari.exe', 'edge.exe', 'iexplore.exe', 'brave.exe']
    LEGITIMATE_PROCESSES = []

    # The list of legitimate services
    # Example: ['mysql', 'postgresql', 'apache2', 'nginx', 'httpd', 'ssh', 'ftp', 'smb', 'rdp', 'vnc', 'telnet']
    LEGITIMATE_SERVICES = []

    # The list of legitimate users
    # Example: ['root', 'admin', 'user', 'guest']
    LEGITIMATE_USERS = []