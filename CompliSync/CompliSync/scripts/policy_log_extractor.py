import re
import json
import os
from config import TEMP_FOLDER

# Function to extract default and updated values
def extract_values(log_content):
    pattern = re.compile(
        r"^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} - (.+?):\s+(.+)$", re.MULTILINE
    )
    return {match[0].strip(): match[1].strip() for match in pattern.findall(log_content)}

# Function to extract expected values
def extract_expected_values(log_content):
    # Extract settings using regex (removing timestamps & log level)
    pattern = re.compile(
        r"Setting\s+'?(.*?)'?\s+to\s+'?(.*?)[\.\n]", re.IGNORECASE)
    matches = pattern.findall(log_content)

    # Store extracted settings in a dictionary
    policy_dict = {}
    for key, value in matches:
        clean_key = key.strip().strip("'")  # Remove extra quotes if present
        clean_value = value.strip().strip("'")  # Remove extra quotes if present
        policy_dict[clean_key] = clean_value

    # Extract "enabled" and "disabled" policies dynamically (removing timestamps & log level)
    enabled_pattern = re.compile(
        r"\[INFO\]\s+'?(.*?)'?\s+(enabled|disabled)[\.\n]", re.IGNORECASE)
    enabled_matches = enabled_pattern.findall(log_content)

    for key, status in enabled_matches:
        clean_key = key.strip().strip("'")
        clean_status = status.strip().capitalize()  # Ensure "Enabled" or "Disabled"
        policy_dict[clean_key] = clean_status

    return policy_dict  # ✅ Fixed indentation

# Read log file
policy_update_log = os.path.join(TEMP_FOLDER, "multiple_policy_update_log.txt")

with open(policy_update_log, "r", encoding="utf-8") as file:
    log_content = file.read()

# Extract values
default_values = extract_values(
    log_content.split("Applying Policy Updates...")[0])
expected_values = extract_expected_values(log_content)
updated_values = extract_values(
    log_content.split("Updated Policies Values")[1])

# Combine extracted data
final_data = {
    "Default Values": default_values,
    "Expected Values": expected_values,
    "Updated Values": updated_values
}

policy_data = os.path.join(TEMP_FOLDER, "multiple_policy_data.json")

# Save to JSON file
with open(policy_data, "w", encoding="utf-8") as json_file:
    json.dump(final_data, json_file, indent=4)
