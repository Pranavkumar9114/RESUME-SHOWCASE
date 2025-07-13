import platform
import socket
import psutil
import flet as ft
import win32com.client
import pythoncom

def get_windows_os_info():
    try:
        pythoncom.CoInitialize()
        wmi = win32com.client.Dispatch("WbemScripting.SWbemLocator")
        service = wmi.ConnectServer(".", "root\\cimv2")
        for os in service.ExecQuery("SELECT Caption FROM Win32_OperatingSystem"):
            return os.Caption.strip()
    except Exception:
        return f"{platform.system()} {platform.release()}"
    finally:
        pythoncom.CoUninitialize()

def get_cpu_name():
    try:
        pythoncom.CoInitialize()
        wmi = win32com.client.Dispatch("WbemScripting.SWbemLocator")
        service = wmi.ConnectServer(".", "root\\cimv2")
        cpus = service.ExecQuery("Select Name from Win32_Processor")
        for cpu in cpus:
            return cpu.Name.strip()
    except Exception:
        return platform.processor()
    finally:
        pythoncom.CoUninitialize()

def get_network_interfaces_with_ips():
    interfaces = psutil.net_if_addrs()
    info_lines = []
    for interface_name, addresses in interfaces.items():
        for addr in addresses:
            if addr.family == socket.AF_INET and addr.address != "127.0.0.1":
                info_lines.append((interface_name, addr.address))
    return info_lines

def get_static_system_info():
    info = {
        "Hostname": socket.gethostname(),
        "Operating System": get_windows_os_info(),
        "OS Version": platform.version(),
        "Machine": platform.machine(),
        "Architecture": platform.architecture()[0],
        "Processor": get_cpu_name(),
        "CPU Cores (Physical)": str(psutil.cpu_count(logical=False)),
        "CPU Cores (Logical)": str(psutil.cpu_count(logical=True)),
    }

    battery = psutil.sensors_battery()
    if battery:
        info["Battery Capacity"] = f"{battery.percent}%"

    info_lines = [(key, value) for key, value in info.items()]
    net_info = get_network_interfaces_with_ips()

    return info_lines, net_info

def windows_info_config(page):
    info_lines, net_info = get_static_system_info()

    display_controls = []
    text_color = ft.colors.WHITE if page.theme_mode == ft.ThemeMode.DARK else ft.colors.BLACK
    bg_color = ft.colors.GREY_900 if page.theme_mode == ft.ThemeMode.DARK else ft.colors.GREY_100

    for key, value in info_lines:
        display_controls.append(
            ft.Row([
                ft.Text(f"{key}: ", weight=ft.FontWeight.BOLD, size=14, color=text_color),
                ft.Text(value, size=14, color=text_color),
            ])
        )

    if net_info:
        display_controls.append(
            ft.Text("Network Interfaces:", weight=ft.FontWeight.BOLD, size=14, color=text_color)
        )
        for iface, ip in net_info:
            display_controls.append(
                ft.Text(f"{iface}: {ip}", size=14, color=text_color)
            )

    def copy_to_clipboard(e):
        full_text = "\n".join([f"{key}: {value}" for key, value in info_lines])
        if net_info:
            full_text += "\n\nNetwork Interfaces:\n"
            full_text += "\n".join([f"{iface}: {ip}" for iface, ip in net_info])
        e.page.set_clipboard(full_text)
        e.page.snack_bar = ft.SnackBar(ft.Text("System info copied to clipboard!"), open=True)
        e.page.update()

    return ft.Card(
        content=ft.Container(
            content=ft.Column([
                ft.Row(
                    [
                        ft.Text("System Information", weight=ft.FontWeight.BOLD, size=20, expand=True, color=text_color),
                        ft.IconButton(
                            icon=ft.icons.CONTENT_COPY,
                            tooltip="Copy Info",
                            on_click=copy_to_clipboard,
                            icon_size=18,
                        ),
                    ],
                    alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                ),
                ft.Container(
                    content=ft.Column(
                        controls=display_controls,
                        scroll=ft.ScrollMode.AUTO,
                        expand=True,
                    ),
                    # height=220,
                    bgcolor=bg_color,
                    padding=20,
                    border_radius=6,
                    expand=True,
                )
            ]),
            padding=20,
            width=500,
            bgcolor=ft.colors.SURFACE_VARIANT,
            border_radius=8,
        )
    )
