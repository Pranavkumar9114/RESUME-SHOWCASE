import ctypes
import subprocess
import sys
import os

def run_powershell_as_admin(script_path):
    """Runs a PowerShell script with administrator privileges."""
    if not os.path.exists(script_path):
        print("Error: Script not found!")
        sys.exit(1)

    command = f'powershell -ExecutionPolicy Bypass -File "{script_path}"'

    try:
        ctypes.windll.shell32.ShellExecuteW(None, "runas", "cmd.exe", f"/c {command}", None, 1)
    except Exception as e:
        print(f"Failed to run as admin: {e}")

if __name__ == "__main__":
    script_path = os.path.join(os.getcwd(), "scripts", "multiple_policy", "multiple.ps1")
    run_powershell_as_admin(script_path)
