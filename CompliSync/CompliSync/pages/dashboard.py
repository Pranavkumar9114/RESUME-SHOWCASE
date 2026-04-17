import flet as ft
from pages.dashboard_components.radial_gauge import radial_gauge
from pages.dashboard_components.statistical_pie_chart import statistical_pie_chart
from pages.dashboard_components.weekly_candle_chart import weekly_candle_chart
from pages.dashboard_components.window_info_config import windows_info_config
from pages.dashboard_components.calculate_score import calculate_scores
from datetime import datetime

def dashboard(page):
    calculate_scores(page)

    compliance_score = page.client_storage.get("compliance_score")
    audit_score = page.client_storage.get("audit_score")
    risk_score = page.client_storage.get("risk_score")

    show_compliance_passed = (compliance_score != 0 or audit_score != 0)

    def get_current_datetime():
        return datetime.now().strftime("%Y-%m-%d %H:%M")

    def hide_container(e):
        compliance_passed_container.visible = False
        e.page.update()

    compliance_passed_container = ft.Container(
        content=ft.Row(
            controls=[
                ft.Text(get_current_datetime(), size=12, color=ft.colors.GREEN_900), 
                ft.Container(
                    content=ft.Text("✅ Compliance Passed", size=18, color=ft.colors.GREEN_700),
                    alignment=ft.alignment.center,
                    expand=True
                ), 
                ft.IconButton(
                    icon=ft.icons.DELETE_OUTLINE,
                    icon_color=ft.colors.RED,
                    tooltip="Delete",
                    on_click=hide_container
                )  
            ],
            alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
            vertical_alignment=ft.CrossAxisAlignment.CENTER
        ),
        padding=10,
        bgcolor=ft.colors.GREEN_100,
        border_radius=10,
        alignment=ft.alignment.center,
        visible=show_compliance_passed
    )

    return ft.Container(
        expand=True,
        padding=20,
        content=ft.Column(
            controls=[
                ft.Container(
                    content=ft.Text(
                        "Dashboard",
                        size=32,
                        weight=ft.FontWeight.BOLD,
                    ),
                    # padding=20,
                ),
                ft.Column(
                    controls=[
                        ft.Row(
                            controls=[
                                radial_gauge("Compliance Score", "Indicates how well the current policies align with the recommended standards. Higher values mean better alignment with the best practices.", compliance_score, "green"),
                                radial_gauge("Audit Score", "Shows how well the system is auditing policy implementation, comparing updated values with recommended policy standards. Higher values indicate fewer discrepancies.", audit_score, "orange"),
                                radial_gauge("Risk Score", "Represents the overall risk level due to non-compliance. The higher the score, the greater the potential risk to the system's integrity.", risk_score, "black"),
                            ],
                            alignment=ft.MainAxisAlignment.CENTER,
                            spacing=20,
                            expand=True
                        ),
                        ft.Row(
                            controls=[
                                ft.Container(
                                    content=windows_info_config(page),
                                    expand=True,
                                    height=350,
                                ),
                                ft.Container(
                                    content=weekly_candle_chart(page),
                                    expand=True,
                                    height=350,
                                ),
                            ],
                            alignment=ft.MainAxisAlignment.CENTER,
                            spacing=20,
                            expand=True,
                        ),
                        compliance_passed_container  
                    ],
                    spacing=20,
                    alignment=ft.MainAxisAlignment.START,
                    scroll="auto",
                    expand=True,
                ),
            ],
            alignment=ft.MainAxisAlignment.START,
        ),
    )
