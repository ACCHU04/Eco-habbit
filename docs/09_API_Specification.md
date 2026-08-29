# EcoHabit — API Specification

**Document Reference**: PRD v1.0, Section 13.3
**Last Updated**: July 2026
**Status**: Draft

---

## 1. API Overview

### Base URL
```
https://api.ecohabit.app/api/v1
```

### Versioning
- URL path versioning: `/api/v1/`
- Current version: v1
- Breaking changes require new version

### Authentication
- Firebase JWT tokens
- Header: `Authorization: Bearer <token>`
- All endpoints except `/auth/*` require authentication

### Error Response Format
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message"
  }
}
```

### Success Response Format
```json
{
  "success": true,
  "data": { },
  "message": "Operation completed"
}
```

### Pagination
- Query parameters: `page` (default: 1), `limit` (default: 20, max: 100)
- Response includes `meta` object with pagination info

### Rate Limiting
- 100 requests per minute per user
- Headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`

---

## 2. API Design Principles

- RESTful resource naming (plural nouns)
- Standard HTTP methods (GET, POST, PUT, DELETE)
- Consistent status codes
- JSON request/response format
- UUIDs for all resource IDs

### HTTP Status Codes

| Code | Usage |
|---|---|
| 200 | Success |
| 201 | Created |
| 204 | No Content (delete) |
| 400 | Bad Request (validation) |
| 401 | Unauthorized (no token) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not Found |
| 409 | Conflict (duplicate) |
| 429 | Too Many Requests (rate limit) |
| 500 | Internal Server Error |

### Error Codes

| Code | HTTP Status | Description |
|---|---|---|
| AUTH_UNAUTHORIZED | 401 | Missing or invalid token |
| AUTH_FORBIDDEN | 403 | Insufficient permissions |
| VALIDATION_ERROR | 400 | Invalid request body |
| MARKETPLACE_LISTING_NOT_FOUND | 404 | Marketplace Listing not found |
| POST_NOT_FOUND | 404 | Post not found |
| AI_CLASSIFICATION_FAILED | 500 | AI service error |
| RATE_LIMIT_EXCEEDED | 429 | Too many requests |

---

## 3. Endpoint Inventory

| Module | Base Path | Endpoints |
|---|---|---|
| Auth | `/api/v1/auth` | register, login, google, logout |
| Users | `/api/v1/users` | me, {id}, {id}/stats |
| Marketplace | `/api/v1/marketplace` | listings, listings/{id}, search, my-listings |
| AI | `/api/v1/ai` | classify, diy-suggestions, cache/{hash} |
| DIY | `/api/v1/diy` | projects, projects/{id}, saved |
| Community | `/api/v1/community` | posts, posts/{id}, posts/{id}/like, posts/{id}/comments |
| Reports | `/api/v1/reports` | submit |
| Admin | `/admin/reports` | list (GET), resolve/{id} (PUT) |
| Rewards | `/api/v1/rewards` | points, badges, leaderboard, history |
| Notifications | `/api/v1/notifications` | preferences, mark-read |

---

## 4. OpenAPI Specification

