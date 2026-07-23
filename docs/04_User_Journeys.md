# EcoHabit — User Journeys

**Document Reference**: PRD v1.0, Section 11
**Last Updated**: July 2026
**Status**: Draft

---

## Overview

This document defines the primary user flows for EcoHabit MVP. Each journey maps user actions to screens, features, and functional requirements.

| # | Journey | Entry Point | Exit Point | Primary Persona |
|---|---|---|---|---|
| 1 | Registration | App Launch | Home Dashboard | All |
| 2 | Buy Marketplace Listing | Home Dashboard | Contact Seller | Rahul |
| 3 | Sell Marketplace Listing | Home Dashboard | Listing Published | Aisha |
| 4 | AI Scan | Home Dashboard | Scan Result | All |
| 5 | DIY Project | Home Dashboard / Scan | Community Feed | Rahul |
| 6 | Community Post | Home Dashboard | Post Published | Priya |
| 7 | Report Content | Any Content | Report Submitted | Priya |

---

## Journey 1: Registration Flow

### Entry Point
App Launch (first time)

### Primary Persona
All users

### Flow
```
┌─────────────┐
│  App Launch  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Splash Screen│
└──────┬──────┘
       │
       ▼
┌─────────────┐     ┌─────────────────┐
│ Login Screen │────▶│ Email Register  │
└──────┬──────┘     └────────┬────────┘
       │                     │
       │     ┌───────────────┘
       │     │
       │     ▼
       │  ┌─────────────────┐
       │  │ Google Sign-In  │
       │  └────────┬────────┘
       │           │
       ▼           ▼
┌─────────────────────────┐
│   Role Selection        │
│ (Student/NGO/Org)       │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│   Profile Setup         │
│ (Name, College, Photo)  │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│   Home Dashboard        │
└─────────────────────────┘
```

### Decision Points
- **Email vs Google**: User chooses registration method
- **Role Selection**: User selects Student, NGO, or Organization

### Edge Cases
| Error | Recovery |
|---|---|
| Google Sign-In fails | Show error message, offer retry or email registration |
| Network timeout | Show "Connection lost" with retry button |
| Email already registered | Show "Account exists" with login option |
| User skips profile setup | Require at minimum name and college |

### Error Recovery Flow
```
┌─────────────────┐
│ Google Sign-In  │
│ Fails           │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Show Error      │
│ "Sign-in failed"│
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────┐
│ Retry   │ │ Use Email   │
└─────────┘ │ Instead     │
            └─────────────┘
```

### Analytics Events
| Step | Event Name | Properties |
|---|---|---|
| App launched | app_launched | source (fresh/returning) |
| Login screen viewed | login_screen_viewed | — |
| Email registration started | registration_started | method (email) |
| Google sign-in started | registration_started | method (google) |
| Registration completed | registration_completed | method, role |
| Profile setup completed | profile_setup_completed | role, college |

### FR References
FR-001, FR-002, FR-003, FR-004, FR-006

### Success Criteria
AC-001, AC-002, AC-003, AC-004, AC-005

---

## Journey 2: Buy Marketplace Listing Flow

### Entry Point
Home Dashboard

### Primary Persona
Rahul (Budget Buyer)

### Flow
```
┌─────────────────┐
│ Home Dashboard  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Browse Marketplace│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Search/Filter   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ View Listing    │
│ Details         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Contact Seller  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Complete Trade  │
│ (Offline)       │
└─────────────────┘
```

### Decision Points
- **Search vs Browse**: User searches or browses categories
- **Filter**: User applies category, price, condition filters
- **Contact Method**: User chooses to contact via displayed info

### Edge Cases
| Error | Recovery |
|---|---|
| No search results | Show "No listings found" with suggestions to broaden filters |
| Seller not responsive | Show "Try again later" + alternative contact options |
| Listing already sold | Show "Sold" status + suggest similar items |
| Network failure | Show cached results if available, otherwise error |
| Image fails to load | Show placeholder image |

### Error Recovery Flow
```
┌─────────────────┐
│ Search Results  │
│ Empty           │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ "No results     │
│  found"         │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────┐
│ Broaden │ │ Browse      │
│ Filters │ │ Categories  │
└─────────┘ └─────────────┘
```

