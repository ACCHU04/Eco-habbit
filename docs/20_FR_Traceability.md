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
| FR-001 | Register with email/password | P0 | SCR-003 | `auth` | `POST /auth/register` | — | ✓ Scaffolded | — | — | In Progress |
| FR-002 | Register with Google Sign-In | P0 | SCR-002, SCR-003 | `auth` | `POST /auth/google` | — | ✓ Scaffolded | — | — | In Progress |
| FR-003 | Select role during registration | P0 | SCR-004 | `users` | `PATCH /users/me` | — | ✓ Scaffolded | — | — | In Progress |
| FR-004 | Complete profile setup | P0 | SCR-005 | `users` | `PATCH /users/me` | — | ✓ Scaffolded | — | — | In Progress |
| FR-005 | Log out | P0 | SCR-019 | `auth` | `POST /auth/logout` | — | ✓ Scaffolded | — | — | In Progress |
| FR-006 | Persist auth state across restarts | P0 | — | `auth` | — | — | — | — | — | In Progress |

---

## Home Dashboard (FR-007–FR-010)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-007 | Personalized welcome message | P0 | SCR-006 | `users` | `GET /users/me` | — | ✓ Scaffolded | — | — | In Progress |
| FR-008 | Quick action buttons | P0 | SCR-006 | — | — | — | — | — | — | In Progress |
| FR-009 | User impact statistics | P0 | SCR-006 | `users` | `GET /users/me/stats` | — | ✓ Scaffolded | — | — | In Progress |
| FR-010 | Recent marketplace listings | P0 | SCR-006 | `marketplace` | `GET /marketplace/listings?featured=true` | — | — | — | — | Not Started |

---

## Marketplace Module (FR-011–FR-022)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-011 | Create listing (title, desc, price, category, condition) | P0 | SCR-009 | `marketplace` | `POST /marketplace/listings` | — | — | — | — | Not Started |
| FR-012 | Upload up to 5 images per listing | P0 | SCR-009 | `marketplace` | `POST /marketplace/listings` | — | — | — | — | Not Started |
| FR-013 | Browse listings in grid view | P0 | SCR-007 | `marketplace` | `GET /marketplace/listings` | — | — | — | — | Not Started |
| FR-014 | Search listings by text | P0 | SCR-007 | `marketplace` | `GET /marketplace/search` | — | — | — | — | Not Started |
| FR-015 | Filter by category | P0 | SCR-007 | `marketplace` | `GET /marketplace/listings?category=` | — | — | — | — | Not Started |
| FR-016 | Filter by price range | P0 | SCR-007 | `marketplace` | `GET /marketplace/listings?min_price=&max_price=` | — | — | — | — | Not Started |
| FR-017 | Filter by condition | P0 | SCR-007 | `marketplace` | `GET /marketplace/listings?condition=` | — | — | — | — | Not Started |
| FR-018 | View listing details | P0 | SCR-008 | `marketplace` | `GET /marketplace/listings/{id}` | — | — | — | — | Not Started |
| FR-019 | Contact seller | P0 | SCR-008 | `marketplace` | — | — | — | — | — | Not Started |
| FR-020 | Edit own listings | P0 | SCR-010 | `marketplace` | `PUT /marketplace/listings/{id}` | — | — | — | — | Not Started |
| FR-021 | Remove own listings | P0 | SCR-010 | `marketplace` | `DELETE /marketplace/listings/{id}` | — | — | — | — | Not Started |
| FR-022 | View own listings | P0 | SCR-010 | `marketplace` | `GET /marketplace/my-listings` | — | — | — | — | Not Started |

---

## AI Scanner (FR-023–FR-030)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-023 | Capture image using camera | P0 | SCR-011 | `ai` | — | — | — | — | — | In Progress |
| FR-024 | Upload image from gallery | P0 | SCR-011 | `ai` | — | — | — | — | — | In Progress |
| FR-025 | Classify waste material from image | P0 | SCR-012 | `ai` | `POST /ai/classify` | — | ✓ Scaffolded | — | — | In Progress |
| FR-026 | Display classification with confidence score | P0 | SCR-012 | `ai` | `POST /ai/classify` | — | ✓ Scaffolded | — | — | In Progress |
| FR-027 | Show disposal suggestions | P0 | SCR-012 | `ai` | `POST /ai/classify` | — | ✓ Scaffolded | — | — | In Progress |
| FR-028 | Show DIY project suggestions | P0 | SCR-012 | `ai` | `POST /ai/diy-suggestions` | — | ✓ Scaffolded | — | — | In Progress |
| FR-029 | Curated DIY database first, AI fallback | P0 | SCR-012 | `ai` | `POST /ai/diy-suggestions` | — | ✓ Scaffolded | — | — | In Progress |
| FR-030 | Cache AI classification results | P1 | — | `ai` | `GET /ai/cache/{hash}` | — | ✓ Scaffolded | — | — | In Progress |

---

## DIY Studio (FR-031–FR-036)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-031 | Browse curated DIY projects | P0 | SCR-013 | `diy` | `GET /diy/projects` | — | — | — | — | Not Started |
| FR-032 | View project details (materials, steps, difficulty) | P0 | SCR-014 | `diy` | `GET /diy/projects/{id}` | — | — | — | — | Not Started |
| FR-033 | View embedded YouTube tutorial | P0 | SCR-014 | `diy` | `GET /diy/projects/{id}` | — | — | — | — | Not Started |
| FR-034 | Save DIY projects for later | P1 | SCR-013 | `diy` | `POST /diy/saved` | — | — | — | — | Not Started |
| FR-035 | View estimated selling price | P0 | SCR-014 | `diy` | `GET /diy/projects/{id}` | — | — | — | — | Not Started |
| FR-036 | Share completed project to Community Feed | P1 | SCR-016 | `community` | `POST /community/posts` | — | — | — | — | Not Started |