```yaml
openapi: 3.0.3
info:
  title: EcoHabit API
  description: AI-powered circular economy platform for college students
  version: 1.0.0

servers:
  - url: https://api.ecohabit.app/api/v1
    description: Production

security:
  - bearerAuth: []

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        full_name:
          type: string
        college:
          type: string
        profile_photo:
          type: string
        role:
          type: string
          enum: [student, ngo, organization, admin]
        created_at:
          type: string
          format: date-time

    MarketplaceListing:
      type: object
      properties:
        id:
          type: string
          format: uuid
        seller_id:
          type: string
          format: uuid
        title:
          type: string
        description:
          type: string
        price:
          type: number
        category:
          type: string
          enum: [textbooks_stationery, electronics_gadgets, furniture_decor, clothing_accessories, sports_fitness, others]
        condition:
          type: string
          enum: [new, good, fair, used]
        status:
          type: string
          enum: [active, sold, removed]
        images:
          type: array
          items:
            type: string
        created_at:
          type: string
          format: date-time

    Post:
      type: object
      properties:
        id:
          type: string
          format: uuid
        author_id:
          type: string
          format: uuid
        post_type:
          type: string
          enum: [diy, tip, marketplace]
        content:
          type: string
        images:
          type: array
          items:
            type: string
        likes_count:
          type: integer
        comments_count:
          type: integer
        created_at:
          type: string
          format: date-time

    ScanResult:
      type: object
      properties:
        id:
          type: string
          format: uuid
        classification:
          type: string
        confidence:
          type: number
        disposal_tips:
          type: string
        diy_suggestions:
          type: array
          items:
            $ref: '#/components/schemas/DiyProject'

    DiyProject:
      type: object
      properties:
        id:
          type: string
          format: uuid
        title:
          type: string
        description:
          type: string
        materials:
          type: array
          items:
            type: string
        steps:
          type: array
          items:
            type: string
        difficulty:
          type: string
          enum: [easy, medium, hard]
        estimated_time:
          type: string
        estimated_price:
          type: number

    Error:
      type: object
      properties:
        success:
          type: boolean
          example: false
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string

paths:
  /auth/register:
    post:
      tags: [Auth]
      summary: Register new user
      security: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [email, password, full_name, college, role]
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
                  minLength: 8
                full_name:
                  type: string
                college:
                  type: string
                role:
                  type: string
                  enum: [student, ngo, organization]
      responses:
        '201':
          description: User registered successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  data:
                    type: object
                    properties:
                      user:
                        $ref: '#/components/schemas/User'
                      access_token:
                        type: string
        '400':
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /auth/login:
    post:
      tags: [Auth]
      summary: Login with email
      security: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [email, password]
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
      responses:
        '200':
          description: Login successful
        '401':
          description: Invalid credentials

  /auth/google:
    post:
      tags: [Auth]
      summary: Login with Google
      security: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [id_token]
              properties:
                id_token:
                  type: string
      responses:
        '200':
          description: Google login successful

  /auth/logout:
    post:
      tags: [Auth]
      summary: Logout user
      description: Invalidates the current JWT token
      responses:
        '200':
          description: Logout successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  message:
                    type: string
                    example: "Logged out successfully"

  /users/me:
    get:
      tags: [Users]
      summary: Get current user profile
      responses:
        '200':
          description: User profile
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  data:
                    $ref: '#/components/schemas/User'
    put:
      tags: [Users]
      summary: Update current user profile
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                full_name:
                  type: string
                college:
                  type: string
                profile_photo:
                  type: string
      responses:
        '200':
          description: Profile updated

  /users/{id}/stats:
    get:
      tags: [Users]
      summary: Get user statistics
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: User stats

  /marketplace/listings:
    get:
      tags: [Marketplace]
      summary: Get marketplace listings
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
        - name: category
          in: query
          schema:
            type: string
        - name: min_price
          in: query
          schema:
            type: number
        - name: max_price
          in: query
          schema:
            type: number
        - name: condition
          in: query
          schema:
            type: string
      responses:
        '200':
          description: List of marketplace listings
    post:
      tags: [Marketplace]
      summary: Create marketplace listing
      requestBody:
        required: true
        content:
          multipart/form-data:
            schema:
              type: object
              required: [title, description, price, category, condition]
              properties:
                title:
                  type: string
                description:
                  type: string
                price:
                  type: number
                category:
                  type: string
                condition:
                  type: string
                images:
                  type: array
                  items:
                    type: string
                    format: binary
      responses:
        '201':
          description: Listing created

  /marketplace/listings/{id}:
    get:
      tags: [Marketplace]
      summary: Get marketplace listing details
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Listing details
        '404':
          description: Listing not found
    put:
      tags: [Marketplace]
      summary: Update marketplace listing
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Listing updated
        '403':
          description: Not owner
    delete:
      tags: [Marketplace]
      summary: Delete marketplace listing
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '204':
          description: Listing deleted
        '403':
          description: Not owner

  /marketplace/search:
    get:
      tags: [Marketplace]
      summary: Search marketplace listings
      parameters:
        - name: q
          in: query
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Search results

  /marketplace/my-listings:
    get:
      tags: [Marketplace]
      summary: Get current user's listings
      responses:
        '200':
          description: User's listings

  /ai/classify:
    post:
      tags: [AI]
      summary: Classify waste image
      requestBody:
        required: true
        content:
          multipart/form-data:
            schema:
              type: object
              required: [image]
              properties:
                image:
                  type: string
                  format: binary
      responses:
        '200':
          description: Classification result
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ScanResult'

  /ai/diy-suggestions:
    get:
      tags: [AI]
      summary: Get DIY suggestions for waste category
      parameters:
        - name: category
          in: query
          required: true
          schema:
            type: string
      responses:
        '200':
          description: DIY suggestions

  /diy/projects:
    get:
      tags: [DIY]
      summary: Get DIY projects
      parameters:
        - name: category
          in: query
          schema:
            type: string
        - name: difficulty
          in: query
          schema:
            type: string
      responses:
        '200':
          description: List of DIY projects

  /diy/projects/{id}:
    get:
      tags: [DIY]
      summary: Get DIY project details
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Project details

  /diy/saved:
    post:
      tags: [DIY]
      summary: Save DIY project
      requestBody:
        content:
          application/json:
            schema:
              type: object
              required: [project_id]
              properties:
                project_id:
                  type: string
                  format: uuid
      responses:
        '201':
          description: Project saved
    get:
      tags: [DIY]
      summary: Get saved DIY projects
      responses:
        '200':
          description: Saved projects

  /community/posts:
    get:
      tags: [Community]
      summary: Get community posts
      parameters:
        - name: type
          in: query
          schema:
            type: string
        - name: page
          in: query
          schema:
            type: integer
        - name: limit
          in: query
          schema:
            type: integer
      responses:
        '200':
          description: List of posts
    post:
      tags: [Community]
      summary: Create post
      requestBody:
        required: true
        content:
          multipart/form-data:
            schema:
              type: object
              required: [post_type, content]
              properties:
                post_type:
                  type: string
                  enum: [diy, tip, marketplace]
                content:
                  type: string
                diy_project_id:
                  type: string
                  format: uuid
                marketplace_listing_id:
                  type: string
                  format: uuid
                images:
                  type: array
                  items:
                    type: string
                    format: binary
      responses:
        '201':
          description: Post created

  /community/posts/{id}:
    get:
      tags: [Community]
      summary: Get post details
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Post details

  /community/posts/{id}/like:
    post:
      tags: [Community]
      summary: Like a post
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '201':
          description: Post liked
    delete:
      tags: [Community]
      summary: Unlike a post
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '204':
          description: Post unliked

  /community/posts/{id}/comments:
    get:
      tags: [Community]
      summary: Get post comments
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: List of comments
    post:
      tags: [Community]
      summary: Add comment to post
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [content]
              properties:
                content:
                  type: string
      responses:
        '201':
          description: Comment added

  /reports:
    post:
      tags: [Reports]
      summary: Submit content report
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [content_type, content_id, reason]
              properties:
                content_type:
                  type: string
                  enum: [marketplace_listing, post, comment]
                content_id:
                  type: string
                  format: uuid
                reason:
                  type: string
                  enum: [spam, inappropriate, scam, other]
                description:
                  type: string
      responses:
        '201':
          description: Report submitted

  /admin/reports:
    get:
      tags: [Admin]
      summary: Get pending reports
      security:
        - bearerAuth: []
      responses:
        '200':
          description: List of pending reports

  /admin/reports/{id}:
    put:
      tags: [Admin]
      summary: Resolve report
      security:
        - bearerAuth: []
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [status, action_taken]
              properties:
                status:
                  type: string
                  enum: [resolved, dismissed]
                action_taken:
                  type: string
      responses:
        '200':
          description: Report resolved

  /rewards/points:
    get:
      tags: [Rewards]
      summary: Get user's total points
      responses:
        '200':
          description: Points total

  /rewards/badges:
    get:
      tags: [Rewards]
      summary: Get user's badges
      responses:
        '200':
          description: List of badges

  /rewards/leaderboard:
    get:
      tags: [Rewards]
      summary: Get campus leaderboard
      responses:
        '200':
          description: Leaderboard

  /rewards/history:
    get:
      tags: [Rewards]
      summary: Get points history
      responses:
        '200':
          description: Points history

  /notifications/preferences:
    get:
      tags: [Notifications]
      summary: Get notification preferences
      responses:
        '200':
          description: Notification preferences
    put:
      tags: [Notifications]
      summary: Update notification preferences
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                like_comment:
                  type: boolean
                marketplace_inquiry:
                  type: boolean
                reward_achievement:
                  type: boolean
                community_update:
                  type: boolean
      responses:
        '200':
          description: Preferences updated

  /notifications/mark-read:
    post:
      tags: [Notifications]
      summary: Mark notifications as read
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                notification_ids:
                  type: array
                  items:
                    type: string
                    format: uuid
      responses:
        '200':
          description: Notifications marked as read
```

