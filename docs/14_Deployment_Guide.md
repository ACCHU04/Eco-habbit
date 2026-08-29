# EcoHabit — Deployment Guide

**Document Reference**: PRD v1.0, Section 17
**Last Updated**: July 2026
**Status**: Draft

---

## Overview

This document covers the deployment architecture, CI/CD pipeline, cloud deployment, monitoring, and rollback strategies for EcoHabit.

### Deployment Targets

| Service | Platform | Purpose |
|---|---|---|
| Backend API | Railway | NestJS REST API |
| AI Service | Railway | FastAPI ML service |
| Database | Supabase | PostgreSQL + Storage |
| Auth | Firebase | Authentication + FCM |
| Mobile App | Play Store / App Store | Flutter application |

---

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        CI/CD Pipeline                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐     │
│  │  Code   │───▶│  Build  │───▶│  Test   │───▶│ Deploy  │     │
│  │  Push   │    │         │    │         │    │         │     │
│  └─────────┘    └─────────┘    └─────────┘    └─────────┘     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Production Environment                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   Railway       │    │   Supabase      │    │   Firebase  │ │
│  │   (Backend)     │    │   (Database)    │    │   (Auth)    │ │
│  │   (AI Service)  │    │   (Storage)     │    │   (FCM)     │ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
│                                                                  │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │   Google Play   │    │   Apple App     │                    │
│  │   Store         │    │   Store         │                    │
│  └─────────────────┘    └─────────────────┘                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## CI/CD Pipeline

### GitHub Actions Workflow

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  # Backend Tests
  test-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: cd services/backend_api && npm ci
      - run: npm run lint
      - run: npm run test:cov
      
  # AI Service Tests
  test-ai:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - run: cd services/ai_service && pip install -r requirements.txt
      - run: pytest --cov=app tests/
      
  # Flutter Tests
  test-flutter:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.0'
      - run: cd apps/mobile_app && flutter pub get
      - run: flutter test
      - run: flutter analyze
      
  # Deploy Backend (main branch only)
  deploy-backend:
    needs: [test-backend, test-ai, test-flutter]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to Railway
        uses: bervProject/railway-deploy@main
        with:
          railway_token: ${{ secrets.RAILWAY_TOKEN }}
          service: backend-api
          
  # Deploy AI Service (main branch only)
  deploy-ai:
    needs: [test-backend, test-ai, test-flutter]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to Railway
        uses: bervProject/railway-deploy@main
        with:
          railway_token: ${{ secrets.RAILWAY_TOKEN }}
          service: ai-service
```

### Pipeline Stages

| Stage | Trigger | Actions |
|---|---|---|
| Code Push | Push to any branch | Run tests |
| Pull Request | PR created/updated | Run tests, block merge on failure |
| Deploy | Push to main | Build, test, deploy to production |

---

## Backend Deployment (Railway)

### Service Configuration

**railway.toml**:
```toml
[build]
builder = "nixpacks"
buildCommand = "npm install && npm run build"

[deploy]
startCommand = "npm run start:prod"
healthcheckPath = "/api/v1/health"
healthcheckTimeout = 300
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 3
```

### Environment Variables

| Variable | Source | Description |
|---|---|---|
| SUPABASE_URL | Supabase | Database URL |
| SUPABASE_ANON_KEY | Supabase | Anonymous key |
| SUPABASE_SERVICE_KEY | Supabase | Service role key |
| FIREBASE_PROJECT_ID | Firebase | Project ID |
| FIREBASE_PRIVATE_KEY | Firebase | Private key |
| FIREBASE_CLIENT_EMAIL | Firebase | Client email |
| AI_SERVICE_URL | Railway | AI service URL |
| AI_SERVICE_API_KEY | Generated | API key |
| JWT_SECRET | Generated | JWT secret |
| JWT_EXPIRATION | Set | Token expiration (e.g., 7d) |
| NODE_ENV | Set | Production |

### Health Check

```
GET /api/v1/health

Response (200):
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2026-07-23T12:00:00Z",
  "database": "connected",
  "redis": "connected"
}
```

---

## AI Service Deployment (Railway)

### Service Configuration

**railway.toml**:
```toml
[build]
builder = "nixpacks"
buildCommand = "pip install -r requirements.txt"

[deploy]
startCommand = "uvicorn app.main:app --host 0.0.0.0 --port $PORT"
healthcheckPath = "/api/v1/health"
healthcheckTimeout = 60
restartPolicyType = "on_failure"
```

### Environment Variables

| Variable | Source | Description |
|---|---|---|
| REDIS_URL | Redis | Cache URL |
| SUPABASE_URL | Supabase | Database URL |
| SUPABASE_SERVICE_KEY | Supabase | Service key |
| MODEL_PATH | Set | Model directory |
| CONFIDENCE_THRESHOLD | Set | 0.80 |
| API_KEY | Generated | API key |
| PORT | Railway | Assigned port |

### Model Deployment

```bash
# Build with model included
docker build -t ecohabit-ai .

