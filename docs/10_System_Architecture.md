# EcoHabit — System Architecture

**Document Reference**: PRD v1.0, Section 13.1
**Last Updated**: July 2026
**Status**: Draft

---

## Overview

EcoHabit uses a **Modular Monolith** architecture with NestJS as the backend framework. This provides clear module boundaries while keeping deployment simple for MVP.

### Architecture Style Decision

| Factor | Modular Monolith | Microservices |
|---|---|---|
| Deployment complexity | Low | High |
| Development speed | Fast | Slower |
| Module boundaries | Clear (NestJS modules) | Service boundaries |
| Scaling | Vertical (scale whole app) | Horizontal (scale services) |
| MVP suitability | ✅ Ideal | ❌ Over-engineered |

**Decision**: Modular Monolith for V1. Migrate to microservices if scaling requires it.

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              CLIENT LAYER                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────┐    ┌─────────────────────┐    ┌──────────────┐   │
│  │   Flutter App       │    │   Flutter App       │    │  Admin Web   │   │
│  │   (Android)         │    │   (iOS)             │    │  (Next.js)   │   │
│  └──────────┬──────────┘    └──────────┬──────────┘    └──────┬───────┘   │
│             │                          │                      │            │
└─────────────┼──────────────────────────┼──────────────────────┼────────────┘
              │                          │                      │
              ▼                          ▼                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              API GATEWAY                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        NestJS Backend                                │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────┐  │   │
│  │  │  Auth   │ │Market-  │ │Community│ │   AI    │ │   Rewards   │  │   │
│  │  │ Module  │ │place    │ │ Module  │ │ Module  │ │   Module    │  │   │
│  │  │         │ │ Module  │ │         │ │         │ │             │  │   │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────────┘  │   │
│  │                                                                     │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────┐  │   │
│  │  │  User   │ │  DIY    │ │Report   │ │Notifi-  │ │   Admin     │  │   │
│  │  │ Module  │ │ Module  │ │ Module  │ │cation   │ │   Module    │  │   │
│  │  │         │ │         │ │         │ │ Module  │ │             │  │   │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
              │                          │                      │
              ▼                          ▼                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              SERVICE LAYER                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────┐ │
│  │   Supabase      │    │   Firebase      │    │     AI Service          │ │
│  │   (PostgreSQL)  │    │   (Auth + FCM)  │    │     (FastAPI)           │ │
│  │   + Storage     │    │                 │    │     Python + ML         │ │
│  └─────────────────┘    └─────────────────┘    └─────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Component Architecture

### 1. Flutter Mobile App

**Purpose**: Cross-platform mobile application for students, NGOs, and organizations.

**Key Components**:
```
lib/
├── core/                    # Shared utilities, constants, theme
│   ├── config/             # App configuration
│   ├── theme/              # UI theme, colors, typography
│   ├── utils/              # Helper functions
│   └── constants/          # API URLs, enum values
├── features/               # Feature modules
│   ├── auth/               # Authentication screens, providers
│   ├── home/               # Dashboard, quick actions
│   ├── marketplace/        # Listings, search, filters
│   ├── scanner/            # AI scanner, results
│   ├── diy/                # DIY projects, details
│   ├── community/          # Feed, posts, comments
│   ├── rewards/            # Points, badges, leaderboard
│   └── profile/            # User profile, settings
├── shared/                 # Shared widgets, models
│   ├── widgets/            # Reusable UI components
│   └── models/             # Data models
└── main.dart               # App entry point
```

**State Management**: Riverpod

**Key Dependencies**:
- `flutter_riverpod` — State management
- `go_router` — Navigation
- `dio` — HTTP client
- `firebase_core` — Firebase initialization
- `firebase_auth` — Authentication
- `firebase_messaging` — Push notifications
- `image_picker` — Camera/gallery access
- `cached_network_image` — Image caching
- `shared_preferences` — Local storage

### 2. NestJS Backend

**Purpose**: REST API server handling all business logic.

**Module Architecture**:
```
src/
├── modules/
│   ├── auth/               # Authentication, JWT, guards
│   ├── users/              # User management
│   ├── marketplace/        # Listings, search
│   ├── community/          # Posts, comments, likes
│   ├── ai/                 # AI service integration
│   ├── diy/                # DIY projects
│   ├── rewards/            # Points, badges
│   ├── reports/            # Content moderation
│   ├── notifications/      # Push notifications
│   └── admin/              # Admin operations
├── common/                 # Shared utilities
│   ├── guards/             # Auth guards
│   ├── decorators/         # Custom decorators
│   ├── filters/            # Exception filters
│   ├── pipes/              # Validation pipes
│   └── interceptors/       # Logging, transform
├── config/                 # Configuration
└── main.ts                 # Application entry
```