---

## 5. Example Requests & Responses

### POST /api/v1/auth/register

**Request**:
```json
{
  "email": "aisha@college.edu",
  "password": "securePassword123",
  "full_name": "Aisha Khan",
  "college": "Delhi Technological University",
  "role": "student"
}
```

**Response (201)**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "aisha@college.edu",
      "full_name": "Aisha Khan",
      "college": "Delhi Technological University",
      "role": "student",
      "created_at": "2026-07-23T10:00:00Z"
    },
    "access_token": "eyJhbGciOiJSUzI1NiIs..."
  },
  "message": "Registration successful"
}
```

### POST /api/v1/auth/login

**Request**:
```json
{
  "email": "rahul@college.edu",
  "password": "myPassword123"
}
```

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "660e8400-e29b-41d4-a716-446655440001",
      "email": "rahul@college.edu",
      "full_name": "Rahul Sharma",
      "college": "Delhi Technological University",
      "role": "student",
      "created_at": "2026-07-22T10:00:00Z"
    },
    "access_token": "eyJhbGciOiJSUzI1NiIs..."
  },
  "message": "Login successful"
}
```

### POST /api/v1/marketplace/listings

**Request**:
```json
{
  "title": "Data Structures Textbook",
  "description": "Second-hand Data Structures book by Narasimha Karumanchi. Good condition, no highlighting.",
  "price": 250,
  "category": "textbooks_stationery",
  "condition": "good"
}
```

