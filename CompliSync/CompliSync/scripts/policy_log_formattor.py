import json
import re
import os
from config import POLICY_LOG_FOLDER, TEMP_FOLDER
from datetime import datetime
import subprocess

# Load JSON data from file
policy_data = os.path.join(TEMP_FOLDER, "multiple_policy_data.json")

with open(policy_data, "r") as file:
    data = json.load(file)

# PowerShell SID to Name conversion
def sid_to_name(sid):
    try:
        output = subprocess.check_output([
            "powershell",
            "-Command",
            f"$sid = New-Object System.Security.Principal.SecurityIdentifier('{sid}'); "
            "$account = $sid.Translate([System.Security.Principal.NTAccount]); "
            "$account.Value.Split('\\')[1]"
        ], universal_newlines=True)
        return output.strip()
    except Exception:
        return sid  # fallback if cannot resolve

# Transform function: supports multiple SIDs
def transform_value(value):
    if not isinstance(value, str):
        return value

    # Find all SID patterns in the string
    sids = re.findall(r"\*?(S-\d-\d+(?:-\d+)+)", value)
    for sid in sids:
        resolved_name = sid_to_name(sid)
        value = value.replace(sid, resolved_name)
    return value

# Process each section of the JSON
for section in ["Default Values", "Expected Values", "Updated Values"]:
    if section in data:
        updated_section = {}
        for key, value in data[section].items():
            clean_key = key.replace("'", "").strip()
            if section in ["Expected Values", "Updated Values"] and clean_key in data["Default Values"]:
                updated_section[clean_key] = transform_value(data["Default Values"][clean_key])
            else:
                updated_section[clean_key] = transform_value(value)
        data[section] = updated_section

# Save updated JSON
policy_log_path = os.path.join(
    POLICY_LOG_FOLDER, f"policy_log_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.json"
)

with open(policy_log_path, "w") as output_file:
    json.dump(data, output_file, indent=4)

print("Updated policy data saved to:")
print(policy_log_path)
