# Operations Runbook

## Service Endpoints

| Service | URL | Health Check |
|---------|-----|-------------|
| Backend API | `https://eco-habbit.onrender.com` | `GET /health` |
| AI Service | Internal (or `http://localhost:8000`) | `GET /health` |
| Supabase | `https://uxbduizptptsyayqimlk.supabase.co` | Dashboard |
| Redis | Internal to Render | `redis-cli ping` |

---

## Monitoring

### Backend Logs

- Render Dashboard → your service → "Logs" tab
- Structured log format:
  ```
  [method] [url] [statusCode] [durationMs] [requestId]
  ```
- Filter by `ERROR` level: `error` in the search bar

### Flutter Crashlytics

- Firebase Console → Crashlytics dashboard
- Filter by version (`2.0.0`)
- Check for fatal vs. non-fatal error rates
- Investigate stack traces in the Issues tab

### Firebase Analytics

- Firebase Console → Analytics dashboard
- Key events to monitor: `scan_completed`, `scan_failed`, `post_created`, `listing_created`
- User engagement: daily/weekly active users, session duration

---

## Common Operations

### Restart Backend

Render Dashboard → your service → "Manual Deploy" → "Clear build cache & deploy"

### Check API Latency

```bash
curl -w "@curl-format.txt" -o /dev/null -s https://eco-habbit.onrender.com/health
```

with `curl-format.txt` containing:
```
time_total: %{time_total}s\n
```

### View Database Status

Supabase Dashboard → Database → "Roles" → verify service role exists
Supabase Dashboard → SQL Editor → run:
```sql
SELECT schemaname, tablename, tableowner FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;
```

### Check Cache Hit Rate

Backend logs show cache HIT/MISS per request. Search for:
- `Cache HIT for hash`
- `Cache MISS for hash`
- `Invalidated [N] cache keys matching`

---

## Common Issues

### Issue: Backend returns 500 on startup

**Check:** Environment variables — are `SUPABASE_URL`, `SUPABASE_SERVICE_KEY`, and Firebase credentials set correctly?

**Fix:** Render Dashboard → Environment → verify all required vars. Redeploy after fixing.

### Issue: Flutter app shows "Connection timeout"

**Check:** Is the API base URL correct? Is the backend running?

**Fix:** Verify `API_BASE_URL` in `lib/core/config/app_config.dart` matches the deployed backend URL. Rebuild with correct `--dart-define`.

### Issue: AI classification fails

**Check:** Is the AI service running? Is `AI_SERVICE_URL` set correctly?

**Fix:** If AI service is unavailable, the backend returns a 500 error. Deploy the AI service or set a fallback.

### Issue: Campus picker shows no campuses

**Check:** Were the campus migrations applied? Is there seed data?

**Fix:** Run `20260729010000_create_campuses.sql` migration. The migration includes seed data for Chanakya University, Standard University, Green Valley College.

### Issue: Admin panel returns 403

**Check:** Does the user have `admin` or `super_admin` role?

**Fix:** Directly update the role in Supabase: `UPDATE users SET role = 'admin' WHERE id = 'user-id';`

### Issue: Push notifications not delivered

**Check:** FCM token stored? Firebase credentials valid?

**Fix:** Verify `FIREBASE_PRIVATE_KEY` format (must include `\n` line breaks). Check Firebase Console → Cloud Messaging for send stats.

---

## Backup

### Database

Supabase takes automatic daily backups (Pro plan). To restore:
1. Supabase Dashboard → Database → Backups
2. Select a backup
3. Click "Restore" (creates a new project)

### Code

Git repository at `https://github.com/ACCHU04/Eco-habbit.git` serves as the code backup.

---

## Scheduled Tasks

| Task | Frequency | Method |
|------|-----------|--------|
| Review error rates | Daily | Firebase Crashlytics |
| Check API latency | Weekly | Render logs |
| Verify database size | Weekly | Supabase Dashboard |
| Rotate service keys | Quarterly | Manual |
| Update dependencies | Monthly | `npm outdated`, `flutter pub outdated` |
