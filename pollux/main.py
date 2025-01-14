from pollux.wrapper.initialize import logo, check_config, audit_to_conduct
from pollux.wrapper.wrapper import (
    execute_script_list_lin,
    execute_script_list_win,
    verify_output_path,
)
from pollux.config import PolluxConfig

if __name__ == "__main__":
    logo()
    check_config()
    audit_to_conduct()
    verify_output_path()

    if PolluxConfig.OS == "windows":
        for script in PolluxConfig.SCRIPT_LIST:
            execute_script_list_win(script)
    elif PolluxConfig.OS == "linux":
        for script in PolluxConfig.SCRIPT_LIST:
            execute_script_list_lin(script)
    else:
        print("OS not supported by Pollux.")
