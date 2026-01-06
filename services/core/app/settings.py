"""Application settings using Pydantic Settings."""

from typing import Optional
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings."""
    
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore"
    )
    
    # Environment
    ENV: str = "development"
    
    # MasterDocs configuration
    MASTERDOCS_LOCAL_PATH: str = ""
    MASTERDOCS_PULL_ON_START: str = "false"
    MASTERDOCS_REPO_URL: Optional[str] = None
    MASTERDOCS_TOKEN: Optional[str] = None
    
    def model_post_init(self, __context) -> None:
        """Validate settings after initialization."""
        # If PULL_ON_START is true and LOCAL_PATH is empty, require REPO_URL
        if self.MASTERDOCS_PULL_ON_START.lower() == "true":
            if not self.MASTERDOCS_LOCAL_PATH:
                if not self.MASTERDOCS_REPO_URL:
                    raise ValueError(
                        "MASTERDOCS_REPO_URL is required when "
                        "MASTERDOCS_PULL_ON_START=true and MASTERDOCS_LOCAL_PATH is empty"
                    )
        # If LOCAL_PATH is set, REPO_URL is optional
        # (we can use local path without pulling from repo)


# Global settings instance
settings = Settings()

