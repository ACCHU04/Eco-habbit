# EcoHabbit v2.0.0 — Release Notes

**Release Date:** July 28, 2026
**Codename:** Campus Sustainability Super App

---

## What's New in v2.0.0

EcoHabbit v2.0 transforms from a simple waste management app into a **campus sustainability super app** with gamification, contextual AI, daily habit loops, multi-campus support, and production-grade observability.

---

### Quests & Coins (M1)
- **Daily Quests:** Personalized eco-action quests with XP and coin rewards
- **Streak System:** Daily login and action streaks with multiplier bonuses
- **Coin Shop:** Spend earned coins on rewards and upgrades
- **Quest Progress Tracking:** Real-time progress bars and completion states

### Eco Passport (M2)
- **Digital Passport:** Track all eco actions in a personal digital passport
- **Streak Calendar:** Visual heatmap of daily eco actions
- **Milestone Rewards:** Unlock achievements at key milestones
- **Action Categories:** Track waste reduction, energy saving, and community contributions

### Community & Social (M3)
- **Rich Posts:** Create posts with images, tags, and formatting
- **Bookmarks:** Save posts for later reference
- **Search:** Full-text search across community content
- **Notifications:** Real-time push notifications for social interactions
- **Trending Algorithm:** Discover popular and impactful content

### Marketplace (M4)
- **Browse & List:** Buy and sell secondhand items on campus
- **Image Upload:** Multiple images per listing with drag-and-drop
- **Category Filters:** Furniture, electronics, textbooks, clothing
- **Listing Management:** Edit, pause, and delete your listings

### Engagement Features (M5)
- **Global Leaderboards:** Compete with the entire campus
- **Friend Leaderboards:** See how you rank among friends
- **Hostel Battles:** Inter-hostel sustainability competitions
- **Friend Challenges:** 1v1 eco-action challenges with progress tracking
- **Achievements:** 15+ badge types and 10 achievement definitions

### Polish & Optimization (M6)
- **Page Transitions:** Custom slide-up, fade-through, and shared-axis transitions
- **Image Caching:** All images cached offline with `CachedNetworkImage`
- **Error Handling:** Consistent error views with retry across all screens
- **Empty States:** Beautiful empty state illustrations with call-to-action
- **Skeleton Loaders:** Shimmer loading states instead of spinners
- **Accessibility:** Semantic labels and tooltips throughout

### Analytics & Observability (M7)
- **Firebase Analytics:** Custom event tracking (scan, post, listing, quest, challenge)
- **Crashlytics:** Fatal and non-fatal error reporting with stack traces
- **Screen Tracking:** Automatic screen view events via FirebaseAnalyticsObserver
- **LoggingInterceptor:** Backend request/response logging with timing
- **AllExceptionsFilter:** Global error handling with unique request ID

### Admin Backend & Dashboard (M8)
- **Admin Dashboard:** System-wide stats (users, listings, posts, scans)
- **User Management:** Search, view, edit roles, activate/deactivate users
- **Role Hierarchy:** student → ngo → organization → moderator → admin → super_admin
- **Audit Log:** Track admin actions with actor, target, action, timestamp
- **Content Moderation:** Verify reports and take action
- **Last Super Admin Protection:** Cannot demote or deactivate the sole super_admin

### Performance & Caching (M9)
- **Redis Caching:** AppCacheService with namespaced keys and TTLs
- **Cache Strategy:** Leaderboard (30s), Feed (30s), DIY (5min), Dashboard (1min), Campus (5min)
- **Cache Invalidation:** Pattern-based key invalidation on mutations
- **Image Caching:** All network images use CachedNetworkImage

### Multi-Campus Support (M10)
- **Campuses Table:** Unique slug, name, domain, city, state, settings (JSONB)
- **Backend CampusModule:** CRUD, slug lookup, set user campus, cache integration
- **Campus Assignment:** Users can select their campus; features filter by campus
- **Settings:** Per-campus toggle for leaderboard, marketplace, AI features
- **Flutter Feature:** Campus picker screen, search, profile integration, storage persistence

### AI Enhancements (M11)
- **Configurable Confidence Threshold:** Environment variable instead of hardcoded 0.80
- **AI Explanations:** Human-readable rationale from top-3 ImageNet labels
- **Disposal Guidance API:** Dedicated cached endpoint, ready for campus-specific tips
- **Analytics:** Scan events tracked with category, confidence, uncertainty, cache status
- **Confidence Bands:** High/Medium/Low labels with retake suggestions

---

## Technical Stack

| Layer | Technology |
|-------|-----------|
| Mobile | Flutter 3.44.7 / Dart 3.12.2 |
| State | Riverpod 2.6 |
| Routing | GoRouter 14.8 |
| Backend | NestJS 11 / TypeScript |
| Database | Supabase (PostgreSQL) |
| Auth | Firebase Auth |
| AI | Python / FastAPI / TensorFlow (MobileNetV2) |
| Cache | Redis 7 |
| Hosting | Render (backend) |

---

## Testing

| Suite | Tests | Status |
|-------|-------|--------|
| Flutter | 288 | All passing |
| Backend | 196 | All passing |
| **Total** | **484** | **100% passing** |
| `flutter analyze` | — | 0 issues |

---

## Security

- Helmet HTTP security headers
- Rate limiting (60 requests per minute per IP)
- RolesGuard with 6-tier role hierarchy
- Global exception filter with request ID tracking
- Input validation with whitelist mode (forbidNonWhitelisted)
- CORS restricted to known origins
- Row-Level Security on all Supabase tables
- Last super_admin protection

---

## Known Issues

- iOS support deferred to future release
- Manual re-classification (low confidence override) UI exists but backend endpoint pending
- SQL migrations require manual application via Supabase Dashboard (no CLI/API for DDL)

---

## Upgrade Notes

**From v2.0.0-rc1:** No breaking API changes. Apply all pending Supabase migrations before deploying the updated backend.

**From v1.0.0:** Database migrations are cumulative. Apply all 25 migrations in chronological order. The `users.id` type changed from UUID to text (migration `20260724000001`) — this must run before any migration that references `users(id)` with a text FK.

---

**Full Changelog:** See [CHANGELOG.md](./CHANGELOG.md)
**Deployment Guide:** See [docs/DEPLOYMENT.md](./docs/DEPLOYMENT.md)
**Architecture Overview:** See [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)
