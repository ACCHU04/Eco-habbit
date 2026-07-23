# EcoHabit Screen Specifications

> **Document Version:** 1.0
> **Last Updated:** July 2026
> **Status:** Active

---

## Overview

This document specifies all 20 screens in the EcoHabit MVP. Each screen includes an ASCII wireframe, component inventory, state definitions, interactions, navigation, offline behavior, analytics events, and performance budget.

---

## Screen ID Convention

Screens are identified as `SCR-XXX` for traceability with the PRD and user journeys.

---

## Auth Flow Screens

---

### SCR-001: Splash Screen

| Field | Value |
|---|---|
| Module | Core |
| Priority | P0 |
| FR Traceability | — |
| Offline Support | No |

**Wireframe:**

```
┌──────────────────────────────┐
│                              │
│                              │
│                              │
│         ┌────────┐           │
│         │  Logo  │           │
│         │ (icon) │           │
│         └────────┘           │
│                              │
│        EcoHabit              │
│     Buy. Sell. Sustain.      │
│                              │
│                              │
│         ┌────────┐           │
│         │Spinner │           │
│         └────────┘           │
│                              │
└──────────────────────────────┘
```

**Components:** Logo (icon, 120px), App name (`displaySmall`, `eco.primary`), Tagline (`bodyLarge`, `eco.neutral.500`), Progress indicator (indeterminate)

**States:** Loading (spinner visible) → Navigate to Login or Home

**Interactions:** None (auto-navigate after 2s)

**Navigation:** → Login (if not authenticated) → Home Dashboard (if authenticated)

**Analytics:** `splash_view`

**Performance Budget:**
- API calls: None
- Images: Logo only (bundled asset)
- Cache: Check auth token locally
- Duration: Max 2s before auto-navigate

---

### SCR-002: Login Screen

| Field | Value |
|---|---|
| Module | Auth |
| Priority | P0 |
| FR Traceability | FR-001, FR-002, FR-006 |
| Offline Support | No |

**Wireframe:**

```
┌──────────────────────────────┐
│  ← Back                      │
│                              │
│  Welcome back                │
│  Sign in to continue         │
│                              │
│  ┌──────────────────────────┐│
│  │ Email                    ││
│  └──────────────────────────┘│
│                              │
│  ┌──────────────────────────┐│
│  │ Password          👁     ││
│  └──────────────────────────┘│
│                              │
│  Forgot password?            │
│                              │
│  ┌──────────────────────────┐│
│  │        Sign In           ││
│  └──────────────────────────┘│
│                              │
│  ──────── OR ────────        │
│                              │
│  ┌──────────────────────────┐│
│  │   G  Continue with Google││
│  └──────────────────────────┘│
│                              │
│  Don't have an account?      │
│  Sign Up                     │
└──────────────────────────────┘
```

**Components:** Back button (icon), Title (`headlineMedium`), Subtitle (`bodyMedium`), Email field, Password field (with visibility toggle), Forgot password link, Primary button (Sign In), Divider with "OR", Google button (outlined), Sign up link

**States:**
- Default: Fields empty
- Loading: Button shows spinner, fields disabled
- Error: Snackbar with error message
- Success: Navigate to Home

**Interactions:** Tap email → keyboard open, Tap password → keyboard open, Tap eye → toggle visibility, Tap "Sign In" → validate + authenticate, Tap Google → Google OAuth flow, Tap "Sign Up" → Register screen, Tap "Forgot password" → Reset password email

**Navigation:** → Home Dashboard (success) → Register (sign up) → Forgot Password flow

**Analytics:** `login_view`, `login_email_submit`, `login_google_submit`, `login_success`, `login_error`

**Performance Budget:**
- API calls: 1 (`POST /auth/login`)
- Images: None
- Cache: None
- Skeleton: No (form screen)

---

### SCR-003: Register Screen

| Field | Value |
|---|---|
| Module | Auth |
| Priority | P0 |
| FR Traceability | FR-001, FR-002 |
| Offline Support | No |

**Wireframe:**

```
┌──────────────────────────────┐
│  ← Back                      │
│                              │
│  Create account              │
│  Join the EcoHabit community │
│                              │
│  ┌──────────────────────────┐│
│  │ Full Name                ││
│  └──────────────────────────┘│
│  ┌──────────────────────────┐│
│  │ Email                    ││
│  └──────────────────────────┘│
│  ┌──────────────────────────┐│
│  │ Password          👁     ││
│  └──────────────────────────┘│
│  ┌──────────────────────────┐│
│  │ Confirm Password  👁     ││
│  └──────────────────────────┘│
│  ┌──────────────────────────┐│
│  │ College / University     ││
│  └──────────────────────────┘│
│                              │
│  ┌──────────────────────────┐│
│  │      Create Account      ││
│  └──────────────────────────┘│
│                              │
│  ──────── OR ────────        │
│                              │
│  ┌──────────────────────────┐│
│  │   G  Sign up with Google ││
│  └──────────────────────────┘│
│                              │
│  Already have an account?    │
│  Sign In                     │
└──────────────────────────────┘
```

**Components:** Back button, Title, Subtitle, Full name field, Email field, Password field, Confirm password field, College field, Primary button (Create Account), Google button, Sign in link

**States:** Default → Loading → Error/Success

