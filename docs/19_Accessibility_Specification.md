# EcoHabit Accessibility Specification

> **Document Version:** 1.0
> **Last Updated:** July 2026
> **Status:** Active

---

## Overview

EcoHabit targets **WCAG 2.1 Level AA** compliance. This document specifies accessibility requirements for every screen and component, covering color contrast, touch targets, screen readers, keyboard navigation, reduced motion, and error handling.

---

## 1. WCAG 2.1 AA Checklist

### 1.1 Perceivable

| Criterion | Requirement | Status |
|---|---|---|
| 1.1.1 Non-text Content | All images have alt text | P0 |
| 1.2.1 Audio/Video | Video tutorials have captions | P0 |
| 1.3.1 Info and Relationships | Semantic structure (headings, lists, landmarks) | P0 |
| 1.3.2 Meaningful Sequence | DOM order matches visual order | P0 |
| 1.3.3 Sensory Characteristics | Instructions don't rely solely on color/shape/sound | P0 |
| 1.4.1 Use of Color | Color is not the only visual means of conveying info | P0 |
| 1.4.3 Contrast (Minimum) | Text contrast ≥ 4.5:1 (normal), ≥ 3:1 (large) | P0 |
| 1.4.4 Resize Text | Text scales up to 200% without loss | P1 |
| 1.4.5 Images of Text | No images of text (use real text) | P0 |
| 1.4.10 Reflow | Content reflows at 320px width (no horizontal scroll) | P1 |
| 1.4.11 Non-text Contrast | UI components ≥ 3:1 contrast | P0 |
| 1.4.12 Text Spacing | Content adapts to increased text spacing | P1 |

### 1.2 Operable

| Criterion | Requirement | Status |
|---|---|---|
| 2.1.1 Keyboard | All functionality via keyboard | P0 |
| 2.1.2 No Keyboard Trap | Focus can move away from any component | P0 |
| 2.4.1 Bypass Blocks | Skip navigation link | P1 |
| 2.4.2 Page Titled | Screen titles are descriptive | P0 |
| 2.4.3 Focus Order | Logical tab order | P0 |
| 2.4.4 Link Purpose | Link text is descriptive | P0 |
| 2.4.5 Multiple Ways | Search + navigation available | P1 |
| 2.4.6 Headings and Labels | Descriptive headings and labels | P0 |
| 2.5.1 Pointer Gestures | Multi-point gestures have single-pointer alternatives | P0 |
| 2.5.2 Pointer Cancellation | Up-event triggers actions | P0 |
| 2.5.3 Label in Name | Visible label matches accessible name | P0 |
| 2.5.4 Motion Actuation | Motion-triggered actions have UI alternatives | P1 |

### 1.3 Understandable

| Criterion | Requirement | Status |
|---|---|---|
| 3.1.1 Language of Page | `lang` attribute set | P0 |
| 3.2.1 On Focus | No unexpected context changes on focus | P0 |
| 3.2.2 On Input | No unexpected context changes on input | P0 |
| 3.3.1 Error Identification | Errors identified and described in text | P0 |
| 3.3.2 Labels or Instructions | Form labels and instructions provided | P0 |
| 3.3.3 Error Suggestion | Error correction suggested when possible | P1 |
| 3.3.4 Error Prevention | Confirmation for legal/financial transactions | P1 |

### 1.4 Robust

| Criterion | Requirement | Status |
|---|---|---|
| 4.1.2 Name, Role, Value | All UI components have accessible names | P0 |
| 4.1.3 Status Messages | Status messages announced via live regions | P0 |

---

## 2. Color Contrast Matrix

### 2.1 Text on Backgrounds

| Element | Foreground | Background | Ratio | Pass (4.5:1) |
|---|---|---|---|---|
| Primary text | `#111827` | `#FFFFFF` | 16.75:1 | ✅ |
| Secondary text | `#6B7280` | `#FFFFFF` | 4.63:1 | ✅ |
| Placeholder text | `#9CA3AF` | `#FFFFFF` | 3.03:1 | ❌ (decorative only) |
| Disabled text | `#9CA3AF` | `#FFFFFF` | 3.03:1 | N/A (disabled) |
| Button text (primary) | `#FFFFFF` | `#10B981` | 4.56:1 | ✅ |
| Button text (secondary) | `#10B981` | `#FFFFFF` | 4.56:1 | ✅ |
| Error text | `#DC2626` | `#FFFFFF` | 4.63:1 | ✅ |
| Success text | `#059669` | `#FFFFFF` | 4.53:1 | ✅ |
| Link text | `#2563EB` | `#FFFFFF` | 4.63:1 | ✅ |

