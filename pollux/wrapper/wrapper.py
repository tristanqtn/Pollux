import os

from pollux.config import PolluxConfig
from pollux.wrapper.utils.utils import check_path_exists
from pollux.wrapper.executors.win_executors import (
    execute_antivirus_check_win,
    execute_updates_check_win,
    execute_envvar_check_win,
    execute_session_check_win,
    execute_planned_task_check_win,
)
from pollux.wrapper.executors.lin_executors import (
    execute_antivirus_check_lin,
    execute_update_check_lin,
    execute_envvar_check_lin,
    execute_session_check_lin,
    execute_planned_task_check_lin,
)


def verify_output_path():
    """
    Verify if the output path exists, if not create it.

    :pram: None
    :return: None
    """
    if not check_path_exists(PolluxConfig.TEMPORARY_FILE_LOCATION):
        print("Temporary file location does not exist.")
        print(
            f"Creating temporary file location: {PolluxConfig.TEMPORARY_FILE_LOCATION}\n"
        )
        os.makedirs(PolluxConfig.TEMPORARY_FILE_LOCATION)


def execute_script_list_win(script_list):
    """
    Execute the scripts in the script list for Windows.

    :param script_list: list of scripts to execute
    :type script_list: list[str]
    :return: None
    """
    if "antivirusCheck" in script_list:
        execute_antivirus_check_win()
    elif "updateCheck" in script_list:
        execute_updates_check_win()
    elif "envvarCheck" in script_list:
        execute_envvar_check_win()
    elif "sessionCheck" in script_list:
        execute_session_check_win()
    elif "plannedtaskCheck" in script_list:
        execute_planned_task_check_win()
    else:
        print(f"Script {script_list} not available.")


def execute_script_list_lin(script_list):
    """
    Execute the scripts in the script list for Linux.

    :param script_list: list of scripts to execute
    :type script_list: list[str]
    :return: None
    """
    if "antivirusCheck" in script_list:
        execute_antivirus_check_lin()
    elif "updateCheck" in script_list:
        execute_update_check_lin()
    elif "envvarCheck" in script_list:
        execute_envvar_check_lin()
    elif "sessionCheck" in script_list:
        execute_session_check_lin()
    elif "plannedtaskCheck" in script_list:
        execute_planned_task_check_lin()
    else:
        print(f"Script {script_list} not available.")

def conduct_audit():
    """
    Conduct the audit by executing the scripts in the script list.

    :param: None
    :return: None
    """
    print("======================== Pollux Audit ===========================")
    if PolluxConfig.OS == "windows":
        for script in PolluxConfig.SCRIPT_LIST:
            execute_script_list_win(script)
    elif PolluxConfig.OS == "linux":
        for script in PolluxConfig.SCRIPT_LIST:
            execute_script_list_lin(script)
    else:
        print("OS not supported by Pollux.")
    print("\nAll scripts executed. The temporary files are stored in : ", )
    for file in PolluxConfig.TEMPORARY_FILE_LIST:
        print(file)
    print("=================================================================\n")


def compute_delta():
    """
    Compute the delta between the old and new audit reports and save the results to files.

    :param: None
    :return: None
    """
    print("===================== Pollux Delta ==============================")
    for report in PolluxConfig.SCRIPT_LIST:
        old_report_path = os.path.join(PolluxConfig.TEMPORARY_FILE_LOCATION, f"old_{report}.tmp")
        new_report_path = os.path.join(PolluxConfig.TEMPORARY_FILE_LOCATION, f"{report}.tmp")
        delta_output_path = os.path.join(PolluxConfig.TEMPORARY_FILE_LOCATION, f"delta_{report}.tmp")

        if os.path.exists(old_report_path) and os.path.exists(new_report_path):
            print(f"Delta computation: {report}")
            with open(old_report_path, 'r') as old_file, open(new_report_path, 'r') as new_file:
                old_data = set(old_file.readlines())
                new_data = set(new_file.readlines())

            # Detect new lines and removed lines
            added_lines = new_data - old_data
            removed_lines = old_data - new_data

            if added_lines or removed_lines:
                print(f"Differences found in {report}:")
                with open(delta_output_path, 'w') as delta_file:
                    if added_lines:
                        print("\tAdded lines:")
                        delta_file.write("## Added lines:\n")
                        for line in added_lines:
                            print("\t\t" + line.strip())
                            delta_file.write(line)
                        delta_file.write("***\n")
                    if removed_lines:
                        print("\tRemoved lines:")
                        delta_file.write("\n## Removed lines:\n")
                        for line in removed_lines:
                            print("\t\t" + line.strip())
                            delta_file.write(line)
                        delta_file.write("***\n")
                print(f"Delta saved to {delta_output_path}\n")
                PolluxConfig.DELTA_FILE_LIST.append(delta_output_path)
            else:
                print(f"No differences found in {report}.\n")
        else:
            print(f"Missing old or new report for {report}.\n")

    print("\n===")
    print("Delta computation completed.")
    if(PolluxConfig.DELTA_FILE_LIST):
        print("The delta files are stored in : ")
        for file in PolluxConfig.DELTA_FILE_LIST:
            print(file)
    print("=================================================================\n")