**Interactions:** Form validation on submit, Password strength indicator, Confirm password match check

**Navigation:** → Role Selection (success) → Login (sign in link)

**Analytics:** `register_view`, `register_submit`, `register_google_submit`, `register_success`

**Performance Budget:**
- API calls: 1 (`POST /auth/register`)
- Images: None
- Cache: None

---

### SCR-004: Role Selection Screen

| Field | Value |
|---|---|
| Module | Auth |
| Priority | P0 |
| FR Traceability | FR-003 |
| Offline Support | No |

**Wireframe:**

```
┌──────────────────────────────┐
│                              │
│  Tell us about yourself      │
│  Select your role            │
│                              │
│  ┌──────────────────────────┐│
│  │ 👤 Student               ││
│  │ Buy, sell, and learn     ││
│  └──────────────────────────┘│
│                              │
│  ┌──────────────────────────┐│
│  │ 🏢 Organization          ││
│  │ Manage campus programs   ││
│  └──────────────────────────┘│
│                              │
│  ┌──────────────────────────┐│
│  │ 🤝 NGO                   ││
│  │ Run collection drives    ││
│  └──────────────────────────┘│
│                              │
│  ┌──────────────────────────┐│
│  │       Continue           ││
│  └──────────────────────────┘│
│                              │
└──────────────────────────────┘
```

**Components:** Title (`headlineMedium`), Subtitle (`bodyMedium`), Role cards (3), Primary button

**States:** Default (none selected) → Selected (card highlighted with `eco.primary` border) → Loading → Success

**Interactions:** Tap card → select role (single select), Tap "Continue" → proceed

**Navigation:** → Profile Setup (success)

**Analytics:** `role_selection_view`, `role_selected`, `role_selection_submit`

**Performance Budget:**
- API calls: 1 (`PATCH /users/me` with role)
- Images: None
- Cache: None

---

### SCR-005: Profile Setup Screen

| Field | Value |
|---|---|
| Module | Auth |
| Priority | P0 |
| FR Traceability | FR-004 |
| Offline Support | No |

**Wireframe:**

```
┌──────────────────────────────┐
│  ← Back                      │
│                              │
│  Complete your profile       │
│  Step 3 of 4                 │
│                              │
│      ┌────────┐              │
│      │ Camera │              │
│      │  Icon  │              │
│      └────────┘              │
│   Add profile photo          │
│                              │
│  ┌──────────────────────────┐│
│  │ Bio                      ││
│  └──────────────────────────┘│
│  ┌──────────────────────────┐│
│  │ Phone (optional)         ││
│  └──────────────────────────┘│
│  ┌──────────────────────────┐│
│  │ Interests                ││
│  │ [Sustainability] [Tech]  ││
│  │ [Fashion] [Furniture] +  ││
│  └──────────────────────────┘│
│                              │
│  ┌──────────────────────────┐│
│  │      Complete Setup      ││
│  └──────────────────────────┘│
│                              │
│  Skip for now                │
└──────────────────────────────┘
```

**Components:** Back button, Title, Step indicator, Avatar picker (circle, 80px, camera icon), Bio field (multiline), Phone field, Interest chips (selectable), Primary button, Skip link

**States:** Default → Loading → Success

**Interactions:** Tap camera → image picker, Tap chips → toggle selection, Tap "Complete" → save profile, Tap "Skip" → skip to Home

**Navigation:** → Home Dashboard (success or skip)

**Analytics:** `profile_setup_view`, `profile_photo_added`, `profile_setup_submit`, `profile_setup_skip`

**Performance Budget:**
- API calls: 1 (`PATCH /users/me`) + optional image upload
- Images: Profile photo (max 500KB)
- Cache: None

---

## Core Tab Screens

---

### SCR-006: Home Dashboard

