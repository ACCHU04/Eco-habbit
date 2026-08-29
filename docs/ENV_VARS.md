# Environment Variables Reference

## Backend API (`services/backend_api/.env`)

### Supabase

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `SUPABASE_URL` | Yes | — | Supabase project URL |
| `SUPABASE_ANON_KEY` | Yes | — | Supabase public anon key (publishable) |
| `SUPABASE_SERVICE_KEY` | Yes | — | Supabase service role key (secret — rotate regularly) |

### Firebase

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `FIREBASE_PROJECT_ID` | Yes | — | Firebase project ID |
| `FIREBASE_PRIVATE_KEY` | Yes | — | Firebase Admin SDK private key (must include `\n` for line breaks) |
| `FIREBASE_CLIENT_EMAIL` | Yes | — | Firebase Admin SDK client email |

### AI Service

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `AI_SERVICE_URL` | No | `http://localhost:8000` | FastAPI AI service URL |
| `AI_SERVICE_API_KEY` | No | — | API key for AI service authentication |

### Authentication

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `JWT_SECRET` | No | — | Secret for any internal JWT tokens (not Firebase) |
| `JWT_EXPIRATION` | No | `7d` | JWT token expiry duration |

### Server

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `PORT` | No | `3000` | Backend listen port |
| `NODE_ENV` | No | `development` | `development` or `production` |
| `CORS_ORIGINS` | No | `true` (allow all) | Comma-separated allowed origins |
| `ENABLE_SWAGGER` | No | `true` | Set to `false` in production |

### Cache (optional)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `REDIS_URL` | No | `redis://localhost:6379` | Redis connection URL |
| `CACHE_TTL_LEADERBOARD` | No | `30000` | Leaderboard cache TTL (ms) |
| `CACHE_TTL_FEED` | No | `30000` | Community feed cache TTL (ms) |
| `CACHE_TTL_DIY` | No | `300000` | DIY projects cache TTL (ms) |
| `CACHE_TTL_DASHBOARD` | No | `60000` | Home dashboard cache TTL (ms) |
| `CACHE_TTL_CAMPUS` | No | `300000` | Campus data cache TTL (ms) |
| `CACHE_TTL_DISPOSAL` | No | `300000` | Disposal tips cache TTL (ms) |

---

## AI Service (`services/ai_service/.env`)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `REDIS_URL` | No | `redis://localhost:6379` | Redis connection URL |
| `SUPABASE_URL` | No | — | Supabase project URL (for future DB-backed tips) |
| `SUPABASE_SERVICE_KEY` | No | — | Supabase service role key |
| `CONFIDENCE_THRESHOLD` | No | `0.80` | Minimum confidence for certain classification |
| `API_KEY` | No | — | API key for incoming requests |
| `PORT` | No | `8000` | Service listen port |

---

## Flutter (Compile-Time `--dart-define`)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `API_BASE_URL` | No | `https://eco-habbit.onrender.com/api/v1` | Backend API base URL |
| `AI_SERVICE_URL` | No | `http://10.0.2.2:8000/api/v1` | Direct AI service URL (Android emulator) |

Pass at build time:
```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://eco-habbit.onrender.com/api/v1
```

---

## Docker Compose (`docker-compose.yml`)

Not used in production but available for local development:

| Service | Port | .env File |
|---------|------|-----------|
| `redis` | 6379 | — |
| `backend` | 3000 | `./services/backend_api/.env` |
| `ai_service` | 8000 | `./services/ai_service/.env` |

```bash
docker-compose up --build
```
