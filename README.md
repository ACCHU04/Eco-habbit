# EcoHabit

AI-powered circular economy platform for college students.

## Overview

EcoHabit enables college students to buy, sell, donate, and recycle products while learning entrepreneurship and sustainability through gamified learning.

## Tech Stack

- **Mobile:** Flutter (Dart)
- **Backend:** NestJS (TypeScript)
- **AI Service:** FastAPI (Python)
- **Database:** Supabase (PostgreSQL)
- **Auth:** Firebase Authentication
- **Storage:** Supabase Storage
- **Caching:** Redis
- **ML:** TensorFlow (MobileNetV2)

## Project Structure

```
EcoHabit/
├── apps/
│   ├── mobile_app/          # Flutter mobile app
│   ├── admin_dashboard/     # Admin web panel (V2)
│   └── landing_page/        # Marketing site (V2)
├── services/
│   ├── backend_api/         # NestJS REST API
│   └── ai_service/          # FastAPI AI/ML service
├── packages/
│   ├── shared_models/       # Shared data models
│   ├── shared_utils/        # Shared utilities
│   └── shared_ui/           # Shared UI components (V2)
├── docs/                    # Project documentation
├── scripts/                 # Build/deploy scripts
├── assets/                  # Static assets
└── .github/                 # CI/CD workflows
```

## Getting Started

### Prerequisites

- Node.js 20+
- Python 3.11+
- Flutter 3.22+
- Docker (optional)

### Backend API

```bash
cd services/backend_api
npm install
cp .env.example .env  # Fill in values
npm run start:dev
```

### AI Service

```bash
cd services/ai_service
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
cp .env.example .env  # Fill in values
uvicorn app.main:app --reload
```

### Flutter App

```bash
cd apps/mobile_app
flutter pub get
flutter run
```

### Docker (Redis)

```bash
docker-compose up -d
```

## Documentation

See `docs/` directory for full documentation:

- `02_PRD.md` - Product Requirements
- `03_User_Personas.md` - User Personas
- `04_User_Journeys.md` - User Journeys
- `05_Information_Architecture.md` - Information Architecture
- `08_Database_Design.md` - Database Design
- `09_API_Specification.md` - API Specification
- `10_System_Architecture.md` - System Architecture
- `11_AI_Architecture.md` - AI Architecture
- `12_Development_Setup.md` - Development Setup
- `13_Testing_Strategy.md` - Testing Strategy
- `14_Deployment_Guide.md` - Deployment Guide
- `15_Brand_Identity.md` - Brand Identity
- `16_Design_System.md` - Design System
- `17_Screen_Specifications.md` - Screen Specifications
- `18_Responsive_Design.md` - Responsive Design
- `19_Accessibility_Specification.md` - Accessibility
- `20_FR_Traceability.md` - FR Traceability

## Git Workflow

- `main` - Production-ready code
- `develop` - Development integration branch
- `feature/*` - Feature branches
- `bugfix/*` - Bug fix branches
- `hotfix/*` - Hot fix branches

## License

Private - All rights reserved.