| Field | Value |
|---|---|
| Module | Core |
| Priority | P0 |
| FR Traceability | FR-007, FR-008, FR-009, FR-010 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ EcoHabit           🔔 (1)    │
│──────────────────────────────│
│ ┌──────────────────────────┐ │
│ │ 🔍 Search marketplace... │ │
│ └──────────────────────────┘ │
│                              │
│ ── Featured Listings ──────  │
│ ┌────────┐┌────────┐┌─────┐ │
│ │ Card 1 ││ Card 2 ││ ... │ │
│ │        ││        ││     │ │
│ └────────┘└────────┘└─────┘ │
│ (horizontal scroll)          │
│                              │
│ ── Eco Tips ──────────────  │
│ ┌──────────────────────────┐ │
│ │ 💡 Tip of the day        │ │
│ │ "Donate unused items..." │ │
│ └──────────────────────────┘ │
│                              │
│ ── Trending DIY ──────────  │
│ ┌────────┐┌────────┐        │
│ │ DIY 1  ││ DIY 2  │  →    │
│ │        ││        │        │
│ └────────┘└────────┘        │
│ (horizontal scroll)          │
│                              │
│ ── Your Progress ────────  │
│ ┌──────────────────────────┐ │
│ │ ⭐ 250 pts  🏆 3 badges │ │
│ │ ████████░░ 75% to next  │ │
│ └──────────────────────────┘ │
│                              │
│ 🏠    🏪    📷    👥    👤   │
│ Home  Market Scan Comm Profile│
└──────────────────────────────┘
```

**Components:** App bar with notification bell (badge count), Search bar, Horizontal card scroller (featured listings), Tip card, Horizontal project scroller (DIY), Progress card, Bottom nav bar

**States:**
- Loading: Skeleton screen
- Empty: Empty state ("No listings yet")
- Error: Retry button
- Success: Full content

**Interactions:** Tap search → Marketplace Browse with search focused, Tap listing card → Listing Details, Tap DIY card → Project Details, Tap notification → Notifications, Tap progress card → Profile/Rewards, Pull-to-refresh → Refresh all sections

**Navigation:** → Marketplace Browse (search), → Listing Details (card tap), → Project Details (DIY tap), → Notifications (bell), → Profile (progress card)

**Analytics:** `home_view`, `home_search_tap`, `home_listing_tap`, `home_diy_tap`, `home_notification_tap`, `home_refresh`

**Performance Budget:**
- API calls: 3 (`GET /marketplace/listings?featured=true`, `GET /diy/projects?featured=true`, `GET /users/me/stats`)
- Images: 5 listing thumbnails, 2 DIY thumbnails
- Lazy load: Trending DIY, Your Progress sections
- Cache: 5 minutes for featured listings
- Skeleton: Shimmer loading for all sections
- Pull-to-refresh: Yes

---

### SCR-007: Marketplace Browse

| Field | Value |
|---|---|
| Module | Marketplace |
| Priority | P0 |
| FR Traceability | FR-013, FR-014, FR-015, FR-016, FR-017 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ 🔍 Search marketplace...     │
│──────────────────────────────│
│ [All] [Textbooks] [Electronics]│
│ [Furniture] [Clothing] [+]   │ ← filter chips (scrollable)
│                              │
│ 12 listings found            │
│                              │
│ ┌──────────────────────────┐ │
│ │ ┌──────┐ Textbook        │ │
│ │ │ img  │ ₹250 · Good     │ │
│ │ │      │ IIT Delhi       │ │
│ │ └──────┘ 2h ago          │ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ ┌──────┐ Chair           │ │
│ │ │ img  │ ₹800 · Fair     │ │
│ │ │      │ DU              │ │
│ │ └──────┘ 5h ago          │ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ ┌──────┐ Laptop          │ │
│ │ │ img  │ ₹15,000 · New   │ │
│ │ │      │ JNU             │ │
│ │ └──────┘ 1d ago          │ │
│ └──────────────────────────┘ │
│                              │
│ 🏠    🏪    📷    👥    👤   │
└──────────────────────────────┘
```

**Components:** Search bar (focused state), Filter chips (horizontally scrollable), Result count text, Listing cards (vertical list), Bottom nav bar

**States:**
- Loading: Skeleton cards
- Empty: "No listings found" with clear filters CTA
- Error: Retry button
- Success: List of cards

**Interactions:** Type in search → live search (debounced 300ms), Tap filter chip → apply filter, Tap "All" → clear filters, Tap card → Listing Details, Pull-to-refresh → Refresh results, Scroll → Infinite scroll (load more)

**Navigation:** → Listing Details (card tap), → Search filter modal (tap filter)

**Analytics:** `marketplace_view`, `marketplace_search`, `marketplace_filter_apply`, `marketplace_listing_tap`, `marketplace_scroll`, `marketplace_load_more`

**Performance Budget:**
- API calls: 1 (`GET /marketplace/listings?search=&category=&page=`)
- Images: 10 listing thumbnails (lazy load on scroll)
- Cache: 2 minutes
- Pagination: 20 items per page, infinite scroll
- Skeleton: Yes
- Pull-to-refresh: Yes

---

### SCR-008: Marketplace Listing Details

