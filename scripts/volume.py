#!/usr/bin/env python
import subprocess


# Function to parse the output of "pactl list sinks" and return a list of sinks with their id and name.
def parse_pactl_sinks():
    # Execute the pactl list sinks command and store the output in a variable.
    output = str(
        subprocess.check_output("pactl list sinks", shell=True, encoding="utf-8")
    )

    # Initialize variables to store sink information
    sinks = []
    current_sink = None

    # Parse each line to extract sink ID, name, and whether it's the default
    for line in output.splitlines():
        line = line.strip()

        # Identify the start of a new sink
        if line.startswith("Sink #"):
            if current_sink:  # Append the previous sink info before starting a new one
                sinks.append(current_sink)
            sink_id = int(line.split("#")[1])
            current_sink = {"sink_id": sink_id, "sink_name": "", "is_default": False}

        # Get the name of the sink
        elif line.startswith("Description:") and current_sink:
            current_sink["sink_name"] = line.split(":", 1)[1].strip()

        # Check if the sink is the default based on state
        elif line.startswith("State: RUNNING") and current_sink:
            current_sink["is_default"] = True

    # Append the last sink info
    if current_sink:
        sinks.append(current_sink)

    # Adjust the names to mark the default sink for the menu
    for sink in sinks:
        if sink["is_default"]:
            sink["sink_name"] += " - Default"

    return sinks


# Generate the list of sinks, highlighting the current default sink
output = ""
sinks = parse_pactl_sinks()
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
sinks = parse_pactl_sinks()
selected_sink = next(sink for sink in sinks if sink["sink_name"] == selected_sink_name)
subprocess.run(f"pactl set-default-sink {selected_sink['sink_id']}", shell=True)
