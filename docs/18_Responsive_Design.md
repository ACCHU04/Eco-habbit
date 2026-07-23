# EcoHabit Responsive Design

> **Document Version:** 1.0
> **Last Updated:** July 2026
> **Status:** Active

---

## Overview

EcoHabit is a mobile-first application. The MVP targets phones (320px–428px width). This document defines how the UI adapts to larger screens (tablets, desktop) for future-proofing without designing every screen twice.

---

## 1. Breakpoints

| Name | Width Range | Device Examples | Layout Strategy |
|---|---|---|---|
| `mobile` | 0–599px | Phones (iPhone SE to iPhone 15 Pro Max) | Single column, bottom nav |
| `tablet` | 600–1024px | iPad Mini to iPad Pro, small tablets | Two columns, navigation rail |
| `desktop` | 1025px+ | Web browser, large screens | Three columns, side nav |

**Implementation:** Use `LayoutBuilder` in Flutter with `eco.breakpoint.*` tokens.

```dart
enum Breakpoint { mobile, tablet, desktop }

Breakpoint getBreakpoint(double width) {
  if (width >= 1025) return Breakpoint.desktop;
  if (width >= 600) return Breakpoint.tablet;
  return Breakpoint.mobile;
}
```

---

## 2. Grid System

| Breakpoint | Columns | Gutter | Margin |
|---|---|---|---|
| Mobile | 4 | 16px | 16px |
| Tablet | 8 | 24px | 32px |
| Desktop | 12 | 24px | 48px |

**Column Width Formula:**
```
columnWidth = (screenWidth - (2 × margin) - ((columns - 1) × gutter)) / columns
```

**Examples:**

| Screen | Width | Columns | Column Width |
|---|---|---|---|
| iPhone 14 | 390px | 4 | 74.5px |
| iPad Mini | 768px | 8 | 64px |
| iPad Pro 12.9" | 1024px | 8 | 96px |
| Desktop browser | 1440px | 12 | 90px |

---

## 3. Navigation Adaptation

### 3.1 Mobile (< 600px)

```
┌──────────────────────┐
│       Content        │
│                      │
│                      │
│                      │
│──────────────────────│
│ 🏠  🏪  📷  👥  👤  │  ← Bottom Navigation Bar
└──────────────────────┘
```

- Bottom navigation bar (5 tabs)
- App bar at top
- Full-width content

### 3.2 Tablet (600–1024px)

```
┌────┬─────────────────┐
│ 🏠 │                 │
│ 🏪 │     Content     │
│ 📷 │                 │
│ 👥 │                 │
│ 👤 │                 │
└────┴─────────────────┘
```

- Navigation rail (left side, 72px wide)
- Icons only (no labels)
- Content fills remaining width
- App bar extends full width

### 3.3 Desktop (> 1024px)

```
┌──────┬──────────────────────────┐
│      │                          │
│ 🏠   │        Content           │
│ Home │                          │
│      │                          │
│ 🏪   │                          │
│Market│                          │
│      │                          │
│ 📷   │                          │
│ Scan │                          │
│      │                          │
│ 👥   │                          │
│ Comm │                          │
│      │                          │
│ 👤   │                          │
│ Prof │                          │
└──────┴──────────────────────────┘
```

- Navigation drawer (left side, 256px wide)
- Icons + labels
- Content fills remaining width
- App bar extends full width

---

## 4. Layout Adaptation Rules

### 4.1 Content Width

| Breakpoint | Max Content Width | Behavior |
|---|---|---|
| Mobile | 100% (full width) | Edge-to-edge with 16px padding |
| Tablet | 100% (of remaining space) | Content area with consistent padding |
| Desktop | 100% (of remaining space) | Content area with consistent padding, optional max-width |

### 4.2 Card Grid Layout

| Breakpoint | Columns | Card Width | Aspect Ratio |
|---|---|---|---|
| Mobile | 1 | Full width | Varies |
| Tablet | 2 | (Container - gutter) / 2 | 4:3 |
| Desktop | 3 | (Container - 2×gutter) / 3 | 4:3 |

### 4.3 List Layout

| Breakpoint | Behavior |
|---|---|
| Mobile | Full-width list tiles |
| Tablet | Centered list with max-width 600px |
| Desktop | Centered list with max-width 600px |

### 4.4 Detail Screen Layout

| Breakpoint | Behavior |
|---|---|
| Mobile | Full-width, stacked vertically |
| Tablet | Two-column: media left (50%), details right (50%) |
| Desktop | Two-column: media left (40%), details right (60%), max-width 960px |

---

## 5. Typography Scaling

| Breakpoint | Adjustment |
|---|---|
| Mobile | Base sizes as defined in Design System |
| Tablet | Increase body text by 1px (bodyLarge: 17px, bodyMedium: 15px) |
| Desktop | Increase body text by 2px (bodyLarge: 18px, bodyMedium: 16px) |

