# Rollback Guide

## Backend Rollback

### Render — Revert to Previous Deploy

1. Render Dashboard → your service → "Manual Deploy" → "Deploy to previous version"
2. Select the last known-good deploy
3. Confirm deploy
4. Verify `/health` returns 200

### Git Revert (if needed)

```bash
# Identify the last known-good commit
git log --oneline -10

# Create revert commit
git revert HEAD  # reverts latest commit, creates new commit
git push origin main
```

Render auto-deploys on push.

---

## Database Rollback

### Supabase Migrations

PostgreSQL does not have automatic migration rollback. Each migration must be manually reversed.

### General Strategy

1. Identify which migration(s) caused the issue from the file timestamp
2. Write a compensating migration (e.g., `DROP TABLE`, `ALTER TABLE ... DROP COLUMN`)
3. Apply the compensating SQL via Supabase Dashboard SQL Editor
4. Update the migration file comment to note the rollback

### Rollback Scripts by Migration

#### `20260729010000_create_campuses.sql`
```sql
DROP TABLE IF EXISTS campuses CASCADE;
```

#### `20260729010001_add_campus_id_fks.sql`
```sql
ALTER TABLE users DROP COLUMN IF EXISTS campus_id;
ALTER TABLE users DROP COLUMN IF EXISTS campus_joined_at;
ALTER TABLE hostels DROP COLUMN IF EXISTS campus_id;
ALTER TABLE posts DROP COLUMN IF EXISTS campus_id;
ALTER TABLE marketplace_listings DROP COLUMN IF EXISTS campus_id;
```

#### `20260728010000_admin_module.sql`
```sql
DROP TABLE IF EXISTS audit_log CASCADE;
ALTER TABLE users DROP COLUMN IF EXISTS is_active;
ALTER TABLE users DROP COLUMN IF EXISTS last_active_at;
```

#### `20260724000001_change_user_id_to_text.sql` (irreversible without full restore)
This migration changes `users.id` from UUID to text. Reverting requires:
- Ensure all FK references use text
- Cast back: `ALTER TABLE users ALTER COLUMN id TYPE UUID USING id::uuid;`
- Only safe if no text-based UUIDs exist

**Prefer restoring from backup over reverting this migration.**

---

## Flutter Rollback

### Play Store / Internal Distribution

1. Build the previous APK from the last known-good commit:
   ```bash
   git checkout <last-good-tag>
   flutter build apk --release
   ```
2. Distribute the APK
3. Communicate to users that they should downgrade

### Git Restore

```bash
git checkout tags/v2.0.0-rc1  # or any stable tag
flutter build apk --release
```

---

## Emergency Contacts

| Role | Contact |
|------|---------|
| Backend / Deploy | GitHub repo owner |
| Database (Supabase) | Dashboard admin |
| Firebase | Console admin |

---

## Recovery Time Estimates

| Scenario | RTO |
|----------|-----|
| Backend misconfig | <10 min |
| Bad deploy (migrations applied) | <30 min + DB revert |
| Bad deploy (no DB changes) | <5 min |
| Flutter bad build | <30 min |
| Full system restore from backup | <4 hours |