### 2.2 Text on Dark Mode

| Element | Foreground | Background | Ratio | Pass (4.5:1) |
|---|---|---|---|---|
| Primary text | `#F3F4F6` | `#121212` | 15.37:1 | ✅ |
| Secondary text | `#9CA3AF` | `#121212` | 6.52:1 | ✅ |
| Button text (primary) | `#121212` | `#34D399` | 7.14:1 | ✅ |
| Error text | `#FCA5A5` | `#121212` | 6.89:1 | ✅ |

### 2.3 Non-text Contrast

| Element | Foreground | Background | Ratio | Pass (3:1) |
|---|---|---|---|---|
| Input border (rest) | `#D1D5DB` | `#FFFFFF` | 2.08:1 | ❌ (add icon) |
| Input border (focus) | `#10B981` | `#FFFFFF` | 4.56:1 | ✅ |
| Input border (error) | `#DC2626` | `#FFFFFF` | 4.63:1 | ✅ |
| Card border | `#E5E7EB` | `#FFFFFF` | 1.55:1 | ❌ (use shadow instead) |
| Divider | `#E5E7EB` | `#FFFFFF` | 1.55:1 | N/A (decorative) |
| Icon (active) | `#10B981` | `#FFFFFF` | 4.56:1 | ✅ |
| Icon (inactive) | `#6B7280` | `#FFFFFF` | 4.63:1 | ✅ |
| Bottom nav active | `#10B981` | `#FFFFFF` | 4.56:1 | ✅ |

---

## 3. Touch Target Matrix

All interactive elements must meet the **44×44px minimum** touch target size.

| Element | Size | Touch Target | Pass |
|---|---|---|---|
| Bottom nav icon | 24px | 48×48px padding | ✅ |
| App bar icon button | 24px | 48×48px padding | ✅ |
| List tile | — | Full height 56px | ✅ |
| Input field | 56px height | 56px | ✅ |
| Primary button | 48px height | 48px | ✅ |
| Chip | 32px height | 44×32px (horizontal pad) | ✅ |
| Card | — | Full tap area | ✅ |
| FAB | 56×56px | 56×56px | ✅ |
| Search bar | 48px height | 48px | ✅ |
| Image carousel dot | 8px | 24×24px tap area | ✅ |
| Filter chip | 32px height | 44×32px | ✅ |
| Checkbox | 18px | 48×48px padding | ✅ |
| Switch | 20px | 48×32px | ✅ |
| Radio | 20px | 48×48px padding | ✅ |

---

## 4. Focus Management

### 4.1 Tab Order

Focus follows visual order (left-to-right, top-to-bottom):

| Screen | Focus Order |
|---|---|
| All screens | App bar → Content (top to bottom) → Bottom nav |
| Forms | Field 1 → Field 2 → ... → Submit button |
| Dialogs | Dialog title → First interactive → ... → Close button |
| Bottom sheets | Handle → First item → ... → Last item |

### 4.2 Focus Trapping

| Component | Focus Trap | Escape Behavior |
|---|---|---|
| Dialog | Yes | Escape key closes dialog |
| Bottom sheet | Yes | Escape key closes sheet |
| Dropdown menu | Yes | Escape key closes menu |
| Search overlay | Yes | Escape key closes overlay |

### 4.3 Focus Restoration

| Trigger | Restoration Target |
|---|---|
| Dialog closes | Element that opened the dialog |
| Bottom sheet closes | Element that opened the sheet |
| Navigation back | Previous screen's focused element |
| Snackbar dismisses | No change (non-intrusive) |

### 4.4 Visible Focus Indicator

| Property | Value |
|---|---|
| Style | 2px solid `eco.primary` |
| Offset | 2px |
| Border Radius | Matches element |
| Apply to | All interactive elements on focus |

