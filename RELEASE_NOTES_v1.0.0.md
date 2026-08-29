# Eco-Habbit v1.0.0

**AI-powered circular economy platform for college students.**

Eco-Habbit helps students reduce waste, earn rewards, and build sustainable habits through an AI waste classifier, peer-to-peer marketplace, DIY upcycling studio, and gamified community — all in one Flutter app.

---

## Features

### AI Waste Scanner
- Real-time waste classification using MobileNetV2 (TensorFlow)
- 8 waste categories: plastic, paper/cardboard, glass, metal, organic, e-waste, textile, others
- Confidence scoring with uncertain-flag fallback
- Dual-cache layer (Redis + in-memory) for fast repeat classifications
- Graceful degradation when AI service or TensorFlow unavailable

### Marketplace
- Create, edit, delete listings with images
- Browse and search with category/condition/price filters
- Buyer-seller messaging flow
- Listing status management (active/sold/archived)

### DIY Upcycling Studio
- Curated upcycling project suggestions per waste category
- Material-based project matching
- Step-by-step guides with difficulty and time estimates
- Share projects to community feed

### Community Feed
- Post creation with images
- Like, comment, and report functionality
- Post type filtering (tips, projects, marketplace, general)
- Author profiles and post feeds

### Rewards & Gamification
- Points for sustainable actions (listing, selling, posting, recycling)
- Badge system (first sale, recycler, community helper, etc.)
- Leaderboard
- Points history tracking

### Push Notifications
- FCM integration for real-time push
- Preference management (like/comment, marketplace, rewards, community)
- Foreground and background notification handling
- Badge count tracking

---

## Architecture

| Layer | Technology |
|---|---|
| **Frontend** | Flutter 3.44.7 (Dart 3.12.2) |
| **Backend API** | NestJS 11 (Node.js 20) |
| **Database** | Supabase (PostgreSQL) |
| **AI Service** | Python 3.11, FastAPI, TensorFlow/MobileNetV2 |
| **Auth** | Firebase Authentication (Email/Password + Google Sign-In) |
| **Push** | Firebase Cloud Messaging |
| **CI/CD** | GitHub Actions (3 parallel jobs) |

---

## Codebase

| Component | Files |
|---|---|
| Flutter source | 65 files |
| Flutter tests | 32 test files |
| Backend source | 56 TypeScript files |
| AI service | 7 Python files |
| SQL migrations | 13 files |

---

## Quality

- **253 automated tests** (192 Flutter + 61 Backend + AI service tests)
- **0 static analysis issues** (`flutter analyze`)
- **Green CI/CD** across Flutter, Backend, and AI Service jobs
- Graceful try/catch fallbacks across all backend services
- Lazy TensorFlow imports with fallback classifier for dev environments
- Firebase Admin SDK v14 compatibility

---

## Known Limitations

- Firebase Console project setup (Auth providers, FCM, service account) is required before running against a live backend
- TensorFlow model download required on first AI classification (MobileNetV2 weights)
- Redis required for AI service caching layer (graceful fallback to in-memory when unavailable)
- Release APK signing not yet configured for Play Store distribution

---

## Getting Started

```bash
# Local development setup
cd apps/mobile_app && flutter pub get
cd services/backend_api && npm ci
cd services/ai_service && pip install -r requirements.txt

# Run tests
cd apps/mobile_app && flutter test
cd services/backend_api && npm test
cd services/ai_service && pytest tests/ -v

# Build
flutter build apk --debug
```

---

## CI/CD

GitHub Actions workflow runs on every push to `main` and `develop`:

1. **Flutter** — install deps, analyze, test, build debug APK (uploaded as artifact)
2. **Backend API** — install deps, test, build
3. **AI Service** — install deps, pytest

---

*Built with Flutter, NestJS, Supabase, Firebase, and Python.*
