import flet as ft
from config import config

def main(page: ft.Page):
    config(page)
    from config import APP_NAME
    from components.navbar import navbar
    from components.sidebar import sidebar
    from pages.dashboard import dashboard
    from pages.audit import audit
    from pages.help import help
    from pages.settings import settings
    from pages.report import reports
    from pages.information import information
    from utils.logger import log_action

    log_action("App Initialized")
    page.title = f"{APP_NAME}"

    stored_theme = page.client_storage.get("theme_mode")
    if stored_theme == "dark":
        page.theme_mode = ft.ThemeMode.DARK
    else:
        page.theme_mode = ft.ThemeMode.LIGHT

    def toggle_theme(e):
        """Toggle theme and refresh page contents."""
        page.theme_mode = (
            ft.ThemeMode.DARK if page.theme_mode == ft.ThemeMode.LIGHT else ft.ThemeMode.LIGHT
        )
        page.client_storage.set("theme_mode", "dark" if page.theme_mode == ft.ThemeMode.DARK else "light")

        page.update()
        refresh_current_page()

    page.appbar = navbar(page, toggle_theme)

    drawer = sidebar()
    page.drawer = drawer

    content_area = ft.Column(expand=True)
    page.add(content_area)

    def change_page(e):
        """Handles page switching."""
        selected_index = drawer.selected_index
        log_action("Page Navigation", f"Selected Index: {selected_index}")

        content_area.controls.clear()
        if selected_index == 0:
            content_area.controls.append(dashboard(page))
        elif selected_index == 1:
            content_area.controls.append(audit(page))
        elif selected_index == 2:
            content_area.controls.append(reports(page))
        elif selected_index == 3:
            content_area.controls.append(information(page))
        # elif selected_index == 4:
        #     content_area.controls.append(settings())
        elif selected_index == 4:
            content_area.controls.append(help())

        page.drawer.open = False
        page.update()

    def refresh_current_page():
        """Force reloading the current page to update UI elements."""
        change_page(None) 

    drawer.on_change = change_page
    page.change_page = change_page 

    drawer.selected_index = 0  
    change_page(None) 

    page.update()

ft.app(target=main)
