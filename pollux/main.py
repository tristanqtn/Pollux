from pollux.wrapper.initialize import logo, check_config, audit_to_conduct
from pollux.wrapper.wrapper import execute_script_lin, execute_script_win
from pollux.config import PolluxConfig

if __name__ == "__main__":
    logo()
    check_config()
    audit_to_conduct()

    if PolluxConfig.OS == "windows":
        for script in PolluxConfig.SCRIPT_LIST:
            execute_script_win(script)
    elif PolluxConfig.OS == "linux":
        for script in PolluxConfig.SCRIPT_LIST:
            execute_script_lin(script)
    else:
        print("OS not supported by Pollux.")
