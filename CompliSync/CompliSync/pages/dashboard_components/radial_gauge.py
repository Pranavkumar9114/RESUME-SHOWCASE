import flet as ft

def radial_gauge(name, tooltip_text, value, color):
    return ft.Container(
        padding=20,
        bgcolor=ft.colors.SURFACE_VARIANT,
        border_radius=ft.border_radius.all(12),
        content=ft.Column(
            [
                ft.Row(
                    controls=[
                        ft.Text(name, size=20, weight=ft.FontWeight.BOLD),
                        ft.IconButton(
                            icon=ft.icons.INFO_OUTLINE,
                            tooltip=tooltip_text,
                            icon_size=16,
                            style=ft.ButtonStyle(
                                padding=0,
                                shape=ft.RoundedRectangleBorder(radius=8),
                            )
                        )
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                ),
                ft.Stack(
                    controls=[
                        ft.ProgressRing(
                            value=value / 100,
                            width=120,
                            height=120,
                            color=color,
                            stroke_width=10,
                        ),
                        ft.Text(
                            f"{value}%",
                            size=18,
                            weight=ft.FontWeight.BOLD,
                            text_align=ft.TextAlign.CENTER
                        ),
                    ],
                    alignment=ft.alignment.center,
                )
            ],
            alignment=ft.MainAxisAlignment.CENTER,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        ),
        expand=True,
    )
