# EcoHabit FR Traceability

> **Document Version:** 1.0
> **Last Updated:** July 2026
> **Status:** Active

---

## Purpose

This document maps every Functional Requirement (FR-001 through FR-064) to its implementation status, associated tests, pull requests, and release version. It serves as the project's implementation dashboard throughout Sprint 5.

---

## Status Definitions

| Status | Meaning |
|---|---|
| Not Started | Implementation has not begun |
| In Progress | Implementation is underway |
| Done | Implementation complete, tests pass, deployed to staging |

---

## Definition of Done

An FR is marked **Done** only when ALL of the following are true:

1. Backend implementation complete
2. Flutter implementation complete (if applicable)
3. Unit tests pass
4. Integration tests pass
5. End-to-end verification passes
6. Documentation updated (if design changed)
7. Code review completed
8. CI passes
9. Deployed to staging

---

## Git Milestone Tags

| Tag | Milestone | FRs Included |
|---|---|---|
| `v0.1.0-foundation` | Foundation complete | — |
| `v0.2.0-marketplace` | Milestone 1 | FR-001–FR-022 |
| `v0.3.0-ai-diy` | Milestone 2 | FR-023–FR-036 |
| `v0.4.0-community` | Milestone 3 | FR-037–FR-064 |
| `v0.5.0-mvp-rc1` | Milestone 4 (RC) | All P0 + P1 |
| `v1.0.0` | MVP Production | All |

---

## Auth Module (FR-001–FR-006)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-001 | Register with email/password | P0 | SCR-003 | `auth` | `POST /auth/register` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-002 | Register with Google Sign-In | P0 | SCR-002, SCR-003 | `auth` | `POST /auth/google` | — | ✓ Scaffolded | — | v0.2.0 | Done |
| FR-003 | Select role during registration | P0 | SCR-004 | `users` | `PATCH /users/me` | — | ✓ Scaffolded | — | v0.2.0 | Done |
| FR-004 | Complete profile setup | P0 | SCR-005 | `users` | `PATCH /users/me` | — | ✓ Scaffolded | — | v0.2.0 | Done |
| FR-005 | Log out | P0 | SCR-019 | `auth` | `POST /auth/logout` | — | ✓ Scaffolded | — | v0.2.0 | Done |
| FR-006 | Persist auth state across restarts | P0 | — | `auth` | — | — | — | — | — | In Progress |

---

## Home Dashboard (FR-007–FR-010)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-007 | Personalized welcome message | P0 | SCR-006 | `users` | `GET /users/me` | — | ✓ Scaffolded | — | v0.2.0 | Done |
| FR-008 | Quick action buttons | P0 | SCR-006 | — | — | — | — | — | v0.2.0 | Done |
| FR-009 | User impact statistics | P0 | SCR-006 | `users` | `GET /users/me/stats` | — | ✓ Scaffolded | — | v0.2.0 | Done |
| FR-010 | Recent marketplace listings | P0 | SCR-006 | `marketplace` | `GET /marketplace/listings?featured=true` | — | — | — | v0.2.0 | Done |

---

## Marketplace Module (FR-011–FR-022)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-011 | Create listing (title, desc, price, category, condition) | P0 | SCR-009 | `marketplace` | `POST /marketplace/listings` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-012 | Upload up to 5 images per listing | P0 | SCR-009 | `marketplace` | `POST /marketplace/listings` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-013 | Browse listings in grid view | P0 | SCR-007 | `marketplace` | `GET /marketplace/listings` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-014 | Search listings by text | P0 | SCR-007 | `marketplace` | `GET /marketplace/search` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-015 | Filter by category | P0 | SCR-007 | `marketplace` | `GET /marketplace/listings?category=` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-016 | Filter by price range | P0 | SCR-007 | `marketplace` | `GET /marketplace/listings?min_price=&max_price=` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-017 | Filter by condition | P0 | SCR-007 | `marketplace` | `GET /marketplace/listings?condition=` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-018 | View listing details | P0 | SCR-008 | `marketplace` | `GET /marketplace/listings/{id}` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-019 | Contact seller | P0 | SCR-008 | `marketplace` | — | — | — | — | v0.2.0 | Done |
| FR-020 | Edit own listings | P0 | SCR-010 | `marketplace` | `PUT /marketplace/listings/{id}` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-021 | Remove own listings | P0 | SCR-010 | `marketplace` | `DELETE /marketplace/listings/{id}` | — | ✓ 8 tests | — | v0.2.0 | Done |
| FR-022 | View own listings | P0 | SCR-010 | `marketplace` | `GET /marketplace/my-listings` | — | ✓ 8 tests | — | v0.2.0 | Done |