### Analytics Events
| Step | Event Name | Properties |
|---|---|---|
| Marketplace viewed | marketplace_viewed | — |
| Search performed | marketplace_searched | query, filters |
| Listing viewed | marketplace_listing_viewed | listing_id, category, price |
| Seller contacted | marketplace_seller_contacted | listing_id, contact_method |
| Trade completed | marketplace_trade_completed | listing_id, price, category |

### FR References
FR-013, FR-014, FR-015, FR-016, FR-017, FR-018, FR-019

### Success Criteria
AC-008, AC-009, AC-010, AC-011

---

## Journey 3: Sell Marketplace Listing Flow

### Entry Point
Home Dashboard (Quick Action: Sell)

### Primary Persona
Aisha (Sustainable Seller)

### Flow
```
┌─────────────────┐
│ Home Dashboard  │
└────────┬────────┘
         │
         │ Tap "Sell"
         ▼
┌─────────────────┐
│ Create Listing  │
│ - Title         │
│ - Description   │
│ - Price         │
│ - Category      │
│ - Condition     │
│ - Images (1-5)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Preview Listing │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Publish         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Listing Live    │
│ Receive Inquiries│
└─────────────────┘
```

### Decision Points
- **Category**: User selects from 6 categories
- **Condition**: User selects new/good/fair/used
- **Images**: User uploads 1-5 images

### Edge Cases
| Error | Recovery |
|---|---|
| Image upload fails | Retry option, show upload progress |
| Missing required fields | Show validation errors inline |
| Price too high/low | Show warning but allow |
| Network failure | Save draft locally, retry when online |
| Image too large | Auto-compress or show size limit |

### Error Recovery Flow
```
┌─────────────────┐
│ Image Upload    │
│ Fails           │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Show Error      │
│ "Upload failed" │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────┐
│ Retry   │ │ Skip Image  │
│ Upload  │ │ (continue   │
│         │ │  without)   │
└─────────┘ └─────────────┘
```

### Analytics Events
| Step | Event Name | Properties |
|---|---|---|
| Create listing started | listing_create_started | — |
| Image uploaded | listing_image_uploaded | image_count |
| Category selected | listing_category_selected | category |
| Listing previewed | listing_previewed | — |
| Listing published | listing_published | category, price, condition |

### FR References
FR-011, FR-012, FR-020, FR-021, FR-022

### Success Criteria
AC-006, AC-007, AC-012

---

## Journey 4: AI Scan Flow

### Entry Point
Home Dashboard (Quick Action: Scan)

### Primary Persona
All users

### Flow
```
┌─────────────────┐
│ Home Dashboard  │
└────────┬────────┘
         │
         │ Tap "Scan"
         ▼
┌─────────────────┐     ┌─────────────────┐
│ AI Scanner      │────▶│ Camera Capture  │
└────────┬────────┘     └────────┬────────┘
         │                       │
         │     ┌─────────────────┘
         │     │
         │     ▼
         │  ┌─────────────────┐
         │  │ Gallery Upload  │
         │  └────────┬────────┘
         │           │
         ▼           ▼
┌─────────────────────────┐
│ AI Classification       │
│ (Cloud Processing)      │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│ Scan Result             │
│ - Material Type         │
│ - Confidence Score      │
│ - Disposal Suggestions  │
│ - DIY Suggestions       │
└──────────┬──────────────┘
           │
     ┌─────┴─────┐
     │           │
     ▼           ▼
┌─────────┐ ┌─────────────┐
│ Save    │ │ Share to    │
│ Result  │ │ Community   │
└─────────┘ └─────────────┘
```

### Decision Points
- **Camera vs Gallery**: User chooses input method
- **Save vs Share**: User decides what to do with result

### Edge Cases
| Error | Recovery |
|---|---|
| Classification confidence < 80% | Show "Uncertain" with manual category option |
| AI service unavailable | Show error, suggest retry later |
| Image too large | Auto-compress or reject with message |
| Camera permission denied | Show settings prompt |
| Gallery permission denied | Show settings prompt |
| Poor image quality | Show "Image unclear" with retake option |

