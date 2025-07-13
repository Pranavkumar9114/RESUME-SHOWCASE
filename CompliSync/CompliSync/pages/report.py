import flet as ft
import os
import json
import csv
from datetime import datetime
from config import POLICY_LOG_FOLDER
from pages.dashboard_components.radial_gauge import radial_gauge

compliance_score = 0
audit_score = 0
risk_score = 0

def reports(page: ft.Page):
    global compliance_score, audit_score, risk_score

    # Text controls for displaying logs
    log_text = ft.Text("Compliance Log:", size=20, weight=ft.FontWeight.BOLD)
    log_content = ft.Text(selectable=True, size=16)

    # Dropdowns for date and time selection
    date_dropdown = ft.Dropdown(label="Select Date", on_change=lambda e: update_time_dropdown(), text_size=16)
    time_dropdown = ft.Dropdown(label="Select Time", on_change=lambda e: load_selected_report(), text_size=16)

    # File picker instance
    file_picker = ft.FilePicker(on_result=lambda e: save_exported_file(e.path))
    page.overlay.append(file_picker)

    # Keep track of format selected and data to export
    export_format = {"format": None}
    current_data = {}

    # Buttons for exporting
    export_csv_button = ft.ElevatedButton(
        content=ft.Container(
            content=ft.Text("Export CSV", size=16),
            padding=ft.padding.all(10)  # Adds padding around the text inside the button
        ),
        on_click=lambda e: ask_save_path("csv")
    )

    export_json_button = ft.ElevatedButton(
        content=ft.Container(
            content=ft.Text("Export JSON", size=16),
            padding=ft.padding.all(10)  # Adds padding around the text inside the button
        ),
        on_click=lambda e: ask_save_path("json")
    )

    # export_csv_button = ft.ElevatedButton("Export CSV", on_click=lambda e: ask_save_path("csv"))
    # export_json_button = ft.ElevatedButton("Export JSON", on_click=lambda e: ask_save_path("json"))

    def calculate_scores(json_path):
        global compliance_score, audit_score, risk_score
        try:
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

    # Function to parse filenames and extract datetime
    def parse_filename(filename):
        try:
            timestamp_str = filename.replace("policy_log_", "").replace(".json", "")
            return datetime.strptime(timestamp_str, "%Y-%m-%d_%H-%M-%S")
        except ValueError:
            return None

    # Function to get all report files
    def get_report_files():
        files = []
        for fname in os.listdir(POLICY_LOG_FOLDER):
            if fname.startswith("policy_log_") and fname.endswith(".json"):
                dt = parse_filename(fname)
                if dt:
                    files.append((dt, fname))
        return sorted(files, key=lambda x: x[0], reverse=True)

    # Function to update date dropdown
    def update_date_dropdown():
        files = get_report_files()
        dates = sorted(set(dt.strftime("%Y-%m-%d") for dt, _ in files), reverse=True)
        date_dropdown.options = [ft.dropdown.Option(date) for date in dates]
        if dates:
            stored_date = page.client_storage.get("report_selected_date")
            if stored_date in dates:
                date_dropdown.value = stored_date
                page.client_storage.remove("report_selected_date")  # optional clear
            else:
                date_dropdown.value = dates[0]
            update_time_dropdown()

    # Function to update time dropdown based on selected date
    def update_time_dropdown():
        selected_date = date_dropdown.value
        files = get_report_files()
        times = [dt.strftime("%H-%M-%S") for dt, _ in files if dt.strftime("%Y-%m-%d") == selected_date]
        time_dropdown.options = [ft.dropdown.Option(time) for time in times]
        if times:
            time_dropdown.value = times[0]
            load_selected_report()

    gauge_row = ft.Column()

    # Function to load and display the selected report
    def load_selected_report():
        global compliance_score, audit_score, risk_score

        selected_date = date_dropdown.value
        selected_time = time_dropdown.value
        if not selected_date or not selected_time:
            log_content.value = "Please select both date and time."
            page.update()
            return

        filename = f"policy_log_{selected_date}_{selected_time}.json"
        file_path = os.path.join(POLICY_LOG_FOLDER, filename)

        calculate_scores(file_path)

        # Rebuild the gauge row with new scores
        gauge_row.controls = [
            ft.Row(
                controls=[
                    radial_gauge("Compliance Score", "Indicates how well the current policies align with the recommended standards. Higher values mean better alignment with the best practices.", compliance_score, "green"),
                    radial_gauge("Audit Score", "Shows how well the system is auditing policy implementation, comparing updated values with recommended policy standards. Higher values indicate fewer discrepancies.", audit_score, "orange"),
                    radial_gauge("Risk Score", "Represents the overall risk level due to non-compliance. The higher the score, the greater the potential risk to the system's integrity.", risk_score, "black"),
                ],
                spacing=20
            )
        ]

        if os.path.exists(file_path):
            with open(file_path, "r", encoding="utf-8") as file:
                data = json.load(file)
                current_data.clear()
                current_data.update(data)
                log_content.value = json.dumps(data, indent=4)
        else:
            current_data.clear()
            log_content.value = "Selected report file not found."

        page.update()

    # Ask user where to save file
    def ask_save_path(fmt):
        if not current_data:
            page.snack_bar = ft.SnackBar(ft.Text("No report loaded to export."))
            page.snack_bar.open = True
            page.update()
            return
        export_format["format"] = fmt
        suggested_name = f"exported_report_{date_dropdown.value}_{time_dropdown.value}.{fmt}"
        file_picker.save_file(file_name=suggested_name)

    # Save to selected file
    def save_exported_file(path):
        fmt = export_format["format"]
        if not path or not fmt or not current_data:
            return
        try:
            if fmt == "json":
                with open(path, "w", encoding="utf-8") as f:
                    json.dump(current_data, f, indent=4)
            elif fmt == "csv":
                with open(path, "w", newline='', encoding="utf-8") as f:
                    writer = csv.writer(f)
                    writer.writerow(["Key", "Value"])
                    for key, value in current_data.items():
                        writer.writerow([key, json.dumps(value) if isinstance(value, (dict, list)) else value])
            page.snack_bar = ft.SnackBar(ft.Text(f"Report exported as {fmt.upper()}"))
            page.snack_bar.open = True
        except Exception as e:
            page.snack_bar = ft.SnackBar(ft.Text(f"Error exporting: {str(e)}"))
            page.snack_bar.open = True
        page.update()

    # Initialize dropdowns
    update_date_dropdown()

    gauge_row.controls = [
        ft.Row(
            controls=[
                radial_gauge("Compliance Score", "Indicates how well the current policies align with the recommended standards. Higher values mean better alignment with the best practices.", compliance_score, "green"),
                radial_gauge("Audit Score", "Shows how well the system is auditing policy implementation, comparing updated values with recommended policy standards. Higher values indicate fewer discrepancies.", audit_score, "orange"),
                radial_gauge("Risk Score", "Represents the overall risk level due to non-compliance. The higher the score, the greater the potential risk to the system's integrity.", risk_score, "black"),
            ],
            spacing=20
        )
    ]

    # Return the layout
    return ft.Container(
        ft.Column(
            controls=[
                ft.Text("Reports", size=32, weight=ft.FontWeight.BOLD),
                ft.Row(
                    controls=[
                        date_dropdown,
                        time_dropdown,
                        ft.Container(  # Push export buttons to the right
                            content=ft.Row(
                                controls=[export_json_button, export_csv_button],
                                spacing=10,
                                alignment=ft.MainAxisAlignment.END
                            ),
                            expand=True
                        )
                    ],
                    spacing=20
                ),
                gauge_row,
                ft.Row(
                    controls=[
                        ft.Container(
                            content=ft.Column([log_text, log_content], scroll=ft.ScrollMode.AUTO),
                            padding=10,
                            border=ft.border.all(1),
                            expand=True,
                            height=500
                        )
                    ],
                    expand=True,
                ),
            ],
            expand=True,
            spacing=20,
            scroll=ft.ScrollMode.AUTO,
        ),
        padding=20,
        expand=True,
    )

