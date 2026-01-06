"""FastAPI application main entry point."""

from fastapi import FastAPI
from app.settings import settings

app = FastAPI(title="PusjCore API", version="1.0.0")


@app.get("/health")
async def health():
    """Health check endpoint."""
    return {
        "status": "ok",
        "env": settings.ENV,
        "masterdocs_local_path": settings.MASTERDOCS_LOCAL_PATH or "not set",
        "masterdocs_pull_on_start": settings.MASTERDOCS_PULL_ON_START,
    }


@app.get("/")
async def root():
    """Root endpoint."""
    return {"message": "PusjCore API", "version": "1.0.0"}