**Key Dependencies**:
- `@nestjs/core` — NestJS core
- `@nestjs/jwt` — JWT handling
- `@nestjs/passport` — Authentication
- `@nestjs/swagger` — API documentation
- `@supabase/supabase-js` — Database client
- `firebase-admin` — Firebase integration
- `class-validator` — Input validation
- `class-transformer` — Data transformation

### 3. AI Service (FastAPI)

**Purpose**: Python service for waste classification and DIY suggestions.

**Structure**:
```
ai_service/
├── app/
│   ├── main.py             # FastAPI application
│   ├── api/                # API endpoints
│   │   ├── classify.py     # Classification endpoints
│   │   └── diy.py          # DIY suggestion endpoints
│   ├── core/               # Core configuration
│   │   ├── config.py       # Settings
│   │   └── security.py     # API key validation
│   ├── models/             # ML models
│   │   ├── classifier.py   # Waste classifier
│   │   └── preprocessor.py # Image preprocessing
│   ├── services/           # Business logic
│   │   ├── classification.py
│   │   ├── diy_suggestions.py
│   │   └── cache.py        # Redis caching
│   └── utils/              # Utilities
├── models/                 # Pre-trained model files
├── data/                   # Curated DIY database
└── requirements.txt        # Python dependencies
```

**Key Dependencies**:
- `fastapi` — Web framework
- `uvicorn` — ASGI server
- `tensorflow` / `torch` — ML framework
- `pillow` — Image processing
- `redis` — Caching
- `httpx` — HTTP client
- `pydantic` — Data validation

### 4. Supabase

**Purpose**: PostgreSQL database, file storage, and real-time subscriptions.

**Components**:
- **Database**: PostgreSQL with Row-Level Security
- **Storage**: Image uploads (listings, posts, avatars)
- **Auth**: Supabase Auth (backup for Firebase)
- **Real-time**: WebSocket subscriptions (future)

### 5. Firebase

**Purpose**: Authentication and push notifications.

**Components**:
- **Firebase Auth**: Email/Google authentication
- **Firebase Cloud Messaging**: Push notifications
- **Firebase Analytics**: User analytics (optional)

---

## Service Communication

### API Flow Diagram

```
┌─────────────┐
│ Flutter App  │
└──────┬──────┘
       │
       │ HTTPS (REST API)
       ▼
┌─────────────┐
│   NestJS    │
│   Backend   │
└──────┬──────┘
       │
       ├───────────────────────┐
       │                       │
       ▼                       ▼
┌─────────────┐        ┌─────────────┐
│  Supabase   │        │   Firebase  │
│  (DB)       │        │   (Auth)    │
└─────────────┘        └─────────────┘
       │
       │ HTTPS (REST API)
       ▼
┌─────────────┐
│  AI Service │
│  (FastAPI)  │
└─────────────┘
```

### Authentication Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Flutter App │────▶│   Firebase   │────▶│  NestJS     │
│             │     │   Auth       │     │  Backend    │
└─────────────┘     └─────────────┘     └─────────────┘
      │                   │                   │
      │ 1. Login request  │                   │
      │──────────────────▶│                   │
      │                   │                   │
      │ 2. Firebase JWT   │                   │
      │◀──────────────────│                   │
      │                   │                   │
      │ 3. API call with JWT                  │
      │──────────────────────────────────────▶│
      │                   │                   │
      │                   │ 4. Verify JWT     │
      │                   │◀──────────────────│
      │                   │                   │
      │                   │ 5. User data      │
      │                   │──────────────────▶│
      │                   │                   │
      │ 6. Response       │                   │
      │◀──────────────────────────────────────│
```

### AI Classification Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Flutter App │────▶│   NestJS    │────▶│  AI Service │
│             │     │   Backend   │     │  (FastAPI)  │
└─────────────┘     └─────────────┘     └─────────────┘
      │                   │                   │
      │ 1. Upload image   │                   │
      │──────────────────▶│                   │
      │                   │                   │
      │                   │ 2. Forward image  │
      │                   │──────────────────▶│
      │                   │                   │
      │                   │ 3. Classification │
      │                   │◀──────────────────│
      │                   │                   │
      │                   │ 4. Cache result   │
      │                   │──────────────────▶│
      │                   │                   │
      │ 5. Return result  │                   │
      │◀──────────────────│                   │
```

