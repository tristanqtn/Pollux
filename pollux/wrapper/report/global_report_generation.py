import os
from datetime import datetime
from pollux.config import PolluxConfig

output_file = "POLLUX_REPORT.md"

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
        if line.strip().startswith("## "):
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

#def get_pollux_config_details():
#    """
#    Adding POLLUX configuration details to the report.
#    """
#    config = PolluxConfig()
#    config_details = [
#        "## Pollux Configuration\n",
#        f"- **OS**: {config.OS or 'Not defined'}\n",
#        f"- **Legitimate Open Ports**: {', '.join(map(str, config.LEGITIMATE_OPEN_PORTS)) or 'None'}\n",
#        f"- **Legitimate Processes**: {', '.join(config.LEGITIMATE_PROCESSES) or 'None'}\n",
#        f"- **Legitimate Services**: {', '.join(config.LEGITIMATE_SERVICES) or 'None'}\n",
#        f"- **Legitimate Users**: {', '.join(config.LEGITIMATE_USERS) or 'None'}\n",
#    ]
#    return "\n".join(config_details)

def generate_md_report(file_list, delta_list, output_file):
    """
    Generate a markdown report from temporary files provided in TEMPORARY_FILE_LIST.
    """
    if not file_list:
        print("Error: No files provided in TEMPORARY_FILE_LIST.")
        return

    date, timestamp = get_current_timestamp()

    report_content = [
        "# POLLUX REPORT\n",
        f"_Date: {date}_\n",
        f"_Timestamp: {timestamp}_\n",
        "The POLLUX project is open source and licensed by MIT. As a reminder, it does not comply with any official standard or recommendation, and does not guarantee the security of the infrastructure tested.\n",
        "---\n"
        "### DIFFENCE(S) WITH LAST LAUNCH OF POLLUX"
    ]

    """
    If this is the first report generation, or if older files were deleted for some reasons, there won't be any delta list. 
    If so, it's not an error and will just be treated as an empty list.
    """

    if not delta_list:
        report_content.append("NO PREVIOUS FILE FOUND\n")
    else: 
        for file_path in sorted(delta_list):
            file_name = os.path.basename(file_path)
            try:
                blocks = process_file_blocks(file_path)
                if blocks:
                    report_content.append(f"#### Content from {file_name}\n")
                    for block in blocks:
                        report_content.append(block)
                        report_content.append("\n")
                else:
                    report_content.append(f"#### No relevant content in {file_name}\n")
            except Exception as e:
                report_content.append(f"#### Error processing {file_name}: {e}\n")

    report_content.append(
        "### END OF DELTA\n"
        "\n"
        "---\n"
        "\n"
        "### CONTENT\n"
    )

    for file_name in sorted(file_list):
            file_path = os.path.join(PolluxConfig.LIN_TEMPORARY_FILE_LOCATION, file_name)
            try:
                blocks = process_file_blocks(file_path)
                if blocks:
                    report_content.append(f"#### Content from {file_name}\n")
                    for block in blocks:
                        report_content.append(block)
                        report_content.append("\n")
                else:
                    report_content.append(f"#### No relevant content in {file_name}\n")
            except Exception as e:
                report_content.append(f"#### Error processing {file_name}: {e}\n")

    report_content.append("### END OF CONTENT\n\n")

#    report_content.extend([
#        "### ANNEXES\n",
#        "#### Configuration\n",
#        get_pollux_config_details(),
#        "\n",
#    ])

    with open(output_file, "w") as report_file:
        report_file.write("\n".join(report_content))

    print(f"Report generated: {output_file}")

if __name__ == "__main__":
    generate_md_report(PolluxConfig.TEMPORARY_FILE_LIST,PolluxConfig.DELTA_FILE_LIST,output_file)

"""
Format of the report : 

Presentation page
recap page(s) (delta)
Content page(s)
Annexes

"""