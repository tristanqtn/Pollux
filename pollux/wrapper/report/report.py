import re
import os
from datetime import datetime
from pollux.config import PolluxConfig


def get_current_timestamp():
    """
    Get the current date and timestamp in formatted strings.
    """
    now = datetime.now()
    date_str = now.strftime("%Y-%m-%d")
    timestamp_str = now.strftime("%Y-%m-%d %H:%M:%S")
    return date_str, timestamp_str


def process_file_blocks(file_path):
    """
    Extracts blocks of text from the file. A block starts with a line containing
    '## WORDS HERE' and ends with '***'.
    """
    try:
        with open(file_path, "r") as file:
            content = file.readlines()
    except Exception as e:
        print(f"Error while reading content of {file_path}: {e}")
        return None

    blocks = []
    block = []
    in_block = False

    for line in content:
        if "## " in line:  # Start of a block
            if in_block and block:
                blocks.append("".join(block).strip())
                block = []
            in_block = True
            block.append(line)
        elif in_block and line.strip() == "***":  # End of a block
            block.append(line)
            blocks.append("".join(block).strip())
            block = []
            in_block = False
        elif in_block:
            block.append(line)

    if block:  # Capture any remaining block
        blocks.append("".join(block).strip())

    return blocks


def get_pollux_config_details(report_content):
    """
    Adding POLLUX configuration details to the report.
    """
    config = [
        "## POLLUX CONFIGURATION\n",
        f"- **OS**: `{PolluxConfig.OS or 'Not defined'}`\n",
        f"- **Running as admin**: `{PolluxConfig.RUNNING_AS_ADMIN}`\n",
        f"- **Temporary file location**: `{PolluxConfig.TEMPORARY_FILE_LOCATION or 'Not defined'}`\n",
        f"- **Script list**: {', '.join(PolluxConfig.SCRIPT_LIST) or 'None'}\n",
        f"- **Script extension**: `{PolluxConfig.SCRIPT_EXTENSION or 'Not defined'}`\n",
        f"- **Report file location**: `{PolluxConfig.REPORT_FILE_LOCATION or 'Not defined'}`\n",
        f"- **Report file name**: `{PolluxConfig.REPORT_FILE_NAME or 'Not defined'}`\n",
    ]

    report_content.append("\n".join(config))

    return report_content


def generate_md_report(file_list, delta_list, output_file):
    """
    Generate a markdown report from temporary files provided in TEMPORARY_FILE_LIST.
    """
    if not file_list:
        print("Error: No files provided in TEMPORARY_FILE_LIST.")
        return

    date, timestamp = get_current_timestamp()

    report_template = [
        "# POLLUX REPORT\n",
        f"_Date: {date}_\n",
        f"_Timestamp: {timestamp}_\n",
        f"_Pollux Version: {PolluxConfig.VERSION}_\n",
        "The POLLUX project is open source and licensed by MIT. As a reminder, it does not comply with any official standard or recommendation, and does not guarantee the security of the infrastructure tested.\n",
        "\n---\n",
    ]

    report_content = get_pollux_config_details(report_template)
    """
    If this is the first report generation, or if older files were deleted for some reasons, there won't be any delta list. 
    If so, it's not an error and will just be treated as an empty list.
    """

    report_content.append("\n---\n## DIFFENCE(S) WITH LAST LAUNCH OF POLLUX\n")

    if not delta_list:
        report_content.append("NO PREVIOUS FILE FOUND\n")
    else:
        for file_path in sorted(delta_list):
            file_name = os.path.basename(file_path)
            try:
                blocks = process_file_blocks(file_path)
                if blocks:
                    regex = r"[^\\/]+(?=\.[^\\/]+$)"
                    script_name = re.search(regex, file_name).group(0)
                    report_content.append(f"#### Content from {script_name}\n")
                    report_content.append(
                        f"**Temporary file location:** `{file_name}`\n"
                    )
                    for block in blocks:
                        report_content.append("```plaintext")
                        report_content.append(block)
                        report_content.append("```")
                        report_content.append("\n")
                else:
                    report_content.append(f"#### No relevant content in {file_name}\n")
            except Exception as e:
                report_content.append(f"#### Error processing {file_name}: {e}\n")

    report_content.append("\n" "---\n" "\n" "## CONTENT\n")

    for file_name in sorted(file_list):
        file_path = os.path.join(PolluxConfig.LIN_TEMPORARY_FILE_LOCATION, file_name)
        try:
            blocks = process_file_blocks(file_path)
            if blocks:
                regex = r"[^\\/]+(?=\.[^\\/]+$)"
                script_name = re.search(regex, file_name).group(0)
                report_content.append(f"#### Content from {script_name}\n")
                add_explanations_to_pollux(report_content, script_name)
                report_content.append(f"\n**Temporary file location:** `{file_name}`\n")
                for block in blocks:
                    report_content.append("```plaintext")
                    report_content.append(block)
                    report_content.append("```")
                    report_content.append("\n")
                add_remediations_to_pollux(report_content, script_name)
            else:
                report_content.append(f"#### No relevant content in {file_name}\n")
        except Exception as e:
            report_content.append(f"#### Error processing {file_name}: {e}\n")
        

    report_content.append("# END OF CONTENT\n\n")

    with open(output_file, "w") as report_file:
        report_file.write("\n".join(report_content))

    print(f"Report generated: {output_file}")


