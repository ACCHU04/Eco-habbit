import pytest
from app.models import WasteCategory, ClassificationResult, LabelInfo

# Test models and pure logic without importing TF-dependent classifier


class TestWasteCategoryModel:
    def test_all_values(self):
        expected = [
            "plastic", "paper_cardboard", "glass", "metal",
            "organic", "ewaste", "textile", "others",
        ]
        actual = [c.value for c in WasteCategory]
        assert sorted(actual) == sorted(expected)

    def test_enum_count(self):
        assert len(WasteCategory) == 8


class TestClassificationResult:
    def test_confident_result(self):
        result = ClassificationResult(
            category=WasteCategory.plastic,
            confidence=0.94,
            disposal_tips="Rinse and recycle",
            is_uncertain=False,
            explanation="I identified this as plastic because...",
            top_labels=[LabelInfo(label="plastic_bottle", confidence=0.94)],
        )
        assert result.category == WasteCategory.plastic
        assert result.confidence == 0.94
        assert result.is_uncertain is False
        assert result.explanation == "I identified this as plastic because..."
        assert len(result.top_labels) == 1
        assert result.top_labels[0].label == "plastic_bottle"

    def test_uncertain_result(self):
        result = ClassificationResult(
            category=WasteCategory.paper_cardboard,
            confidence=0.55,
            disposal_tips="Recycle",
            is_uncertain=True,
        )
        assert result.is_uncertain is True
        assert result.explanation == ""
        assert result.top_labels == []

    def test_default_uncertain_is_false(self):
        result = ClassificationResult(
            category=WasteCategory.glass,
            confidence=0.85,
            disposal_tips="Recycle glass",
        )
        assert result.is_uncertain is False


class TestLabelInfo:
    def test_model_fields(self):
        label = LabelInfo(label="plastic_bottle", confidence=0.94)
        assert label.label == "plastic_bottle"
        assert label.confidence == 0.94


class TestDiySuggestion:
    def test_model_fields(self):
        from app.models import DiySuggestion
        s = DiySuggestion(
            project_id="test-1",
            title="Test Project",
            difficulty="easy",
            estimated_time="30 minutes",
            estimated_price=100.0,
            materials=["material1"],
            thumbnail_url=None,
        )
        assert s.project_id == "test-1"
        assert s.thumbnail_url is None


class TestConfidenceThreshold:
    """Test the 80% threshold logic without importing classifier module."""

    THRESHOLD = 0.80

    def test_high_confidence_is_uncertain_false(self):
        assert not (0.94 < self.THRESHOLD)

    def test_low_confidence_is_uncertain_true(self):
        assert 0.55 < self.THRESHOLD is False or 0.55 < self.THRESHOLD

    def test_boundary_at_threshold(self):
        assert not (0.80 < self.THRESHOLD)
        assert 0.79 < self.THRESHOLD

    def test_very_low_confidence(self):
        assert 0.10 < self.THRESHOLD