| Field | Value |
|---|---|
| Module | Marketplace |
| Priority | P0 |
| FR Traceability | FR-018, FR-019 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ ← Back            ♡   📤    │
│──────────────────────────────│
│ ┌──────────────────────────┐ │
│ │                          │ │
│ │    Image Carousel        │ │
│ │    (4:3 aspect)          │ │
│ │                          │ │
│ │    ● ○ ○ ○ ○             │ │
│ └──────────────────────────┘ │
│                              │
│ Title Textbook               │
│ ₹ 250                        │
│ Good condition · 2 days ago  │
│                              │
│ ── Seller Info ──────────── │
│ ┌────┐ Aisha Khan           │
│ │ 📷 │ IIT Delhi            │
│ └────┘ ★ 4.8 · 12 sales    │
│                              │
│ ── Description ──────────── │
│ Engineering Mathematics      │
│ textbook, lightly used...    │
│                              │
│ ── Details ──────────────── │
│ Category: Textbooks          │
│ Condition: Good              │
│ Location: IIT Delhi          │
│                              │
│ ┌──────────────────────────┐│
│ │    Contact Seller        ││
│ └──────────────────────────┘│
└──────────────────────────────┘
```

**Components:** Back button, Favorite button (heart icon), Share button, Image carousel with dots, Title (`headlineMedium`), Price (`headlineLarge`), Condition chip, Time ago text, Seller info card (avatar, name, college, rating), Description text, Detail list, Contact button (primary, full width)

**States:**
- Loading: Skeleton (image placeholder, text lines)
- Error: Retry
- Success: Full details

**Interactions:** Swipe images → carousel navigation, Tap heart → toggle favorite, Tap share → share sheet, Tap seller → seller profile, Tap "Contact Seller" → initiate chat/contact

**Navigation:** → Back (previous screen), → Seller Profile (tap seller), → Contact (tap contact button)

**Analytics:** `listing_detail_view`, `listing_image_swipe`, `listing_favorite_toggle`, `listing_share`, `listing_contact_tap`

**Performance Budget:**
- API calls: 1 (`GET /marketplace/listings/{id}`)
- Images: Up to 6 listing images (lazy load carousel)
- Cache: 5 minutes
- Skeleton: Yes

---

### SCR-009: Create Marketplace Listing

| Field | Value |
|---|---|
| Module | Marketplace |
| Priority | P0 |
| FR Traceability | FR-011, FR-012 |
| Offline Support | Queued |

**Wireframe:**

```
┌──────────────────────────────┐
│ ✕  Create Listing     Post → │
│──────────────────────────────│
│ ┌──────────────────────────┐ │
│ │ 📷 Add Photos (0/6)      │ │
│ │ ┌────┐ ┌────┐ ┌────┐    │ │
│ │ │ +  │ │    │ │    │    │ │
│ │ └────┘ └────┘ └────┘    │ │
│ └──────────────────────────┘ │
│                              │
│ ┌──────────────────────────┐│
│ │ Title *                  ││
│ └──────────────────────────┘│
│ ┌──────────────────────────┐│
│ │ Description *            ││
│ │ (multiline)              ││
│ └──────────────────────────┘│
│ ┌──────────────────────────┐│
│ │ Price * (₹)              ││
│ └──────────────────────────┘│
│ ┌──────────────────────────┐│
│ │ Category *               ││
│ └──────────────────────────┘│
│                              │
│ Condition *                  │
│ [New] [Good] [Fair] [Used]  │ ← radio chips
│                              │
│ ┌──────────────────────────┐│
│ │ Location *               ││
│ └──────────────────────────┘│
│                              │
│ ┌──────────────────────────┐│
│ │      Post Listing        ││
│ └──────────────────────────┘│
└──────────────────────────────┘
```

**Components:** Close button, Title ("Create Listing"), Post button (top right), Image picker grid, Title field, Description field (multiline), Price field (number), Category dropdown, Condition radio chips, Location field, Primary button

**States:**
- Default: Empty form
- Loading: Button shows spinner
- Validation error: Inline errors below fields
- Success: Navigate to My Listings with snackbar "Listing created!"
- Offline: "Will post when online" snackbar, queued

**Interactions:** Tap image placeholder → image picker, Tap category → dropdown, Tap condition chip → select, Tap "Post Listing" → validate + submit

**Navigation:** → My Listings (success), → Back (cancel with confirmation if data entered)

**Analytics:** `create_listing_view`, `create_listing_photo_add`, `create_listing_submit`, `create_listing_success`

**Performance Budget:**
- API calls: 1 (`POST /marketplace/listings`) + image uploads
- Images: Up to 6 (compressed client-side, max 1MB each)
- Offline: Queue action locally
- Skeleton: No (form screen)

---

### SCR-010: My Marketplace Listings

| Field | Value |
|---|---|
| Module | Marketplace |
| Priority | P0 |
| FR Traceability | FR-020, FR-021, FR-022 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ My Listings                  │
│──────────────────────────────│
│ [All] [Active] [Sold] [Removed]│ ← tabs
│                              │
│ ┌──────────────────────────┐ │
│ │ ┌──────┐ Textbook        │ │
│ │ │ img  │ ₹250 · Active   │ │
│ │ │      │ 3 views · 1 save│ │
│ │ └──────┘        Edit  ···│ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ ┌──────┐ Chair           │ │
│ │ │ img  │ ₹800 · Sold     │ │
│ │ │      │ Sold 2 days ago │ │
│ │ └──────┘        Edit  ···│ │
│ └──────────────────────────┘ │
│                              │
│ ┌──────────────────────────┐│
│ │    + Create New Listing  ││
│ └──────────────────────────┘│
└──────────────────────────────┘
```

**Components:** Title, Tab bar (All/Active/Sold/Removed), Listing cards with status badge, Views/save counts, Edit/More menu, Create new button (FAB or bottom)

**States:**
- Loading: Skeleton cards
- Empty: "No listings yet" with create CTA
- Success: Filtered list

**Interactions:** Tap tab → filter listings, Tap card → Listing Details, Tap "Edit" → Edit Listing, Tap "..." → More menu (Edit, Mark as Sold, Remove, Share), Tap "Create" → Create Listing

**Navigation:** → Listing Details (card tap), → Edit Listing (edit), → Create Listing (FAB)

**Analytics:** `my_listings_view`, `my_listings_tab_switch`, `my_listings_edit`, `my_listings_mark_sold`, `my_listings_remove`

**Performance Budget:**
- API calls: 1 (`GET /marketplace/my-listings?status=`)
- Images: Listing thumbnails (lazy load)
- Cache: 2 minutes
- Pull-to-refresh: Yes

---

### SCR-011: AI Scanner

| Field | Value |
|---|---|
| Module | AI |
| Priority | P0 |
| FR Traceability | FR-023, FR-024, FR-025, FR-026 |
| Offline Support | No |

