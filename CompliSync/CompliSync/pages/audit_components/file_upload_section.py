import flet as ft
import os
import shutil
from utils.logger import log_action
from config import UPLOADS_DIR, EXTRACTED_POLICIES_DIR
import logging
from utils.extract_policy_data import extract_policies_from_pdf
from pages.audit_components.compliance_actions import update_compliance_buttons_state

def file_upload_section(page):
    uploaded_file_text = ft.Text(visible=False, size=14)
    star = ft.Text("*", size=16, weight=ft.FontWeight.BOLD)
    help_text = ft.Text("To Download PDF Go To Help Page", size=14,)

    last_pdf_file_path = page.client_storage.get("last_uploaded_file_path")
    json_path = page.client_storage.get("extracted_json_path")
    
    upload_button = ft.ElevatedButton(
        content=ft.Container(
            content=ft.Text("Upload CIS PDF", size=16),
            padding=ft.padding.all(10) 
        ),
        on_click=None
    )

    last_file_button = ft.ElevatedButton(
        content=ft.Container(
            content=ft.Text("Use Last Uploaded File", size=16),
            padding=ft.padding.all(10)  
        ),
        on_click=None,
        visible=False
    )

    fetch_drive_button = ft.ElevatedButton(
        content=ft.Container(
            content=ft.Text("Fetch from Drive", size=16),
            padding=ft.padding.all(10)  
        ),
        on_click=None
    )

    file_picker = ft.FilePicker(on_result=lambda e: handle_file_result(e))
    page.overlay.append(file_picker)

    def handle_file_result(e):
        """Handles file selection and extraction process."""
        try:
            if e.files and e.files[0].name.lower().endswith(".pdf"):
                disable_buttons(True)

                src_path = e.files[0].path
                dest_path = os.path.join(UPLOADS_DIR, e.files[0].name)

                shutil.copy(src_path, dest_path)
                file_name = os.path.basename(dest_path)

                uploaded_file_text.value = f"File uploaded: {file_name}\nExtracting policies from PDF..."
                uploaded_file_text.visible = True
                page.client_storage.set("last_uploaded_file_path", dest_path)
                update_last_file_button(dest_path)
                log_action("File Uploaded", e.files[0].name)
                page.update()

                extract_policies(dest_path)

            else:
                uploaded_file_text.value = "Please select a valid PDF file."
                uploaded_file_text.visible = True
                log_action("Invalid File Upload Attempt")

            page.update()
        except Exception as ex:
            logging.error("Error during file upload", exc_info=True)
        finally:
            disable_buttons(False)

    def upload_file(e):
        """Triggers file picker to select a PDF."""
        disable_buttons(True)
        file_picker.pick_files(allow_multiple=False, allowed_extensions=["pdf"])

    def fetch_from_drive(e):
        """Simulates fetching a file from drive."""
        disable_buttons(True)
        uploaded_file_text.value = "Fetching file from drive..."
        uploaded_file_text.visible = True
        page.update()
        log_action("Fetch from Drive Triggered")
        disable_buttons(False)

    def use_last_file(e):
        """Handles clicking 'Use Last Uploaded File' button."""
        disable_buttons(True)

        if json_path and os.path.isfile(json_path):
            file_name = os.path.basename(json_path)

            uploaded_file_text.value = f"Using last uploaded file: {file_name}\nExtracting policies from PDF..."
            uploaded_file_text.visible = True
            update_compliance_buttons_state(True)
            page.update()
            log_action("Used Last Extracted Uploaded File", json_path)

        else:
            uploaded_file_text.value = "Error: Last Extracted file not found. Please upload a new PDF."
            uploaded_file_text.visible = True
            page.update()
            log_action("Last Extracted File Not Found")

        disable_buttons(False)

    def extract_policies(pdf_path):
        """Runs policy extraction and updates UI."""
        try:
            file_name = os.path.splitext(os.path.basename(pdf_path))[0]
            extracted_file_path = os.path.join(EXTRACTED_POLICIES_DIR, f"{file_name}_policies.json")

            page.client_storage.set("extracted_json_path", extracted_file_path)
            page.client_storage.set("json_dest_path", extracted_file_path)

            extract_policies_from_pdf(pdf_path, extracted_file_path)

            if os.path.isfile(extracted_file_path):
                uploaded_file_text.value = f"File uploaded: {file_name}\nPolicies extracted successfully."
                log_action("Policy Extraction Success", extracted_file_path)
                
                update_compliance_buttons_state(True)
            else:
                uploaded_file_text.value = "Error: Policy extraction failed. Please upload a valid PDF."
                log_action("Policy Extraction Failed", file_name)

        except Exception as ex:
            logging.error("Error during policy extraction", exc_info=True)
            uploaded_file_text.value = "Error during policy extraction."
            log_action("Policy Extraction Script Error", str(ex))

        uploaded_file_text.visible = True
        disable_buttons(False)
        page.update()

    def disable_buttons(disabled):
        """Enable or disable buttons during processing."""
        upload_button.disabled = disabled
        last_file_button.disabled = disabled
        fetch_drive_button.disabled = disabled
        page.update()

    def update_last_file_button(path):
        """Update the last uploaded file button visibility."""
        last_file_button.visible = True
        page.update()

    upload_button.on_click = upload_file
    fetch_drive_button.on_click = fetch_from_drive

    if json_path and os.path.isfile(json_path):
        last_file_button.on_click = use_last_file
        last_file_button.visible = True

    return ft.Column(
        controls=[
            ft.Row(
                controls=[star, help_text],
                alignment=ft.MainAxisAlignment.START,
                spacing=10,
            ),
            ft.Row(
                controls=[upload_button, last_file_button],
                alignment=ft.MainAxisAlignment.CENTER,
                spacing=20,
            ),
            ft.Row(
                controls=[uploaded_file_text],
                alignment=ft.MainAxisAlignment.CENTER,
            ),
            # ft.Row(
            #     controls=[ft.Text("OR", weight=ft.FontWeight.BOLD)],
            #     alignment=ft.MainAxisAlignment.CENTER,
            # ),
            # ft.Row(
            #     controls=[fetch_drive_button],
            #     alignment=ft.MainAxisAlignment.CENTER,
            # ),
        ],
        spacing=20,
        alignment=ft.MainAxisAlignment.CENTER,
    )
