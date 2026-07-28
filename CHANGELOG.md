# Changelog

All notable changes to EcoHabbit will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [2.0.0] — 2026-07-28

### Added
- **M7 Analytics & Observability:** Firebase Analytics event tracking, Crashlytics error reporting, FirebaseAnalyticsObserver for screen tracking, LoggingInterceptor, AllExceptionsFilter with request ID
- **M9 Performance & Caching:** Redis-backed AppCacheService with 5-min TTL for leaderboards/DIY/campuses, cache key namespacing (community:diy:leaderboard:), CachedNetworkImage migration for all network images
- **M8 Admin Backend & Dashboard:** 10 admin endpoints (dashboard stats, user management, role management, content moderation, audit log, settings), admin role hierarchy (student → ngo → organization → moderator → admin → super_admin), last super_admin protection
- **M10 Multi-Campus Support:** campuses table with slug/UUID, campus_id FK on users/hostels/posts/marketplace_listings, backend CampusModule (CRUD, slug lookup, set user campus, cache integration), Flutter campus feature (model, repository, providers, CampusPickerScreen, CampusChip, CampusAvatar, storage persistence, router integration, profile integration)
- **M11 AI Enhancements:** Configurable confidence threshold via env var, human-readable AI explanations from top-3 ImageNet labels, cached DisposalModule endpoint (campus-aware foundation), analytics logging for scanCompleted/scanFailed events, confidence band labels (high/medium/low)
- **288 Flutter tests** across all features
- **196 backend tests** across all modules

### Security
- Helmet HTTP security headers
- Rate limiting (60 req/min per IP)
- RolesGuard with role hierarchy for admin endpoints
- Global exception filter with request ID tracking
- Request ID middleware for traceability
- Validation pipe with whitelist + forbidNonWhitelisted

### Changed
- All `Image.network` replaced with `CachedNetworkImage` for offline caching
- Error states now use `EcoErrorView` with retry across all screens
- Empty states now use `EcoEmptyState` consistently
- Engagement screens use skeleton loaders instead of spinners
- Scanner screens migrated to EcoTokens spacing system
- Backend version bumped from 2.0.0-rc1 to 2.0.0

## [2.0.0-rc1] — 2026-07-28

### Added
- **Phase 2 Milestone 1 — Quests & Coins:** Daily quests, streaks, coin shop, quest progress tracking
- **Phase 2 Milestone 2 — Eco Passport:** Digital passport with eco actions, streak calendar, milestone rewards
- **Phase 2 Milestone 3 — Community Rewrite:** Rich posts with images/tags, bookmarks, search, notifications, trending
- **Phase 2 Milestone 4 — Marketplace:** Browse/list items, image upload, listings management
- **Phase 2 Milestone 5 — Engagement Features:** Leaderboards (global/friends/hostel), hostel battles, friend challenges, achievements system
- **Phase 2 Milestone 6 — Polish & Optimization:** Page transitions, CachedNetworkImage, EcoErrorView, EcoEmptyState, skeleton loaders, accessibility (Semantics, tooltips)
- **279 Flutter tests** across all features
- **126 backend tests** across all modules
- **8 DIY project templates** seeded in database

### Security
- Helmet HTTP security headers
- Rate limiting (60 req/min per IP)
- Global exception filter with request ID tracking
- Request ID middleware for traceability

### Changed
- All `Image.network` replaced with `CachedNetworkImage` for offline caching
- Error states now use `EcoErrorView` with retry across all screens
- Empty states now use `EcoEmptyState` consistently
- Engagement screens use skeleton loaders instead of spinners
- Backend version bumped to 2.0.0-rc1

## [1.0.0] — 2026-07-20

### Added
- AI Waste Scanner (MobileNetV2)
- Marketplace
- DIY Upcycling Studio
- Community Feed
- Rewards & Gamification
- Push Notifications
- 253 automated tests
- Flutter / NestJS / Supabase / Python/FastAPI/TensorFlow / Firebase Auth architecture