# Or mount model volume
docker run -v ./models:/app/models ecohabit-ai
```

---

## Mobile App Deployment

### Android (Google Play Store)

**Build Command**:
```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

**Play Store Requirements**:
- App icon (512x512)
- Feature graphic (1024x500)
- Screenshots (min 2, max 8)
- Privacy policy URL
- Content rating questionnaire

**Upload Process**:
1. Build app bundle
2. Sign with release keystore
3. Upload to Play Console
4. Fill store listing
5. Submit for review

### iOS (App Store)

**Build Command**:
```bash
flutter build ios --release
```

**Xcode Configuration**:
- Bundle identifier: `com.ecohabit.app`
- Version: 1.0.0
- Build number: 1

**App Store Requirements**:
- App icon (1024x1024)
- Screenshots (6.5", 5.5", iPad)
- Privacy policy URL
- App description

**Upload Process**:
1. Build iOS release
2. Archive in Xcode
3. Upload to App Store Connect
4. Fill store listing
5. Submit for review

---

## Database Deployment (Supabase)

### Production Setup

1. Create Supabase project
2. Enable required extensions
3. Run migrations
4. Set up RLS policies
5. Configure storage buckets

### Migrations

```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link to project
supabase link --project-ref your-project-ref

# Run migrations
supabase db push

# Reset database (development only)
supabase db reset
```

### Storage Buckets

| Bucket | Purpose | Access |
|---|---|---|
| avatars | User profile photos | Public read, auth write |
| listings | Marketplace listing images | Public read, auth write |
| posts | Community post images | Public read, auth write |
| diy-projects | DIY project images | Public read, auth write |

---

## Monitoring

### Logging

**Backend (NestJS)**:
```typescript
// Use NestJS Logger
logger.log('User registered', { userId: user.id });
logger.warn('Low confidence classification', { confidence: 0.65 });
logger.error('AI service timeout', error.stack);
```

**AI Service (FastAPI)**:
```python
import logging

logger = logging.getLogger(__name__)

logger.info("Classification completed", extra={"confidence": 0.94})
logger.warning("Cache miss", extra={"hash": image_hash})
logger.error("Model loading failed", exc_info=True)
```

### Metrics

| Metric | Target | Alert Threshold |
|---|---|---|
| API response time | < 500ms | > 1000ms |
| AI classification time | < 5s | > 10s |
| Error rate | < 1% | > 5% |
| Uptime | > 99.9% | < 99% |

### Alerting

| Alert | Condition | Action |
|---|---|---|
| High error rate | > 5% for 5 min | Notify team |
| High response time | > 2s for 5 min | Investigate |
| Service down | Health check fails | Auto-restart |
| Database connection | < 10 available | Scale up |

---

## Rollback Strategy

### Backend Rollback

```bash
# Railway CLI
railway rollback

# Or via dashboard
# Go to Deployments > Select previous deployment > Rollback
```

### Frontend Rollback

**Play Store**:
1. Go to Play Console
2. Select app
3. Go to Release > Production
4. Rollback to previous version

**App Store**:
1. Go to App Store Connect
2. Select app
3. Go to Activity > All Builds
4. Rollback to previous version

### Database Rollback

```bash
# Create backup before migration
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d).sql

# If migration fails, restore
psql $DATABASE_URL < backup_20260723.sql
```

---

## Backup Strategy

### Database Backups

| Type | Frequency | Retention |
|---|---|---|
| Automated (Supabase) | Daily | 7 days |
| Manual backup | Before migrations | 30 days |
| Export | Weekly | 90 days |

### Storage Backups

| Type | Frequency | Retention |
|---|---|---|
| Supabase Storage | Daily | 7 days |
| Manual export | Monthly | 1 year |

### Disaster Recovery

| Scenario | Recovery Time | Recovery Point |
|---|---|---|
| Database corruption | < 1 hour | Last backup |
| Service outage | < 15 minutes | Real-time |
| Data loss | < 4 hours | Last daily backup |

---

## Environment Promotion

### Development → Staging → Production

```
develop (dev environment)
    ↓ PR + Tests
staging (staging environment)
    ↓ Manual approval
main (production)
```

### Environment Differences

| Setting | Development | Staging | Production |
|---|---|---|---|
| Database | Local/Dev Supabase | Staging Supabase | Production Supabase |
| AI Model | Test model | Staging model | Production model |
| Logging | Debug | Info | Warn |
| Error tracking | Console | Sentry | Sentry |

---

## Post-Deployment Checklist

| Task | Owner | Status |
|---|---|---|
| Verify health checks | DevOps | ☐ |
| Run smoke tests | QA | ☐ |
| Check error rates | DevOps | ☐ |
| Verify monitoring | DevOps | ☐ |
| Test critical paths | QA | ☐ |
| Update documentation | Team | ☐ |

---

## Document Reference

This document references:
- PRD v1.0, Section 17 (Release Strategy)
- 10_System_Architecture.md
- 13_Testing_Strategy.md

This document is referenced by:
- Operations runbook (future)
