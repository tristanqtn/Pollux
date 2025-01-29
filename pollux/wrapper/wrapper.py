import os
import logging

from pollux.config import PolluxConfig
from pollux.wrapper.utils.utils import check_path_exists
from pollux.wrapper.executors.win_executors import (
    execute_antivirus_check_win,
    execute_updates_check_win,
    execute_envvar_check_win,
    execute_session_check_win,
    execute_planned_task_check_win,
    execute_file_system_check_win,
    execute_password_check_win,
    execute_port_check_win,
    execute_firewall_check_win,
    execute_service_check_win,
)
from pollux.wrapper.executors.lin_executors import (
    execute_antivirus_check_lin,
    execute_update_check_lin,
    execute_envvar_check_lin,
    execute_session_check_lin,
    execute_planned_task_check_lin,
    execute_file_system_check_lin,
    execute_password_check_lin,
    execute_port_check_lin,
    execute_firewall_check_lin,
    execute_service_check_lin,
)

from pollux.wrapper.report.report import generate_md_report

# Configure logging
logging.basicConfig(
    format="[%(asctime)s] [%(levelname)s] | %(message)s",
    level=logging.DEBUG,  # You can change this to INFO, WARNING, ERROR, etc.
)


def verify_output_path():
    """
    Verify if the output path exists, if not create it.

    :pram: None
    :return: None
    """
    if not check_path_exists(PolluxConfig.TEMPORARY_FILE_LOCATION):
        logging.info("Temporary file location does not exist.")
        logging.info(
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
    elif "passwordCheck" in script_list:
        execute_password_check_win()
    elif "filesystemCheck" in script_list:
        execute_file_system_check_win()
    elif "portCheck" in script_list:
        execute_port_check_win()
    elif "firewallCheck" in script_list:
        execute_firewall_check_win()
    elif "serviceCheck" in script_list:
        execute_service_check_win()
    else:
        logging.error(f"Script {script_list} not available.")


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
    elif "filesystemCheck" in script_list:
        execute_file_system_check_lin()
    elif "passwordCheck" in script_list:
        execute_password_check_lin()
    elif "portCheck" in script_list:
        execute_port_check_lin()
    elif "firewallCheck" in script_list:
        execute_firewall_check_lin()
    elif "serviceCheck" in script_list:
        execute_service_check_lin()
    else:
        logging.error(f"Script {script_list} not available.")


def conduct_audit():
    """
    Conduct the audit by executing the scripts in the script list.

    :param: None
    :return: None
    """
    logging.info("======================== Pollux Audit ===========================")
    if PolluxConfig.OS == "windows":
        for script in PolluxConfig.SCRIPT_LIST:
            execute_script_list_win(script)
    elif PolluxConfig.OS == "linux":
        for script in PolluxConfig.SCRIPT_LIST:
            execute_script_list_lin(script)
    else:
        logging.error("OS not supported by Pollux.")
    logging.info("All scripts executed. The temporary files are stored in : ")
    for file in PolluxConfig.TEMPORARY_FILE_LIST:
        logging.info(file)
    logging.info("=================================================================\n")


def compute_delta():
    """
    Compute the delta between the old and new audit reports and save the results to files.

    :param: None
    :return: None
    """
    logging.info("===================== Pollux Delta ==============================")
    for report in PolluxConfig.SCRIPT_LIST:
        old_report_path = os.path.join(
            PolluxConfig.TEMPORARY_FILE_LOCATION, f"old_{report}.tmp"
        )
        new_report_path = os.path.join(
            PolluxConfig.TEMPORARY_FILE_LOCATION, f"{report}.tmp"
        )
        delta_output_path = os.path.join(
            PolluxConfig.TEMPORARY_FILE_LOCATION, f"delta_{report}.tmp"
        )

        if os.path.exists(old_report_path) and os.path.exists(new_report_path):
            logging.info(f"Delta computation: {report}")
            with (
                open(old_report_path, "r") as old_file,
                open(new_report_path, "r") as new_file,
            ):
                old_data = set(old_file.readlines())
                new_data = set(new_file.readlines())

            # Detect new lines and removed lines
            added_lines = new_data - old_data
            removed_lines = old_data - new_data

            if added_lines or removed_lines:
                logging.info(f"Differences found in {report}:")
                with open(delta_output_path, "w") as delta_file:
                    if added_lines:
                        logging.info("\tAdded lines:")
                        delta_file.write("## Added lines:\n")
                        for line in added_lines:
                            logging.info("\t\t" + line.strip())
                            delta_file.write(line)
                        delta_file.write("***\n")
                    if removed_lines:
                        logging.info("\tRemoved lines:")
                        delta_file.write("\n## Removed lines:\n")
                        for line in removed_lines:
                            logging.info("\t\t" + line.strip())
                            delta_file.write(line)
                        delta_file.write("***\n")
                logging.info(f"Delta saved to {delta_output_path}\n")
                PolluxConfig.DELTA_FILE_LIST.append(delta_output_path)
            else:
                logging.info(f"No differences found in {report}.\n")
        else:
            logging.info(f"Missing old or new report for {report}.\n")

    logging.info("Delta computation completed.")
    if PolluxConfig.DELTA_FILE_LIST:
        logging.info("The delta files are stored in : ")
        for file in PolluxConfig.DELTA_FILE_LIST:
            logging.info(file)
    logging.info("=================================================================\n")


def create_report():
    """
    Create the final audit report by combining the audit reports and delta reports.

    :param: None
    :return: None
    """
    logging.info("======================== Pollux Report ==========================")
    output_file = os.path.join(
        PolluxConfig.REPORT_FILE_LOCATION, PolluxConfig.REPORT_FILE_NAME
    )
    generate_md_report(
        PolluxConfig.TEMPORARY_FILE_LIST, PolluxConfig.DELTA_FILE_LIST, output_file
    )
    logging.info("=================================================================\n")
