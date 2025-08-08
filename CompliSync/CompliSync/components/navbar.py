import flet as ft
import psutil
import threading
import time
from config import APP_NAME

class SystemMonitor(ft.Container):
    def __init__(self):
        super().__init__()

        self.cpu_data = [0] * 50
        self.ram_data = [0] * 50
        self.disk_data = [0] * 50

        self.cpu_label = ft.Text("CPU Usage", size=12, weight=ft.FontWeight.BOLD, color=ft.colors.WHITE)
        self.cpu_text = ft.Text("0%", size=12, weight=ft.FontWeight.BOLD, color=ft.colors.WHITE)

        self.ram_label = ft.Text("RAM Usage", size=12, weight=ft.FontWeight.BOLD, color=ft.colors.WHITE)
        self.ram_text = ft.Text("0%", size=12, weight=ft.FontWeight.BOLD, color=ft.colors.WHITE)

        self.disk_label = ft.Text("Disk Usage", size=12, weight=ft.FontWeight.BOLD, color=ft.colors.WHITE)
        self.disk_text = ft.Text("0%", size=12, weight=ft.FontWeight.BOLD, color=ft.colors.WHITE)

        self.cpu_series = ft.LineChartData(stroke_width=2, color=ft.colors.RED)
        self.ram_series = ft.LineChartData(stroke_width=2, color=ft.colors.BLUE)
        self.disk_series = ft.LineChartData(stroke_width=2, color=ft.colors.GREEN)

        self.cpu_chart = self.create_chart(self.cpu_series)
        self.ram_chart = self.create_chart(self.ram_series)
        self.disk_chart = self.create_chart(self.disk_series)

        self.content = ft.Column(
            controls=[
                ft.Row(
                    controls=[
                        self.create_chart_container(self.cpu_label, self.cpu_text, self.cpu_chart),
                        self.create_chart_container(self.ram_label, self.ram_text, self.ram_chart),
                        self.create_chart_container(self.disk_label, self.disk_text, self.disk_chart),
                    ],
                    spacing=20,
                    alignment=ft.MainAxisAlignment.CENTER,
                ),
            ],
            spacing=40,
        )

        self.start_monitoring_thread()

    def create_chart(self, data_series):
        return ft.LineChart(
            data_series=[data_series],
            min_y=0,
            max_y=100,
            animate=True,
            width=100,
            height=30,
        )

    def create_chart_container(self, label, percentage_text, chart):
        return ft.Container(
            content=ft.Column(
                controls=[
                    ft.Column(
                        controls=[label],
                    ),
                    ft.Stack(
                        controls=[
                            chart,
                            ft.Container(
                                content=percentage_text,
                                alignment=ft.alignment.center,
                                width=chart.width, 
                                height=chart.height, 
                                expand=True,
                            ),
                        ],
                        width=chart.width,
                        height=chart.height,
                        expand=True,
                    )
                ],
                spacing=5,
                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                expand=True,
            ),
            padding=10,
            border_radius=10,
            bgcolor=ft.colors.GREY_900
        )

    def start_monitoring_thread(self):
        def update_chart():
            while not hasattr(self, 'page') or self.page is None:
                time.sleep(0.1) 

            while True:
                cpu_usage = psutil.cpu_percent()
                ram_usage = psutil.virtual_memory().percent
                disk_usage = psutil.disk_usage('/').percent

                self.cpu_text.value = f"{cpu_usage:.1f}%"
                self.ram_text.value = f"{ram_usage:.1f}%"
                self.disk_text.value = f"{disk_usage:.1f}%"

                self.cpu_data.append(cpu_usage)
                self.ram_data.append(ram_usage)
                self.disk_data.append(disk_usage)

                self.cpu_data.pop(0)
                self.ram_data.pop(0)
                self.disk_data.pop(0)

                self.cpu_series.data_points = [ft.LineChartDataPoint(i, v) for i, v in enumerate(self.cpu_data)]
                self.ram_series.data_points = [ft.LineChartDataPoint(i, v) for i, v in enumerate(self.ram_data)]
                self.disk_series.data_points = [ft.LineChartDataPoint(i, v) for i, v in enumerate(self.disk_data)]

                self.update()
                time.sleep(1)

        threading.Thread(target=update_chart, daemon=True).start()


def navbar(page, toggle_theme):
    return ft.AppBar(
        toolbar_height=100,
        leading=None,
        automatically_imply_leading=False,
        title=ft.Row(
            controls=[
                ft.Row(
                    controls=[
                        ft.IconButton(
                            icon=ft.icons.MENU,
                            on_click=lambda _: setattr(page.drawer, "open", True) or page.update(),
                        )
                    ],
                    alignment=ft.MainAxisAlignment.START,
                ),
                ft.Row(
                    controls=[
                        ft.Text(APP_NAME, size=24, weight=ft.FontWeight.BOLD),
                        ft.Container(
                            content=SystemMonitor(),
                            width=250,
                            padding=20,
                            alignment=ft.alignment.center,
                        ),
                    ],
                    alignment=ft.MainAxisAlignment.START,
                    expand=True,
                ),
                ft.Row(
                    controls=[
                        # ft.IconButton(icon=ft.icons.NOTIFICATIONS, tooltip="Notifications"),
                        ft.IconButton(icon=ft.icons.BRIGHTNESS_6, tooltip="Toggle Theme", on_click=toggle_theme),
                        # ft.IconButton(icon=ft.icons.SETTINGS, tooltip="Settings"),
                        # ft.IconButton(icon=ft.icons.ACCOUNT_CIRCLE, tooltip="Profile"),
                    ],
                    alignment=ft.MainAxisAlignment.END,
                ),
            ],
            alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
            expand=True,
        ),
    )
