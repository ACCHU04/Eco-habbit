# EcoHabit — Information Architecture

**Document Reference**: PRD v1.0, Sections 6, 13.5
**Last Updated**: July 2026
**Status**: Draft

---

## Overview

This document defines the content structure, navigation model, and screen hierarchy for EcoHabit MVP.

---

## Navigation Structure

### Bottom Navigation (5 Tabs)

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│                    [Screen Content]                     │
│                                                         │
├─────────────────────────────────────────────────────────┤
│  🏠 Home  │  🛒 Market  │  📷 Scan  │  👥 Community  │  👤 Profile  │
└─────────────────────────────────────────────────────────┘
```

| Tab | Icon | Primary Screen | Badge |
|---|---|---|---|
| Home | 🏠 | Home Dashboard | — |
| Market | 🛒 | Marketplace Browse | Listing count |
| Scan | 📷 | AI Scanner | — |
| Community | 👥 | Community Feed | New posts |
| Profile | 👤 | Profile | Notifications |

### Tab Hierarchy

```
Home
├── Quick Actions
│   ├── Scan → AI Scanner
│   ├── Sell → Create Marketplace Listing
│   └── Browse → Marketplace Browse
├── Impact Stats
├── Recent Listings → Marketplace Listing Details
└── Featured DIY → DIY Project Details

Marketplace
├── Browse
│   ├── Search
│   ├── Filters
│   └── Listing Grid
├── Listing Details → Contact Seller
├── Create Listing
└── My Listings
    ├── Active
    ├── Sold
    └── Removed

Scan
├── Camera Capture
├── Gallery Upload
└── Scan Result
    ├── Disposal Suggestions
    ├── DIY Suggestions → DIY Project Details
    └── Share to Community → Create Post

Community
├── Feed
│   ├── Filter by Type
│   └── Post Cards
├── Create Post
├── Post Details
│   ├── Likes
│   └── Comments
└── Report Content

Profile
├── Info
├── My Listings
├── Purchases
├── Impact Stats
├── Points & Badges
├── Settings
│   ├── Notification Preferences
│   └── Account
└── Logout
```

---

## Screen Inventory

| # | Screen | Module | Tab | Priority | Offline Support |
|---|---|---|---|---|---|
| 1 | Splash | Core | — | P0 | No |
| 2 | Login | Auth | — | P0 | No |
| 3 | Register | Auth | — | P0 | No |
| 4 | Role Selection | Auth | — | P0 | No |
| 5 | Profile Setup | Auth | — | P0 | No |
| 6 | Home Dashboard | Core | Home | P0 | Cached |
| 7 | Marketplace Browse | Marketplace | Market | P0 | Cached |
| 8 | Marketplace Listing Details | Marketplace | Market | P0 | Cached |
| 9 | Create Marketplace Listing | Marketplace | Market | P0 | Queued |
| 10 | My Marketplace Listings | Marketplace | Profile | P0 | Cached |
| 11 | AI Scanner | AI | Scan | P0 | No |
| 12 | Scan Result | AI | Scan | P0 | Cached |
| 13 | DIY Browse | DIY | Home | P0 | Cached |
| 14 | DIY Project Details | DIY | Home | P0 | Cached |
| 15 | Community Feed | Community | Community | P0 | Cached |
| 16 | Create Post | Community | Community | P0 | Queued |
| 17 | Notifications | Notifications | Profile | P1 | Cached |
| 18 | Profile | Profile | Profile | P0 | Cached |
| 19 | Settings | Profile | Profile | P0 | Cached |
| 20 | Admin Dashboard | Admin | — | P1 | No |

---

## Screen Relationships

```
                    ┌─────────────┐
                    │   Splash    │
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │   Login     │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
       ┌──────────┐ ┌──────────┐ ┌──────────┐
       │ Register │ │  Google  │ │  Forgot  │
       └────┬─────┘ └────┬─────┘ └──────────┘
            │            │
            └─────┬──────┘
                  ▼
           ┌─────────────┐
           │Role Selection│
           └──────┬──────┘
                  │
                  ▼
           ┌─────────────┐
           │Profile Setup│
           └──────┬──────┘
                  │
                  ▼
           ┌─────────────┐
           │    Home     │◄──────────────────────┐
           │  Dashboard  │                       │
           └──────┬──────┘                       │
                  │                              │
    ┌─────────────┼─────────────┬────────────────┤
    ▼             ▼             ▼                ▼
