# Deployment Guide

## Prerequisites

- Git access to `https://github.com/ACCHU04/Eco-habbit.git`
- Supabase Dashboard access (for SQL migrations)
- Render.com account (backend hosting)
- Firebase Console access (for Google Services JSON)
- Flutter 3.44.7+ SDK

---

## 1. Supabase Migrations

All DDL must be applied via the **Supabase Dashboard SQL Editor** — the project's Supabase Management API key is not available.

### Execution Order

Apply migrations in chronological order by timestamp:

```
20260723100000_create_enums.sql
20260723100001_create_users_table.sql
20260723100002_create_marketplace_tables.sql
20260723100003_create_ai_tables.sql
20260723100004_create_diy_tables.sql
20260723100005_create_community_tables.sql
20260723100006_create_reports_table.sql
20260723100007_create_rewards_tables.sql
20260723100008_create_notifications_tables.sql
20260723100009_create_rls_policies.sql
20260723100010_create_functions.sql
20260723110000_seed_diy_projects.sql
20260723120000_add_fcm_token.sql
20260724000001_change_user_id_to_text.sql    ← Critical: run before any text-FK migration
20260725000001_fix_rpcs_and_add_gamification.sql
20260726000001_add_last_active_date.sql
20260726000002_create_user_bookmarks.sql
20260726000003_create_trending_rpc.sql
20260727000001_fix_linter_and_type_safety.sql
20260728000001_m5_engagement_features.sql
20260728010000_admin_module.sql
20260729010000_create_campuses.sql
20260729010001_add_campus_id_fks.sql
```

### Steps

1. Open the Supabase Dashboard → SQL Editor
2. Paste each migration file's content and run
3. Verify no errors before proceeding to the next
4. After all migrations, verify: `SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';`

---

## 2. Backend Deployment (Render)

### Build Configuration

| Setting | Value |
|---------|-------|
| Runtime | Node |
| Build command | `npm ci && npm run build` |
| Start command | `node dist/main.js` |
| Health check path | `/health` |

### Environment Variables (Production)

Set these in Render Dashboard → Environment:

| Variable | Production Value | Notes |
|----------|-----------------|-------|
| `NODE_ENV` | `production` | Disables verbose errors |
| `ENABLE_SWAGGER` | `false` | Disables Swagger UI in prod |
| `CORS_ORIGINS` | `https://your-app.onrender.com,ecohabbit://` | Flutter app scheme |
| `SUPABASE_URL` | `https://uxbduizptptsyayqimlk.supabase.co` | |
| `SUPABASE_SERVICE_KEY` | *(rotated)* | Use rotated key |
| `FIREBASE_PROJECT_ID` | `echo-habbit` | |
| `FIREBASE_PRIVATE_KEY` | *(rotated)* | Use rotated key |
| `FIREBASE_CLIENT_EMAIL` | `firebase-adminsdk-fbsvc@echo-habbit.iam.gserviceaccount.com` | |
| `AI_SERVICE_URL` | `http://localhost:8000` | Or deployed AI service URL |
| `JWT_SECRET` | *(generated)* | Random 64-char string |
| `JWT_EXPIRATION` | `7d` | |
| `PORT` | `3000` | |
| `REDIS_URL` | `redis://...` | If Redis is available |

### Deployment Steps

1. Push latest code to `main` branch
2. Render auto-deploys via GitHub integration (or manual deploy from branch)
3. Verify: `curl https://your-app.onrender.com/health`
4. Verify: `curl https://your-app.onrender.com/api/v1/ai/classify` returns 401 (auth required)
5. Monitor logs for errors

---

## 3. Flutter Build

### Production Configuration

The API base URL is a compile-time constant in `lib/core/config/app_config.dart`. Default points to `https://eco-habbit.onrender.com/api/v1`.

### Build Command

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://eco-habbit.onrender.com/api/v1
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Verification

1. Install APK on device
2. Register a new account
3. Verify home screen loads with dashboard data
4. Perform an AI scan
5. Browse community feed
6. Verify campus picker works
7. Logout and re-login

---

## 4. Post-Deployment Verification

### API Smoke Tests

```bash
# Health
curl https://your-app.onrender.com/health

# Auth-protected endpoint (expect 401 without token)
curl https://your-app.onrender.com/api/v1/ai/classify

# Public endpoint
curl https://your-app.onrender.com/api/v1/campuses
```

### Cross-Feature Smoke Test

1. Register new user → select campus → perform AI scan → create community post → verify campus filter on leaderboard → check admin panel (admin account) → verify scan history

---

## 5. Rollback

See [ROLLBACK.md](./ROLLBACK.md) for revert procedures.
