# EcoHabit — AI Architecture

**Document Reference**: PRD v1.0, Section 13.6
**Last Updated**: July 2026
**Status**: Draft

---

## Overview

The AI Service powers waste classification and DIY suggestions. It uses a **pre-trained model with fine-tuning** approach for faster MVP delivery.

### Technology Stack

| Component | Technology |
|---|---|
| Framework | FastAPI (Python 3.11+) |
| ML Framework | TensorFlow / PyTorch |
| Image Processing | Pillow, OpenCV |
| Caching | Redis |
| Model | MobileNetV2 / EfficientNet (pre-trained, fine-tuned) |

---

## Model Pipeline

### Classification Flow

```
Input Image (JPEG/PNG)
       |
       v
Preprocessing (Resize, Normalize)
       |
       v
Feature Extraction (CNN backbone)
       |
       v
Classification Head (Dense layers)
       |
       v
Post-processing (Confidence, Category, Tips)
       |
       v
Output: { classification, confidence, disposal_tips, diy_suggestions }
```

### Pre-trained Model Selection

| Model | Accuracy | Speed | Size | MVP Choice |
|---|---|---|---|---|
| MobileNetV2 | 71% | Fast | 14MB | ✅ Default |
| EfficientNetB0 | 77% | Medium | 20MB | Alternative |
| ResNet50 | 76% | Slow | 100MB | Not recommended |

**Decision**: MobileNetV2 for speed and small size. Upgrade to EfficientNet if accuracy needs improvement.

### Fine-tuning Strategy

1. Start with ImageNet pre-trained weights
2. Replace final classification layer (8 waste categories)
3. Fine-tune last 20 layers on waste dataset
4. Freeze early layers (feature extraction)
5. Retrain periodically with new data

---

## Waste Categories

| ID | Category | Training Samples (Target) |
|---|---|---|
| 0 | plastic | 500+ |
| 1 | paper_cardboard | 500+ |
| 2 | glass | 300+ |
| 3 | metal | 300+ |
| 4 | organic | 500+ |
| 5 | ewaste | 300+ |
| 6 | textile | 300+ |
| 7 | others | 300+ |

### Training Data Sources

- TACO (Trash Annotations in Context) dataset
- Waste classification datasets on Kaggle
- Custom collected campus waste images
- Synthetic augmentation (rotation, flip, brightness)

---

## Hybrid DIY Engine

### Lookup Flow

```
Waste Classification Result
       |
       v
┌─────────────────┐
│ Curated DIY DB  │──> Match found? ──> Return curated projects
└────────┬────────┘
         | (no match)
         v
┌─────────────────┐
│ AI Fallback     │──> Generate suggestions based on material
└────────┬────────┘
         |
         v
┌─────────────────┐
│ Cache Result    │──> Store for future requests
└─────────────────┘
```

### Curated DIY Database

| Field | Type | Description |
|---|---|---|
| id | uuid | Project ID |
| title | text | Project title |
| description | text | Project description |
| source_materials | jsonb | Waste categories used |
| materials | jsonb | Required materials |
| steps | jsonb | Step-by-step instructions |
| difficulty | enum | easy/medium/hard |
| estimated_time | text | Completion time |
| estimated_price | number | Selling price |
| video_url | text | YouTube tutorial |
| images | jsonb | Project images |

### AI Fallback Logic

```python
def get_diy_suggestions(waste_category: str) -> list:
    # Step 1: Check curated database
    curated = db.query("diy_projects")
        .filter(waste_category in source_materials)
        .limit(3)
        .all()
    
    if len(curated) >= 2:
        return curated
    
    # Step 2: AI fallback - suggest based on material properties
    suggestions = generate_suggestions(waste_category)
    
    # Step 3: Cache for future
    cache.set(f"diy:{waste_category}", suggestions, ttl=30*24*3600)
    
    return curated + suggestions
```

---

## AI Service API

### Endpoints

| Endpoint | Method | Description |
|---|---|---|
| `/api/v1/classify` | POST | Classify waste image |
| `/api/v1/diy-suggestions` | GET | Get DIY suggestions |
| `/api/v1/cache/{hash}` | GET | Get cached result |
| `/api/v1/health` | GET | Health check |

### Classification Request

