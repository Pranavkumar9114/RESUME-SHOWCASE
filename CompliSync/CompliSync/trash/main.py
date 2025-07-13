import flet as ft


def main(page: ft.Page):
    page.title = "Dashboard"
    page.theme_mode = ft.ThemeMode.LIGHT  # Toggle between LIGHT and DARK
    page.drawer = ft.NavigationDrawer(
        controls=[
            ft.NavigationDrawerDestination(
                icon=ft.icons.DASHBOARD, label="Dashboard"),
            ft.NavigationDrawerDestination(
                icon=ft.icons.ANALYTICS, label="Analytics"),
            ft.NavigationDrawerDestination(
                icon=ft.icons.SETTINGS, label="Settings"),
        ]
    )

    def toggle_theme(e):
        page.theme_mode = (
            ft.ThemeMode.DARK if page.theme_mode == ft.ThemeMode.LIGHT else ft.ThemeMode.LIGHT
        )
        page.update()

    # Navigation bar with icons
    navbar = ft.AppBar(
        leading=ft.IconButton(
            icon=ft.icons.MENU,
            on_click=lambda _: setattr(
                page.drawer, "open", True) or page.update(),
        ),
        title=ft.Text("Dashboard", size=20, weight=ft.FontWeight.BOLD),
        actions=[
            ft.IconButton(icon=ft.icons.NOTIFICATIONS,
                          tooltip="Notifications"),
            ft.IconButton(icon=ft.icons.BRIGHTNESS_6,
                          tooltip="Toggle Theme", on_click=toggle_theme),
            ft.IconButton(icon=ft.icons.SETTINGS, tooltip="Settings"),
            ft.IconButton(icon=ft.icons.ACCOUNT_CIRCLE, tooltip="Profile"),
        ],
    )

    # System Monitor - Placeholder Graph
    system_monitor = ft.Container(
        content=ft.Text("System Monitor Graph", size=16),
        alignment=ft.alignment.center,
        height=50,
        bgcolor=ft.colors.BLUE_100,
        border_radius=10,
        padding=10,
    )

    # KPI Performance Indicators
    kpi_section = ft.Row(
        [
            ft.Container(
                content=ft.Text("72% Audit Score", size=16),
                bgcolor=ft.colors.GREEN_100,
                border_radius=10,
                padding=10,
                expand=1,
            ),
            ft.Container(
                content=ft.Text("46% Severity", size=16),
                bgcolor=ft.colors.RED_100,
                border_radius=10,
                padding=10,
                expand=1,
            ),
            ft.Container(
                content=ft.Text("95% Compliance", size=16),
                bgcolor=ft.colors.BLUE_100,
                border_radius=10,
                padding=10,
                expand=1,
            ),
        ],
        alignment=ft.MainAxisAlignment.SPACE_AROUND,
    )

    # Weekly Revenue & Statistics
    revenue_chart = ft.Container(
        content=ft.Text("Weekly Revenue Chart"),
        bgcolor=ft.colors.BLUE_200,
        height=200,
        expand=1,
        border_radius=10,
        padding=10,
    )

    statistics_chart = ft.Container(
        content=ft.Text("Statistics Pie Chart"),
        bgcolor=ft.colors.PURPLE_200,
        height=200,
        expand=1,
        border_radius=10,
        padding=10,
    )

    # Compliance Category & System Info
    compliance_card = ft.Container(
        content=ft.Text("Category-based Compliance"),
        bgcolor=ft.colors.ORANGE_200,
        height=150,
        expand=1,
        border_radius=10,
        padding=10,
    )

    system_info_card = ft.Container(
        content=ft.Text("System Info Popup"),
        bgcolor=ft.colors.GREY_300,
        height=150,
        expand=1,
        border_radius=10,
        padding=10,
    )

    # Workflows Table
    workflow_table = ft.Container(
        content=ft.Text("Workflows Table - Reports & Status"),
        bgcolor=ft.colors.GREY_200,
        height=150,
        border_radius=10,
        padding=10,
    )

    # Calendar
    calendar_section = ft.Container(
        content=ft.Text("Calendar for Compliance Tracking"),
        bgcolor=ft.colors.CYAN_200,
        height=150,
        border_radius=10,
        padding=10,
    )

    # Layout
    page.add(
        navbar,
        system_monitor,
        kpi_section,
        ft.Row([revenue_chart, statistics_chart], expand=1),
        ft.Row([compliance_card, system_info_card], expand=1),
        workflow_table,
        calendar_section,
    )


ft.app(target=main)
