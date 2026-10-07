from fastapi import FastAPI
from fastapi.responses import RedirectResponse

from app.api import routes_auth, routes_exercises, routes_health

app = FastAPI(
    title="BehavioralOS API",
    version="0.2.0",
    docs_url="/docs",
    openapi_url="/api/v1/openapi.json",
)

app.include_router(routes_health.router, prefix="/api/v1")
app.include_router(routes_auth.router, prefix="/api/v1")
app.include_router(routes_exercises.router, prefix="/api/v1")


@app.get("/", include_in_schema=False)
async def root() -> RedirectResponse:
    return RedirectResponse(url="/docs")
