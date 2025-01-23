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
                report_content.append(f"**Temporary file location:** `{file_name}`\n")
                for block in blocks:
                    report_content.append("```plaintext")
                    report_content.append(block)
                    report_content.append("```")
                    report_content.append("\n")
            else:
                report_content.append(f"#### No relevant content in {file_name}\n")
        except Exception as e:
            report_content.append(f"#### Error processing {file_name}: {e}\n")

    report_content.append("# END OF CONTENT\n\n")

    with open(output_file, "w") as report_file:
        report_file.write("\n".join(report_content))

    print(f"Report generated: {output_file}")