### Error Recovery Flow
```
┌─────────────────┐
│ Classification  │
│ Confidence < 80%│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ "Uncertain      │
│  Classification"│
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────┐
│ Accept  │ │ Manual      │
│ Result  │ │ Category    │
│ anyway  │ │ Selection   │
└─────────┘ └─────────────┘
```

### Analytics Events
| Step | Event Name | Properties |
|---|---|---|
| Scanner opened | scanner_opened | input_method (camera/gallery) |
| Image captured | scanner_image_captured | source |
| Classification started | scanner_classification_started | — |
| Classification completed | scanner_classification_completed | classification, confidence |
| Low confidence shown | scanner_low_confidence | confidence |
| Result saved | scanner_result_saved | classification |
| Result shared | scanner_result_shared | classification |

### FR References
FR-023, FR-024, FR-025, FR-026, FR-027, FR-028, FR-029

### Success Criteria
AC-013, AC-014, AC-015, AC-016, AC-017, AC-018

---

## Journey 5: DIY Project Flow

### Entry Point
Home Dashboard or AI Scan Result

### Primary Persona
Rahul (Budget Buyer)

### Flow
```
┌─────────────────┐
│ Entry Point     │
│ (Dashboard/Scan)│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Browse DIY      │
│ Projects        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ View Project    │
│ Details         │
│ - Materials     │
│ - Steps         │
│ - Difficulty    │
│ - Video         │
│ - Price         │
└────────┬────────┘
         │
     ┌───┴───┐
     │       │
     ▼       ▼
┌─────────┐ ┌─────────────┐
│ Save    │ │ Start       │
│ Project │ │ Project     │
└─────────┘ └──────┬──────┘
                   │
                   ▼
            ┌─────────────┐
            │ Complete    │
            │ Project     │
            └──────┬──────┘
                   │
                   ▼
            ┌─────────────┐
            │ Share to    │
            │ Community   │
            └─────────────┘
```

### Decision Points
- **Browse vs Search**: User explores or searches for specific projects
- **Save vs Start**: User bookmarks or begins project
- **Share**: User shares completed project to community

### Edge Cases
| Error | Recovery |
|---|---|
| No matching DIY projects | Show AI-generated suggestions |
| Video unavailable | Show "Video not available" message |
| Project too difficult | Show difficulty rating prominently |
| Steps unclear | Show "Need help?" with community link |

### Error Recovery Flow
```
┌─────────────────┐
│ Video Load      │
│ Fails           │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ "Video not      │
│  available"     │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────┐
│ View    │ │ Search      │
│ Written │ │ YouTube     │
│ Steps   │ │ Directly    │
└─────────┘ └─────────────┘
```

### Analytics Events
| Step | Event Name | Properties |
|---|---|---|
| DIY browse opened | diy_browse_opened | — |
| DIY project viewed | diy_project_viewed | project_id, difficulty |
| DIY project saved | diy_project_saved | project_id |
| DIY project started | diy_project_started | project_id |
| DIY project completed | diy_project_completed | project_id |
| DIY project shared | diy_project_shared | project_id |

### FR References
FR-031, FR-032, FR-033, FR-034, FR-035, FR-036

### Success Criteria
AC-019, AC-020, AC-021, AC-022

---

## Journey 6: Community Post Flow

### Entry Point
Home Dashboard

### Primary Persona
Priya (NGO Coordinator)

### Flow
```
┌─────────────────┐
│ Home Dashboard  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Community Feed  │
└────────┬────────┘
         │
         │ Tap "Create Post"
         ▼
┌─────────────────┐
│ Select Post Type│
│ - DIY Project   │
│ - Tip           │
│ - Marketplace   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Add Content     │
│ - Text          │
│ - Images        │
│ - Link (opt)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Publish Post    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Post Live       │
│ Receive Likes/  │
│ Comments        │
└─────────────────┘
```

### Decision Points
- **Post Type**: User selects DIY, Tip, or Marketplace
- **Content**: User adds text, images, optional links

### Edge Cases
| Error | Recovery |
|---|---|
| Image upload fails | Retry option |
| Post flagged by system | Show moderation warning |
| No posts in feed | Show "No posts yet" with create prompt |
| Content too long | Show character count and limit |

