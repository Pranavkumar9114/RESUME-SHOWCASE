import flet as ft
from pages.audit_components.file_upload_section import file_upload_section
from pages.audit_components.compliance_actions import compliance_actions
from pages.audit_components.policy_list_view import policy_list_view

def audit(page):
    return ft.Container(
        expand=True,
        padding=20,
        content=ft.Column(
            controls=[
                ft.Text("Compliance & Audit", size=32, weight=ft.FontWeight.BOLD),
                ft.Divider(),
                file_upload_section(page),
                ft.Divider(),
                compliance_actions(page),
                ft.Divider(),
                policy_list_view(page),
            ],
            scroll="auto",
        )
    )