---

## Community Feed (FR-037–FR-044)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-037 | Create post with 3 types (DIY, Tip, Marketplace) | P0 | SCR-016 | `community` | `POST /community/posts` | — | — | — | — | Not Started |
| FR-038 | Add text content to posts | P0 | SCR-016 | `community` | `POST /community/posts` | — | — | — | — | Not Started |
| FR-039 | Upload images to posts | P0 | SCR-016 | `community` | `POST /community/posts` | — | — | — | — | Not Started |
| FR-040 | Like posts | P0 | SCR-015 | `community` | `POST /community/posts/{id}/like` | — | — | — | — | Not Started |
| FR-041 | Comment on posts | P0 | SCR-015 | `community` | `POST /community/posts/{id}/comments` | — | — | — | — | Not Started |
| FR-042 | View Community Feed | P0 | SCR-015 | `community` | `GET /community/posts` | — | — | — | — | Not Started |
| FR-043 | Filter feed by post type | P1 | SCR-015 | `community` | `GET /community/posts?type=` | — | — | — | — | Not Started |
| FR-044 | Report posts | P0 | SCR-015 | `reports` | `POST /reports` | — | — | — | — | Not Started |

---

## Reports & Moderation (FR-045–FR-049)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-045 | Report listings, posts, comments | P0 | — | `reports` | `POST /reports` | — | — | — | — | Not Started |
| FR-046 | Select report reason | P0 | — | `reports` | `POST /reports` | — | — | — | — | Not Started |
| FR-047 | Add description to report | P0 | — | `reports` | `POST /reports` | — | — | — | — | Not Started |
| FR-048 | Admin views reported content queue | P0 | SCR-020 | `admin` | `GET /admin/reports` | — | — | — | — | Not Started |
| FR-049 | Admin takes action on reported content | P0 | SCR-020 | `admin` | `PUT /admin/reports/{id}` | — | — | — | — | Not Started |

---

## Eco Rewards (FR-050–FR-055)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-050 | Award points for actions | P1 | SCR-018 | `rewards` | `GET /rewards/points` | — | — | — | — | Not Started |
| FR-051 | Track total points | P1 | SCR-018 | `rewards` | `GET /rewards/points` | — | — | — | — | Not Started |
| FR-052 | Award badges when criteria met | P1 | SCR-018 | `rewards` | `GET /rewards/badges` | — | — | — | — | Not Started |
| FR-053 | Campus-wide leaderboard | P1 | SCR-018 | `rewards` | `GET /rewards/leaderboard` | — | — | — | — | Not Started |
| FR-054 | Points history | P1 | SCR-018 | `rewards` | `GET /rewards/history` | — | — | — | — | Not Started |
| FR-055 | Display earned badges | P1 | SCR-018 | `rewards` | `GET /rewards/badges` | — | — | — | — | Not Started |

---

## Profile (FR-056–FR-060)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-056 | View and edit profile | P0 | SCR-018 | `users` | `GET /users/me`, `PUT /users/me` | — | ✓ Scaffolded | — | — | In Progress |
| FR-057 | View own marketplace listings | P0 | SCR-010 | `marketplace` | `GET /marketplace/my-listings` | — | — | — | — | Not Started |
| FR-058 | View purchase history | P0 | SCR-018 | `marketplace` | `GET /marketplace/my-listings` | — | — | — | — | Not Started |
| FR-059 | View impact statistics | P0 | SCR-018 | `users` | `GET /users/me/stats` | — | — | — | — | Not Started |
| FR-060 | Manage notification preferences | P0 | SCR-019 | `notifications` | `GET /notifications/preferences`, `PUT /notifications/preferences` | — | — | — | — | Not Started |

---

## Notifications (FR-061–FR-064)

| FR | Description | Priority | Screen | NestJS Module | API Endpoint | Flutter Test | Backend Test | PR | Commit | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| FR-061 | Push notification for likes/comments | P1 | SCR-017 | `notifications` | — | — | — | — | — | Not Started |
| FR-062 | Push notification for listing inquiries | P1 | SCR-017 | `notifications` | — | — | — | — | — | Not Started |
| FR-063 | Push notification for reward achievements | P1 | SCR-017 | `notifications` | — | — | — | — | — | Not Started |
| FR-064 | Push notification for community updates | P1 | SCR-017 | `notifications` | — | — | — | — | — | Not Started |

---

## Summary

| Module | Total FRs | P0 | P1 | Done | Progress |
|---|---|---|---|---|---|
| Auth | 6 | 6 | 0 | 0 | 0% (25% scaffolded) |
| Core (Home) | 4 | 4 | 0 | 0 | 0% (50% scaffolded) |
| Marketplace | 12 | 12 | 0 | 0 | 0% |
| AI Scanner | 8 | 7 | 1 | 0 | 0% (100% scaffolded) |
| DIY Studio | 6 | 4 | 2 | 0 | 0% |
| Community | 8 | 7 | 1 | 0 | 0% |
| Reports | 5 | 5 | 0 | 0 | 0% |
| Rewards | 6 | 0 | 6 | 0 | 0% |
| Profile | 5 | 5 | 0 | 0 | 0% (20% scaffolded) |
| Notifications | 4 | 0 | 4 | 0 | 0% |
| **Total** | **64** | **50** | **14** | **0** | **0%** |

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
