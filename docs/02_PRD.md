# EcoHabit — Product Requirements Document

---

## Document Control

| Field | Value |
|---|---|
| Document | Product Requirements Document |
| Project | EcoHabit |
| Version | 1.0 |
| Status | Draft |
| Owner | EcoHabit Team |
| Created | July 2026 |
| Last Updated | July 2026 |

**Baseline Policy**: This document is the authoritative Product Requirements Document (PRD) for EcoHabit Version 1.0. Functional Requirement identifiers (FR-001 to FR-064) are permanent and shall not be renumbered. Subsequent changes must be recorded through the Revision History and assigned a new document version.

### Revision History

| Version | Date | Status | Description |
|---|---|---|---|
| 1.0 | July 2026 | Draft | Initial PRD Release |

---

## Table of Contents

- [1. Executive Summary](#1-executive-summary)
- [2. Vision & Mission](#2-vision--mission)
- [3. Problem Statement](#3-problem-statement)
- [4. Target Users & Personas](#4-target-users--personas)
- [5. Product Goals & Success Metrics](#5-product-goals--success-metrics)
- [6. MVP Feature Specification](#6-mvp-feature-specification)
- [7. In Scope (MVP)](#7-in-scope-mvp)
- [8. Out of Scope (MVP)](#8-out-of-scope-mvp)
- [9. Functional Requirements](#9-functional-requirements)
- [10. User Roles & Permissions](#10-user-roles--permissions)
- [11. User Journeys](#11-user-journeys)
- [12. Acceptance Criteria](#12-acceptance-criteria)
- [13. Technical Architecture](#13-technical-architecture)
- [14. Non-Functional Requirements](#14-non-functional-requirements)
- [15. Assumptions & Dependencies](#15-assumptions--dependencies)
- [16. Risks & Mitigations](#16-risks--mitigations)
- [17. Release Strategy](#17-release-strategy)
- [18. Milestones & Roadmap](#18-milestones--roadmap)
- [19. Appendix](#19-appendix)

---

## 1. Executive Summary

**EcoHabit** is an AI-powered circular economy platform for college students. It enables buying, selling, donating, and recycling products while teaching entrepreneurship and sustainability through gamified learning.

The platform connects three user groups — students, NGOs, and campus organizations — in a unified ecosystem where every transaction contributes to measurable environmental impact. An AI waste scanner classifies items and suggests DIY repurposing ideas, turning trash into opportunity.

**EcoHabit** transforms campus waste streams into economic opportunities, making sustainability accessible, rewarding, and community-driven.

---

## 2. Vision & Mission

### 2.1 Vision

A world where every campus operates as a circular economy — where nothing is wasted, everything has value, and students lead the sustainability revolution.

### 2.2 Mission

To empower college students with the tools, knowledge, and community to participate in the circular economy, reducing waste while building real business skills.

### 2.3 Core Values

- **Sustainability First**: Every feature should reduce waste or increase resource efficiency
- **Learning by Doing**: Students learn entrepreneurship through real transactions
- **Community Power**: Collective action creates measurable environmental impact
- **Accessible Impact**: Sustainability should be easy, rewarding, and fun

---

## 3. Problem Statement

### 3.1 The Campus Waste Problem

Indian colleges generate approximately 25,000 tons of waste annually. Students discard usable items — textbooks, electronics, furniture, clothes — because they lack efficient redistribution channels.

### 3.2 The Awareness Gap

Most students want to act sustainably but don't know how. They lack knowledge about waste classification, recycling options, and the environmental impact of their choices.

### 3.3 The Opportunity

Every campus has a micro-economy of unused goods. Students need textbooks, furniture, and electronics. Others have these items but no easy way to sell or donate them. This creates a missed opportunity for both economic value and environmental impact.

### 3.4 The Solution Gap

No existing platform combines marketplace functionality with sustainability education, AI-powered waste management, and community engagement in a student-focused package.

---

## 4. Target Users & Personas

### 4.1 Persona 1: Aisha — The Sustainable Seller

**Demographics**: 21, Engineering student, lives in college hostel

**Goals**:
- Sell used textbooks and electronics before graduation
- Earn recognition for sustainable behavior
- Reduce personal waste footprint

**Pain Points**:
- No efficient way to sell items to juniors
- Existing platforms (OLX, Facebook Marketplace) aren't student-focused
- Doesn't know how to recycle electronics properly

**EcoHabit Features She Uses**:
- Marketplace Listings
- AI Scanner for waste classification
- Eco Rewards for sustainable actions

### 4.2 Persona 2: Rahul — The Budget Buyer

**Demographics**: 19, First-year student, limited budget

**Goals**:
- Find affordable textbooks and supplies
- Buy quality used items at discount
- Learn about sustainability

**Pain Points**:
- New textbooks are expensive
- Doesn't know where to find used items on campus
- Wants to make sustainable choices but needs guidance

**EcoHabit Features He Uses**:
- Marketplace browsing and search
- DIY suggestions for upcycling
- Community feed for tips

### 4.3 Persona 3: Priya — The NGO Coordinator

**Demographics**: 25, Works with campus environmental NGO

**Goals**:
- Organize donation drives efficiently
- Connect with student volunteers
- Track environmental impact metrics

**Pain Points**:
- Difficulty reaching students for donations
- Manual tracking of donations and volunteers
- No centralized platform for campus sustainability initiatives

**EcoHabit Features She Uses**:
- Donation Listings (V2)
- Community posts for drives
- Impact Dashboard (V2)

### 4.4 Persona 4: Dr. Sharma — The Campus Administrator

**Demographics**: 45, Dean of Student Affairs

**Goals**:
- Track campus sustainability metrics
- Support student environmental initiatives
- Reduce campus waste management costs

**Pain Points**:
- No visibility into campus sustainability efforts
- Difficulty measuring impact of green initiatives
- Limited tools for student engagement

**EcoHabit Features He Uses**:
- Organization Dashboard (V2)
- Analytics and Reports (V2)

---

## 5. Product Goals & Success Metrics

### 5.1 V1 Goals (First 3 Months)

1. **Launch at single college campus** — 500+ registered users
2. **Establish marketplace** — 200+ active listings
3. **Drive engagement** — 40% weekly active users
4. **Measure impact** — Track items redirected from landfill

### 5.2 Key Performance Indicators (KPIs)

| Metric | Target | Measurement |
|---|---|---|
| Registered Users | 500+ | Firebase Auth count |
| Monthly Active Users | 200+ | Analytics events |
| Listings Created | 200+ | Database count |
| Items Sold/Donated | 100+ | Transaction records |
| AI Scans Performed | 500+ | API call logs |
| Community Posts | 100+ | Database count |
| Eco Points Earned | 5,000+ | Rewards system |

### 5.3 Success Criteria

The MVP is considered successful when:

| Criterion | Threshold | Measurement Method |
|---|---|---|
| User Registration | 500+ registered users | Firebase Auth count |
| Marketplace Activity | 200+ listings created | Database query |
| AI Scanner Accuracy | 80%+ classification accuracy | Manual validation sample |
| User Retention | 40% weekly active users | Analytics cohort analysis |
| App Store Rating | 4.3+ stars | Play Store / App Store |
| Community Engagement | 100+ posts, 500+ interactions | Database query |
| Environmental Impact | 100+ items diverted from landfill | Transaction + donation records |

### 5.4 Environmental Impact Metrics

| Metric | Target | Calculation |
|---|---|---|
| Items Diverted from Landfill | 100+ | Sold + Donated + Recycled |
| Estimated CO2 Saved | 500 kg | Based on item categories |
| Water Saved | 10,000 liters | Based on recycling impact |

---

## 6. MVP Feature Specification

### 6.1 Authentication Module

| Feature | Description | Priority |
|---|---|---|
| Email Registration | Create account with email/password | P0 |
| Google Sign-In | OAuth with Google account | P0 |
| Role Selection | Choose Student/NGO/Organization during signup | P0 |
| Profile Setup | Add name, college, profile picture | P0 |

**User Flow**:
1. Open app → Splash screen
2. Login screen → Choose Email or Google
3. If new user → Role selection screen
4. Profile setup → Home dashboard

### 6.2 Home Dashboard

| Feature | Description | Priority |
|---|---|---|
| Welcome Header | Personalized greeting with name | P0 |
| Quick Actions | Scan, Sell, Browse buttons | P0 |
| Impact Stats | Items saved, CO2 reduced, points earned | P0 |
| Recent Activity | Latest Marketplace Listings | P0 |
| Featured DIY | Curated sustainability projects | P1 |

**Layout**:
```
┌─────────────────────────────┐
│ Welcome, Aisha!             │
├─────────────────────────────┤
│ [Scan] [Sell] [Browse]      │
├─────────────────────────────┤
│ Your Impact                 │
│ 🌳 12 items saved           │
│ 💨 45kg CO2 reduced         │
│ ⭐ 230 points               │
├─────────────────────────────┤
│ Recent Listings             │
│ [Item 1] [Item 2] [Item 3] │
├─────────────────────────────┤
│ Featured DIY                │
│ [Project 1] [Project 2]     │
└─────────────────────────────┘
```

### 6.3 Marketplace Module

| Feature | Description | Priority |
|---|---|---|
| Marketplace Listing | Create listing with photos, description, price | P0 |
| Browse Marketplace Listings | Grid view with search and filters | P0 |
| Marketplace Listing Details | Full listing with seller info | P0 |
| Search | Text search across Marketplace Listings | P0 |
| Filters | Category, price range, condition | P0 |
| Contact Seller | Show contact info or in-app message (V2: chat) | P0 |
| My Marketplace Listings | Manage own Marketplace Listings | P0 |
| Save/Unsave | Bookmark Marketplace Listings (V2: Wishlist) | P1 |

**Marketplace Listing Categories**:
- Textbooks & Stationery
- Electronics & Gadgets
- Furniture & Decor
- Clothing & Accessories
- Sports & Fitness
- Others

**Marketplace Listing Data Model**:
```
{
  id: uuid,
  seller_id: uuid,
  title: string,
  description: string,
  price: number,
  category: enum,
  condition: enum (new/good/fair/used),
  images: string[],
  status: enum (active/sold/removed),
  created_at: timestamp,
  updated_at: timestamp
}
```

### 6.4 AI Waste Scanner

| Feature | Description | Priority |
|---|---|---|
| Camera Capture | Take photo of waste item | P0 |
| Gallery Upload | Select photo from device | P0 |
| Classification | Identify material type | P0 |
| Disposal Suggestions | Recycling/composting options | P0 |
| DIY Suggestions | Upcycling project ideas | P0 |
| Share to Community | Post scan result to feed | P1 |

**AI Pipeline**:
```
User Input (Camera/Gallery)
    ↓
Image Preprocessing
    ↓
Classification Model (Cloud API)
    ↓
Material Category Result
    ↓
  ┌─────────────────┐
  │ Curated DIY DB  │→ Fast lookup
  └─────────────────┘
    ↓ (if no match)
  ┌─────────────────┐
  │ AI Fallback     │→ Generate suggestions
  └─────────────────┘
    ↓
  ┌─────────────────┐
  │ Cache Result    │→ Store for future
  └─────────────────┘
    ↓
Display Results to User
```

**Waste Categories**:
- Plastic (PET, HDPE, PVC, etc.)
- Paper & Cardboard
- Glass
- Metal
- Organic/Compostable
- E-waste
- Textile
- Others

### 6.5 DIY Studio

| Feature | Description | Priority |
|---|---|---|
| Browse Projects | Curated list of DIY projects | P0 |
| Project Details | Materials, steps, difficulty, estimated time | P0 |
| Difficulty Levels | Easy, Medium, Hard | P0 |
| Estimated Selling Price | Potential value of finished project | P0 |
| Video Tutorials | Embedded YouTube tutorials | P0 |
| AI Images | Generated preview of finished project | P1 |
| Save Projects | Bookmark for later | P0 |
| Share to Community | Post completed project | P1 |

**Project Data Model**:
```
{
  id: uuid,
  title: string,
  description: string,
  materials: string[],
  steps: string[],
  difficulty: enum (easy/medium/hard),
  estimated_time: string,
  estimated_selling_price: number,
  category: string,
  images: string[],
  video_url: string,
  ai_generated_image: string,
  source_materials: string[]
}
```

### 6.6 Community Feed

| Feature | Description | Priority |
|---|---|---|
| Create Post | 3 post types with text + images | P0 |
| Like Post | React to posts | P0 |
| Comment on Post | Add comments | P0 |
| Report Post | Flag inappropriate content | P0 |
| Feed Filtering | Filter by post type | P1 |

**Post Types**:

1. **DIY Project Share**
   - Links to DIY project
   - Before/after images
   - Materials used

2. **Sustainability Tip**
   - Text-based advice
   - Supporting images
   - Tags for categories

3. **Marketplace Listing Share**
   - Links to Marketplace Listing
   - Endorsement text
   - Price information

**Post Data Model**:
```
{
  id: uuid,
  author_id: uuid,
  post_type: enum (diy/tip/marketplace),
  content: string,
  images: string[],
  diy_project_id: uuid?,
  marketplace_listing_id: uuid?,
  likes_count: number,
  comments_count: number,
  created_at: timestamp
}
```

### 6.7 User Reports & Moderation

| Feature | Description | Priority |
|---|---|---|
| Report Content | Flag Marketplace Listings, posts, comments | P0 |
| Report Reasons | Spam, inappropriate, scam, other | P0 |
| Admin Queue | View reported content | P0 |
| Admin Actions | Remove content, warn user, ban user | P0 |
| User Notifications | Notify reporter of action taken | P1 |

**Report Data Model**:
```
{
  id: uuid,
  reporter_id: uuid,
  content_type: enum (marketplace_listing/post/comment),
  content_id: uuid,
  reason: enum,
  description: string,
  status: enum (pending/resolved/dismissed),
  admin_id: uuid?,
  action_taken: string?,
  created_at: timestamp
}
```

### 6.8 Eco Rewards

| Feature | Description | Priority |
|---|---|---|
| Points System | Earn points for actions | P1 |
| Badges | Achievement badges | P1 |
| Leaderboard | Campus-wide rankings | P1 |
| Points History | Track earning/spending | P1 |

**Points Earning Rules**:

| Action | Points |
|---|---|
| List a Marketplace Listing | +10 |
| Complete a sale | +50 |
| Complete a donation | +30 |
| Recycle item (verified) | +20 |
| Post community content | +5 |
| Like a post | +1 |
| Comment on a post | +2 |
| AI Scan an item | +5 |
| Complete a DIY project | +40 |
| Refer a friend | +25 |

**Badge Categories**:

| Badge | Requirement |
|---|---|
| 🌱 First Sale | Complete first sale |
| ♻️ Recycler | Recycle 10 items |
| 🎨 Creator | Complete 5 DIY projects |
| 💬 Community Star | Get 50 likes on posts |
| 🏆 Campus Champion | Top 10 leaderboard |
| 🌍 Eco Warrior | Save 100kg CO2 |

### 6.9 User Profile

| Feature | Description | Priority |
|---|---|---|
| Profile Info | Name, email, college, photo | P0 |
| My Marketplace Listings | Active, sold, removed | P0 |
| My Purchases | Items bought | P0 |
| Impact Stats | Items saved, CO2 reduced | P0 |
| Points & Badges | Rewards summary | P0 |
| Settings | Notification preferences, account | P0 |

### 6.10 Push Notifications

| Notification Type | Trigger | Priority |
|---|---|---|
| Likes & Comments | Someone interacts with your post | P1 |
| Marketplace Listing Inquiries | Someone messages about your Marketplace Listing | P1 |
| Reward Achievements | You earn a new badge or milestone | P1 |
| Community Updates | New posts in your followed topics | P1 |

**Implementation**: Firebase Cloud Messaging (FCM)

### 6.11 Screen Inventory

| # | Screen | Module | Priority |
|---|---|---|---|
| 1 | Splash | Core | P0 |
| 2 | Login | Auth | P0 |
| 3 | Register | Auth | P0 |
| 4 | Role Selection | Auth | P0 |
| 5 | Profile Setup | Auth | P0 |
| 6 | Home Dashboard | Core | P0 |
| 7 | Marketplace Browse | Marketplace | P0 |
| 8 | Marketplace Listing Details | Marketplace | P0 |
| 9 | Create Marketplace Listing | Marketplace | P0 |
| 10 | My Marketplace Listings | Marketplace | P0 |
| 11 | AI Scanner | AI | P0 |
| 12 | Scan Result | AI | P0 |
| 13 | DIY Browse | DIY | P0 |
| 14 | DIY Project Details | DIY | P0 |
| 15 | Community Feed | Community | P0 |
| 16 | Create Post | Community | P0 |
| 17 | Notifications | Notifications | P1 |
| 18 | Profile | Profile | P0 |
| 19 | Settings | Profile | P0 |
| 20 | Admin Dashboard | Admin | P1 |

---

## 7. In Scope (MVP)

The following features are included in Version 1:

- Firebase Authentication (Email + Google)
- Home Dashboard
- Marketplace (Buy & Sell)
- AI Waste Scanner (Camera + Gallery)
- DIY Studio (Curated + AI Hybrid)
- Community Feed (3 post types)
- User Reports & Admin Moderation
- Eco Rewards (Points + Badges)
- User Profile
- Push Notifications (4 types)

---

## 8. Out of Scope (MVP)

The following features are intentionally excluded from Version 1:

| Feature | Reason | Planned Version |
|---|---|---|
| Online Payments | Legal complexity, payment gateway setup | V2 |
| Rent & Exchange | Additional Marketplace complexity | V2 |
| Wishlist | Nice-to-have, not critical | V2 |
| In-app Chat | Requires real-time infrastructure | V2 |
| NGO Management Portal | Separate admin interface | V2 |
| Organization Dashboard | Analytics require data volume | V2 |
| AI Content Moderation | Needs training data from V1 usage | V2 |
| Coupon/Real Rewards | Business partnerships needed | V2 |
| Tree Planting Integration | Third-party API dependency | V2 |
| Offline AI Scanner | Model optimization required | V3 |
| Multi-language Support | Internationalization scope | V3 |
| Campus Verification | Email domain validation | V2 |

---

## 9. Functional Requirements

### Priority Legend

| Priority | Meaning | Definition |
|---|---|---|
| P0 | Required for MVP | Must be complete for launch |
| P1 | Important | Should be complete, can defer if needed |
| P2 | Nice-to-have | Include if time permits |

### 9.1 Authentication

| ID | Priority | Requirement |
|---|---|---|
| FR-001 | P0 | User shall register using Email with password |
| FR-002 | P0 | User shall register using Google Sign-In |
| FR-003 | P0 | User shall select a role during registration (Student/NGO/Organization) |
| FR-004 | P0 | User shall complete profile setup after registration |
| FR-005 | P0 | User shall log out from the application |
| FR-006 | P0 | System shall persist authentication state across app restarts |

### 9.2 Home Dashboard

| ID | Priority | Requirement |
|---|---|---|
| FR-007 | P0 | System shall display personalized welcome message |
| FR-008 | P0 | System shall show quick action buttons (Scan, Sell, Browse) |
| FR-009 | P0 | System shall display user's impact statistics |
| FR-010 | P0 | System shall show recent Marketplace Listings |

### 9.3 Marketplace

| ID | Priority | Requirement |
|---|---|---|
| FR-011 | P0 | User shall create a Marketplace Listing with title, description, price, category, and condition |
| FR-012 | P0 | User shall upload up to 5 images per Marketplace Listing |
| FR-013 | P0 | User shall browse Marketplace Listings in grid view |
| FR-014 | P0 | User shall search Marketplace Listings by text |
| FR-015 | P0 | User shall filter Marketplace Listings by category |
| FR-016 | P0 | User shall filter Marketplace Listings by price range |
| FR-017 | P0 | User shall filter Marketplace Listings by condition |
| FR-018 | P0 | User shall view Marketplace Listing details |
| FR-019 | P0 | User shall contact seller via displayed contact information |
| FR-020 | P0 | User shall edit their own Marketplace Listings |
| FR-021 | P0 | User shall remove their own Marketplace Listings |
| FR-022 | P0 | User shall view their own Marketplace Listings |

### 9.4 AI Waste Scanner

| ID | Priority | Requirement |
|---|---|---|
| FR-023 | P0 | User shall capture image using device camera |
| FR-024 | P0 | User shall upload image from device gallery |
| FR-025 | P0 | System shall classify waste material from image |
| FR-026 | P0 | System shall display classification result with confidence score |
| FR-027 | P0 | System shall show disposal suggestions for classified material |
| FR-028 | P0 | System shall show DIY project suggestions for classified material |
| FR-029 | P0 | System shall use curated DIY database first, then AI fallback |
| FR-030 | P1 | System shall cache AI classification results |

### 9.5 DIY Studio

| ID | Priority | Requirement |
|---|---|---|
| FR-031 | P0 | User shall browse curated DIY projects |
| FR-032 | P0 | User shall view DIY project details (materials, steps, difficulty) |
| FR-033 | P0 | User shall view embedded YouTube tutorial |
| FR-034 | P1 | User shall save DIY projects for later |
| FR-035 | P0 | User shall view estimated selling price for DIY project |
| FR-036 | P1 | User shall share completed DIY project to Community Feed |

### 9.6 Community Feed

| ID | Priority | Requirement |
|---|---|---|
| FR-037 | P0 | User shall create a post with 3 post types (DIY, Tip, Marketplace Listing) |
| FR-038 | P0 | User shall add text content to posts |
| FR-039 | P0 | User shall upload images to posts |
| FR-040 | P0 | User shall like posts |
| FR-041 | P0 | User shall comment on posts |
| FR-042 | P0 | User shall view Community Feed |
| FR-043 | P1 | User shall filter Community Feed by post type |
| FR-044 | P0 | User shall report posts |

### 9.7 Reports & Moderation

| ID | Priority | Requirement |
|---|---|---|
| FR-045 | P0 | User shall report Marketplace Listings, posts, and comments |
| FR-046 | P0 | User shall select a report reason (spam, inappropriate, scam, other) |
| FR-047 | P0 | User shall add description to report |
| FR-048 | P0 | Admin shall view reported content queue |
| FR-049 | P0 | Admin shall take action on reported content (remove, warn, ban) |

### 9.8 Eco Rewards

| ID | Priority | Requirement |
|---|---|---|
| FR-050 | P1 | System shall award points for specified actions |
| FR-051 | P1 | System shall track user's total points |
| FR-052 | P1 | System shall award badges when criteria are met |
| FR-053 | P1 | System shall display campus-wide leaderboard |
| FR-054 | P1 | System shall show user's points history |
| FR-055 | P1 | System shall display user's earned badges |

### 9.9 Profile

| ID | Priority | Requirement |
|---|---|---|
| FR-056 | P0 | User shall view and edit profile information |
| FR-057 | P0 | User shall view their own Marketplace Listings |
| FR-058 | P0 | User shall view their purchase history |
| FR-059 | P0 | User shall view their impact statistics |
| FR-060 | P0 | User shall manage notification preferences |

### 9.10 Notifications

| ID | Priority | Requirement |
|---|---|---|
| FR-061 | P1 | System shall send push notification for likes and comments |
| FR-062 | P1 | System shall send push notification for Marketplace Listing inquiries |
| FR-063 | P1 | System shall send push notification for reward achievements |
| FR-064 | P1 | System shall send push notification for community updates |

### 9.11 Traceability Matrix

| FR | Priority | AC | API Endpoint | DB Entity | UI Screen | Test Case |
|---|---|---|---|---|---|---|
| FR-001 | P0 | AC-001 | POST /api/v1/auth/register | users | Register | TC-001 |
| FR-002 | P0 | — | POST /api/v1/auth/google | users | Login | TC-002 |
| FR-003 | P0 | AC-003 | POST /api/v1/auth/register | users | Role Selection | TC-003 |
| FR-004 | P0 | AC-004 | PUT /api/v1/users/me | users | Profile Setup | TC-004 |
| FR-005 | P0 | — | POST /api/v1/auth/logout | — | Profile | TC-005 |
| FR-006 | P0 | AC-005 | — | — | — | TC-006 |
| FR-007 | P0 | — | GET /api/v1/users/me | users | Home Dashboard | TC-007 |
| FR-008 | P0 | — | — | — | Home Dashboard | TC-008 |
| FR-009 | P0 | — | GET /api/v1/users/{id}/stats | eco_rewards | Home Dashboard | TC-009 |
| FR-010 | P0 | — | GET /api/v1/marketplace/listings | marketplace_listings | Home Dashboard | TC-010 |
| FR-011 | P0 | AC-006 | POST /api/v1/marketplace/listings | marketplace_listings | Create Marketplace Listing | TC-011 |
| FR-012 | P0 | AC-007 | POST /api/v1/marketplace/listings/{id}/images | marketplace_listing_images | Create Marketplace Listing | TC-012 |
| FR-013 | P0 | AC-008 | GET /api/v1/marketplace/listings | marketplace_listings | Marketplace Browse | TC-013 |
| FR-014 | P0 | AC-009 | GET /api/v1/marketplace/search | marketplace_listings | Marketplace Browse | TC-014 |
| FR-015 | P0 | AC-010 | GET /api/v1/marketplace/listings?category= | marketplace_listings | Marketplace Browse | TC-015 |
| FR-016 | P0 | AC-010 | GET /api/v1/marketplace/listings?min_price=&max_price= | marketplace_listings | Marketplace Browse | TC-016 |
| FR-017 | P0 | AC-010 | GET /api/v1/marketplace/listings?condition= | marketplace_listings | Marketplace Browse | TC-017 |
| FR-018 | P0 | AC-011 | GET /api/v1/marketplace/listings/{id} | marketplace_listings | Marketplace Listing Details | TC-018 |
| FR-019 | P0 | AC-011 | GET /api/v1/marketplace/listings/{id}/seller | users | Marketplace Listing Details | TC-019 |
| FR-020 | P0 | AC-012 | PUT /api/v1/marketplace/listings/{id} | marketplace_listings | Edit Marketplace Listing | TC-020 |
| FR-021 | P0 | AC-012 | DELETE /api/v1/marketplace/listings/{id} | marketplace_listings | My Marketplace Listings | TC-021 |
| FR-022 | P0 | — | GET /api/v1/marketplace/my-listings | marketplace_listings | My Marketplace Listings | TC-022 |
| FR-023 | P0 | AC-013 | — | — | AI Scanner | TC-023 |
| FR-024 | P0 | AC-014 | — | — | AI Scanner | TC-024 |
| FR-025 | P0 | AC-015 | POST /api/v1/ai/classify | ai_scans | Scan Result | TC-025 |
| FR-026 | P0 | AC-016 | GET /api/v1/ai/classify/{id} | ai_scans | Scan Result | TC-026 |
| FR-027 | P0 | — | GET /api/v1/ai/classify/{id}/disposal | ai_scans | Scan Result | TC-027 |
| FR-028 | P0 | — | GET /api/v1/ai/classify/{id}/diy | ai_scans, diy_projects | Scan Result | TC-028 |
| FR-029 | P0 | AC-017, AC-018 | GET /api/v1/ai/diy-suggestions | diy_projects | Scan Result | TC-029 |
| FR-030 | P1 | — | — | ai_scan_cache | — | TC-030 |
| FR-031 | P0 | AC-019 | GET /api/v1/diy/projects | diy_projects | DIY Browse | TC-031 |
| FR-032 | P0 | AC-020 | GET /api/v1/diy/projects/{id} | diy_projects | DIY Project Details | TC-032 |
| FR-033 | P0 | AC-021 | — | diy_projects | DIY Project Details | TC-033 |
| FR-034 | P1 | AC-022 | POST /api/v1/diy/saved | diy_saved | DIY Browse | TC-034 |
| FR-035 | P0 | — | GET /api/v1/diy/projects/{id} | diy_projects | DIY Project Details | TC-035 |
| FR-036 | P1 | — | POST /api/v1/community/posts | posts | Create Post | TC-036 |
| FR-037 | P0 | AC-023 | POST /api/v1/community/posts | posts | Create Post | TC-037 |
| FR-038 | P0 | — | POST /api/v1/community/posts | posts | Create Post | TC-038 |
| FR-039 | P0 | — | POST /api/v1/community/posts/{id}/images | post_images | Create Post | TC-039 |
| FR-040 | P0 | AC-025 | POST /api/v1/community/posts/{id}/like | post_likes | Community Feed | TC-040 |
| FR-041 | P0 | AC-026 | POST /api/v1/community/posts/{id}/comments | post_comments | Community Feed | TC-041 |
| FR-042 | P0 | AC-024 | GET /api/v1/community/posts | posts | Community Feed | TC-042 |
| FR-043 | P1 | — | GET /api/v1/community/posts?type= | posts | Community Feed | TC-043 |
| FR-044 | P0 | AC-027 | POST /api/v1/reports | reports | Community Feed | TC-044 |
| FR-045 | P0 | — | POST /api/v1/reports | reports | Report Form | TC-045 |
| FR-046 | P0 | — | POST /api/v1/reports | reports | Report Form | TC-046 |
| FR-047 | P0 | — | POST /api/v1/reports | reports | Report Form | TC-047 |
| FR-048 | P0 | — | GET /api/v1/admin/reports | reports | Admin Dashboard | TC-048 |
| FR-049 | P0 | — | PUT /api/v1/admin/reports/{id} | reports | Admin Dashboard | TC-049 |
| FR-050 | P1 | AC-028 | GET /api/v1/rewards/points | eco_rewards | Profile | TC-050 |
| FR-051 | P1 | — | GET /api/v1/rewards/points | eco_rewards | Profile | TC-051 |
| FR-052 | P1 | AC-029 | GET /api/v1/rewards/badges | user_badges | Profile | TC-052 |
| FR-053 | P1 | AC-030 | GET /api/v1/rewards/leaderboard | eco_rewards | Community Feed | TC-053 |
| FR-054 | P1 | — | GET /api/v1/rewards/history | eco_rewards | Profile | TC-054 |
| FR-055 | P1 | — | GET /api/v1/rewards/badges | user_badges | Profile | TC-055 |
| FR-056 | P0 | AC-031 | PUT /api/v1/users/me | users | Profile | TC-056 |
| FR-057 | P0 | AC-032 | GET /api/v1/marketplace/my-listings | marketplace_listings | My Marketplace Listings | TC-057 |
| FR-058 | P0 | — | GET /api/v1/users/{id}/purchases | marketplace_listings | Profile | TC-058 |
| FR-059 | P0 | AC-033 | GET /api/v1/users/{id}/stats | eco_rewards | Profile | TC-059 |
| FR-060 | P0 | — | PUT /api/v1/users/me/notifications | notification_preferences | Settings | TC-060 |
| FR-061 | P1 | — | — | notifications | Notifications | TC-061 |
| FR-062 | P1 | — | — | notifications | Notifications | TC-062 |
| FR-063 | P1 | — | — | notifications | Notifications | TC-063 |
| FR-064 | P1 | — | — | notifications | Notifications | TC-064 |

---

## 10. User Roles & Permissions

### 10.1 Role Definitions

| Role | Description |
|---|---|
| Student | Primary user. Can buy, sell, post, and earn rewards |
| NGO | Campus environmental organizations. Can post and request donations |
| Organization | Campus clubs and societies. Can post and organize drives |
| Admin | Platform administrators. Can moderate content and manage users |

### 10.2 Permission Matrix

| Feature | Student | NGO | Organization | Admin |
|---|:---:|:---:|:---:|:---:|
| Register/Login | ✅ | ✅ | ✅ | ✅ |
| Create Marketplace Listing | ✅ | ❌ | ❌ | ✅ |
| Buy Marketplace Listing | ✅ | ❌ | ❌ | ✅ |
| Create Community Post | ✅ | ✅ | ✅ | ✅ |
| Like/Comment | ✅ | ✅ | ✅ | ✅ |
| AI Waste Scanner | ✅ | ✅ | ✅ | ✅ |
| DIY Studio | ✅ | ✅ | ✅ | ✅ |
| Earn Eco Rewards | ✅ | ✅ | ✅ | ❌ |
| View Leaderboard | ✅ | ✅ | ✅ | ✅ |
| Report Content | ✅ | ✅ | ✅ | ✅ |
| Moderate Content | ❌ | ❌ | ❌ | ✅ |
| Manage Users | ❌ | ❌ | ❌ | ✅ |
| View Analytics | ❌ | ❌ | ❌ | ✅ |

---

## 11. User Journeys

### 11.1 Registration Flow

```
Open App
    ↓
Splash Screen
    ↓
Login Screen
    ↓
[Email Registration] or [Google Sign-In]
    ↓
Role Selection (Student/NGO/Organization)
    ↓
Profile Setup (Name, College, Photo)
    ↓
Home Dashboard
```

### 11.2 Buy Marketplace Listing Flow

```
Home Dashboard
    ↓
Browse Marketplace
    ↓
Search / Filter Marketplace Listings
    ↓
View Marketplace Listing Details
    ↓
Contact Seller
    ↓
Complete Transaction (Offline)
```

### 11.3 Sell Marketplace Listing Flow

```
Home Dashboard
    ↓
Tap "Sell" Quick Action
    ↓
Create Marketplace Listing
  - Add title, description
  - Set price
  - Select category
  - Select condition
  - Upload images (up to 5)
    ↓
Publish Marketplace Listing
    ↓
Receive Inquiry Notification
    ↓
Contact Buyer
    ↓
Complete Transaction (Offline)
```

### 11.4 AI Scan Flow

```
Home Dashboard
    ↓
Tap "Scan" Quick Action
    ↓
[Camera Capture] or [Gallery Upload]
    ↓
AI Classification Processing
    ↓
View Classification Result
  - Material type
  - Confidence score
  - Disposal suggestions
  - DIY project suggestions
    ↓
[Save Result] or [Share to Community]
```

### 11.5 DIY Project Flow

```
Home Dashboard or Scan Result
    ↓
Browse DIY Projects
    ↓
View Project Details
  - Materials needed
  - Step-by-step instructions
  - Difficulty level
  - Estimated time
  - Video tutorial
  - Estimated selling price
    ↓
Save Project / Start Project
    ↓
Complete Project
    ↓
Share to Community Feed
```

### 11.6 Community Post Flow

```
Home Dashboard
    ↓
Navigate to Community Feed
    ↓
Tap "Create Post"
    ↓
Select Post Type (DIY/Tip/Marketplace Listing)
    ↓
Add Content
  - Text description
  - Upload images
  - Link to DIY project or Marketplace Listing (optional)
    ↓
Publish Post
    ↓
Receive Likes/Comments
```

### 11.7 Report Content Flow

```
View Marketplace Listing / Post / Comment
    ↓
Tap "Report"
    ↓
Select Reason (Spam/Inappropriate/Scam/Other)
    ↓
Add Description (optional)
    ↓
Submit Report
    ↓
Admin Reviews Report
    ↓
Action Taken (Remove/Warn/Ban)
    ↓
Reporter Notified
```

---

## 12. Acceptance Criteria

### 12.1 Authentication

| AC ID | Criterion | FR Reference |
|---|---|---|
| AC-001 | User can register with email and receive confirmation | FR-001 |
| AC-002 | User can register with Google and be authenticated | FR-002 |
| AC-003 | Role selection screen appears only for new users | FR-003 |
| AC-004 | Profile setup requires name and college at minimum | FR-004 |
| AC-005 | Logged-out user must authenticate to access app features | FR-006 |

### 12.2 Marketplace

| AC ID | Criterion | FR Reference |
|---|---|---|
| AC-006 | User can create Marketplace Listing with all required fields | FR-011 |
| AC-007 | User can upload up to 5 images per Marketplace Listing | FR-012 |
| AC-008 | Marketplace Listings display in grid with image, title, price | FR-013 |
| AC-009 | Search returns relevant results within 1 second | FR-014 |
| AC-010 | Filters correctly narrow Marketplace Listing results | FR-015, FR-016, FR-017 |
| AC-011 | Marketplace Listing detail shows all information and seller contact | FR-018, FR-019 |
| AC-012 | User can only edit/remove their own Marketplace Listings | FR-020, FR-021 |

### 12.3 AI Scanner

| AC ID | Criterion | FR Reference |
|---|---|---|
| AC-013 | Camera captures image successfully | FR-023 |
| AC-014 | Gallery upload selects and loads image | FR-024 |
| AC-015 | Classification returns result within 5 seconds | FR-025 |
| AC-016 | Confidence score displayed for all classifications | FR-026 |
| AC-017 | Curated DIY suggestions appear when available | FR-029 |
| AC-018 | AI fallback triggers when no curated match exists | FR-029 |

### 12.4 DIY Studio

| AC ID | Criterion | FR Reference |
|---|---|---|
| AC-019 | DIY projects load and display correctly | FR-031 |
| AC-020 | Project details show all required information | FR-032 |
| AC-021 | YouTube video embeds and plays | FR-033 |
| AC-022 | Saved projects appear in user's saved list | FR-034 |

### 12.5 Community

| AC ID | Criterion | FR Reference |
|---|---|---|
| AC-023 | User can create post with all 3 post types | FR-037 |
| AC-024 | Posts display in feed with author, content, timestamp | FR-042 |
| AC-025 | Like count updates immediately on tap | FR-040 |
| AC-026 | Comments appear in real-time | FR-041 |
| AC-027 | Report submission confirms successfully | FR-044 |

### 12.6 Rewards

| AC ID | Criterion | FR Reference |
|---|---|---|
| AC-028 | Points awarded correctly for each action | FR-050 |
| AC-029 | Badges awarded when criteria are met | FR-052 |
| AC-030 | Leaderboard ranks users by total points | FR-053 |

### 12.7 Profile

| AC ID | Criterion | FR Reference |
|---|---|---|
| AC-031 | Profile displays correct user information | FR-056 |
| AC-032 | My Marketplace Listings shows correct items | FR-057 |
| AC-033 | Impact statistics calculate correctly | FR-059 |

---

## 13. Technical Architecture

### 13.1 System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Mobile App (Flutter)                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │ Auth     │ │ Market-  │ │ Scanner  │ │ Community│   │
│  │ Module   │ │ place    │ │ Module   │ │ Module   │   │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                  API Gateway (NestJS)                     │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │ Auth     │ │ Product  │ │ AI       │ │ User     │   │
│  │ Service  │ │ Service  │ │ Service  │ │ Service  │   │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
└─────────────────────────────────────────────────────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
┌─────────────────┐ ┌─────────────┐ ┌─────────────────┐
│   Supabase      │ │  Firebase   │ │  AI Service     │
│   (PostgreSQL)  │ │  (Auth/FCM) │ │  (FastAPI)      │
│   + Storage     │ │             │ │  Python + ML    │
└─────────────────┘ └─────────────┘ └─────────────────┘
```

### 13.2 Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| Mobile | Flutter 3.x | Cross-platform UI |
| State Management | Riverpod | Reactive state |
| Backend | NestJS | REST API |
| Database | Supabase PostgreSQL | Data storage |
| File Storage | Supabase Storage | Images, files |
| Authentication | Firebase Auth | Email + Google OAuth |
| Notifications | Firebase Cloud Messaging | Push notifications |
| AI Service | Python + FastAPI | Waste classification |
| AI Model | Cloud-based ML | Image classification |
| Caching | Redis (optional) | AI response caching |

### 13.3 API Principles

**Base URL**: `https://api.ecohabit.app/api/v1`

**Conventions**:
- RESTful endpoints with standard HTTP methods
- JSON request/response format
- JWT authentication via Firebase tokens in `Authorization` header
- Rate limiting: 100 requests/minute per user
- Pagination via `page` and `limit` query parameters

**Standard Response Format**:
```json
{
  "success": true,
  "data": { },
  "message": "Operation completed",
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100
  }
}
```

**Error Response Format**:
```json
{
  "success": false,
  "error": {
    "code": "MARKETPLACE_LISTING_NOT_FOUND",
    "message": "Marketplace Listing not found"
  }
}
```

**Error Codes**:

| Code | HTTP Status | Description |
|---|---|---|
| AUTH_UNAUTHORIZED | 401 | Missing or invalid token |
| AUTH_FORBIDDEN | 403 | Insufficient permissions |
| VALIDATION_ERROR | 400 | Invalid request body |
| MARKETPLACE_LISTING_NOT_FOUND | 404 | Marketplace Listing not found |
| AI_CLASSIFICATION_FAILED | 500 | AI service error |

**API Endpoint Inventory**:

| Module | Endpoint Group | Key Endpoints |
|---|---|---|
| Auth | `/api/v1/auth/*` | `/register`, `/login`, `/google`, `/logout` |
| Users | `/api/v1/users/*` | `/{id}`, `/me`, `/stats` |
| Marketplace | `/api/v1/marketplace/*` | `/listings`, `/listings/{id}`, `/search`, `/my-listings` |
| AI Scanner | `/api/v1/ai/*` | `/classify`, `/diy-suggestions`, `/cache/{hash}` |
| DIY | `/api/v1/diy/*` | `/projects`, `/projects/{id}`, `/saved` |
| Community | `/api/v1/community/*` | `/posts`, `/posts/{id}`, `/posts/{id}/like`, `/posts/{id}/comments` |
| Reports | `/api/v1/reports/*` | `/submit`, `/queue` (admin), `/resolve/{id}` (admin) |
| Rewards | `/api/v1/rewards/*` | `/points`, `/badges`, `/leaderboard`, `/history` |
| Notifications | `/api/v1/notifications/*` | `/preferences`, `/mark-read` |

### 13.4 Database Design

**Principles**:
- UUID primary keys
- Timestamps (`created_at`, `updated_at`)
- Soft deletes where appropriate
- Indexes on frequently queried fields
- Foreign key constraints

### 13.5 Database Enums

| Enum | Values |
|---|---|
| UserRole | `student`, `ngo`, `organization`, `admin` |
| ProductCategory | `textbooks_stationery`, `electronics_gadgets`, `furniture_decor`, `clothing_accessories`, `sports_fitness`, `others` |
| ProductCondition | `new`, `good`, `fair`, `used` |
| TransactionType | `buy`, `sell`, `rent`, `exchange` |
| PostType | `diy`, `tip`, `marketplace` |
| ReportReason | `spam`, `inappropriate`, `scam`, `other` |
| ReportStatus | `pending`, `resolved`, `dismissed` |
| BadgeType | `first_sale`, `recycler`, `creator`, `community_star`, `campus_champion`, `eco_warrior` |
| NotificationType | `like_comment`, `marketplace_inquiry`, `reward_achievement`, `community_update` |
| WasteCategory | `plastic`, `paper_cardboard`, `glass`, `metal`, `organic`, `ewaste`, `textile`, `others` |
| DifficultyLevel | `easy`, `medium`, `hard` |
| MarketplaceListingStatus | `active`, `sold`, `removed` |

### 13.6 AI Requirements

**Classification Requirements**:

| Requirement | Specification |
|---|---|
| Confidence Threshold | 80% — below this, display "Uncertain" |
| Maximum Image Size | 10 MB |
| Supported Formats | JPEG, PNG, WebP |
| Response Time Target | < 5 seconds |
| Fallback Behavior | Show "Classification uncertain" with manual category selection |
| Cache Duration | 30 days for identical images |
| Rate Limit | 50 classifications per user per day |

**AI Operational KPIs**:

| Metric | Target | Measurement |
|---|---|---|
| Classification Success Rate | > 90% | Successful classifications / total attempts |
| Average Response Time | < 5 seconds | P95 of API response times |
| Manual Correction Rate | < 15% | User overrides / total classifications |
| Scan-to-DIY Conversion | > 30% | Scans leading to DIY view / total scans |
| Cache Hit Rate | > 40% | Cached results / total requests |

---

## 14. Non-Functional Requirements

### 14.1 Performance

| Metric | Target |
|---|---|
| App Launch Time | < 3 seconds |
| API Response Time | < 500ms (95th percentile) |
| AI Classification Time | < 5 seconds |
| Image Upload Time | < 10 seconds |
| Offline Data Access | Cached Marketplace Listings viewable |

### 14.2 Security

| Requirement | Implementation |
|---|---|
| Authentication | Firebase Auth with JWT |
| Data Encryption | HTTPS/TLS for all API calls |
| Input Validation | Server-side validation on all inputs |
| Rate Limiting | 100 requests/minute per user |
| Content Moderation | User reports + admin review |
| Data Privacy | GDPR-compliant data handling |

### 14.3 Accessibility

| Requirement | Standard |
|---|---|
| Screen Reader Support | WCAG 2.1 AA |
| Color Contrast | Minimum 4.5:1 ratio |
| Touch Targets | Minimum 44x44 pixels |
| Font Sizes | Scalable text support |

### 14.4 Offline Support

| Feature | Offline Behavior |
|---|---|
| Browse Marketplace Listings | Cached data available |
| View Profile | Cached data available |
| Create Marketplace Listing | Queued for sync |
| AI Scanner | Requires internet |

---

## 15. Assumptions & Dependencies

### 15.1 Assumptions

1. Target college has reliable internet connectivity
2. Students have smartphones with cameras
3. Firebase services remain free for MVP scale
4. Supabase free tier handles initial data volume
5. AI classification accuracy > 80% for common waste items

### 15.2 Dependencies

| Dependency | Provider | Free Tier |
|---|---|---|
| Firebase Auth | Google | 50K monthly active users |
| Firebase FCM | Google | Unlimited |
| Supabase Database | Supabase | 500MB storage |
| Supabase Storage | Supabase | 1GB storage |
| AI Model Hosting | To be determined | TBD |

---

## 16. Risks & Mitigations

### 16.1 Technical Risks

| Risk | Impact | Mitigation |
|---|---|---|
| AI classification accuracy | Poor user experience | Start with curated DB, use AI as fallback |
| Supabase free tier limits | Service disruption | Monitor usage, plan upgrade path |
| Flutter performance | Slow app | Profile early, optimize critical paths |
| Image upload failures | Lost Marketplace Listings | Implement retry logic, local caching |

### 16.2 Product Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Low user adoption | No marketplace activity | Campus ambassador program, incentives |
| Spam/fake Marketplace Listings | Trust issues | Verification, reporting, moderation |
| Negative community content | Platform reputation | Proactive moderation, clear guidelines |

### 16.3 Timeline Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Scope creep | Delays launch | Strict MVP adherence, defer non-critical features |
| AI integration delays | Missing core feature | Curated DB as primary, AI as enhancement |
| Resource constraints | Slow development | Focus on critical path, parallel work streams |

---

## 17. Release Strategy

### 17.1 Alpha (Weeks 1-2)

- Development team only
- Core features functional
- No external users
- Internal testing and bug fixes

### 17.2 Beta (Weeks 3-6)

- Single campus pilot
- 50-100 invited students
- Feedback collection via in-app survey
- Weekly iteration cycles
- Monitor KPIs and crash reports

### 17.3 Production (Week 7+)

- Public release on Play Store and App Store
- Marketing push on campus
- Campus ambassador program
- Scale to more campuses based on success

---

## 18. Milestones & Roadmap

### Sprint 1: Product Foundation (Current)
- [x] PRD document
- [ ] User personas
- [ ] User journeys
- [ ] Information architecture

### Sprint 2: Database & API Design
- [ ] ER diagram
- [ ] Database schema
- [ ] API contracts
- [ ] Backend module structure

### Sprint 3: UI/UX Design
- [ ] Brand identity
- [ ] Design system
- [ ] Wireframes
- [ ] High-fidelity mockups

### Sprint 4: Development Setup
- [ ] Flutter project setup
- [ ] NestJS project setup
- [ ] Firebase configuration
- [ ] Supabase setup

### Sprint 5: Core Features (Backend)
- [ ] Authentication module
- [ ] User management
- [ ] Marketplace Listings
- [ ] Community posts

### Sprint 6: Core Features (Frontend)
- [ ] Auth screens
- [ ] Home dashboard
- [ ] Marketplace screens
- [ ] Profile screens

### Sprint 7: AI Integration
- [ ] AI Scanner implementation
- [ ] DIY suggestions engine
- [ ] Caching layer

### Sprint 8: Polish & Launch
- [ ] Bug fixes
- [ ] Performance optimization
- [ ] Beta testing
- [ ] Campus launch

---

## 19. Appendix

### 19.1 Glossary

| Term | Definition |
|---|---|
| Circular Economy | Economic system aimed at eliminating waste through reuse, repair, and recycling |
| DIY | Do It Yourself — creating or repairing items instead of buying new |
| Upcycling | Converting waste materials into new products of higher value |
| CO2 Saved | Estimated carbon dioxide emissions prevented by diverting items from landfill |
| Eco Points | Gamification currency earned through sustainable actions |

### 19.2 References

- UN Sustainable Development Goals (SDGs)
- Circular Economy principles
- Indian Waste Management Rules 2016

---

**Document Version**: 1.0
**Last Updated**: July 2026
**Author**: EcoHabit Team
