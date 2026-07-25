# Phase 2 API Contract

Backend base URL: `https://eco-habbit.onrender.com/api/v1`

All endpoints require `Authorization: Bearer <firebase_id_token>` header unless noted.

---

## Quests

### GET /quests/today

Returns today's active daily quests enriched with the authenticated user's progress.

**Response 200:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "title": "First Scan",
      "description": "Scan your first item for recycling",
      "quest_type": "daily",
      "xp_reward": 25,
      "coin_reward": 5,
      "difficulty": "easy",
      "target_action": "scan_item",
      "target_count": 1,
      "progress": 0,
      "completed": false
    }
  ]
}
```

### GET /quests

Returns all active quests (daily + weekly + bonus) with user progress.

**Response 200:** Same shape as `/quests/today` but `data` includes all quest types.

### GET /quests/history?page=1&limit=20

Returns the authenticated user's completed quest history with pagination.

**Query params:** `page` (default 1), `limit` (default 20)

**Response 200:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "quest_id": "uuid",
      "user_id": "uid",
      "current_count": 1,
      "completed_at": "2026-07-25T10:00:00Z",
      "created_at": "2026-07-25T08:00:00Z",
      "eco_quests": {
        "id": "uuid",
        "title": "First Scan",
        "xp_reward": 25,
        "coin_reward": 5
      }
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 45,
    "total_pages": 3
  }
}
```

### POST /quests/:id/progress

Increments quest progress by 1 (default). On completion awards XP + coins, upserts user_xp level.

**Path params:** `id` — quest UUID

**Response 200 (quest completed):**
```json
{
  "success": true,
  "data": {
    "quest": { "id": "uuid", "title": "First Scan", "xp_reward": 25, "coin_reward": 5, "target_count": 1, "target_action": "scan_item" },
    "progress": { "current_count": 1, "completed": true },
    "xp_awarded": 25,
    "coins_awarded": 5,
    "leveled_up": false
  }
}
```

**Response 200 (already completed):**
```json
{
  "success": true,
  "data": {
    "quest": { "..." : "..." },
    "progress": { "current_count": 1, "completed": true },
    "xp_awarded": 0,
    "coins_awarded": 0,
    "leveled_up": false
  }
}
```

**Response 404:** `{ "statusCode": 404, "message": "Quest not found" }`

### GET /quests/levels

Returns XP level thresholds and helper functions.

**Response 200:**
```json
{
  "success": true,
  "data": {
    "thresholds": [0, 100, 300, 600, 1000, 1500, 2200, 3000, 4000, 5200, 6600, 8200, 10000, 12200, 14800, 17800, 21200, 25000, 29200, 34000]
  }
}
```

---

## Coins

### GET /coins/balance

Returns the authenticated user's total coin balance.

**Response 200:**
```json
{
  "success": true,
  "data": {
    "user_id": "uid",
    "total_coins": 150
  }
}
```

### GET /coins/history?page=1&limit=20

Returns coin transaction history.

**Query params:** `page` (default 1), `limit` (default 20)

**Response 200:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "user_id": "uid",
      "points": 25,
      "coin_value": 5,
      "action": "quest_complete:scan_item",
      "created_at": "2026-07-25T10:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 12,
    "total_pages": 1
  }
}
```

---

## Existing Endpoints (unchanged)

| Method | Path | Description |
|--------|------|-------------|
| POST | /auth/register | Register user |
| POST | /auth/login | Login |
| POST | /auth/logout | Logout |
| GET | /users/profile | Get user profile |
| PUT | /users/profile | Update user profile |
| GET | /users/stats | Get user stats (listings count, total_points, badges) |
| GET | /users/dashboard | Get dashboard data |
| POST | /users/fcm-token | Upsert FCM token |
| GET | /listings | List marketplace items |
| POST | /listings | Create listing |
| GET | /listings/:id | Get listing detail |
| PUT | /listings/:id | Update listing |
| DELETE | /listings/:id | Delete listing |
| POST | /listings/:id/buy | Buy listing |
| GET | /community/posts | List posts |
| POST | /community/posts | Create post |
| POST | /community/posts/:id/react | React to post |
| GET | /community/posts/:id/comments | Get comments |
| POST | /community/posts/:id/comments | Add comment |
| GET | /recycle/projects | List DIY projects |
| POST | /recycle/scan | Process recycled item |
| GET | /recycle/impact | Get user impact stats |
| GET | /rewards | List rewards |
| POST | /rewards/:id/redeem | Redeem reward |
| GET | /rewards/user | Get user rewards |
| GET | /notifications | List notifications |
| PUT | /notifications/:id/read | Mark as read |
| PUT | /notifications/read-all | Mark all as read |
| GET | /search | Global search |
| GET | /admin/stats | Admin stats |
| POST | /diagnostics/log | Client diagnostics |
| POST | /admin/seed/listings | Seed listings |
| POST | /admin/seed/notifications | Seed notifications |
