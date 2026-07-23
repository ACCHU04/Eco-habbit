from fastapi import APIRouter
from pydantic import BaseModel

from app.models import WasteCategory, DiySuggestion
from app.services.diy_suggestions import get_suggestions_for_category

router = APIRouter()


class DiyRequest(BaseModel):
    waste_category: WasteCategory
    materials_available: list[str] = []


class DiyResponse(BaseModel):
    suggestions: list[DiySuggestion]


@router.post("/diy-suggestions", response_model=DiyResponse)
async def get_diy_suggestions(request: DiyRequest):
    suggestions = get_suggestions_for_category(
        request.waste_category,
        request.materials_available,
    )
    return DiyResponse(suggestions=suggestions)
