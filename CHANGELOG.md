# Changelog

All notable changes to EcoHabbit will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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