┌────────┐  ┌──────────┐  ┌──────────┐    ┌──────────┐
│ Market │  │   Scan   │  │Community │    │ Profile  │
│ Browse │  │          │  │  Feed    │    │          │
└───┬────┘  └────┬─────┘  └────┬─────┘    └────┬─────┘
    │            │             │                │
    ▼            ▼             ▼                ▼
┌────────┐  ┌──────────┐  ┌──────────┐    ┌──────────┐
│Listing │  │Scan Result│  │Create Post│    │Settings  │
│Details │  └────┬─────┘  └──────────┘    └──────────┘
└────────┘       │
                 ▼
           ┌──────────┐
           │DIY Project│
           │ Details  │
           └──────────┘
```

---

## Content Taxonomy

### Marketplace Listing Categories

| ID | Category | Icon | Example Items |
|---|---|---|---|
| textbooks_stationery | Textbooks & Stationery | 📚 | Books, notebooks, pens |
| electronics_gadgets | Electronics & Gadgets | 💻 | Phones, chargers, headphones |
| furniture_decor | Furniture & Decor | 🪑 | Chairs, lamps, posters |
| clothing_accessories | Clothing & Accessories | 👕 | Clothes, bags, watches |
| sports_fitness | Sports & Fitness | ⚽ | Cricket bats, dumbbells, mats |
| others | Others | 📦 | Mixed items |

### Marketplace Listing Conditions

| Value | Label | Description |
|---|---|---|
| new | Like New | Unused, original packaging |
| good | Good | Minimal wear, fully functional |
| fair | Fair | Some wear, fully functional |
| used | Well Used | Visible wear, functional |

### DIY Project Categories

| Category | Description | Examples |
|---|---|---|
| Home Decor | Items for room decoration | Bottle lamps, photo frames |
| Accessories | Wearable items | Beaded bracelets, cloth bags |
| Utilities | Functional items | Phone stands, organizers |
| Art | Creative pieces | Paintings, sculptures |
| Gifts | Gift items | Handmade cards, boxes |

### DIY Difficulty Levels

| Level | Label | Time Range | Skill Required |
|---|---|---|---|
| easy | Easy | < 1 hour | Beginner |
| medium | Medium | 1-3 hours | Intermediate |
| hard | Hard | 3+ hours | Advanced |

### Waste Categories

| Category | Examples | Recycling Options |
|---|---|---|
| plastic | Bottles, containers, packaging | Recycle, upcycle |
| paper_cardboard | Books, boxes, newspapers | Recycle, compost |
| glass | Bottles, jars | Recycle |
| metal | Cans, foil, utensils | Recycle |
| organic | Food waste, leaves | Compost |
| ewaste | Electronics, batteries | Specialized recycling |
| textile | Clothes, fabric | Donate, upcycle |
| others | Mixed/uncategorized | Manual sorting |

### Post Types

| Type | Description | Content Fields |
|---|---|---|
| diy | DIY project share | content, images, diy_project_id |
| tip | Sustainability tip | content, images |
| marketplace | Marketplace Listing share | content, images, marketplace_listing_id |

### Report Reasons

| Reason | Description | Action |
|---|---|---|
| spam | Unwanted commercial content | Remove |
| inappropriate | Offensive or harmful content | Remove + warn |
| scam | Fraudulent listing or post | Remove + ban |
| other | Other violation | Review |

### Badge Types

| Badge | Requirement | Points |
|---|---|---|
| first_sale | Complete first sale | 50 |
| recycler | Recycle 10 items | 200 |
| creator | Complete 5 DIY projects | 200 |
| community_star | Get 50 likes on posts | 150 |
| campus_champion | Top 10 leaderboard | 100 |
| eco_warrior | Save 100kg CO2 | 300 |

---

## Search Architecture

### Searchable Entities

| Entity | Searchable Fields | Filters | Sort Options |
|---|---|---|---|
| Marketplace Listings | title, description | category, price, condition | date, price |
| DIY Projects | title, description, materials | difficulty, category | date, difficulty |
| Community Posts | content | post_type | date, likes |
| Users | name, college | role | — |

### Search Result Ranking

| Entity | Primary Sort | Secondary Sort | Limit |
|---|---|---|---|
| Marketplace Listings | relevance | date (newest) | 20 |
| DIY Projects | relevance | difficulty | 20 |
| Community Posts | date (newest) | likes | 20 |

### Search Filters

**Marketplace Filters**:
```
├── Category (multi-select)
│   ├── Textbooks & Stationery
│   ├── Electronics & Gadgets
│   ├── Furniture & Decor
│   ├── Clothing & Accessories
│   ├── Sports & Fitness
│   └── Others
├── Price Range (slider)
│   ├── Min: ₹0
│   └── Max: ₹10,000
├── Condition (multi-select)
│   ├── Like New
│   ├── Good
│   ├── Fair
│   └── Well Used
└── Sort By
    ├── Newest First
    ├── Price: Low to High
    └── Price: High to Low
