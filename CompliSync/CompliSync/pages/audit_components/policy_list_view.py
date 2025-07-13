import flet as ft
import json
import os
import subprocess
import glob
from utils.logger import log_action
from config import POLICY_LOG_FOLDER, TEMP_FOLDER

def policy_list_view(page):
    # Path to the policy_data.json file
    policy_file_path = glob.glob(os.path.join(POLICY_LOG_FOLDER, "policy_log_*.json"))

    # Sort files by modified time, descending
    policy_file_path.sort(key=os.path.getmtime, reverse=True)

    # Select the latest one
    policy_file_path = policy_file_path[0] if policy_file_path else "temp"

    # Path to the temporary policy update JSON file
    temp_policy_file_path = os.path.join(TEMP_FOLDER, "temp_policy_update.json")

    # Initialize policies list
    policies = []

    # Check if the policy_data.json file exists and load data
    if os.path.exists(policy_file_path):
        try:
            with open(policy_file_path, 'r') as file:
                policy_data = json.load(file)

            # Extract data from the JSON file
            default_values = policy_data.get("Default Values", {})
            expected_values = policy_data.get("Expected Values", {})
            updated_values = policy_data.get("Updated Values", {})

            # Create policies list from default values
            for policy_name, default_value in default_values.items():
                policies.append({
                    "name": policy_name,
                    "current": updated_values.get(policy_name, default_value),
                    "recommended": expected_values.get(policy_name, default_value)
                })
        except Exception as e:
            print(f"Error loading policy data: {e}")
            # Fallback to dummy data if file loading fails
            policies = [
                {"name": "Policy 1", "current": "Enabled",
                    "recommended": "Disabled"},
                {"name": "Policy 2", "current": "Disabled",
                    "recommended": "Disabled"},
                {"name": "Policy 3", "current": "Enabled", "recommended": "Enabled"},
            ]
    else:
        print("Policy data file not found, using dummy data")
        # Fallback to dummy data if file doesn't exist
        policies = [
            {"name": "Policy 1", "current": "Enabled", "recommended": "Disabled"},
            {"name": "Policy 2", "current": "Disabled", "recommended": "Disabled"},
            {"name": "Policy 3", "current": "Enabled", "recommended": "Enabled"},
        ]

    filter_tabs = ["All", "Complied", "Non-Complied"]
    selected_tab = ft.Text("All",weight=ft.FontWeight.BOLD, size=16)

    def on_tab_change(e):
        selected_tab.value = e.control.text
        print("Filter changed to:", e.control.text)
        page.update()

    policy_controls = []
    for policy in policies:
        # Create refs for TextField and Checkbox
        custom_value_field = ft.Ref[ft.TextField]()
        apply_checkbox = ft.Ref[ft.Checkbox]()

        def apply_policy(e, policy_name=policy['name'], custom_value_ref=custom_value_field, checkbox_ref=apply_checkbox):
            if checkbox_ref.current.value:
                custom_value = custom_value_ref.current.value
                if custom_value:
                    print(
                        f"Applying custom policy: {policy_name} with value: {custom_value}")
                    log_action("Policy Applied",
                               f"Policy: {policy_name}, Value: {custom_value}")

                    # Save the policy update to a temporary JSON file
                    policy_update = {
                        "policy_name": policy_name,
                        "custom_value": custom_value
                    }
                    try:
                        with open(temp_policy_file_path, 'w') as temp_file:
                            json.dump(policy_update, temp_file)

                        # Execute the audit.ps1 script with the policy name and custom value
                        # Update with the actual path to audit.ps1
                        powershell_script = os.path.join(os.getcwd(), "scripts", "single_policy", "single.ps1")
                        print(powershell_script)
                        result = subprocess.run(
                        ["powershell.exe", "-Command", f"Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"{powershell_script}\"' -Verb RunAs"],
                        capture_output=True,
                        text=True
                        )
                        if result.returncode == 0:
                            print(f"Policy {policy_name} updated successfully")
                            log_action(
                                "Policy Update Success", f"Policy: {policy_name}, Value: {custom_value}")
                            # Update the UI to reflect the new current value
                            for p in policies:
                                if p['name'] == policy_name:
                                    p['current'] = custom_value
                                    break
                            page.update()
                        else:
                            print(
                                f"Error executing PowerShell script: {result.stderr}")
                            log_action(
                                "Policy Update Error", f"Policy: {policy_name}, Error: {result.stderr}")
                    except Exception as ex:
                        print(f"Error applying policy: {ex}")
                        log_action("Policy Update Error",
                                   f"Policy: {policy_name}, Error: {ex}")
                else:
                    print(
                        f"No custom value provided for policy: {policy_name}")
            else:
                print(f"Checkbox not ticked for policy: {policy_name}")

        policy_controls.append(
            ft.Card(
                content=ft.Container(
                    padding=10,
                    content=ft.Column(
                        controls=[
                            ft.Text(
                                f"Policy: {policy['name']}", weight=ft.FontWeight.BOLD),
                            ft.Text(f"Current Value: {policy['current']}"),
                            ft.Text(
                                f"Recommended Value: {policy['recommended']}"),
                            ft.TextField(
                                label="Custom Value (Optional)", ref=custom_value_field),
                            ft.Checkbox(label="Apply Custom Value",
                                        ref=apply_checkbox),
                            ft.ElevatedButton(
                                text="Apply Policy",
                                on_click=apply_policy
                            )
                        ],
                        spacing=5
                    )
                )
            )
        )
    log_action("Policy List View Loaded", f"Total Policies: {len(policies)}")

    return ft.Column(
        controls=[
            # ft.Row(
            #     controls=[ft.TextButton(tab, on_click=on_tab_change)
            #               for tab in filter_tabs],
            #     spacing=10,
            # ),
            # ft.Text("Filtered by: ", size=12),
            selected_tab,
            ft.Column(controls=policy_controls, spacing=10),
        ],
        spacing=15,
    )