---

## Sequence Diagrams

### User Registration

```
participant Flutter
participant Firebase
participant NestJS
participant Supabase

Flutter->>Firebase: signInWithGoogle()
Firebase-->>Flutter: Firebase JWT
Flutter->>NestJS: POST /auth/register {email, name, role}
NestJS->>Supabase: INSERT INTO users
Supabase-->>NestJS: User record
NestJS-->>Flutter: {user, access_token}
```

### Marketplace Listing Creation

```
participant Flutter
participant NestJS
participant Supabase

Flutter->>NestJS: POST /marketplace/listings (multipart)
NestJS->>Supabase: Upload images to Storage
Supabase-->>NestJS: Image URLs
NestJS->>Supabase: INSERT INTO marketplace_listings
Supabase-->>NestJS: Listing record
NestJS-->>Flutter: {listing}
```

### AI Scan Flow

```
participant Flutter
participant NestJS
participant AI Service
participant Cache

Flutter->>NestJS: POST /ai/classify (image)
NestJS->>Cache: Check cache
alt Cache hit
    Cache-->>NestJS: Cached result
else Cache miss
    NestJS->>AI Service: POST /classify (image)
    AI Service-->>NestJS: Classification result
    NestJS->>Cache: Store result
end
NestJS-->>Flutter: {classification, diy_suggestions}
```

### Community Post Creation

```
participant Flutter
participant NestJS
participant Supabase

Flutter->>NestJS: POST /community/posts (multipart)
NestJS->>Supabase: Upload images
Supabase-->>NestJS: Image URLs
NestJS->>Supabase: INSERT INTO posts
Supabase-->>NestJS: Post record
NestJS->>NestJS: Award points (+5)
NestJS-->>Flutter: {post}
```

---

## Deployment Architecture

### Cloud Services

```
┌─────────────────────────────────────────────────────────────────┐
│                        DEPLOYMENT MAP                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   Railway       │    │   Supabase      │    │   Firebase  │ │
│  │   (Backend)     │    │   (Database)    │    │   (Auth)    │ │
│  │                 │    │   (Storage)     │    │   (FCM)     │ │
│  │   NestJS API    │    │   PostgreSQL    │    │             │ │
│  │   FastAPI AI    │    │   File Storage  │    │             │ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
│                                                                  │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │   Google Play   │    │   Apple App     │                    │
│  │   Store         │    │   Store         │                    │
│  │   (Android)     │    │   (iOS)         │                    │
│  └─────────────────┘    └─────────────────┘                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Network Topology

```
┌─────────────────────────────────────────────────────────────────┐
│                         INTERNET                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      CDN / Load Balancer                         │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│   Railway       │ │   Supabase      │ │   Firebase      │
│   (Backend)     │ │   (Database)    │ │   (Auth)        │
│   Port 3000     │ │   Port 5432     │ │   Port 443      │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

### Security Boundaries

| Boundary | Protection | Implementation |
|---|---|---|
| Client → API | HTTPS | TLS 1.3 |
| API → Database | Supabase internal | VPC / Private network |
| API → AI Service | Internal API | API key authentication |
| API → Firebase | Firebase SDK | Service account |
| Database | RLS policies | Row-Level Security |
| Storage | Signed URLs | Time-limited access |

---

## Scalability Considerations

### Horizontal Scaling

| Component | Scaling Strategy |
|---|---|
| NestJS Backend | Multiple instances behind load balancer |
| AI Service | Multiple instances, queue-based processing |
| Supabase | Managed scaling (Supabase handles) |
| Firebase | Managed scaling (Google handles) |

### Vertical Scaling

| Component | Current | Upgrade Path |
|---|---|---|
| NestJS Backend | 1GB RAM | 2GB, 4GB |
| AI Service | 1GB RAM | 2GB, 4GB, GPU |
| Supabase | Free tier | Pro, Team |

### Performance Targets

| Metric | Target | Strategy |
|---|---|---|
| API response time | < 500ms | Connection pooling, caching |
| AI classification | < 5s | Model optimization, caching |
| Image upload | < 10s | Compression, CDN |
| App launch | < 3s | Lazy loading, caching |

---

## Document Reference

This document references:
- PRD v1.0, Section 13.1 (System Architecture)
- 08_Database_Design.md
- 09_API_Specification.md

This document is referenced by:
- 11_AI_Architecture.md
- 12_Development_Setup.md
- 14_Deployment_Guide.md
