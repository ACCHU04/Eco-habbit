# EcoHabbit v2.0.0-rc1 — Release Notes

**Release Date:** July 28, 2026
**Codename:** Campus Sustainability Super App

---

## What's New in v2.0.0

EcoHabbit v2.0 transforms from a simple waste management app into a **campus sustainability super app** with gamification, contextual AI, and daily habit loops that drive real behavioral change.

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
| AI | Python / FastAPI / TensorFlow |
| Hosting | Render (backend) |

---

## Testing

| Suite | Tests | Status |
|-------|-------|--------|
| Flutter | 279 | All passing |
| Backend | 126 | All passing |
| **Total** | **405** | **100% passing** |

---

## Security

- Helmet HTTP security headers
- Rate limiting (60 requests per minute per IP)
- Global exception filter with request ID tracking
- Input validation with whitelist mode
- CORS properly configured

---

## Known Issues

- iOS support deferred to Phase 4
- Some Flutter packages have newer versions available (non-breaking)

---

## Upgrade Notes

No breaking API changes from v1.0.0. This is a feature-complete release candidate.

---

**Full Changelog:** See [CHANGELOG.md](../CHANGELOG.md)