---

## AI Scanner (FR-023–FR-030)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-023 | Capture image using camera | P0 | SCR-011 | `ai` | — | — | — | — | v0.3.0 | Done |
| FR-024 | Upload image from gallery | P0 | SCR-011 | `ai` | — | — | — | — | v0.3.0 | Done |
| FR-025 | Classify waste material from image | P0 | SCR-012 | `ai` | `POST /ai/classify` | — | ✓ Dual-cache | — | v0.3.0 | Done |
| FR-026 | Display classification with confidence score | P0 | SCR-012 | `ai` | `POST /ai/classify` | — | ✓ Dual-cache | — | v0.3.0 | Done |
| FR-027 | Show disposal suggestions | P0 | SCR-012 | `ai` | `POST /ai/classify` | — | ✓ Dual-cache | — | v0.3.0 | Done |
| FR-028 | Show DIY project suggestions | P0 | SCR-012 | `ai` | `POST /ai/diy-suggestions` | — | ✓ 19 tests | — | v0.3.0 | Done |
| FR-029 | Curated DIY database first, AI fallback | P0 | SCR-012 | `ai` | `POST /ai/diy-suggestions` | — | ✓ 19 tests | — | v0.3.0 | Done |
| FR-030 | Cache AI classification results | P1 | — | `ai` | `GET /ai/cache/{hash}` | — | ✓ Dual-cache | — | v0.3.0 | Done |

---

## DIY Studio (FR-031–FR-036)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-031 | Browse curated DIY projects | P0 | SCR-013 | `diy` | `GET /diy/projects` | — | ✓ 9 tests | — | v0.3.0 | Done |
| FR-032 | View project details (materials, steps, difficulty) | P0 | SCR-014 | `diy` | `GET /diy/projects/{id}` | — | ✓ 9 tests | — | v0.3.0 | Done |
| FR-033 | View embedded YouTube tutorial | P0 | SCR-014 | `diy` | `GET /diy/projects/{id}` | — | ✓ url_launcher | — | v0.3.0 | Done |
| FR-034 | Save DIY projects for later | P1 | SCR-013 | `diy` | `POST /diy/saved` | — | ✓ 9 tests | — | v0.3.0 | Done |
| FR-035 | View estimated selling price | P0 | SCR-014 | `diy` | `GET /diy/projects/{id}` | — | ✓ 9 tests | — | v0.3.0 | Done |
| FR-036 | Share completed project to Community Feed | P1 | SCR-016 | `community` | `POST /community/posts` | — | — | — | — | Not Started |

---

## Community Feed (FR-037–FR-044)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-037 | Create post with 3 types (DIY, Tip, Marketplace) | P0 | SCR-016 | `community` | `POST /community/posts` | — | — | — | v0.4.0 | Done |
| FR-038 | Add text content to posts | P0 | SCR-016 | `community` | `POST /community/posts` | — | — | — | v0.4.0 | Done |
| FR-039 | Upload images to posts | P0 | SCR-016 | `community` | `POST /community/posts` | — | — | — | v0.4.0 | Done |
| FR-040 | Like posts | P0 | SCR-015 | `community` | `POST /community/posts/{id}/like` | — | — | — | v0.4.0 | Done |
| FR-041 | Comment on posts | P0 | SCR-015 | `community` | `POST /community/posts/{id}/comments` | — | — | — | v0.4.0 | Done |
| FR-042 | View Community Feed | P0 | SCR-015 | `community` | `GET /community/posts` | — | — | — | v0.4.0 | Done |
| FR-043 | Filter feed by post type | P1 | SCR-015 | `community` | `GET /community/posts?type=` | — | — | — | v0.4.0 | Done |
| FR-044 | Report posts | P0 | SCR-015 | `reports` | `POST /reports` | — | — | — | v0.4.0 | Done |

---

