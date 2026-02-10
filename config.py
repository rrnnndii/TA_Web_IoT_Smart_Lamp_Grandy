import os

class Config:
    SECRET_KEY = "smartlamp_secret_key_123"

    DB_HOST = "localhost"
    DB_USER = "root"
    DB_PASSWORD = ""
    DB_NAME = "smart_lamp_db"

    DB_PORT = 3306
    DB_USE_PURE = True
    DB_SSL_DISABLED = True
    DB_CONNECTION_TIMEOUT = 5