```

---

## Notification Architecture

### Notification Types

| Type | Trigger | Channel | Priority |
|---|---|---|---|
| like_comment | Someone likes/comments on your post | Push + In-app | High |
| marketplace_inquiry | Someone messages about your listing | Push + In-app | High |
| reward_achievement | You earn a badge or milestone | Push + In-app | Medium |
| community_update | New posts in followed topics | In-app | Low |

### Notification Preferences

| Type | Default | User Toggle | Push |
|---|---|---|---|
| like_comment | On | Yes | Yes |
| marketplace_inquiry | On | Yes | Yes |
| reward_achievement | On | Yes | Yes |
| community_update | Off | Yes | No |

### Notification Payload

```json
{
  "id": "uuid",
  "user_id": "uuid",
  "type": "like_comment",
  "title": "New like on your post",
  "body": "Aisha liked your post about bottle planters",
  "data": {
    "post_id": "uuid",
    "actor_name": "Aisha",
    "actor_avatar": "url"
  },
  "read_at": null,
  "created_at": "2026-07-23T10:00:00Z"
}
```

---

## Accessibility Considerations

### WCAG 2.1 AA Compliance

| Requirement | Implementation | Priority |
|---|---|---|
| Color contrast | 4.5:1 minimum for text | P0 |
| Touch targets | 44x44px minimum | P0 |
| Screen reader | Semantic labels on all interactive elements | P0 |
| Keyboard navigation | Tab order follows visual flow | P1 |
| Text scaling | Support up to 200% zoom | P1 |
| Motion | Respect "Reduce Motion" system setting | P1 |

### Screen-Specific Accessibility

| Screen | Considerations |
|---|---|
| Marketplace Browse | Alt text for all listing images, price announced |
| AI Scanner | Voice feedback for classification results |
| Community Feed | ARIA labels for post interactions, like/comment counts announced |
| Profile | Focus management for form fields, error announcements |
| DIY Project | Step numbers announced, video captions required |

### Color System

| Element | Color | Contrast Ratio |
|---|---|---|
| Primary text | #1A1A1A on #FFFFFF | 16.75:1 ✓ |
| Secondary text | #6B7280 on #FFFFFF | 4.63:1 ✓ |
| Primary button | #FFFFFF on #10B981 | 4.56:1 ✓ |
| Error text | #DC2626 on #FFFFFF | 4.63:1 ✓ |
| Success text | #059669 on #FFFFFF | 4.53:1 ✓ |

### Screen Reader Announcements

| Element | Announcement |
|---|---|
| Listing card | "{title}, {price}, {condition}" |
| Like button | "Like, {count} likes" |
| Comment button | "Comment, {count} comments" |
| Badge | "{badge name}, earned {date}" |
| Navigation tab | "{tab name}, {unread count} new" |

---

## Offline Behavior Matrix

| Screen | Offline Behavior | Data Source |
|---|---|---|
| Home Dashboard | Show cached stats + listings | Local cache |
| Marketplace Browse | Show cached listings | Local cache |
| Marketplace Listing Details | Show cached details | Local cache |
| Create Marketplace Listing | Queue for sync | Local storage |
| AI Scanner | Show "Internet required" | — |
| Scan Result | Show cached results | Local cache |
| DIY Browse | Show cached projects | Local cache |
| DIY Project Details | Show cached details | Local cache |
| Community Feed | Show cached posts | Local cache |
| Create Post | Queue for sync | Local storage |
| Profile | Show cached profile | Local cache |
| Settings | Show cached preferences | Local storage |

### Sync Strategy

```
┌─────────────────┐
│ App Launched    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Check Network   │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────┐
│ Online  │ │ Offline     │
│ Sync    │ │ Use Cache   │
│ Queue   │ │             │
└─────────┘ └─────────────┘
```

---

## Document Reference

This document references:
- PRD v1.0, Sections 6, 13.5
- 04_User_Journeys.md
- 03_User_Personas.md

This document is referenced by:
- 08_Database_Design.md
- 09_API_Specification.md