**Wireframe:**

```
┌──────────────────────────────┐
│ AI Scanner                   │
│──────────────────────────────│
│                              │
│ ┌──────────────────────────┐ │
│ │                          │ │
│ │    Camera Viewfinder     │ │
│ │                          │ │
│ │    ┌──────────────┐      │ │
│ │    │  Scan Frame  │      │ │
│ │    │  (corners)   │      │ │
│ │    └──────────────┘      │ │
│ │                          │ │
│ └──────────────────────────┘ │
│                              │
│ Point camera at an item      │
│ to classify it               │
│                              │
│ ┌──────────────────────────┐│
│ │    📷 Capture            ││
│ └──────────────────────────┘│
│                              │
│ 📁 Upload from Gallery      │
└──────────────────────────────┘
```

**Components:** Title, Camera viewfinder (full width), Scan frame overlay (corners), Instruction text, Capture button (large, circular, `eco.primary`), Gallery upload link

**States:**
- Default: Camera active
- Scanning: Overlay animation, "Scanning..." text
- Processing: Spinner over viewfinder
- Error: "Could not scan. Try again." snackbar
- Permission denied: "Camera access required" with settings link

**Interactions:** Tap capture → take photo + classify, Tap gallery → image picker, Position item in frame → auto-suggest

**Navigation:** → Scan Result (after classification), → Gallery (image picker)

**Analytics:** `scanner_view`, `scanner_capture`, `scanner_gallery_upload`, `scanner_scan_start`, `scanner_scan_complete`, `scanner_error`

**Performance Budget:**
- API calls: 1 (`POST /ai/classify`)
- Images: 1 captured image (compressed, max 2MB)
- Response time: < 5 seconds
- Offline: Not supported
- Camera permission required

---

### SCR-012: Scan Result

| Field | Value |
|---|---|
| Module | AI |
| Priority | P0 |
| FR Traceability | FR-025, FR-026, FR-027, FR-028, FR-029 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ ← Back      Scan Result      │
│──────────────────────────────│
│ ┌──────────────────────────┐ │
│ │    Scanned Image         │ │
│ └──────────────────────────┘ │
│                              │
│ Classification: Plastic Bottle│
│ Confidence: 92%              │
│ ████████████████████░░ 92%   │
│                              │
│ ── Disposal Guide ──────── │
│ ┌──────────────────────────┐ │
│ │ ♻️ Recycle               │ │
│ │ Rinse and place in blue  │ │
│ │ recycling bin...         │ │
│ └──────────────────────────┘ │
│                              │
│ ── DIY Suggestions ────── │
│ ┌────────┐ ┌────────┐      │
│ │ Planter│ │ Wallet │ →    │
│ │ Easy   │ │ Medium │      │
│ └────────┘ └────────┘      │
│ (horizontal scroll)          │
│                              │
│ ┌──────────────────────────┐│
│ │    🔍 Scan Another       ││
│ └──────────────────────────┘│
└──────────────────────────────┘
```

**Components:** Back button, Scanned image, Classification text, Confidence indicator (progress bar + percentage), Disposal guide card, DIY suggestions (horizontal scroll), "Scan Another" button

**States:**
- Loading: Processing overlay
- Uncertain (confidence < 80%): Show "Uncertain — Please select manually" with manual selection options
- Success: Full result
- Error: "Classification failed" with retry

**Interactions:** Tap DIY card → Project Details, Tap "Scan Another" → AI Scanner, Swipe DIY cards → scroll

**Navigation:** → AI Scanner (scan another), → Project Details (DIY tap)

**Analytics:** `scan_result_view`, `scan_result_diy_tap`, `scan_result_scan_another`, `scan_confidence_level`

**Performance Budget:**
- API calls: 1 (`GET /ai/cache/{hash}` if cached, or result from classify)
- Images: 1 scanned image
- Cache: Results cached by image hash
- Skeleton: No (single result)

---

### SCR-013: DIY Browse

| Field | Value |
|---|---|
| Module | DIY |
| Priority | P0 |
| FR Traceability | FR-031, FR-034 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ DIY Projects           🔍    │
│──────────────────────────────│
│ [All] [Easy] [Medium] [Hard]│ ← difficulty filter
│                              │
│ ┌──────────────────────────┐ │
│ │ ┌──────────────────────┐ │ │
│ │ │    Project Image     │ │ │
│ │ └──────────────────────┘ │ │
│ │ Plastic Bottle Planter  │ │
│ │ Easy · 30 min · ₹50     │ │
│ │ ♻️ 3 materials needed   │ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ ┌──────────────────────┐ │ │
│ │ │    Project Image     │ │ │
│ │ └──────────────────────┘ │ │
│ │ Cardboard Organizer     │ │
│ │ Medium · 1 hr · ₹0     │ │
│ │ ♻️ 2 materials needed   │ │
│ └──────────────────────────┘ │
│                              │
│ 🏠    🏪    📷    👥    👤   │
└──────────────────────────────┘
```

**Components:** Title, Search icon, Difficulty filter chips, Project cards (image, title, difficulty chip, time, price, materials count), Bottom nav bar

**States:**
- Loading: Skeleton cards
- Empty: "No projects found"
- Success: Grid/list of cards

