import flet as ft

# Statistical Pie Chart Function with Dummy Data
def statistical_pie_chart():
    # Dummy Data for Pie Chart (Compliance Tools Stats)
    pie_data = [
        ("Tool A", 35),
        ("Tool B", 25),
        ("Tool C", 20),
        ("Tool D", 10),
        ("Tool E", 10)
    ]

    return ft.Container(
        width=200,
        height=200,
        bgcolor=ft.colors.SURFACE_VARIANT,
        padding=15,
        content=ft.Column(
            controls=[
                ft.Text("Compliance Tools", size=14),
                ft.PieChart(
                    data=pie_data,
                    width=160,
                    height=120,
                ),
            ],
            alignment=ft.MainAxisAlignment.CENTER,
        ),
        border_radius=ft.border_radius.all(12),
    )