```
POST /api/v1/classify
Content-Type: multipart/form-data

image: [binary image data]
```

### Classification Response

```json
{
  "classification": "plastic",
  "confidence": 0.94,
  "disposal_tips": "Rinse before recycling. Remove cap.",
  "diy_suggestions": [
    {
      "id": "uuid",
      "title": "Plastic Bottle Planter",
      "difficulty": "easy",
      "source": "curated"
    }
  ],
  "processing_time_ms": 1250
}
```

### Error Response

```json
{
  "error": "classification_failed",
  "message": "Unable to classify image",
  "fallback": "manual_selection"
}
```

---

## Confidence Threshold

### Threshold Logic

```
Confidence >= 0.80  -->  Show classification (high confidence)
Confidence >= 0.60  -->  Show with "Uncertain" label
Confidence < 0.60   -->  Show "Unable to classify" + manual options
```

### Manual Category Selection

When confidence is low, user can manually select:
- Plastic
- Paper & Cardboard
- Glass
- Metal
- Organic
- E-waste
- Textile
- Others

---

## Caching Strategy

### Cache Key Structure

```
classify:{image_hash}          --> Classification result (30 days)
diy:{waste_category}           --> DIY suggestions (30 days)
diy:curated:{waste_category}   --> Curated projects (7 days)
```

### Cache Implementation

```python
import redis
import hashlib

redis_client = redis.Redis(host='redis', port=6379, db=0)

def get_cache_key(image_bytes: bytes) -> str:
    image_hash = hashlib.sha256(image_bytes).hexdigest()
    return f"classify:{image_hash}"

def cache_classification(image_bytes: bytes, result: dict):
    key = get_cache_key(image_bytes)
    redis_client.setex(key, 30 * 24 * 3600, json.dumps(result))

def get_cached_classification(image_bytes: bytes) -> dict:
    key = get_cache_key(image_bytes)
    cached = redis_client.get(key)
    if cached:
        return json.loads(cached)
    return None
```

### Cache Performance Targets

| Metric | Target |
|---|---|
| Cache hit rate | > 40% |
| Cache TTL | 30 days |
| Cache size | < 1GB |

---

## Model Performance

### Accuracy Targets

| Metric | Target | Measurement |
|---|---|---|
| Top-1 accuracy | > 80% | Correct classification / total |
| Top-3 accuracy | > 95% | Correct in top 3 / total |
| False positive rate | < 10% | Incorrect high-confidence / total |

### Performance Targets

| Metric | Target | Measurement |
|---|---|---|
| Inference time | < 2s | Model prediction time |
| Total response time | < 5s | End-to-end API response |
| Throughput | > 10 req/s | Concurrent requests |

### Monitoring

```python
# Track metrics
metrics = {
    "classification_count": 0,
    "avg_confidence": 0.0,
    "avg_response_time_ms": 0,
    "cache_hit_rate": 0.0,
    "error_rate": 0.0
}
```

---

## Model Lifecycle

### Versioning

```
models/
├── mobilenetv2_waste_v1.0/
│   ├── model.h5
│   ├── labels.json
│   └── metadata.json
├── mobilenetv2_waste_v1.1/
│   ├── model.h5
│   ├── labels.json
│   └── metadata.json
```

### Deployment Pipeline

```
1. Train/Fine-tune model locally
2. Evaluate on test set
3. If accuracy >= threshold:
   a. Save model to models/ directory
   b. Update metadata.json
   c. Deploy to AI service
   d. Monitor performance
4. If accuracy < threshold:
   a. Collect more training data
   b. Adjust hyperparameters
   c. Retrain
```

### A/B Testing (Future)

- Route 10% traffic to new model
- Compare accuracy and response times
- Graduate new model if improvements

---

## Security Considerations

| Concern | Mitigation |
|---|---|
| Model theft | Obfuscate model files |
| API abuse | Rate limiting (50 req/user/day) |
| Input validation | Validate image type, size |
| Data privacy | Don't store user images longer than needed |

---

## Document Reference

This document references:
- PRD v1.0, Section 13.6 (AI Requirements)
- 08_Database_Design.md (diy_projects table)
- 10_System_Architecture.md

This document is referenced by:
- 12_Development_Setup.md
