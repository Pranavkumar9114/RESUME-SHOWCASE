import json
import os
import re
from datetime import datetime
from config import POLICY_LOG_FOLDER

def get_latest_policy_log(folder):
    log_files = [
        f for f in os.listdir(folder)
        if re.match(r"policy_log_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}\.json", f)
    ]

    if not log_files:
        raise FileNotFoundError("No policy log files found in the folder.")

    # Extract datetime from filenames and sort
    log_files.sort(key=lambda f: datetime.strptime(
        re.search(r"(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})", f).group(1),
        "%Y-%m-%d_%H-%M-%S"
    ), reverse=True)

    return os.path.join(folder, log_files[0])

def calculate_scores(page):

    try:
        json_path = get_latest_policy_log(POLICY_LOG_FOLDER)
        if not os.path.exists(json_path):
            raise FileNotFoundError("Policy data file not found.")

        with open(json_path, "r", encoding="utf-8") as file:
            data = json.load(file)

        default_values = data.get("Default Values", {})
        expected_values = data.get("Expected Values", {})
        updated_values = data.get("Updated Values", {})
        # print(default_values)
        # print(expected_values)

        # Compliance Score
        total_checks = len(expected_values)
        compliance_matches = 0
        for k, v in expected_values.items(): 
            # print(k, " : ", v)
            if default_values.get(k) == v:
                compliance_matches += 1
            # else:
            #     print(k, " : ", default_values.get(k), " : ", v)

        # print(total_checks)
        # print(compliance_matches)
        compliance_score = round((compliance_matches / total_checks) * 100, 2) if total_checks > 0 else 0

        # Audit Score
        total_updates = len(updated_values)
        audit_matches = sum(
            1 for k, v in updated_values.items() if default_values.get(k) == v
        )
        audit_score = round((audit_matches / total_updates) * 100, 2) if total_updates > 0 else 0

        # Risk Score
        risk_score = round(((compliance_matches / total_checks) + (audit_matches / total_updates)) / 2, 2)

    except Exception as e:
        # Default to 50 if any error occurs
        compliance_score = 0
        audit_score = 0
        risk_score = 0
        print(f"Error calculating scores: {e}")

    # Save in client storage
    page.client_storage.set("compliance_score", compliance_score)
    page.client_storage.set("audit_score", audit_score)
    page.client_storage.set("risk_score", risk_score)

