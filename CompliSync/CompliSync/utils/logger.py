import os
import logging
from datetime import datetime
from config import APP_LOG_DIR

def rotate_logs(retention_days=60):
    now = datetime.now()
    for file_name in os.listdir(APP_LOG_DIR):
        file_path = os.path.join(APP_LOG_DIR, file_name)
        if os.path.isfile(file_path) and file_name.startswith("log_") and file_name.endswith(".txt"):
            try:
                file_time = datetime.fromtimestamp(os.path.getmtime(file_path))
                if (now - file_time).days > retention_days:
                    os.remove(file_path)
            except Exception as e:
                print(f"Failed to delete old log: {file_name} | {e}")

rotate_logs(60)

log_filename = datetime.now().strftime("log_%Y-%m-%d_%H-%M-%S.txt")
log_file_path = os.path.join(APP_LOG_DIR, log_filename)

logging.basicConfig(
    filename=log_file_path,
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
)

logging.info("=== CompliSync Application Started ===")

def log_action(action: str, details: str = ""):
    message = f"ACTION: {action}"
    if details:
        message += f" | DETAILS: {details}"
    logging.info(message)

def setup_exception_logging():
    import sys
    def handle_exception(exc_type, exc_value, exc_traceback):
        if issubclass(exc_type, KeyboardInterrupt):
            sys.__excepthook__(exc_type, exc_value, exc_traceback)
            return
        logging.error("Uncaught exception", exc_info=(exc_type, exc_value, exc_traceback))
    sys.excepthook = handle_exception

setup_exception_logging()
