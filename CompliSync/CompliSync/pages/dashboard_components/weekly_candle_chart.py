import flet as ft
import calendar
from datetime import datetime
import os
from config import POLICY_LOG_FOLDER


def weekly_candle_chart(page):
    today = datetime.today()
    current_year = today.year
    current_month = today.month

    # Parse report log dates
    def get_report_dates():
        reports = {}
        for fname in os.listdir(POLICY_LOG_FOLDER):
            if fname.startswith("policy_log_") and fname.endswith(".json"):
                try:
                    timestamp_str = fname.replace("policy_log_", "").replace(".json", "")
                    dt = datetime.strptime(timestamp_str, "%Y-%m-%d_%H-%M-%S")
                    date_str = dt.strftime("%Y-%m-%d")
                    if date_str not in reports:
                        reports[date_str] = []
                    reports[date_str].append(dt)
                except ValueError:
                    continue
        return reports

    report_dates = get_report_dates()
    report_date_keys = set(datetime.strptime(d, "%Y-%m-%d").date() for d in report_dates)

    # Calendar layout
    month_label = ft.Text(f"{calendar.month_name[current_month]} {current_year}", size=18, weight=ft.FontWeight.BOLD)
    days_grid = ft.Column(spacing=5)

    def navigate_to_report(date_str: str):
        page.client_storage.set("report_selected_date", date_str)
        page.drawer.selected_index = 2  # Go to reports
        page.change_page(None)  # Trigger refresh to switch page

    def update_calendar(year, month):
        month_label.value = f"{calendar.month_name[month]} {year}"
        days_grid.controls.clear()

        # Weekday headers
        days_grid.controls.append(ft.Row([
            ft.Text(day, size=16, weight=ft.FontWeight.BOLD)
            for day in ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        ], alignment=ft.MainAxisAlignment.CENTER))

        # Day cells
        for week in calendar.monthcalendar(year, month):
            row = []
            for day in week:
                if day == 0:
                    # Empty cell
                    row.append(ft.Container(width=30, height=30))
                    continue

                this_date = datetime(year, month, day).date()
                is_today = this_date == today.date()
                has_report = this_date in report_date_keys
                date_str = this_date.strftime("%Y-%m-%d")

                content = ft.Text(str(day), size=16)
                bg_color = (
                    ft.colors.BLUE_300 if has_report else
                    ft.colors.GREEN if is_today else None
                )

                container = ft.Container(
                    content=content,
                    width=30,
                    height=30,
                    alignment=ft.alignment.center,
                    bgcolor=bg_color,
                    border=ft.border.all(1, ft.colors.OUTLINE_VARIANT),
                    border_radius=5,
                    on_click=(lambda e, ds=date_str: navigate_to_report(ds)) if has_report else None,
                    ink=True
                )
                row.append(container)

            days_grid.controls.append(ft.Row(row, alignment=ft.MainAxisAlignment.CENTER))

        page.update()

    # Navigation
    def change_month(offset):
        nonlocal current_year, current_month
        current_month += offset
        if current_month > 12:
            current_month = 1
            current_year += 1
        elif current_month < 1:
            current_month = 12
            current_year -= 1
        update_calendar(current_year, current_month)

    prev_button = ft.IconButton(ft.icons.ARROW_BACK, on_click=lambda e: change_month(-1))
    next_button = ft.IconButton(ft.icons.ARROW_FORWARD, on_click=lambda e: change_month(1))

    update_calendar(current_year, current_month)

    return ft.Container(
        # width=250,
        # height=300,
        bgcolor=ft.colors.SURFACE_VARIANT,
        padding=20,
        content=ft.Column(
            controls=[
                ft.Row([prev_button, month_label, next_button], alignment=ft.MainAxisAlignment.CENTER),
                days_grid
            ],
            alignment=ft.MainAxisAlignment.CENTER,
            expand=True,
        ),
        border_radius=ft.border_radius.all(12),
        expand=True,
    )