**Interactions:** Tap filter → filter projects, Tap search → search DIY projects, Tap card → Project Details, Pull-to-refresh → Refresh

**Navigation:** → Project Details (card tap)

**Analytics:** `diy_browse_view`, `diy_filter_apply`, `diy_project_tap`

**Performance Budget:**
- API calls: 1 (`GET /diy/projects?difficulty=`)
- Images: Project thumbnails (lazy load)
- Cache: 10 minutes (curated content changes infrequently)
- Pagination: 20 per page
- Pull-to-refresh: Yes

---

### SCR-014: DIY Project Details

| Field | Value |
|---|---|
| Module | DIY |
| Priority | P0 |
| FR Traceability | FR-032, FR-033, FR-035 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ ← Back        ♡  📤  💾     │
│──────────────────────────────│
│ ┌──────────────────────────┐ │
│ │    Project Image (16:9)  │ │
│ └──────────────────────────┘ │
│                              │
│ Plastic Bottle Planter       │
│ Easy · 30 min · Est. ₹50    │
│                              │
│ ── Materials ────────────── │
│ • 1 plastic bottle           │
│ • Soil                       │
│ • Paint (optional)           │
│                              │
│ ── Steps ────────────────── │
│ 1. Clean the bottle          │
│ ┌──────────────────────────┐ │
│ │    Step 1 Image          │ │
│ └──────────────────────────┘ │
│ 2. Cut in half...            │
│ ┌──────────────────────────┐ │
│ │    Step 2 Image          │ │
│ └──────────────────────────┘ │
│ 3. Paint and decorate...     │
│                              │
│ ── Video Tutorial ──────── │
│ ┌──────────────────────────┐ │
│ │    ▶ Watch Video         │ │
│ └──────────────────────────┘ │
│                              │
│ ┌──────────────────────────┐│
│ │    💾 Save Project       ││
│ └──────────────────────────┘│
└──────────────────────────────┘
```

**Components:** Back button, Favorite, Share, Save buttons, Hero image, Title, Difficulty/time/price chips, Materials list, Steps list (numbered, with images), Video tutorial link, Save button (primary, full width)

**States:**
- Loading: Skeleton
- Success: Full content
- Saved: Button changes to "Saved ✓"

**Interactions:** Tap heart → toggle favorite, Tap share → share sheet, Tap save → save project, Tap video → open video player/embed, Scroll → scroll through steps

**Navigation:** → Back (previous), → Video player (tap video)

**Analytics:** `diy_detail_view`, `diy_favorite_toggle`, `diy_save`, `diy_video_tap`, `diy_share`

**Performance Budget:**
- API calls: 1 (`GET /diy/projects/{id}`)
- Images: Hero image + step images (lazy load per step)
- Cache: 10 minutes
- Video: External embed (YouTube), not cached

---

### SCR-015: Community Feed

| Field | Value |
|---|---|
| Module | Community |
| Priority | P0 |
| FR Traceability | FR-040, FR-041, FR-042, FR-043, FR-044 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ Community Feed       🔍  ✏️  │
│──────────────────────────────│
│ [All] [DIY] [Tips] [Market] │ ← filter tabs
│                              │
│ ┌──────────────────────────┐ │
│ │ 📷 Aisha · 2h ago    ···│ │
│ │ Check out this planter   │ │
│ │ I made from a bottle!    │ │
│ │ ┌──────────────────────┐ │ │
│ │ │    Post Image        │ │ │
│ │ └──────────────────────┘ │ │
│ │ ♡ 12  💬 3  📤 Share    │ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ 📷 Rahul · 5h ago    ···│ │
│ │ Pro tip: Always check    │ │
│ │ textbook edition before  │ │
│ │ buying...                │ │
│ │ ♡ 8  💬 1  📤 Share     │ │
│ └──────────────────────────┘ │
│                              │
│              ✏️              │ ← FAB
│ 🏠    🏪    📷    👥    👤   │
└──────────────────────────────┘
```

**Components:** Title, Search icon, Create post icon, Filter tabs, Post cards (avatar, name, time, content, image, actions), FAB (create post), Bottom nav bar

**States:**
- Loading: Skeleton cards
- Empty: "No posts yet" with create CTA
- Success: Feed list

**Interactions:** Tap tab → filter posts, Tap heart → toggle like (optimistic UI), Tap comment → open comments, Tap share → share sheet, Tap FAB → Create Post, Tap avatar → user profile, Pull-to-refresh → Refresh feed, Scroll → Infinite scroll

**Navigation:** → Create Post (FAB), → Comments (tap comment), → User Profile (tap avatar)

**Analytics:** `community_feed_view`, `community_filter_switch`, `community_like_toggle`, `community_comment_tap`, `community_share`, `community_create_tap`, `community_scroll`

**Performance Budget:**
- API calls: 1 (`GET /community/posts?filter=&page=`)
- Images: Post images (lazy load on scroll)
- Cache: 2 minutes
- Pagination: 20 per page, infinite scroll
- Optimistic UI: Like toggle
- Pull-to-refresh: Yes

---

### SCR-016: Create Post

| Field | Value |
|---|---|
| Module | Community |
| Priority | P0 |
| FR Traceability | FR-037, FR-038, FR-039 |
| Offline Support | Queued |

**Wireframe:**