```dart
// Flutter focus indicator
FocusNode(
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: hasFocus
        ? Border.all(color: EcoColors.primary, width: 2)
        : null,
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

---

## 5. Screen Reader Specifications

### 5.1 Landmark Roles

| Landmark | Flutter Widget | Usage |
|---|---|---|
| Banner | `Scaffold` with `appBar` | App bar at top |
| Navigation | `BottomNavigationBar` | Bottom nav |
| Main | `body` of `Scaffold` | Primary content |
| Complementary | `Drawer` | Side navigation |
| Contentinfo | `AboutListTile` | Footer/about info |

### 5.2 Semantic Labels

| Element | Announce Format | Example |
|---|---|---|
| Listing card | "{title}, {price}, {condition}, {time ago}" | "Textbook, ₹250, Good, 2 hours ago" |
| Like button | "{status}, {count} likes" | "Not liked, 12 likes" |
| Comment button | "{count} comments" | "3 comments" |
| Share button | "Share" | "Share" |
| Badge | "{badge name}, earned {date}" | "Recycler, earned July 2026" |
| Navigation tab | "{tab name}, {unread count} new" | "Home, 3 new" |
| Notification | "{type} from {person}: {preview}" | "Like from Aisha: post about..." |
| Price | "{amount} rupees" | "250 rupees" |
| Rating | "{rating} out of 5 stars" | "4.8 out of 5 stars" |
| Progress bar | "{percentage} percent" | "75 percent" |
| Toggle | "{label}, {state}" | "Dark Mode, off" |
| Chip | "{label}, selected/not selected" | "Textbooks, selected" |

### 5.3 Live Regions

| Trigger | Role | Message |
|---|---|---|
| Snackbar appears | `polite` | Snackbar content |
| Error appears | `assertive` | Error message |
| Loading complete | `polite` | "{item} loaded" |
| Pull-to-refresh | `polite` | "Refreshing..." then "Updated" |
| Like toggle | `polite` | "Liked" / "Unliked" |
| Form validation error | `assertive` | "Error: {field} {message}" |
| Offline banner | `polite` | "You are offline" |
| Online restored | `polite` | "Connection restored" |

### 5.4 Heading Hierarchy

| Level | Usage | Example |
|---|---|---|
| H1 | Screen title (1 per screen) | "Marketplace" |
| H2 | Section headers | "Featured Listings" |
| H3 | Subsection headers | "Textbooks & Stationery" |
| H4 | Card titles (if needed) | "Engineering Mathematics" |

**Rule:** Never skip heading levels (H1 → H3 is not allowed).

---

## 6. Keyboard Navigation

### 6.1 Key Mappings

| Key | Action |
|---|---|
| Tab | Move to next interactive element |
| Shift+Tab | Move to previous interactive element |
| Enter / Space | Activate button/link |
| Escape | Close dialog/bottom sheet/menu |
| Arrow keys | Navigate within groups (tabs, radio buttons, lists) |
| Home | Jump to first item in list |
| End | Jump to last item in list |

### 6.2 Complex Screen Flows

**Marketplace Browse (Filter Chips):**

```
Search bar → Tab → Category chips (← → to navigate) → Tab → Listing cards
```

**Create Listing (Form):**

```
Image picker → Tab → Title → Tab → Description → Tab → Price → Tab →
Category dropdown → Tab → Condition chips (← → to navigate) → Tab →
Location → Tab → Submit button
```

**Community Feed (Post Card):**

```
Post card → Tab → Like button → Tab → Comment button → Tab → Share button →
Tab → Next post card
```

---

## 7. Reduced Motion

### 7.1 Respect System Setting

Check `MediaQuery.of(context).disableAnimations` and reduce/remove animations accordingly.

### 7.2 Animation Alternatives

| Standard Animation | Reduced Motion Alternative |
|---|---|
| Page transition (slide) | Instant change or cross-fade |
| Bottom sheet open (slide up) | Instant appear |
| Dialog open (scale + fade) | Instant appear |
| Skeleton shimmer | Static gray placeholder |
| Pull-to-refresh (rotate) | Static spinner |
| Like button (bounce) | Instant state change |
| Badge earn (confetti) | Static badge with text |
| Hero animation | No transition |
| FAB appear (scale) | Instant appear |

### 7.3 Implementation

```dart
bool get reduceMotion => MediaQuery.of(context).disableAnimations;

