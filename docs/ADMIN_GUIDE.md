# Admin Guide

## Role Hierarchy

```
student (0) → ngo (1) → organization (2) → moderator (3) → admin (4) → super_admin (5)
```

Higher roles inherit all permissions from lower roles. Only `admin` and `super_admin` can access the Admin Panel.

---

## Accessing the Admin Panel

1. Log in with an account that has `admin` or `super_admin` role
2. Go to Profile → "Admin Panel" (appears at the bottom of the menu)
3. Use the admin navigation to access different sections

If "Admin Panel" does not appear, the account does not have admin privileges.

---

## Admin Dashboard

The dashboard shows system-wide metrics:

- **Total Users:** Registered user count
- **Active Listings:** Marketplace listings with status = 'active'
- **Total Posts:** Community posts count
- **Total Scans:** AI classification scans performed
- **Pending Reports:** Reports awaiting moderator action

---

## User Management

### Viewing Users
- Search by name, email, or role
- Table shows: Name, Email, Role, Status (Active/Inactive), Joined Date

### Editing a User
1. Click a user row to view details
2. Available actions:
   - **Change Role:** Select from role hierarchy dropdown
   - **Activate/Deactivate:** Toggle account status
   - **View Audit History:** See admin actions involving this user

### Role Assignment Guidelines

| Target Role | Allowed From |
|------------|--------------|
| `moderator` | admin, super_admin |
| `admin` | super_admin only |
| `super_admin` | Cannot be assigned via UI (DB only) |

### Protection Rules

- Cannot deactivate your own account
- Cannot deactivate the last `super_admin`
- Cannot demote the last `super_admin` to a lower role
- Role changes are recorded in the audit log

---

## Campus Management

Only `admin` and `super_admin` can manage campuses.

### Creating a Campus
- **Name:** Full university/college name
- **Slug:** URL-friendly unique identifier (e.g., `chanakya-university`)
- **Short Name:** Abbreviation for display (e.g., `CU`)
- **Domain:** Optional email domain for auto-assignment
- **City, State, Country:** Location
- **Logo URL:** Optional image URL

### Settings (JSONB)

Standard keys that can be set in the settings JSON:

```json
{
  "leaderboard_enabled": true,
  "marketplace_enabled": true,
  "ai_enabled": true,
  "theme_color": "#10B981"
}
```

### Deactivating a Campus

Use the "Deactivate" action. Deactivated campuses:
- Do not appear in the campus picker
- Existing users retain their campus assignment
- Content is preserved but filtered from queries

---

## Content Moderation

### Reports
- Users can report inappropriate content (posts, listings)
- Admin dashboard shows pending reports
- Each report shows: reporter, target type, reason, timestamp
- Action options:
  - **Dismiss:** No action taken
  - **Hide Content:** Remove from public view (soft delete)
  - **Warn User:** Send a warning notification
  - **Ban User:** Deactivate the offending user's account

---

## Audit Log

Every admin action is recorded with:

| Field | Description |
|-------|-------------|
| Actor ID | Admin who performed the action |
| Actor Name | Admin's name |
| Action | Type of action (update_role, deactivate_user, dismiss_report, etc.) |
| Target ID | User or resource affected |
| Target Name | Name of the affected entity |
| Details | JSON with action-specific metadata |
| Timestamp | When the action occurred |

### Retention
Audit logs are retained indefinitely for compliance and traceability.

---

## Troubleshooting

### "Insufficient permissions" error
- The account role is not high enough for the attempted action
- Verify the role in Supabase: `SELECT id, full_name, role FROM users WHERE id = 'your-uid';`

### Campus not appearing
- Check if the campus is active: `SELECT slug, name, is_active FROM campuses;`
- Verify the migration was applied

### User cannot be found
- The user may not have a Supabase row yet (auto-created on first API call)
- Have the user perform an action (scan, post, etc.) or use the sync helper
