#!/usr/bin/env python
import subprocess


# Function to parse the output of "wpctl status" and return a dictionary of sinks with their id and name.
def parse_wpctl_status():
    # Execute the wpctl status command and store the output in a variable.
    output = str(subprocess.check_output("wpctl status", shell=True, encoding="utf-8"))

    # Remove the ASCII tree characters and return a list of lines
    lines = (
        output.replace("├", "")
        .replace("─", "")
        .replace("│", "")
        .replace("└", "")
        .splitlines()
    )

    # Find the index of the "Sinks:" line as a starting point
    sinks_index: int = None
    for index, line in enumerate(lines):
        if "Sinks:" in line:
            sinks_index = index
            break

    # Gather the lines after "Sinks:" and before the next blank line
    sinks = []
    for line in lines[sinks_index + 1 :]:
        if not line.strip():
            break
        sinks.append(line.strip())

    # Remove the "[vol:" suffix from the sink names
    for index, sink in enumerate(sinks):
        sinks[index] = sink.split("[vol:")[0].strip()

    # Mark the default sink by appending "- Default" to the end
    for index, sink in enumerate(sinks):
        if sink.startswith("*"):
            sinks[index] = sink.strip().replace("*", "").strip() + " - Default"

    # Construct the dictionary in the format {'sink_id': <int>, 'sink_name': <str>}
    sinks_dict = [
        {"sink_id": int(sink.split(".")[0]), "sink_name": sink.split(".")[1].strip()}
        for sink in sinks
    ]

    return sinks_dict


# Generate the list of sinks, highlighting the current default sink
output = ""
sinks = parse_wpctl_status()
for items in sinks:
    if items["sink_name"].endswith(" - Default"):
        output += f"<b>-> {items['sink_name']}</b>\n"
    else:
        output += f"{items['sink_name']}\n"

# Display the sink list using rofi
rofi_command = (
    f"echo '{output}' | rofi -dmenu -markup-rows -location 0 -width 600 -lines 10"
)

# Run the rofi command and capture the selected sink name
rofi_process = subprocess.run(
    rofi_command,
    shell=True,
    encoding="utf-8",
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
)

# Exit if the user canceled
if rofi_process.returncode != 0:
    print("User cancelled the operation.")
    exit(0)

# Set the selected sink as the default
selected_sink_name = rofi_process.stdout.strip()
sinks = parse_wpctl_status()
selected_sink = next(sink for sink in sinks if sink["sink_name"] == selected_sink_name)
subprocess.run(f"wpctl set-default {selected_sink['sink_id']}", shell=True)
