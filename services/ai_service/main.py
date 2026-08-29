import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

from app.routes import classify, diy_suggestions

load_dotenv()

app = FastAPI(
    title="EcoHabit AI Service",
    version="1.0.0",
    docs_url="/api/v1/docs",
    openapi_url="/api/v1/openapi.json",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(classify.router, prefix="/api/v1/ai", tags=["classify"])
app.include_router(diy_suggestions.router, prefix="/api/v1/ai", tags=["diy"])


@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "ai-service"}


@app.get("/api/v1/health")
async def health_check_v1():
    return {"status": "ok", "service": "ai-service", "version": "1.0.0"}
