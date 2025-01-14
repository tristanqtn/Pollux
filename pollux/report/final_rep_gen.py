import os
from datetime import datetime
from pollux.config import PolluxConfig

hardcoded_path = "/tmp/pollux/output"  # PolluxConfig().PATH
output_file = "POLLUX_REPORT.md"


def get_current_timestamp():
    now = datetime.now()
    date_str = now.strftime("%Y-%m-%d")
    timestamp_str = now.strftime("%Y-%m-%d %H:%M:%S")
    return date_str, timestamp_str


def process_file(file_path):
    try:
        with open(file_path, "r") as file:
            return file.read().strip()
    except Exception as e:
        print(f"Error while reading content of {file_path}: {e}")
        return None


def get_pollux_config_details():
    """
    Adding POLLUX configuration details to the report
    """
    config = PolluxConfig()
    config_details = [
        "#### Pollux Configuration\n",
        f"- **OS**: {config.OS or 'Not defined'}\n",
        f"- **Legitimate Open Ports**: {', '.join(map(str, config.LEGITIMATE_OPEN_PORTS)) or 'None'}\n",
        f"- **Legitimate Processes**: {', '.join(config.LEGITIMATE_PROCESSES) or 'None'}\n",
        f"- **Legitimate Services**: {', '.join(config.LEGITIMATE_SERVICES) or 'None'}\n",
        f"- **Legitimate Users**: {', '.join(config.LEGITIMATE_USERS) or 'None'}\n",
    ]
    return "\n".join(config_details)


def generate_md_report(input_directory, output_file):
    if not os.path.exists(input_directory):
        print(f"Error : {input_directory} doesn't exist.")
        return

    file_list = [
        os.path.join(input_directory, f)
        for f in os.listdir(input_directory)
        if os.path.isfile(os.path.join(input_directory, f))
    ]

    if not file_list:
        print("No file found in directory.")
        return

    date, timestamp = get_current_timestamp()

    report_content = [
        "# POLLUX REPORT\n",
        f"_Date : {date}_\n",
        f"_Timestamp : {timestamp}_\n",
        "The POLLUX project is open source and licensed by MIT. As a reminder, it does not comply with any official standard or recommendation, and does not guarantee the security of the infrastructure tested.\n",
        "### CONTENT\n",
    ]

    for file_path in sorted(file_list):
        file_name = os.path.basename(file_path)
        try:
            file_content = process_file(file_path)
            if file_content:
                report_content.append(f"#### Content from {file_name}\n")
                report_content.append(file_content)
                report_content.append("\n")
            else:
                report_content.append(f"#### Error reading {file_name}\n")
        except Exception as e:
            report_content.append(f"#### Error processing {file_name}: {e}\n")
    report_content.append("### END OF CONTENT\n\n")

    report_content.extend(
        [
            "### RECOMMENDATIONS\n",
            "\n",
            "### END OF RECOMMENDATIONS\n\n",
            "### ANNEXES\n",
            "#### Configuration\n",
            "\n",
            get_pollux_config_details(),
            "\n",
        ]
    )

    with open(output_file, "w") as report_file:
        report_file.write("\n".join(report_content))

    print(f"Report generated : {output_file}")


if __name__ == "__main__":
    generate_md_report(hardcoded_path, output_file)
