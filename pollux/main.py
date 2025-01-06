import os
import sys

from pollux.config import PolluxConfig
from pollux.utils import detect_os, detect_os_version

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
print('Welcome to Pollux wrapper !')
print('Current directory:', os.getcwd())
print('Python version:', sys.version)
print("=================================================================\n")
print("======================== Pollux Config ==========================")
print("Pollux configuration:")
print("OS:", PolluxConfig.OS)
print("Legitimate open ports:", PolluxConfig.LEGITIMATE_OPEN_PORTS)
print("Legitimate processes:", PolluxConfig.LEGITIMATE_PROCESSES)
print("Legitimate services:", PolluxConfig.LEGITIMATE_SERVICES)
    
if(PolluxConfig.OS != detect_os()):
    print("The current OS is different from the one configured in Pollux.")
    exit(1)
else:
    print("The current OS matches the one configured in Pollux.")
print("=================================================================")

print("OS version:", detect_os_version())



