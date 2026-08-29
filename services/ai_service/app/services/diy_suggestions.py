from app.models import WasteCategory, DiySuggestion

# Curated DIY projects database (subset for MVP)
CURATED_PROJECTS = [
    {
        "id": "diy-001",
        "title": "Plastic Bottle Planter",
        "description": "Turn plastic bottles into hanging planters for your dorm room.",
        "waste_categories": [WasteCategory.plastic],
        "materials": ["plastic bottle", "scissors", "rope", "paint"],
        "difficulty": "easy",
        "estimated_time": "30 minutes",
        "estimated_price": 150.0,
        "thumbnail_url": None,
    },
    {
        "id": "diy-002",
        "title": "Cardboard Bookshelf",
        "description": "Create a sturdy bookshelf from layered cardboard sheets.",
        "waste_categories": [WasteCategory.paper_cardboard],
        "materials": ["cardboard", "glue", "scissors", "ruler"],
        "difficulty": "medium",
        "estimated_time": "2 hours",
        "estimated_price": 300.0,
        "thumbnail_url": None,
    },
    {
        "id": "diy-003",
        "title": "Glass Jar Lantern",
        "description": "Decorate glass jars into beautiful desk lanterns.",
        "waste_categories": [WasteCategory.glass],
        "materials": ["glass jar", "paint", "LED tea light", "ribbons"],
        "difficulty": "easy",
        "estimated_time": "45 minutes",
        "estimated_price": 200.0,
        "thumbnail_url": None,
    },
    {
        "id": "diy-004",
        "title": "Tin Can Organizer",
        "description": "Upcycle tin cans into desk organizers for pens and stationery.",
        "waste_categories": [WasteCategory.metal],
        "materials": ["tin can", "paint", "fabric", "glue"],
        "difficulty": "easy",
        "estimated_time": "1 hour",
        "estimated_price": 120.0,
        "thumbnail_url": None,
    },
    {
        "id": "diy-005",
        "title": "T-Shirt Tote Bag",
        "description": "No-sew tote bag made from an old t-shirt.",
        "waste_categories": [WasteCategory.textile],
        "materials": ["old t-shirt", "scissors"],
        "difficulty": "easy",
        "estimated_time": "20 minutes",
        "estimated_price": 250.0,
        "thumbnail_url": None,
    },
    {
        "id": "diy-006",
        "title": "Newspaper Seed Pots",
        "description": "Biodegradable seed starter pots from newspaper.",
        "waste_categories": [WasteCategory.paper_cardboard],
        "materials": ["newspaper", "water"],
        "difficulty": "easy",
        "estimated_time": "15 minutes",
        "estimated_price": 50.0,
        "thumbnail_url": None,
    },
    {
        "id": "diy-007",
        "title": "E-Waste Sculpture",
        "description": "Create artistic sculptures from broken electronics parts.",
        "waste_categories": [WasteCategory.ewaste],
        "materials": ["old circuit boards", "hot glue", "wire", "base"],
        "difficulty": "hard",
        "estimated_time": "4 hours",
        "estimated_price": 500.0,
        "thumbnail_url": None,
    },
    {
        "id": "diy-008",
        "title": "Cardboard Laptop Stand",
        "description": "Ergonomic laptop stand made from reinforced cardboard.",
        "waste_categories": [WasteCategory.paper_cardboard],
        "materials": ["cardboard", "tape", "scissors"],
        "difficulty": "medium",
        "estimated_time": "1.5 hours",
        "estimated_price": 350.0,
        "thumbnail_url": None,
    },
]


def get_suggestions_for_category(
    waste_category: WasteCategory,
    materials_available: list[str] = [],
) -> list[DiySuggestion]:
    matches = [
        p for p in CURATED_PROJECTS if waste_category in p["waste_categories"]
    ]

    if materials_available:
        scored = []
        for p in matches:
            overlap = len(
                set(m.lower() for m in p["materials"])
                & set(m.lower() for m in materials_available)
            )
            scored.append((overlap, p))
        scored.sort(key=lambda x: x[0], reverse=True)
        matches = [p for _, p in scored]

    return [
        DiySuggestion(
            project_id=p["id"],
            title=p["title"],
            difficulty=p["difficulty"],
            estimated_time=p["estimated_time"],
            estimated_price=p["estimated_price"],
            materials=p["materials"],
            thumbnail_url=p["thumbnail_url"],
        )
        for p in matches[:5]
    ]