**Response (201)**:
```json
{
  "success": true,
  "data": {
    "id": "770e8400-e29b-41d4-a716-446655440002",
    "seller_id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Data Structures Textbook",
    "description": "Second-hand Data Structures book by Narasimha Karumanchi. Good condition, no highlighting.",
    "price": 250,
    "category": "textbooks_stationery",
    "condition": "good",
    "status": "active",
    "images": [],
    "created_at": "2026-07-23T10:30:00Z"
  },
  "message": "Listing created successfully"
}
```

### GET /api/v1/marketplace/listings

**Response (200)**:
```json
{
  "success": true,
  "data": [
    {
      "id": "770e8400-e29b-41d4-a716-446655440002",
      "seller_id": "550e8400-e29b-41d4-a716-446655440000",
      "title": "Data Structures Textbook",
      "price": 250,
      "category": "textbooks_stationery",
      "condition": "good",
      "status": "active",
      "images": ["https://storage.ecohabit.app/listings/img1.jpg"],
      "created_at": "2026-07-23T10:30:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 1
  }
}
```

### POST /api/v1/ai/classify

**Request**:
```
Content-Type: multipart/form-data
image: [binary image data]
```

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "id": "880e8400-e29b-41d4-a716-446655440003",
    "classification": "plastic",
    "confidence": 0.94,
    "disposal_tips": "This appears to be a PET plastic bottle. Rinse before recycling. Remove cap separately if possible.",
    "diy_suggestions": [
      {
        "id": "990e8400-e29b-41d4-a716-446655440004",
        "title": "Plastic Bottle Planter",
        "difficulty": "easy",
        "estimated_time": "30 minutes"
      }
    ]
  },
  "message": "Classification complete"
}
```

### POST /api/v1/community/posts

**Request**:
```json
{
  "post_type": "diy",
  "content": "Check out this amazing planter I made from a plastic bottle! Super easy project.",
  "diy_project_id": "990e8400-e29b-41d4-a716-446655440004"
}
```

**Response (201)**:
```json
{
  "success": true,
  "data": {
    "id": "aa0e8400-e29b-41d4-a716-446655440005",
    "author_id": "550e8400-e29b-41d4-a716-446655440000",
    "post_type": "diy",
    "content": "Check out this amazing planter I made from a plastic bottle! Super easy project.",
    "diy_project_id": "990e8400-e29b-41d4-a716-446655440004",
    "likes_count": 0,
    "comments_count": 0,
    "created_at": "2026-07-23T11:00:00Z"
  },
  "message": "Post created successfully"
}
```

### GET /api/v1/community/posts

**Response (200)**:
```json
{
  "success": true,
  "data": [
    {
      "id": "aa0e8400-e29b-41d4-a716-446655440005",
      "author_id": "550e8400-e29b-41d4-a716-446655440000",
      "post_type": "diy",
      "content": "Check out this amazing planter I made from a plastic bottle!",
      "likes_count": 12,
      "comments_count": 3,
      "created_at": "2026-07-23T11:00:00Z",
      "author": {
        "full_name": "Aisha Khan",
        "profile_photo": "https://storage.ecohabit.app/avatars/aisha.jpg"
      }
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 1
  }
}
```

### POST /api/v1/reports

**Request**:
```json
{
  "content_type": "post",
  "content_id": "aa0e8400-e29b-41d4-a716-446655440005",
  "reason": "spam",
  "description": "This post contains commercial advertising"
}
```

**Response (201)**:
```json
{
  "success": true,
  "data": {
    "id": "bb0e8400-e29b-41d4-a716-446655440006",
    "reporter_id": "660e8400-e29b-41d4-a716-446655440001",
    "content_type": "post",
    "content_id": "aa0e8400-e29b-41d4-a716-446655440005",
    "reason": "spam",
    "status": "pending",
    "created_at": "2026-07-23T12:00:00Z"
  },
  "message": "Report submitted successfully"
}
```

---

## 6. API Lifecycle

### Versioning Policy
- Current version: v1
- Breaking changes require new version
- Old versions supported for 6 months after deprecation

### Deprecation Process
1. Announce deprecation in API changelog
2. Add `Deprecation` header to responses
3. Add `Sunset` header with deprecation date
4. Remove endpoint after 6 months

### Changelog

| Version | Date | Changes |
|---|---|---|
| v1.0.0 | July 2026 | Initial release |

### Breaking Changes Definition
- Removing an endpoint
- Renaming a field
- Changing field type
- Removing an enum value
- Changing authentication method

### API Health Check
```
GET /api/v1/health

Response (200):
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2026-07-23T12:00:00Z",
  "database": "connected",
  "redis": "connected"
}
```

---

## 7. Data Models Reference

All data models reference the Database Design document (`docs/08_Database_Design.md`). See that document for complete schema definitions, relationships, and constraints.

### API Schema vs Database Schema Mapping

API schemas intentionally differ from database schemas. The following notes document the key differences:

| API Schema | Database Table | Key Differences |
|---|---|---|
| `User` | `users` | API omits `updated_at`, `is_verified`, `xp_points` (internal) |
| `MarketplaceListing` | `marketplace_listings` | API includes computed `images` array from `marketplace_listing_images` table |
| `Post` | `posts` | API includes computed `images` from `post_images`; omits `diy_project_id`, `marketplace_listing_id` (internal FKs) |
| `DiyProject` | `diy_projects` | API omits `category`, `video_url`, `source_materials`, `images`, `created_at` |
| `ScanResult` | `ai_scans` | API adds computed `diy_suggestions`; omits `user_id`, `image_url`, `created_at` (internal) |

**Note:** API schemas represent the public contract. Internal fields, computed values, and foreign keys not needed by clients are excluded.

---

## 8. Admin Module

The Admin module is a separate NestJS module from Reports. It handles administrative operations including report management.

| Endpoint | Method | Description | Auth |
|---|---|---|---|
| `/admin/reports` | GET | List pending reports | Admin role required |
| `/admin/reports/{id}` | PUT | Resolve/dismiss report | Admin role required |

**Module ownership:** `src/modules/admin/` (separate from `src/modules/reports/`)

---

## Document Reference

This document references:
- PRD v1.0, Section 13.3 (API Principles)
- 08_Database_Design.md
- 04_User_Journeys.md

This document is referenced by:
- Development setup documentation
- Testing strategy documentation
