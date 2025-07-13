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

    # Navbar with theme toggle function
    def toggle_theme(e):
        """Toggle theme and refresh page contents."""
        page.theme_mode = (
            ft.ThemeMode.DARK if page.theme_mode == ft.ThemeMode.LIGHT else ft.ThemeMode.LIGHT
        )
        page.client_storage.set("theme_mode", "dark" if page.theme_mode == ft.ThemeMode.DARK else "light")

        page.update()
        # Refresh current page to apply theme to all widgets
        refresh_current_page()

    page.appbar = navbar(page, toggle_theme)

    # Sidebar
    drawer = sidebar()
    # page.change_page = change_page  # Expose for use in components like calendar
    page.drawer = drawer

    # Content Area
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
        change_page(None)  # Reload the current page

    drawer.on_change = change_page
    page.change_page = change_page  # Expose for use in components like calendar

    # Always open Dashboard when the app starts
    drawer.selected_index = 0  
    change_page(None)  # Render Dashboard

    page.update()

ft.app(target=main)
