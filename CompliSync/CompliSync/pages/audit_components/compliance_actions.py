import flet as ft
import subprocess
import os
import time
from utils.logger import log_action

# Global variables
run_compliance_button = None
apply_policies_button = None
compliance_status_text = None  # New global text field

def compliance_actions(page):
    global run_compliance_button, apply_policies_button, compliance_status_text

    def run_compliance(e):
        script_path = os.path.join(os.getcwd(), "scripts", "run_as_admin.py")

        if not os.path.exists(script_path):
            page.snack_bar = ft.SnackBar(ft.Text("Error: Compliance script not found!"), open=True)
            log_action("Compliance Check Error", "Script not found")
            return

        run_compliance_button.disabled = True
        compliance_status_text.value = ""  # Clear previous status
        page.update()

        try:
            subprocess.run(["python", script_path], check=True)
            time.sleep(30)

            import scripts.policy_log_extractor
            import scripts.policy_log_formattor

            log_action("Compliance Check Completed", "Executed with admin privileges")
            compliance_status_text.value = "✅ Compliance Passed"
            page.snack_bar = ft.SnackBar(ft.Text("Compliance check started as administrator."), open=True)

        except subprocess.CalledProcessError as ex:
            log_action("Compliance Check Failed", str(ex))
            compliance_status_text.value = "❌ Compliance Failed"
            page.snack_bar = ft.SnackBar(ft.Text("Compliance check failed. Check logs for details."), open=True)

        run_compliance_button.disabled = False
        page.update()

    def apply_selected_policies(e):
        print("Applying Selected Policies...")

    run_compliance_button = ft.ElevatedButton(
        content=ft.Container(
            content=ft.Text("Start Audit", size=16),
            padding=ft.padding.all(10)  # Adds padding around the text inside the button
        ),
        disabled=True,
        on_click=run_compliance
    )

    apply_policies_button = ft.ElevatedButton(
        content=ft.Container(
            content=ft.Text("Apply Selected Policies", size=16),
            padding=ft.padding.all(10)  # Adds padding around the text inside the button
        ),
        disabled=True,
        on_click=apply_selected_policies
    )

    compliance_status_text = ft.Text("", size=16, color=ft.colors.GREEN_700, text_align=ft.TextAlign.CENTER)

    return ft.Column(
        controls=[
            ft.Row(
                controls=[run_compliance_button],
                alignment=ft.MainAxisAlignment.CENTER,
                spacing=10,
            ),
            compliance_status_text  # Added status text here
        ],
        spacing=20,
        alignment=ft.MainAxisAlignment.CENTER,
    )

def update_compliance_buttons_state(enabled):
    if run_compliance_button and apply_policies_button:
        run_compliance_button.disabled = not enabled
        apply_policies_button.disabled = not enabled
