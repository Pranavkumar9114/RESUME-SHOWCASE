import flet as ft
from components.navbar import navbar
from components.sidebar import sidebar
from pages.dashboard import dashboard
from pages.audit import audit
from pages.help import help
from pages.settings import settings
from pages.report import reports
from pages.information import information
from config import APP_DATA_DIR, APP_LOG_DIR, APP_NAME
from utils.logger import log_action
log_action("App Initialized")


def main(page: ft.Page):
    page.title = f"{APP_NAME} - Compliance Dashboard"
    page.client_storage.set("app_data_dir", APP_DATA_DIR)
    page.client_storage.set("log_dir", APP_LOG_DIR)

    stored_theme = page.client_storage.get("theme_mode")
    if stored_theme == "dark":
        page.theme_mode = ft.ThemeMode.DARK
    else:
        page.theme_mode = ft.ThemeMode.LIGHT

    def toggle_theme(e):
        page.theme_mode = (
            ft.ThemeMode.DARK if page.theme_mode == ft.ThemeMode.LIGHT else ft.ThemeMode.LIGHT
        )
        page.client_storage.set("theme_mode", "dark" if page.theme_mode == ft.ThemeMode.DARK else "light")
        page.update()
        rebuild_dashboard()

    page.appbar = navbar(page, toggle_theme)

    drawer = sidebar()
    page.drawer = drawer

    content_area = ft.Column(expand=True)
    page.add(content_area)

    def rebuild_dashboard():
        content_area.controls.clear()
        content_area.controls.append(dashboard(page))
        page.update()

    def change_page(e):
        selected_index = drawer.selected_index
        log_action("Page Navigation", f"Selected Index: {selected_index}")
        content_area.controls.clear()

        if selected_index == 0:
            content_area.controls.append(dashboard(page))
        elif selected_index == 1:
            content_area.controls.append(audit(page))
        elif selected_index == 2:
            content_area.controls.append(reports())
        elif selected_index == 3:
            content_area.controls.append(information())
        elif selected_index == 4:
            content_area.controls.append(settings())
        elif selected_index == 5:
            content_area.controls.append(help())

        page.drawer.open = False
        page.update()

    drawer.on_change = change_page
    rebuild_dashboard() 
    page.update()

ft.app(target=main)
