import flet as ft


def sidebar():
    return ft.NavigationDrawer(
        on_change=lambda e: print(
            f"Selected index: {e.control.selected_index}"),  # Debugging
        controls=[
            ft.Text("", size=12, weight=ft.FontWeight.BOLD),
            ft.Container(height=30),
            ft.NavigationDrawerDestination(icon=ft.icons.DASHBOARD, label="Dashboard"),
            ft.Container(height=10),
            ft.NavigationDrawerDestination(icon=ft.icons.ANALYTICS, label="Compliance & Audit"),
            ft.Container(height=10),
            ft.NavigationDrawerDestination(icon=ft.icons.ASSESSMENT, label="Reports"),
            ft.Container(height=10),
            ft.NavigationDrawerDestination(icon=ft.icons.INFO, label="Information"),
            ft.Container(height=10),
            # ft.NavigationDrawerDestination(icon=ft.icons.SETTINGS, label="Settings"),
            # ft.Container(height=10),
            ft.NavigationDrawerDestination(icon=ft.icons.HELP, label="Help"),
        ],
    )
