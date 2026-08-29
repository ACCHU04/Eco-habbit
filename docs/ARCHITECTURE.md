# EcoHabbit Architecture

## System Overview

```
[Mobile App: Flutter/Dart]
       | HTTPS (Bearer JWT)
       v
[NestJS Backend API] ──→ [Supabase (PostgreSQL)]
       |                      └─ RLS policies
       | HTTPS
       v
[FastAPI AI Service] ──→ [TensorFlow MobileNetV2]
       |
       v
[Redis Cache]
```

## Flutter Architecture (`apps/mobile_app/`)

### Layer Structure (Feature-First)

```
lib/
  core/              # Cross-cutting concerns
    config/          # AppConfig (compile-time constants)
    router/          # GoRouter (auth redirect, role-based guards)
    services/        # ApiClient, StorageService, AnalyticsService
    theme/           # AppTheme, EcoTokens, colors
    widgets/         # Shared: EcoErrorView, EcoEmptyState, EcoBottomNav
  features/          # Feature modules
    auth/            # Login, register, role selection, profile setup
    scanner/         # AI camera + classification results
    home/            # Dashboard
    community/       # Posts, comments, bookmarks, search
    marketplace/     # Listings, categories, images
    profile/         # User profile, stats, settings
    campus/          # Multi-campus picker, widgets
    admin/           # Admin dashboard, users, audit, reports
    ...              # quests, coins, passport, engagement, etc.
```

### Key Patterns

- **State Management:** Riverpod (StateNotifier for async, Provider for DI, FutureProvider for data fetching)
- **Repository Pattern:** Each feature has a repository wrapping ApiClient calls
- **GoRouter:** Auth redirect guard, role-based route protection, ShellRoute for bottom nav
- **ApiClient:** Dio-based, auto-attaches Firebase ID token, error mapping
- **AnalyticsService:** Wraps Firebase Analytics, typed event enum, screen tracking observer

## NestJS Backend (`services/backend_api/`)

### Module Structure

```
src/
  main.ts                  # Bootstrap: Helmet, CORS, Swagger, ValidationPipe
  app.module.ts            # Root module (imports all feature modules)
  app.controller.ts        # Health check
  config/                  # SupabaseModule, FirebaseModule
  common/
    guards/                # AuthGuard (Firebase JWT), RolesGuard (role hierarchy)
    decorators/            # @CurrentUser, @Roles
    filters/               # AllExceptionsFilter (request ID, structured error)
    interceptors/          # LoggingInterceptor (timing, method, URL)
    middleware/             # RequestIdMiddleware (correlation ID)
    cache/                 # AppCacheService (Redis-backed, namespaced keys)
    helpers/               # user-sync.helper (auto-create Supabase user row)
  modules/
    auth/                  # Firebase token verification, phone auth
    users/                 # CRUD, campus assignment
    ai/                    # Classification passthrough to FastAPI, scan history
    campuses/              # CRUD, slug lookup, user campus assignment
    community/             # Posts, comments, likes, bookmarks, trending
    marketplace/           # Listings, categories, images
    diy/                   # DIY projects CRUD
    rewards/               # Points, badges
    notifications/         # Push notifications (FCM)
    quests/                # Daily quests, progress tracking
    coins/                 # Coin transactions, shop
    passport/              # Eco passport, activity timeline
    leaderboards/          # Global, friend, hostel rankings
    hostels/               # Hostel management, battles
    challenges/            # Friend challenges
    engagement/            # Unified engagement hub
    admin/                 # Dashboard stats, user management, audit log
    disposal/              # Disposal tips (campus-ready)
```

### Request Flow

```
Request
  → RequestIdMiddleware (adds x-request-id)
  → ThrottlerGuard (60 req/min)
  → AuthGuard (verifies Firebase JWT, attaches user)
  → RolesGuard (checks role if @Roles present)
  → Controller
  → Service (business logic + Supabase + Cache)
  → LoggingInterceptor (logs response + timing)
  → AllExceptionsFilter (catch-all, structured error)
```

## FastAPI AI Service (`services/ai_service/`)

### Pipeline

```
Image Upload
  → File validation (JPEG/PNG, max 5MB)
  → Redis cache check (TTL: 24h)
  → TensorFlow MobileNetV2 inference
  → ImageNet label → waste category mapping
  → Top-3 label extraction
  → Explanation generation (human-readable rationale)
  → DIY suggestion lookup (curated by waste category)
  → Redis cache write
  → Response
```

### Fallback

When TensorFlow is unavailable: always classifies as `plastic` with 0.9450 confidence. Used for development environments.

## Supabase Schema

### Key Tables

| Table | Purpose | RLS |
|-------|---------|-----|
| `users` | User profiles, roles, campus_id | Owner read/write |
| `campuses` | Campus definitions, settings | Service role only |
| `ai_scans` | Scan history | Owner read, system insert |
| `ai_scan_cache` | Durable scan cache (30-day TTL) | Service role only |
| `posts` / `comments` / `likes` | Community content | Public read, owner write |
| `marketplace_listings` | Listings | Public read, seller write |
| `eco_rewards` / `user_badges` | Gamification | Owner read, system insert |
| `notifications` | Push notifications | Owner read/write |
| `audit_log` | Admin action log | Service role only |
| `eco_quests` / `user_quest_progress` | Quests | System manage |

## Cache Flow

```
┌─ AppCacheService (NestJS, Redis) ─────────────────┐
│  CacheKeys: namespaced, e.g. "leaderboard:..."    │
│  CacheTTL: 30s leaderboard, 5min campus/DIY        │
│  Invalidation: pattern-based key deletion          │
└───────────────────────────────────────────────────┘

AI Cache (3 tiers):
  1. PostgreSQL ai_scan_cache (30-day TTL, durable)
  2. Redis (24-hour TTL, FastAPI side)
  3. Model inference (slow path)
```

## Analytics Flow

```
Flutter Event (scanCompleted, postCreated, etc.)
  → AnalyticsService.logEvent()
  → Firebase Analytics
  → Firebase Console / BigQuery

Backend Request
  → LoggingInterceptor (method, URL, status, ms)
  → stdout (structured logs)
  → Render log dashboard
```
