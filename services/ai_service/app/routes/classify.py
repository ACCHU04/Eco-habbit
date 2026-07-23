from fastapi import APIRouter, UploadFile, File, HTTPException
import httpx

from app.models import ClassifyResponse, WasteCategory
from app.services.classifier import classify_image_from_url, classify_image_from_bytes
from app.services.diy_suggestions import get_suggestions_for_category

router = APIRouter()

MAX_FILE_SIZE = 5 * 1024 * 1024  # 5MB
ALLOWED_TYPES = {"image/jpeg", "image/png", "image/jpg"}


@router.post("/classify", response_model=ClassifyResponse)
async def classify_item(
    file: UploadFile | None = None,
    image_url: str | None = None,
):
    if not file and not image_url:
        raise HTTPException(status_code=400, detail="Provide either file or image_url")

    try:
        if file:
            if file.content_type not in ALLOWED_TYPES:
                raise HTTPException(
                    status_code=400,
                    detail=f"Invalid file type: {file.content_type}. Allowed: JPEG, PNG",
                )

            image_bytes = await file.read()

            if len(image_bytes) > MAX_FILE_SIZE:
                raise HTTPException(
                    status_code=400,
                    detail=f"File too large: {len(image_bytes)} bytes. Max: {MAX_FILE_SIZE}",
                )

            result = await classify_image_from_bytes(image_bytes)
        else:
            result = await classify_image_from_url(image_url)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Classification failed: {str(e)}")

    diy = get_suggestions_for_category(result.category)

    return ClassifyResponse(
        result=result,
        diy_suggestions=diy,
        cached=False,
    )


@router.get("/cache/{image_hash}")
async def get_cached_result(image_hash: str):
    import redis
    import os
    import json

    cache = redis.from_url(os.environ.get("REDIS_URL", "redis://localhost:6379"), decode_responses=True)
    cached = cache.get(f"classify:{image_hash}")
    if not cached:
        raise HTTPException(status_code=404, detail="Not cached")
    return json.loads(cached)
