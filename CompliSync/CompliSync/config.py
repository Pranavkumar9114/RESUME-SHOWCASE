import os
from appdirs import user_data_dir, user_log_dir

APP_NAME = None
APP_DATA_DIR = None
APP_LOG_DIR = None
UPLOADS_DIR = None
EXTRACTED_POLICIES_DIR = None
POLICY_LOG_FOLDER = None
TEMP_FOLDER = None

def config( page):
    global APP_NAME
    global APP_DATA_DIR
    global APP_LOG_DIR
    global UPLOADS_DIR
    global EXTRACTED_POLICIES_DIR
    global POLICY_LOG_FOLDER
    global TEMP_FOLDER

    APP_NAME = "CompliSync"
    APP_DATA_DIR = user_data_dir(APP_NAME, appauthor=False, roaming=True)
    APP_LOG_DIR = user_log_dir(APP_NAME, appauthor=False)
    UPLOADS_DIR = os.path.join(APP_DATA_DIR, "Uploads")
    EXTRACTED_POLICIES_DIR = os.path.join(APP_DATA_DIR, "Extracted Policies")
    POLICY_LOG_FOLDER = os.path.join(APP_DATA_DIR, "Policy Update Logs")
    TEMP_FOLDER = os.path.join(APP_DATA_DIR, "Temp")

    os.makedirs(APP_LOG_DIR, exist_ok=True)

    if not os.path.exists(APP_DATA_DIR):
        print("client storage cleared")
        page.client_storage.clear()
        os.makedirs(APP_DATA_DIR, exist_ok=True)

    os.makedirs(UPLOADS_DIR, exist_ok=True)
    os.makedirs(EXTRACTED_POLICIES_DIR, exist_ok=True)
    os.makedirs(POLICY_LOG_FOLDER, exist_ok=True)
    os.makedirs(TEMP_FOLDER, exist_ok=True)
    