```
┌──────────────────────────────┐
│ ✕  Create Post        Post → │
│──────────────────────────────│
│ ┌────┐                       │
│ │ 📷 │ Aisha Khan            │
│ └────┘                       │
│                              │
│ ┌──────────────────────────┐ │
│ │ What's on your mind?     │ │
│ │ (multiline, expandable)  │ │
│ └──────────────────────────┘ │
│                              │
│ Post Type:                   │
│ [DIY] [Tip] [Marketplace]   │ ← radio chips
│                              │
│ ┌──────────────────────────┐ │
│ │ 📷 Add Photo             │ │
│ └──────────────────────────┘ │
│                              │
│ Link to listing (optional):  │
│ ┌──────────────────────────┐│
│ │ Paste listing URL...     ││
│ └──────────────────────────┘│
│                              │
│ ┌──────────────────────────┐│
│ │      Post                ││
│ └──────────────────────────┘│
└──────────────────────────────┘
```

**Components:** Close button, Title, User avatar + name, Content field (multiline, expandable), Post type chips, Photo picker, Link field, Primary button

**States:**
- Default: Empty form
- Loading: Button spinner
- Validation error: Inline errors
- Success: Navigate to Community Feed with snackbar "Posted!"
- Offline: Queued

**Interactions:** Tap type chip → select type, Tap photo → image picker, Tap "Post" → validate + submit

**Navigation:** → Community Feed (success), → Back (cancel confirmation if data entered)

**Analytics:** `create_post_view`, `create_post_type_select`, `create_post_photo_add`, `create_post_submit`, `create_post_success`

**Performance Budget:**
- API calls: 1 (`POST /community/posts`) + optional image upload
- Images: 1 (compressed, max 2MB)
- Offline: Queue action
- Skeleton: No (form screen)

---

### SCR-017: Notifications

| Field | Value |
|---|---|
| Module | Utility |
| Priority | P1 |
| FR Traceability | FR-061, FR-062, FR-063, FR-064 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ ← Back     Notifications     │
│──────────────────────────────│
│ [All] [Messages] [System]    │ ← filter
│                              │
│ ── Today ────────────────── │
│ ┌──────────────────────────┐ │
│ │ 🔔 Aisha liked your post │ │
│ │    2 minutes ago         │ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ 💬 Rahul commented on... │ │
│ │    15 minutes ago        │ │
│ └──────────────────────────┘ │
│                              │
│ ── Yesterday ────────────── │
│ ┌──────────────────────────┐ │
│ │ 🏆 You earned the        │ │
│ │    Recycler badge!       │ │
│ │    1 day ago             │ │
│ └──────────────────────────┘ │
│                              │
│ Mark all as read             │
└──────────────────────────────┘
```

**Components:** Back button, Title, Filter tabs, Grouped notification list (by time), Notification items (icon, text, time), "Mark all as read" link

**States:**
- Loading: Skeleton
- Empty: "All caught up!" with bell illustration
- Success: Grouped list

**Interactions:** Tap notification → navigate to relevant content, Tap "Mark all as read" → clear badges, Pull-to-refresh → Refresh

**Navigation:** → Back (previous), → Content (based on notification type)

**Analytics:** `notifications_view`, `notification_tap`, `notifications_mark_all_read`

**Performance Budget:**
- API calls: 1 (`GET /notifications?filter=`)
- Images: None
- Cache: 1 minute
- Pull-to-refresh: Yes

---

### SCR-018: Profile

| Field | Value |
|---|---|
| Module | Profile |
| Priority | P0 |
| FR Traceability | FR-056, FR-057, FR-058, FR-059 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ Profile              ⚙️      │
│──────────────────────────────│
│         ┌────────┐           │
│         │ Avatar │           │
│         │  XL    │           │
│         └────────┘           │
│       Aisha Khan             │
│     IIT Delhi · Student      │
│                              │
│ ┌────────┐┌────────┐┌──────┐│
│ │⭐ 250  ││🏆 3    ││📦 5  ││
│ │Points  ││Badges  ││Listed││
│ └────────┘└────────┘└──────┘│
│                              │
│ ── Quick Actions ────────── │
│ ┌──────────────────────────┐ │
│ │ 📦 My Listings           │ │
│ │ 💾 Saved Items            │ │
│ │ 📜 Transaction History   │ │
│ │ 🏆 Rewards               │ │
│ │ 🔔 Notifications         │ │
│ │ ⚙️ Settings              │ │
│ └──────────────────────────┘ │
│                              │
│ 🏠    🏪    📷    👥    👤   │
└──────────────────────────────┘
```

**Components:** Settings icon, Avatar (XL, editable), Name, College/Role, Stats row (points, badges, listings), Menu list (icon + label + chevron), Bottom nav bar

**States:**
- Loading: Skeleton
- Success: Full profile

**Interactions:** Tap avatar → edit photo, Tap stats → detailed view, Tap menu item → navigate, Tap settings → Settings screen

**Navigation:** → Settings, → My Listings, → Saved Items, → Transaction History, → Rewards, → Notifications

**Analytics:** `profile_view`, `profile_stats_tap`, `profile_menu_tap`, `profile_edit_photo`

**Performance Budget:**
- API calls: 1 (`GET /users/me`)
- Images: 1 avatar
- Cache: 5 minutes
- Pull-to-refresh: Yes