def add_explanations_to_pollux(file_name, report_content):
    
    if file_name == "antivirusCheck.tmp":
        report_content.append("This script aims to provide information about the antivirus solution installed on the machine, if it is active, and if some scripts were run recently.\n")
    
    elif file_name == "envvarCheck.tmp":
        report_content.append("This script aims to detect abnormal environment variables. These could be clues for malicious activites.\n")
    
    elif file_name == "filesystemCheck.tmp":
        report_content.append("This script aims to verify file system permissions and sensitive locations or content. Sensitive files or directories with too much permissions are vulnerable, or could have been modified by malicious actors.\n")
        
    elif file_name == "firewallCheck.tmp":
        report_content.append("This script aims to verify firewall configurations, rules, trusted connections and network. A firewall not monitored is potentially vulnerable, as it could have rules that are not up to date. \n")
        
    elif file_name == "passwordCheck.tmp":
        report_content.append("This script aims to verify the systems' password policy.\n")
        
    elif file_name == "plannedtaskCheck.tmp":
        report_content.append("This script aims to check scheduled tasks running on the system, to detect abnormal ones.\n")
        
    elif file_name == "portCheck.tmp":
        report_content.append("This script aims to list open ports and associated service. The goal is to detect unlegitimate open ports.\n")
        
    elif file_name == "sessionCheck.tmp":
        report_content.append("This script aims to list verify user sessions and associated privileges. This helps avoid overpriviledged users and privilege escalation. \n")
        
    elif file_name == "updateCheck.tmp":
        report_content.append("This script aims to check OS version and packages. It allows to see if the system is up to date, to prevent outdated system issues.\n")
        
    """
    TEMPLATE : 
    
    elif file_name == "<>Check":
        report_content.append("This script aims to ...\n")
        
    """   

def add_remediations_to_pollux(file_name, report_content):
    
    report_content.append("Good Practices : \n")
    
    if file_name == "antivirusCheck.tmp":
        report_content.append("Keep your antivirus up to date, and verify it is running on the system. \n")
        report_content.append("Use automated scannings. \n")
        
        
    elif file_name == "envvarCheck.tmp":
        report_content.append("Verify regulary your environment variables. Use consistent naming to avoid false positives and keep track of all legitimate variables. \n")
        report_content.append("If possible, use a tool to monitor environment variables and detect abnormal ones. \n")
        
    elif file_name == "filesystemCheck.tmp":
        report_content.append("Implement zero-trust, and give minimal access to sensitive files. \n")
        report_content.append("If possible, use a file integrity monitoring system to detect unauthorized changes. \n")
        
    elif file_name == "firewallCheck.tmp":
        report_content.append(" Implement default deny approach, where all traffic is blocked by default and only necessary services are explicitly allowed. This minimizes exposure to unnecessary threats. \n")
        report_content.append("Implement principle of least privilege to ensure that access is onlu granted to user or devices that truly require it. \n")
    
    elif file_name == "passwordCheck.tmp":
        report_content.append("If not done yet, implement a strong password policy.\n")
        report_content.append("For users with a password policy, use a password manager to generate strong passwords.\n")
        report_content.append("As recommended by the NIST, a good password policy should focus more on using long, unique sentences and combine unusual words or unexpected concepts than on a specific length.\n")
        report_content.append("Plus, password should have at least one special character.\n")

    elif file_name == "plannedtaskCheck.tmp":
        report_content.append("Use consistent naming to easily detect abnormal cron jobs. \n")
        report_content.append("Check regularly the security of the task by looking at the execution time, the user, and the command. \n")
        report_content.append("Planned tasks linked to sensitive data must not be readable or writable by non-priviledged users. \n")
        
    elif file_name == "portCheck.tmp":
        report_content.append("Expose as few ports as possible, to minimize the attack surface.\n")
        report_content.append("Monitor opened port to detect unlegitimate ones, and close those who are no longer in use.\n")
        
        
    elif file_name == "sessionCheck.tmp":
        report_content.append("Implement role-based access to simplify users rights management.\n")
        report_content.append("Always give least privileges to users.\n")
        
    elif file_name == "updateCheck.tmp":
        report_content.append("If possible, activate automatic updates. If not check regularly for it, especially when major vulnerabilites are found on the OS.\n")
        report_content.append("If possible, use a tool to monitor OS and packages versions.\n")
        
    """
    TEMPLATE : 
    
    elif file_name == "<>Check":
        report_content.append("<Remediations>\n")
        
    """   