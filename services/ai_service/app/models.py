from pydantic import BaseModel
from enum import Enum


class WasteCategory(str, Enum):
    plastic = "plastic"
    paper_cardboard = "paper_cardboard"
    glass = "glass"
    metal = "metal"
    organic = "organic"
    ewaste = "ewaste"
    textile = "textile"
    others = "others"


class ClassificationResult(BaseModel):
    category: WasteCategory
    confidence: float
    disposal_tips: str
    is_uncertain: bool = False


class DiySuggestion(BaseModel):
    project_id: str
    title: str
    difficulty: str
    estimated_time: str
    estimated_price: float
    materials: list[str]
    thumbnail_url: str | None = None


class ClassifyResponse(BaseModel):
    result: ClassificationResult
    diy_suggestions: list[DiySuggestion]
    cached: bool = False


class ClassifyRequest(BaseModel):
    image_url: str | None = None


class DiyRequest(BaseModel):
    waste_category: WasteCategory
    materials_available: list[str] = []