---

### SCR-019: Settings

| Field | Value |
|---|---|
| Module | Profile |
| Priority | P0 |
| FR Traceability | FR-060 |
| Offline Support | Cached |

**Wireframe:**

```
┌──────────────────────────────┐
│ ← Back     Settings          │
│──────────────────────────────│
│ ── Account ──────────────── │
│ Edit Profile                 │
│ Change Password              │
│ Linked Accounts              │
│                              │
│ ── Preferences ──────────── │
│ Notifications      [Toggle] │
│ Dark Mode          [Toggle] │
│ Language            English >│
│                              │
│ ── Privacy ──────────────── │
│ Profile Visibility           │
│ Data & Privacy               │
│                              │
│ ── About ────────────────── │
│ Terms of Service             │
│ Privacy Policy               │
│ App Version 1.0.0            │
│                              │
│ ── Account ──────────────── │
│ 🚪 Log Out                   │
│ 🗑️ Delete Account            │
└──────────────────────────────┘
```

**Components:** Back button, Title, Section headers, Menu items (label + chevron), Toggles (notifications, dark mode), Log out (red text), Delete account (red text)

**States:**
- Default: Settings loaded
- Toggle: Immediate save on toggle
- Log out: Confirmation dialog

**Interactions:** Tap item → navigate/toggle, Tap "Log Out" → confirmation dialog, Tap "Delete Account" → confirmation dialog (2-step)

**Navigation:** → Edit Profile, → Change Password, → Linked Accounts, → Language selector, → About pages

**Analytics:** `settings_view`, `settings_toggle`, `settings_logout`, `settings_delete_account`

**Performance Budget:**
- API calls: 1 (`GET /users/me`) + 1 on save (`PATCH /users/me`)
- Images: None
- Cache: 5 minutes

---

### SCR-020: Admin Dashboard

| Field | Value |
|---|---|
| Module | Admin |
| Priority | P1 |
| FR Traceability | FR-048, FR-049 |
| Offline Support | No |

**Wireframe:**

```
┌──────────────────────────────┐
│ Admin Dashboard              │
│──────────────────────────────│
│ ┌────────┐┌────────┐┌──────┐│
│ │ 👥     ││ 📦     ││ ⚠️   ││
│ │ 1,234  ││ 456    ││ 12   ││
│ │ Users  ││ Listings││ Reports││
│ └────────┘└────────┘└──────┘│
│                              │
│ ── Pending Reports ──────── │
│ ┌──────────────────────────┐ │
│ │ ⚠️ Spam post by user123  │ │
│ │ Reported 2h ago · View   │ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ ⚠️ Inappropriate listing │ │
│ │ Reported 5h ago · View   │ │
│ └──────────────────────────┘ │
│                              │
│ ── Recent Activity ──────── │
│ 15 new users today           │
│ 23 new listings today        │
│ 8 reports pending            │
└──────────────────────────────┘
```

**Components:** Title, Stats cards (3 columns), Report queue list, Activity summary

**States:**
- Loading: Skeleton
- Success: Dashboard data

**Interactions:** Tap stat card → detailed view, Tap report → Report Details

**Navigation:** → Report Details (tap report)

**Analytics:** `admin_dashboard_view`, `admin_report_tap`

**Performance Budget:**
- API calls: 3 (`GET /admin/stats`, `GET /admin/reports?status=pending`, `GET /admin/activity`)
- Images: None
- Cache: No (real-time data)
- Skeleton: Yes

---

## Screen Summary

| ID | Screen | Module | Priority | Offline |
|---|---|---|---|---|
| SCR-001 | Splash | Core | P0 | No |
| SCR-002 | Login | Auth | P0 | No |
| SCR-003 | Register | Auth | P0 | No |
| SCR-004 | Role Selection | Auth | P0 | No |
| SCR-005 | Profile Setup | Auth | P0 | No |
| SCR-006 | Home Dashboard | Core | P0 | Cached |
| SCR-007 | Marketplace Browse | Marketplace | P0 | Cached |
| SCR-008 | Listing Details | Marketplace | P0 | Cached |
| SCR-009 | Create Listing | Marketplace | P0 | Queued |
| SCR-010 | My Listings | Marketplace | P0 | Cached |
| SCR-011 | AI Scanner | AI | P0 | No |
| SCR-012 | Scan Result | AI | P0 | Cached |
| SCR-013 | DIY Browse | DIY | P0 | Cached |
| SCR-014 | Project Details | DIY | P0 | Cached |
| SCR-015 | Community Feed | Community | P0 | Cached |
| SCR-016 | Create Post | Community | P0 | Queued |
| SCR-017 | Notifications | Utility | P1 | Cached |
| SCR-018 | Profile | Profile | P0 | Cached |
| SCR-019 | Settings | Profile | P0 | Cached |
| SCR-020 | Admin Dashboard | Admin | P1 | No |

---

## Document Reference

This document references:
- 15_Brand_Identity.md (colors, typography, icons)
- 16_Design_System.md (components, tokens, patterns)
- 04_User_Journeys.md (analytics events, interactions)
- 05_Information_Architecture.md (navigation, offline behavior)

This document is referenced by:
- 18_Responsive_Design.md
- 19_Accessibility_Specification.md