### Error Recovery Flow
```
┌─────────────────┐
│ Post Flagged    │
│ by System       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ "Your post      │
│  needs review"  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Post Pending    │
│ Admin Review    │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────┐
│ Approved│ │ Rejected    │
│ Published│ │ Edit &     │
│         │ │ Resubmit    │
└─────────┘ └─────────────┘
```

### Analytics Events
| Step | Event Name | Properties |
|---|---|---|
| Community feed viewed | community_feed_viewed | — |
| Create post started | community_post_started | post_type |
| Post type selected | community_post_type_selected | post_type |
| Image uploaded | community_post_image_uploaded | image_count |
| Post published | community_post_published | post_type |
| Post liked | community_post_liked | post_id, post_type |
| Post commented | community_post_commented | post_id, post_type |

### FR References
FR-037, FR-038, FR-039, FR-040, FR-041, FR-042, FR-043

### Success Criteria
AC-023, AC-024, AC-025, AC-026

---

## Journey 7: Report Content Flow

### Entry Point
Any content (Marketplace Listing, Post, Comment)

### Primary Persona
Priya (NGO Coordinator)

### Flow
```
┌─────────────────┐
│ View Content    │
└────────┬────────┘
         │
         │ Tap "Report"
         ▼
┌─────────────────┐
│ Select Reason   │
│ - Spam          │
│ - Inappropriate │
│ - Scam          │
│ - Other         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Add Description │
│ (Optional)      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Submit Report   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Confirmation    │
│ "Report submitted"│
└─────────────────┘
         │
         ▼
┌─────────────────┐
│ Admin Reviews   │
│ Takes Action    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Reporter        │
│ Notified        │
└─────────────────┘
```

### Decision Points
- **Reason**: User selects from 4 report reasons
- **Description**: User optionally adds details

### Edge Cases
| Error | Recovery |
|---|---|
| Already reported by user | Show "Already reported" message |
| Content removed before report | Show "Content no longer available" |
| Report submission fails | Retry option |
| Network failure | Queue report for later submission |

### Error Recovery Flow
```
┌─────────────────┐
│ Report Already  │
│ Submitted       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ "You've already │
│  reported this" │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ View Previous   │
│ Report Status   │
└─────────────────┘
```

### Analytics Events
| Step | Event Name | Properties |
|---|---|---|
| Report initiated | report_initiated | content_type, content_id |
| Report reason selected | report_reason_selected | reason |
| Report submitted | report_submitted | content_type, reason |
| Report resolved | report_resolved | action_taken |

### FR References
FR-044, FR-045, FR-046, FR-047

### Success Criteria
AC-027

---

## Journey-to-Screen Mapping

| Journey | Screens Involved |
|---|---|
| Registration | Splash, Login, Register, Role Selection, Profile Setup, Home |
| Buy Marketplace Listing | Home, Marketplace Browse, Marketplace Listing Details |
| Sell Marketplace Listing | Home, Create Marketplace Listing, My Marketplace Listings |
| AI Scan | Home, AI Scanner, Scan Result |
| DIY Project | Home, DIY Browse, DIY Project Details, Create Post |
| Community Post | Home, Community Feed, Create Post |
| Report Content | Any Screen, Report Form, Confirmation |

---

## Journey-to-FR Mapping Summary

| Journey | FRs Exercised |
|---|---|
| Registration | FR-001, FR-002, FR-003, FR-004, FR-006 |
| Buy Marketplace Listing | FR-013, FR-014, FR-015, FR-016, FR-017, FR-018, FR-019 |
| Sell Marketplace Listing | FR-011, FR-012, FR-020, FR-021, FR-022 |
| AI Scan | FR-023, FR-024, FR-025, FR-026, FR-027, FR-028, FR-029 |
| DIY Project | FR-031, FR-032, FR-033, FR-034, FR-035, FR-036 |
| Community Post | FR-037, FR-038, FR-039, FR-040, FR-041, FR-042, FR-043 |
| Report Content | FR-044, FR-045, FR-046, FR-047 |

---

## Document Reference

This document references:
- PRD v1.0, Section 11 (User Journeys)
- 03_User_Personas.md
- PRD v1.0, Section 12 (Acceptance Criteria)

This document is referenced by:
- 05_Information_Architecture.md
- 09_API_Specification.md
