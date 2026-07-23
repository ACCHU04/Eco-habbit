# EcoHabit — Development Setup

**Document Reference**: PRD v1.0
**Last Updated**: July 2026
**Status**: Draft

---

## Overview

This document covers the local development environment setup, repository structure, coding standards, and development workflow.

---

## Prerequisites

### Required Software

| Software | Version | Purpose |
|---|---|---|
| Flutter SDK | 3.22+ | Mobile app development |
| Dart SDK | 3.4+ | Dart language |
| Node.js | 20+ | Backend runtime |
| npm | 10+ | Package manager |
| Python | 3.11+ | AI service |
| pip | Latest | Python package manager |
| Git | 2.40+ | Version control |
| Docker | 24+ | Containerization (optional) |

### IDE Setup

**VS Code (Recommended)**:
- Flutter extension
- Dart extension
- NestJS extension
- Python extension
- ESLint extension
- Prettier extension

**Android Studio**:
- Flutter plugin
- Dart plugin
- Android SDK 34+

---

## Repository Structure

### Monorepo Layout

```
EcoHabit/
├── apps/
│   ├── mobile_app/          # Flutter application
│   ├── admin_dashboard/     # Next.js admin (V2)
│   └── landing_page/        # Next.js landing (V2)
├── services/
│   ├── backend_api/         # NestJS backend
│   └── ai_service/          # FastAPI AI service
├── packages/
│   ├── shared_models/       # Shared data models
│   ├── shared_utils/        # Shared utilities
│   └── shared_ui/           # Shared UI components (V2)
├── docs/                    # Documentation
├── scripts/                 # Build/deploy scripts
├── assets/                  # Static assets
├── .github/                 # GitHub Actions
├── docker-compose.yml       # Docker setup
├── .gitignore
└── README.md
```

### Mobile App Structure

```
apps/mobile_app/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   ├── api_config.dart
│   │   │   └── firebase_config.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── colors.dart
│   │   │   └── typography.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   └── helpers.dart
│   │   └── constants/
│   │       ├── api_endpoints.dart
│   │       ├── enums.dart
│   │       └── assets.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── providers/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   ├── home/
│   │   ├── marketplace/
│   │   ├── scanner/
│   │   ├── diy/
│   │   ├── community/
│   │   ├── rewards/
│   │   └── profile/
│   ├── shared/
│   │   ├── widgets/
│   │   ├── models/
│   │   └── services/
│   └── main.dart
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```

### Backend Structure

```
services/backend_api/
├── src/
│   ├── modules/
│   │   ├── auth/
│   │   │   ├── auth.module.ts
│   │   │   ├── auth.controller.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── auth.guard.ts
│   │   │   └── dto/
│   │   ├── users/
│   │   ├── marketplace/
│   │   ├── community/
│   │   ├── ai/
│   │   ├── diy/
│   │   ├── rewards/
│   │   ├── reports/
│   │   ├── notifications/
│   │   └── admin/
│   ├── common/
│   │   ├── guards/
│   │   ├── decorators/
│   │   ├── filters/
│   │   ├── pipes/
│   │   └── interceptors/
│   ├── config/
│   │   ├── configuration.ts
│   │   └── validation.ts
│   └── main.ts
├── test/
├── package.json
├── tsconfig.json
├── nest-cli.json
└── .env
```

### AI Service Structure

```
services/ai_service/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── api/
│   │   ├── __init__.py
│   │   ├── classify.py
│   │   └── diy.py
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py
│   │   └── security.py
│   ├── models/
│   │   ├── __init__.py
│   │   ├── classifier.py
│   │   └── preprocessor.py
│   ├── services/
│   │   ├── __init__.py
│   │   ├── classification.py
│   │   ├── diy_suggestions.py
│   │   └── cache.py
│   └── utils/
│       └── __init__.py
├── models/
│   └── mobilenetv2_waste_v1.0/
├── data/
│   └── diy_projects.json
├── tests/
├── requirements.txt
├── Dockerfile
└── .env
```

---

## Local Development Setup

### 1. Clone Repository

```bash
git clone https://github.com/ecohabit/ecohabit.git
cd ecohabit
```

### 2. Backend Setup (NestJS)

```bash
cd services/backend_api
npm install
cp .env.example .env
npm run start:dev
```

**Environment Variables** (`.env`):
```
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_KEY=your-service-key

# Firebase
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY=your-private-key
FIREBASE_CLIENT_EMAIL=your-client-email

# AI Service
AI_SERVICE_URL=http://localhost:8000
AI_SERVICE_API_KEY=your-api-key

# JWT
JWT_SECRET=your-jwt-secret
JWT_EXPIRATION=7d

# App
PORT=3000
NODE_ENV=development
```