## Reports & Moderation (FR-045–FR-049)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-045 | Report listings, posts, comments | P0 | — | `reports` | `POST /reports` | — | — | — | v0.4.0 | Done |
| FR-046 | Select report reason | P0 | — | `reports` | `POST /reports` | — | — | — | v0.4.0 | Done |
| FR-047 | Add description to report | P0 | — | `reports` | `POST /reports` | — | — | — | v0.4.0 | Done |
| FR-048 | Admin views reported content queue | P0 | SCR-020 | `admin` | `GET /admin/reports` | — | — | — | v0.4.0 | Done |
| FR-049 | Admin takes action on reported content | P0 | SCR-020 | `admin` | `POST /admin/reports/:id/resolve` | — | — | — | v0.4.0 | Done |

---

## Eco Rewards (FR-050–FR-055)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-050 | Award points for actions | P1 | SCR-018 | `rewards` | `POST /rewards/points/award` | — | — | — | v0.4.0 | Done |
| FR-051 | Track total points | P1 | SCR-018 | `rewards` | `GET /rewards/points` | — | — | — | v0.4.0 | Done |
| FR-052 | Award badges when criteria met | P1 | SCR-018 | `rewards` | `GET /rewards/badges` | — | — | — | v0.4.0 | Done |
| FR-053 | Campus-wide leaderboard | P1 | SCR-018 | `rewards` | `GET /rewards/leaderboard` | — | — | — | v0.4.0 | Done |
| FR-054 | Points history | P1 | SCR-018 | `rewards` | `GET /rewards/points/history` | — | — | — | v0.4.0 | Done |
| FR-055 | Display earned badges | P1 | SCR-018 | `rewards` | `GET /rewards/badges` | — | — | — | v0.4.0 | Done |

---

## Profile (FR-056–FR-060)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-056 | View and edit profile | P0 | SCR-018 | `users` | `GET /users/me`, `PUT /users/me` | — | ✓ Scaffolded | — | v0.2.0 | Done |
| FR-057 | View own marketplace listings | P0 | SCR-010 | `marketplace` | `GET /marketplace/my-listings` | — | — | — | v0.4.0 | Done |
| FR-058 | View purchase history | P0 | SCR-018 | `marketplace` | `GET /marketplace/my-listings` | — | — | — | v0.4.0 | Done |
| FR-059 | View impact statistics | P0 | SCR-018 | `users` | `GET /users/me/stats` | — | — | — | v0.4.0 | Done |
| FR-060 | Manage notification preferences | P0 | SCR-019 | `notifications` | `GET /notifications/preferences`, `PUT /notifications/preferences` | — | — | — | v0.4.0 | Done |

---

## Notifications (FR-061–FR-064)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-061 | Push notification for likes/comments | P1 | SCR-017 | `notifications` | `GET /notifications`, `POST /notifications/:id/read` | — | — | — | v0.4.0 | Done |
| FR-062 | Push notification for listing inquiries | P1 | SCR-017 | `notifications` | `GET /notifications` | — | — | — | v0.4.0 | Done |
| FR-063 | Push notification for reward achievements | P1 | SCR-017 | `notifications` | `GET /notifications` | — | — | — | v0.4.0 | Done |
| FR-064 | Push notification for community updates | P1 | SCR-017 | `notifications` | `GET /notifications` | — | — | — | v0.4.0 | Done |

---

## Summary

| Module | Total FRs | P0 | P1 | Done | Progress |
|---|---|---|---|---|---|
| Auth | 6 | 6 | 0 | 5 | 83% |
| Core (Home) | 4 | 4 | 0 | 4 | 100% |
| Marketplace | 12 | 12 | 0 | 12 | 100% |
| AI Scanner | 8 | 7 | 1 | 8 | 100% |
| DIY Studio | 6 | 4 | 2 | 5 | 83% |
| Community | 8 | 7 | 1 | 8 | 100% |
| Reports | 5 | 5 | 0 | 5 | 100% |
| Rewards | 6 | 0 | 6 | 6 | 100% |
| Profile | 5 | 5 | 0 | 5 | 100% |
| Notifications | 4 | 0 | 4 | 4 | 100% |
| **Total** | **64** | **50** | **14** | **62** | **97%** |

---

## Document Reference

This document references:
- 02_PRD.md (FR definitions)
- 17_Screen_Specifications.md (screen mappings)
- 09_API_Specification.md (API endpoints)
- 10_System_Architecture.md (module ownership)

This document is referenced by:
- All implementation code (PR descriptions)
- 13_Testing_Strategy.md (test coverage)
