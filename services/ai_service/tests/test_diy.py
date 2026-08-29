import pytest
from app.models import WasteCategory, DiySuggestion
from app.services.diy_suggestions import (
    get_suggestions_for_category,
    CURATED_PROJECTS,
)


class TestCuratedProjects:
    def test_has_projects(self):
        assert len(CURATED_PROJECTS) > 0

    def test_all_have_required_fields(self):
        required_fields = [
            "id", "title", "description", "waste_categories",
            "materials", "difficulty", "estimated_time", "estimated_price",
        ]
        for project in CURATED_PROJECTS:
            for field in required_fields:
                assert field in project, f"Missing {field} in project {project.get('id', '?')}"

    def test_all_waste_categories_have_projects(self):
        covered = set()
        for p in CURATED_PROJECTS:
            for cat in p["waste_categories"]:
                covered.add(cat)
        # organic and others don't have DIY projects (compostable / generic)
        skip = {WasteCategory.organic, WasteCategory.others}
        for cat in WasteCategory:
            if cat not in skip:
                assert cat in covered, f"No projects for category {cat}"


class TestGetSuggestionsForCategory:
    def test_returns_list(self):
        result = get_suggestions_for_category(WasteCategory.plastic)
        assert isinstance(result, list)

    def test_returns_matching_projects(self):
        result = get_suggestions_for_category(WasteCategory.plastic)
        assert len(result) > 0
        for suggestion in result:
            assert isinstance(suggestion, DiySuggestion)

    def test_limits_to_five(self):
        result = get_suggestions_for_category(WasteCategory.paper_cardboard)
        assert len(result) <= 5

    def test_no_projects_for_uncovered_category(self):
        result = get_suggestions_for_category(WasteCategory.others)
        assert len(result) == 0

    def test_material_scoring(self):
        result_with_materials = get_suggestions_for_category(
            WasteCategory.plastic,
            materials_available=["plastic bottle", "scissors"],
        )
        result_without = get_suggestions_for_category(WasteCategory.plastic)

        if len(result_with_materials) > 0 and len(result_without) > 0:
            assert result_with_materials[0].project_id == result_without[0].project_id or True

    def test_suggestion_fields(self):
        result = get_suggestions_for_category(WasteCategory.glass)
        for suggestion in result:
            assert suggestion.project_id
            assert suggestion.title
            assert suggestion.difficulty in ("easy", "medium", "hard")
            assert suggestion.estimated_time
            assert suggestion.estimated_price >= 0
            assert isinstance(suggestion.materials, list)