**Note:** Display and headline sizes remain the same across breakpoints. Only body and label text scales.

---

## 6. Image Sizing

| Breakpoint | Listing Image | Post Image | Avatar | Max Upload |
|---|---|---|---|---|
| Mobile | 100% width, 4:3 | 100% width, 1:1 | 40px | 1200px |
| Tablet | 50% width, 4:3 | 50% width, 1:1 | 48px | 1600px |
| Desktop | 33% width, 4:3 | 33% width, 1:1 | 56px | 1600px |

**Lazy Loading:** Images below the fold load on scroll at all breakpoints.

---

## 7. Spacing Adjustments

| Breakpoint | Multiplier | Base | Effect |
|---|---|---|---|
| Mobile | 1.0× | 4px | Standard spacing |
| Tablet | 1.25× | 5px | Slightly more breathing room |
| Desktop | 1.5× | 6px | More spacious layout |

**Applied to:** Section spacing, card padding, list item padding. Not applied to tight spacing (xxs, xs).

---

## 8. Component Adaptations

### 8.1 Bottom Navigation → Rail → Drawer

| Breakpoint | Component | Width | Behavior |
|---|---|---|---|
| Mobile | Bottom nav bar | Full width, 80px height | 5 tabs with labels |
| Tablet | Navigation rail | 72px width | Icons only, selected indicator |
| Desktop | Navigation drawer | 256px width | Icons + labels, always visible |

### 8.2 App Bar

| Breakpoint | Behavior |
|---|---|
| Mobile | Standard app bar with back button |
| Tablet | Same, but with more horizontal padding |
| Desktop | Same, with optional breadcrumbs |

### 8.3 Dialogs

| Breakpoint | Behavior |
|---|---|
| Mobile | Full-screen or bottom sheet |
| Tablet | Centered dialog, max-width 400px |
| Desktop | Centered dialog, max-width 400px |

### 8.4 Bottom Sheets

| Breakpoint | Behavior |
|---|---|
| Mobile | Full-width bottom sheet |
| Tablet | Side sheet (right side, 400px width) |
| Desktop | Side sheet (right side, 400px width) |

### 8.5 Search Bar

| Breakpoint | Behavior |
|---|---|
| Mobile | Full width, collapsible on scroll |
| Tablet | Full width of content area |
| Desktop | Full width of content area, optional persistent expand |

### 8.6 Image Carousel

| Breakpoint | Behavior |
|---|---|
| Mobile | Full-width swipe carousel |
| Tablet | 60% width carousel with thumbnails on right |
| Desktop | 50% width carousel with thumbnails on right |

---

## 9. Platform-Specific Considerations

### 9.1 Web (Desktop)

| Consideration | Implementation |
|---|---|
| URL routing | Deep links map to routes (`/marketplace/123`) |
| Browser back button | Supported via `go_router` |
| Right-click context menu | Disabled on interactive elements |
| Hover states | Add hover effects for mouse users |
| Keyboard shortcuts | Ctrl+K for search, Escape to close |

### 9.2 iPad (Tablet)

| Consideration | Implementation |
|---|---|
| Split view | Support multitasking (33%, 50%, 67%) |
| Stage Manager | Adapt to dynamic window sizes |
| Apple Pencil | No special handling (standard touch) |
| Keyboard shortcuts | Basic support (Cmd+Z undo) |

### 9.3 Android Tablets

| Consideration | Implementation |
|---|---|
| Freeform window | Adapt to any window size |
| Split screen | Support split-screen mode |
| Foldable devices | Handle hinge area, fold/unfold transitions |

---

## 10. Responsive Patterns by Screen

| Screen | Mobile | Tablet | Desktop |
|---|---|---|---|
| Splash | Full screen | Centered card | Centered card |
| Login | Full screen | Centered card (400px) | Centered card (400px) |
| Home | Single column | Two columns | Three columns |
| Marketplace | Single column list | 2-column grid | 3-column grid |
| Listing Details | Stacked | Side-by-side (50/50) | Side-by-side (40/60) |
| Create Listing | Full width form | Centered form (600px) | Centered form (600px) |
| AI Scanner | Full screen camera | Centered viewfinder | Centered viewfinder |
| Scan Result | Stacked | Side-by-side | Side-by-side |
| Community | Single column | 2-column feed | 3-column feed |
| Profile | Stacked | Side-by-side | Side-by-side |
| Admin | Stacked cards | 2-column grid | 3-column grid + sidebar |

---

## Document Reference

This document references:
- 16_Design_System.md (breakpoint tokens, spacing, grid)
- 17_Screen_Specifications.md (screen layouts)

This document is referenced by:
- 19_Accessibility_Specification.md