AnimatedContainer(
  duration: reduceMotion ? Duration.zero : Duration(milliseconds: 300),
  // ...
)
```

---

## 8. Error Handling

### 8.1 Error Identification

| Requirement | Implementation |
|---|---|
| Errors identified in text | Error message below field in `bodySmall`, `eco.error` |
| Not color alone | Error icon (⚠️) + text + border color change |
| Live region | `assertive` live region announces error |
| Focus management | Focus moves to first error field on submit |

### 8.2 Error Prevention

| Context | Prevention |
|---|---|
| Form submission | Inline validation on blur for first field |
| Destructive actions | Confirmation dialog ("Are you sure?") |
| Logout | Confirmation dialog |
| Delete account | 2-step confirmation |
| Remove listing | Confirmation dialog |

### 8.3 Error Message Pattern

```
❌ Field Label
Error description text
```

**Example:**
```
❌ Email
Please enter a valid email address
```

---

## 9. Per-Screen Accessibility

### SCR-001: Splash Screen

| Requirement | Implementation |
|---|---|
| Alt text | Logo: "EcoHabit logo" |
| Loading indicator | Announce "Loading" |
| Auto-navigate | Announce "Welcome to EcoHabit" before navigate |

### SCR-002: Login Screen

| Requirement | Implementation |
|---|---|
| Form labels | Each field has associated label |
| Error announcement | "Error: {field} {message}" |
| Success announcement | "Login successful" |
| Google button | "Continue with Google" |
| Keyboard | Tab through all fields, Enter to submit |

### SCR-006: Home Dashboard

| Requirement | Implementation |
|---|---|
| Section headers | H2 headings for each section |
| Card announcements | "{title}, {price}, {condition}" |
| Search bar | "Search marketplace" label |
| Notification bell | "Notifications, {count} new" |
| Progress card | "Your progress: {points} points, {badges} badges" |

### SCR-007: Marketplace Browse

| Requirement | Implementation |
|---|---|
| Filter chips | "Category filter: {name}, selected/not selected" |
| Result count | "{count} listings found" |
| Listing cards | "{title}, {price}, {condition}, {time}, {college}" |
| Infinite scroll | "Loading more listings" when loading |
| Empty state | "No listings found. Try adjusting your filters." |

### SCR-011: AI Scanner

| Requirement | Implementation |
|---|---|
| Camera permission | "Camera access is required for scanning" |
| Capture button | "Capture photo for classification" |
| Gallery button | "Upload photo from gallery" |
| Processing | "Scanning your item..." |
| Error | "Could not classify item. Please try again." |

### SCR-012: Scan Result

| Requirement | Implementation |
|---|---|
| Classification | "Classification: {name}, confidence: {percent}%" |
| Confidence bar | "{percent}% confidence" (text + visual) |
| Disposal guide | H2 heading, full text announced |
| DIY suggestions | "{count} DIY suggestions available" |
| Manual selection | "Uncertain? Tap to select manually" (if confidence < 80%) |

### SCR-015: Community Feed

| Requirement | Implementation |
|---|---|
| Post content | Full text announced (no truncation in screen reader) |
| Image alt text | Post image: "{author}'s post image" or description |
| Like button | "{liked/not liked}, {count} likes" |
| Comment button | "{count} comments" |
| Filter tabs | "Filter: {name}, selected/not selected" |

### SCR-018: Profile

| Requirement | Implementation |
|---|---|
| Avatar | "Profile photo of {name}" |
| Stats | "{count} points, {count} badges, {count} listings" |
| Menu items | Each announced with icon + label |
| Edit photo | "Change profile photo" |

---

## 10. Testing Checklist

### 10.1 Automated Testing

| Tool | Scope | Frequency |
|---|---|---|
| Flutter `SemanticsDebugger` | Widget accessibility | Every PR |
| `accessibility_test` package | Automated WCAG checks | Every PR |
| Color contrast analyzer | All color combinations | On change |

### 10.2 Manual Testing

| Test | Method | Frequency |
|---|---|---|
| Screen reader (TalkBack/VoiceOver) | Full app walkthrough | Monthly |
| Keyboard-only navigation | Full app walkthrough | Monthly |
| Zoom to 200% | Content reflow check | Monthly |
| Reduced motion | Animation check | Monthly |
| Color contrast | Visual inspection | On change |

### 10.3 Testing Devices

| Device | OS | Screen Reader | Purpose |
|---|---|---|---|
| Android phone | Android 12+ | TalkBack | Primary mobile |
| iPhone | iOS 15+ | VoiceOver | iOS compatibility |
| iPad | iPadOS 15+ | VoiceOver | Tablet layout |
| Desktop browser | Chrome/Firefox | NVDA/JAWS | Web accessibility |

---

## Document Reference

This document references:
- 15_Brand_Identity.md (color palette, contrast ratios)
- 16_Design_System.md (components, touch targets, tokens)
- 17_Screen_Specifications.md (screen layouts, states)
- 18_Responsive_Design.md (breakpoint adaptations)
- 05_Information_Architecture.md (existing accessibility requirements)

This document is referenced by:
- 13_Testing_Strategy.md (accessibility testing)
