"""
Configuration settings for Queue Management System
"""
from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    """Application settings"""

    # Database
    database_url: str = "sqlite:///./queue_management.db"

    # Security
    secret_key: str = "your-secret-key-change-in-production-09876543210"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30

    # Ticket Configuration
    ticket_expiry_hours: int = 2
    max_queue_size: int = 500

    # Server
    host: str = "0.0.0.0"
    port: int = 8000

    # Application
    app_name: str = "Queue Management System - Ethiopia"
    version: str = "1.0.0"

    class Config:
        env_file = ".env"
        case_sensitive = False


settings = Settings()