### 3. Mobile App Setup (Flutter)

```bash
cd apps/mobile_app
flutter pub get
flutter run
```

**Environment Configuration**:
- `lib/core/config/app_config.dart`
- Set API URL based on environment
- Configure Firebase options

### 4. AI Service Setup (FastAPI)

```bash
cd services/ai_service
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

**Environment Variables** (`.env`):
```
# Redis
REDIS_URL=redis://localhost:6379

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your-service-key

# Model
MODEL_PATH=./models/mobilenetv2_waste_v1.0
CONFIDENCE_THRESHOLD=0.80

# API
API_KEY=your-api-key
PORT=8000
```

---

## Environment Configuration

### Development

| Service | URL | Purpose |
|---|---|---|
| Backend API | http://localhost:3000 | Local API server |
| AI Service | http://localhost:8000 | Local AI server |
| Supabase | https://your-project.supabase.co | Cloud database |
| Firebase | https://console.firebase.google.com | Cloud auth |

### Production

| Service | URL | Purpose |
|---|---|---|
| Backend API | https://api.ecohabit.app | Production API |
| AI Service | https://ai.ecohabit.app | Production AI |
| Supabase | https://your-project.supabase.co | Production database |
| Firebase | https://console.firebase.google.com | Production auth |

---

## Coding Standards

### Dart/Flutter

- Follow official Dart style guide
- Use `flutter analyze` for linting
- Maximum line length: 80 characters
- Use `dart format` for formatting

**Key Rules**:
- Use `final` for immutable variables
- Prefer `const` constructors
- Use meaningful variable names
- Add type annotations
- Avoid `print()` in production (use logging)

### TypeScript/NestJS

- Follow official NestJS style guide
- Use ESLint + Prettier
- Maximum line length: 100 characters
- Use `npm run lint` for linting

**Key Rules**:
- Use strict TypeScript
- Add explicit return types
- Use DTOs for validation
- Follow NestJS module pattern
- Use dependency injection

### Python/FastAPI

- Follow PEP 8 style guide
- Use `black` for formatting
- Use `ruff` for linting
- Maximum line length: 88 characters

**Key Rules**:
- Use type hints
- Add docstrings
- Use `async/await` for async operations
- Follow FastAPI patterns

---

## Git Workflow

### Branching Strategy

```
main                    # Production-ready code
├── develop             # Development branch
│   ├── feature/*       # Feature branches
│   ├── bugfix/*        # Bug fix branches
│   └── hotfix/*        # Hot fix branches
```

### Branch Naming

```
feature/marketplace-search
feature/ai-scanner-ui
bugfix/login-error
hotfix/critical-security-patch
```

### Commit Conventions

**Format**:
```
type(scope): description

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

**Examples**:
```
feat(marketplace): add search functionality
fix(auth): resolve login timeout issue
docs(api): update endpoint documentation
```

### Pull Request Process

1. Create feature branch from `develop`
2. Make changes
3. Write/update tests
4. Update documentation if needed
5. Create PR to `develop`
6. Request review
7. Merge after approval

---

## Debugging

### Flutter Debugging

```bash
# Run in debug mode
flutter run --debug

# Run with logging
flutter run --verbose

# Hot reload
r (in terminal)

# Hot restart
R (in terminal)
```

### NestJS Debugging

```bash
# Run with debugger
npm run start:debug

# Run with logging
npm run start:dev -- --verbose
```

### AI Service Debugging

```bash
# Run with debug mode
uvicorn app.main:app --reload --log-level debug

# Test endpoint
curl -X POST http://localhost:8000/api/v1/classify \
  -F "image=@test_image.jpg"
```

---

## Useful Commands

### Flutter

```bash
flutter pub get                    # Get dependencies
flutter pub upgrade                # Upgrade dependencies
flutter analyze                    # Analyze code
flutter test                       # Run tests
flutter build apk                  # Build Android APK
flutter build ios                  # Build iOS
```

### NestJS

```bash
npm install                        # Install dependencies
npm run start:dev                  # Start dev server
npm run build                      # Build for production
npm run start:prod                 # Start production
npm run lint                       # Lint code
npm run test                       # Run tests
npm run test:e2e                   # Run E2E tests
```

### AI Service

```bash
pip install -r requirements.txt    # Install dependencies
uvicorn app.main:app --reload      # Start dev server
python -m pytest                   # Run tests
black .                            # Format code
ruff check .                       # Lint code
```

---

## Document Reference

This document references:
- 10_System_Architecture.md
- 11_AI_Architecture.md

This document is referenced by:
- 13_Testing_Strategy.md
