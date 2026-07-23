# EcoHabit Design System

> **Document Version:** 1.0
> **Last Updated:** July 2026
> **Status:** Active

---

## Part A: Design Tokens

Design tokens are the single source of truth for visual properties. They map directly to Flutter's `ThemeData` and related theme classes.

### 1. Color Tokens → Flutter `ColorScheme`

```dart
// eco_theme.dart
class EcoColors {
  // Primary
  static const primary = Color(0xFF10B981);
  static const primaryLight = Color(0xFF34D399);
  static const primaryDark = Color(0xFF059669);
  static const primaryContainer = Color(0xFFD1FAE5);
  static const onPrimaryContainer = Color(0xFF065F46);

  // Secondary
  static const secondary = Color(0xFF0D9488);
  static const secondaryContainer = Color(0xFFCCFBF1);
  static const tertiary = Color(0xFFF59E0B);
  static const tertiaryContainer = Color(0xFFFEF3C7);

  // Neutral (Light Mode)
  static const backgroundLight = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFF9FAFB);
  static const onBackgroundLight = Color(0xFF111827);
  static const onSurfaceLight = Color(0xFF1F2937);
  static const outlineLight = Color(0xFFD1D5DB);
  static const outlineVariantLight = Color(0xFFE5E7EB);

  // Neutral (Dark Mode)
  static const backgroundDark = Color(0xFF121212);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const onBackgroundDark = Color(0xFFF3F4F6);
  static const onSurfaceDark = Color(0xFFE5E7EB);
  static const outlineDark = Color(0xFF4B5563);
  static const outlineVariantDark = Color(0xFF374151);

  // Semantic
  static const error = Color(0xFFDC2626);
  static const errorContainer = Color(0xFFFEE2E2);
  static const onErrorContainer = Color(0xFF991B1B);
  static const warning = Color(0xFFF59E0B);
  static const warningContainer = Color(0xFFFEF3C7);
  static const success = Color(0xFF059669);
  static const successContainer = Color(0xFFD1FAE5);
  static const info = Color(0xFF2563EB);
  static const infoContainer = Color(0xFFDBEAFE);
}
```

### 2. Typography Tokens → Flutter `TextTheme`

```dart
class EcoTypography {
  static const fontFamily = 'Inter';

  // Level 1: Display Large
  static const displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 64 / 57,
    letterSpacing: -0.25,
  );

  // Level 2: Display Medium
  static const displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w700,
    height: 52 / 45,
    letterSpacing: 0,
  );

  // Level 3: Display Small
  static const displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 44 / 36,
    letterSpacing: 0,
  );

  // Level 4: Headline Large
  static const headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: 0,
  );

  // Level 5: Headline Medium
  static const headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
    letterSpacing: 0,
  );

  // Level 6: Headline Small
  static const headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
    letterSpacing: 0,
  );

  // Level 7: Title Large
  static const titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 28 / 22,
    letterSpacing: 0,
  );

  // Level 8: Title Medium
  static const titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    letterSpacing: 0.15,
  );

  // Level 9: Title Small
  static const titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  // Level 10: Body Large
  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0.5,
  );

  // Level 11: Body Medium
  static const bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0.25,
  );

  // Level 12: Body Small
  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.4,
  );

  // Level 13: Label Large
  static const labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  // Level 14: Label Medium
  static const labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.5,
  );

  // Level 15: Label Small
  static const labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: 0.5,
  );
}
```

### 3. Spacing Scale (4px Base)

| Token | Value | Usage |
|---|---|---|
| `eco.spacing.xxs` | 2px | Inline spacing, icon gaps |
| `eco.spacing.xs` | 4px | Tight spacing, chip padding |
| `eco.spacing.sm` | 8px | Small gaps, padding within cards |
| `eco.spacing.md` | 12px | Medium gaps, between related elements |
| `eco.spacing.lg` | 16px | Standard padding, card padding |
| `eco.spacing.xl` | 20px | Section spacing, list item padding |
| `eco.spacing.2xl` | 24px | Between sections |
| `eco.spacing.3xl` | 32px | Major section breaks |
| `eco.spacing.4xl` | 40px | Screen-level padding |
| `eco.spacing.5xl` | 48px | Hero spacing |
| `eco.spacing.6xl` | 64px | Maximum spacing |

### 4. Border Radius Tokens

| Token | Value | Flutter Constant | Usage |
|---|---|---|---|
| `eco.radius.none` | 0 | `BorderRadius.zero` | No rounding |
| `eco.radius.xs` | 2px | `BorderRadius.all(Radius.circular(2))` | Chips, small tags |
| `eco.radius.sm` | 4px | `BorderRadius.all(Radius.circular(4))` | Small elements |
| `eco.radius.md` | 8px | `BorderRadius.all(Radius.circular(8))` | Cards, buttons, inputs |
| `eco.radius.lg` | 12px | `BorderRadius.all(Radius.circular(12))` | Bottom sheets, dialogs |
| `eco.radius.xl` | 16px | `BorderRadius.all(Radius.circular(16))` | Large cards, modals |
| `eco.radius.2xl` | 24px | `BorderRadius.all(Radius.circular(24))` | Feature cards |
| `eco.radius.full` | 999px | `BorderRadius.circular(999)` | Avatars, FABs |

### 5. Elevation / Shadow Tokens

| Level | Light Mode | Dark Mode | Usage |
|---|---|---|---|
| 0 | `elevation: 0` | `elevation: 0` | Flat surfaces |
| 1 | `BoxShadow(blurRadius: 3, offset: (0,1), color: Colors.black12)` | `BoxShadow(blurRadius: 3, offset: (0,1), color: Colors.black45)` | Cards at rest |
| 2 | `BoxShadow(blurRadius: 6, offset: (0,2), color: Colors.black15)` | `BoxShadow(blurRadius: 6, offset: (0,2), color: Colors.black50)` | Cards elevated, app bar |
| 3 | `BoxShadow(blurRadius: 12, offset: (0,4), color: Colors.black18)` | `BoxShadow(blurRadius: 12, offset: (0,4), color: Colors.black60)` | Dialogs, bottom sheets |
| 4 | `BoxShadow(blurRadius: 24, offset: (0,8), color: Colors.black22)` | `BoxShadow(blurRadius: 24, offset: (0,8), color: Colors.black70)` | FABs, floating elements |

### 6. Animation Tokens

| Token | Duration | Usage |
|---|---|---|
| `eco.duration.instant` | 100ms | Micro-interactions (ripple, toggle) |
| `eco.duration.fast` | 200ms | Hover states, opacity changes |
| `eco.duration.normal` | 300ms | Page transitions, bottom sheet open |
| `eco.duration.slow` | 500ms | Complex animations, loading transitions |
| `eco.duration.extraSlow` | 800ms | Hero animations, skeleton shimmer cycle |

| Token | Curve | Flutter Curve | Usage |
|---|---|---|---|
| `eco.curve.standard` | Ease-in-out | `Curves.easeInOut` | General transitions |
| `eco.curve.decelerate` | Ease-out | `Curves.easeOut` | Elements entering screen |
| `eco.curve.accelerate` | Ease-in | `Curves.easeIn` | Elements leaving screen |
| `eco.curve.spring` | Spring | `Curves.elasticOut` | Playful interactions (badges, likes) |
| `eco.curve.linear` | Linear | `Curves.linear` | Loading indicators, shimmer |

### 7. Breakpoint Tokens

| Token | Range | Flutter LayoutBuilder | Usage |
|---|---|---|---|
| `eco.breakpoint.mobile` | < 600px | `maxWidth < 600` | Single column, bottom nav |
| `eco.breakpoint.tablet` | 600–1024px | `600 <= maxWidth < 1024` | Two columns, rail nav |
| `eco.breakpoint.desktop` | > 1024px | `maxWidth >= 1024` | Three columns, side nav |

---

## Part B: Components

### 8. Buttons

#### 8.1 Primary Button

| Property | Value |
|---|---|
| Height | 48px |
| Min Width | 64px |
| Padding | Horizontal: 24px, Vertical: 0 |
| Border Radius | `eco.radius.md` (8px) |
| Background | `eco.primary` |
| Text Color | `#FFFFFF` |
| Text Style | `labelLarge` |
| Icon Size | 20px (leading) |
| Icon Color | `#FFFFFF` |

**States:**

| State | Background | Text | Elevation |
|---|---|---|---|
| Default | `eco.primary` | White | 1 |
| Hover/Focus | `eco.primaryLight` | White | 2 |
| Pressed | `eco.primaryDark` | White | 1 |
| Disabled | `eco.neutral.200` | `eco.neutral.400` | 0 |
| Loading | `eco.primary` (opacity 0.6) | White (hidden) | 0 |

#### 8.2 Secondary Button (Outlined)

| Property | Value |
|---|---|
| Height | 48px |
| Min Width | 64px |
| Padding | Horizontal: 24px, Vertical: 0 |
| Border Radius | `eco.radius.md` (8px) |
| Background | Transparent |
| Border | 1px `eco.primary` |
| Text Color | `eco.primary` |
| Text Style | `labelLarge` |

**States:** Same as primary but with outline border color changes.

#### 8.3 Text Button

| Property | Value |
|---|---|
| Height | 40px |
| Padding | Horizontal: 12px, Vertical: 8px |
| Background | Transparent |
| Text Color | `eco.primary` |
| Text Style | `labelLarge` |
| No border, no elevation | — |

#### 8.4 Icon Button

| Property | Value |
|---|---|
| Size | 48px × 48px (touch target) |
| Icon Size | 24px |
| Icon Color | `eco.neutral.700` |
| Background | Transparent |
| Border Radius | `eco.radius.full` |

**States:**

| State | Background | Icon Color |
|---|---|---|
| Default | Transparent | `eco.neutral.700` |
| Pressed | `eco.neutral.100` | `eco.neutral.900` |
| Selected | `eco.primaryContainer` | `eco.primary` |

#### 8.5 Floating Action Button (FAB)

| Property | Value |
|---|---|
| Size | 56px × 56px |
| Border Radius | `eco.radius.lg` (16px) |
| Background | `eco.primary` |
| Icon Size | 24px |
| Icon Color | `#FFFFFF` |
| Elevation | Level 4 |
| Shadow | On surface |

**Mini FAB:** 40px × 40px, icon 24px.

---

### 9. Cards

#### 9.1 Listing Card (Marketplace)

```
┌──────────────────────────────────────┐
│ ┌──────────┐  Title (titleMedium)    │
│ │          │  ₹ Price (headlineSmall)│
│ │  Image   │  Condition chip         │
│ │  4:3     │  College · Time ago     │
│ └──────────┘                         │
└──────────────────────────────────────┘
```

| Property | Value |
|---|---|
| Width | Full width minus 32px (16px margin each side) |
| Border Radius | `eco.radius.md` (8px) |
| Background | `eco.surface` |
| Elevation | Level 1 |
| Padding | 12px |
| Image | 4:3 aspect ratio, `eco.radius.sm` on top-left |
| Image Width | 100px |
| Gap | 12px between image and text |

#### 9.2 Post Card (Community)

```
┌──────────────────────────────────────┐
│ Avatar  Author Name          ···    │
│         Time ago                     │
│ ──────────────────────────────────── │
│ Post text content that can span      │
│ multiple lines and be truncated...   │
│ ┌──────────────────────────────────┐ │
│ │         Post Image (1:1)         │ │
│ └──────────────────────────────────┘ │
│ ──────────────────────────────────── │
│ ♡ 12    💬 3    📤 Share            │
└──────────────────────────────────────┘
```

| Property | Value |
|---|---|
| Border Radius | `eco.radius.md` (8px) |
| Background | `eco.surface` |
| Elevation | Level 1 |
| Padding | 16px |
| Avatar | 40px circle |
| Image Aspect Ratio | 1:1 (optional) |
| Action Row Height | 44px |

#### 9.3 Project Card (DIY)

```
┌──────────────────────────────────────┐
│ ┌──────────────────────────────────┐ │
│ │       Project Image (16:9)       │ │
│ └──────────────────────────────────┘ │
│ Title (titleMedium)                  │
│ Difficulty chip · Estimated time     │
│ Materials: 3 items                   │
└──────────────────────────────────────┘
```

| Property | Value |
|---|---|
| Border Radius | `eco.radius.md` (8px) |
| Background | `eco.surface` |
| Elevation | Level 1 |
| Image Aspect Ratio | 16:9 |
| Padding | 0 (image edge-to-edge), 12px below image |

#### 9.4 Badge Card (Rewards)

```
┌──────────────────────────────────────┐
│      ┌────────┐                      │
│      │ Badge  │  Badge Name          │
│      │ Icon   │  Description         │
│      └────────┘  Earned date         │
└──────────────────────────────────────┘
```

| Property | Value |
|---|---|
| Border Radius | `eco.radius.md` (8px) |
| Background | `eco.surface` |
| Badge Icon | 48px circle with `eco.primaryContainer` background |
| Padding | 12px |

---

### 10. Input Fields

#### 10.1 Text Field

| Property | Value |
|---|---|
| Height | 56px |
| Border Radius | `eco.radius.md` (8px) |
| Background | `eco.background` |
| Border (rest) | 1px `eco.neutral.300` |
| Border (focus) | 2px `eco.primary` |
| Border (error) | 2px `eco.error` |
| Padding | Horizontal: 16px, Vertical: 12px |
| Label Style | `bodyMedium` |
| Input Style | `bodyLarge` |
| Hint Color | `eco.neutral.400` |

**States:**

| State | Border | Background | Label |
|---|---|---|---|
| Empty | `eco.neutral.300` | `eco.background` | Floating label |
| Focused | `eco.primary` (2px) | `eco.background` | Floating label (primary) |
| Filled | `eco.neutral.300` | `eco.background` | Floating label |
| Error | `eco.error` (2px) | `eco.background` | Error label (error) |
| Disabled | `eco.neutral.200` | `eco.neutral.50` | `eco.neutral.400` |

#### 10.2 Search Bar

| Property | Value |
|---|---|
| Height | 48px |
| Border Radius | `eco.radius.2xl` (24px) |
| Background | `eco.neutral.100` |
| Icon | Search (leading, 24px, `eco.neutral.400`) |
| Suffix | Clear button (when text present) |
| Input Style | `bodyLarge` |

#### 10.3 Dropdown

| Property | Value |
|---|---|
| Same as Text Field | — |
| Suffix Icon | Chevron down (24px) |
| Menu | Elevation Level 3, `eco.radius.lg` |
| Menu Item Height | 48px |
| Menu Item Padding | Horizontal: 16px |

---

### 11. Navigation

#### 11.1 Bottom Navigation Bar

| Property | Value |
|---|---|
| Height | 80px (with labels), 64px (without) |
| Background | `eco.background` |
| Elevation | Level 2 |
| Active Icon | Filled, `eco.primary` |
| Inactive Icon | Outlined, `eco.neutral.500` |
| Active Label | `eco.primary`, `labelSmall` |
| Inactive Label | `eco.neutral.500`, `labelSmall` |
| Icon Size | 24px |
| Badge | Red dot or count on icon |

**Tabs (5):**

| Tab | Icon (outlined) | Icon (filled) | Route |
|---|---|---|---|
| Home | `home_outlined` | `home` | `/home` |
| Market | `storefront_outlined` | `storefront` | `/marketplace` |
| Scan | `eco_scan` (custom) | `eco_scan` | `/scanner` |
| Community | `forum_outlined` | `forum` | `/community` |
| Person | `person_outlined` | `person` | `/profile` |

#### 11.2 App Bar

| Property | Value |
|---|---|
| Height | 56px |
| Background | `eco.background` |
| Elevation | Level 0 (flat) |
| Title Style | `titleLarge` |
| Title Color | `eco.neutral.900` |
| Icon Button | 48px touch target |
| Bottom | Optional divider (1px `eco.neutral.200`) |

#### 11.3 Drawer (Settings)

| Property | Value |
|---|---|
| Width | 304px (max 80% screen) |
| Background | `eco.background` |
| Elevation | Level 4 |
| Header | User avatar + name + email |
| Item Height | 56px |
| Item Padding | Horizontal: 16px |
| Divider | 1px `eco.neutral.200`, vertical padding 8px |

---

### 12. Feedback Components

#### 12.1 Snackbar

| Property | Value |
|---|---|
| Background | `eco.neutral.800` |
| Text Color | `#FFFFFF` |
| Text Style | `bodyMedium` |
| Border Radius | `eco.radius.md` (8px) |
| Margin | 16px all sides |
| Padding | Horizontal: 16px, Vertical: 12px |
| Duration | 4 seconds (default), 8 seconds (error) |
| Action | Text button, `eco.primaryLight` |
| Elevation | Level 3 |

#### 12.2 Dialog

| Property | Value |
|---|---|
| Background | `eco.background` |
| Border Radius | `eco.radius.xl` (16px) |
| Elevation | Level 3 |
| Max Width | 312px |
| Padding | 24px |
| Title Style | `headlineSmall` |
| Body Style | `bodyMedium` |
| Actions Alignment | End |
| Barrier Color | `Colors.black54` |

#### 12.3 Bottom Sheet

| Property | Value |
|---|---|
| Background | `eco.background` |
| Border Radius | Top-left: `eco.radius.xl`, Top-right: `eco.radius.xl` |
| Elevation | Level 3 |
| Handle Width | 32px |
| Handle Height | 4px |
| Handle Color | `eco.neutral.300` |
| Handle Border Radius | `eco.radius.full` |
| Max Height | 90% screen height |
| Padding | Top: 16px (below handle), Horizontal: 16px |

#### 12.4 Progress Indicator

| Property | Value |
|---|---|
| Color | `eco.primary` |
| Track Color | `eco.primaryContainer` |
| Stroke Width | 4px (linear), 3px (circular) |
| Indeterminate | Linear animation: 200ms |

---

### 13. Media Components

#### 13.1 Image Carousel (Listing Details)

| Property | Value |
|---|---|
| Aspect Ratio | 4:3 |
| Border Radius | `eco.radius.md` (8px) |
| Indicator | Dots, 8px circle, active: 12px wide |
| Indicator Color | `eco.primary` (active), `eco.neutral.300` (inactive) |
| Indicator Bottom | 12px from bottom |
| Max Images | 6 |
| Placeholder | `eco.neutral.100` with image icon |

#### 13.2 Avatar

| Size | Diameter | Border | Usage |
|---|---|---|---|
| `xs` | 24px | None | Inline comments |
| `sm` | 32px | None | List tiles |
| `md` | 40px | 2px `eco.background` | Post cards, chat |
| `lg` | 56px | 2px `eco.background` | Profile header |
| `xl` | 80px | 3px `eco.primary` | Profile screen |
| `xxl` | 120px | 4px `eco.primary` | Profile edit |

#### 13.3 Thumbnail

| Property | Value |
|---|---|
| Size | 64px × 64px |
| Border Radius | `eco.radius.sm` (4px) |
| Placeholder | `eco.neutral.100` |

---

### 14. Data Display

#### 14.1 List Tile

| Property | Value |
|---|---|
| Height | 56px (default), 72px (with subtitle) |
| Padding | Horizontal: 16px |
| Leading Width | 40px (icon) or 40px (avatar) |
| Title Style | `bodyLarge` |
| Subtitle Style | `bodySmall`, `eco.neutral.500` |
| Trailing | Icon or text |

#### 14.2 Chip / Tag

| Property | Value |
|---|---|
| Height | 32px |
| Border Radius | `eco.radius.sm` (4px) |
| Padding | Horizontal: 12px, Vertical: 6px |
| Text Style | `labelMedium` |
| Icon Size | 18px |

**Variants:**

| Variant | Background | Text | Border |
|---|---|---|---|
| Filled | `eco.primaryContainer` | `eco.onPrimaryContainer` | None |
| Outlined | Transparent | `eco.primary` | 1px `eco.primary` |
| Success | `eco.successContainer` | `eco.success` | None |
| Warning | `eco.warningContainer` | `eco.warning` | None |
| Error | `eco.errorContainer` | `eco.error` | None |

#### 14.3 Divider

| Property | Value |
|---|---|
| Height | 1px |
| Color | `eco.neutral.200` |
| Indent | 0 (full width) or 16px (inset) |
| Thickness | 1px |

---

### 15. Loading Components

#### 15.1 Skeleton Screen

| Property | Value |
|---|---|
| Background | `eco.neutral.200` |
| Shimmer Highlight | `eco.neutral.100` |
| Animation Duration | 800ms (linear, infinite) |
| Border Radius | Matches target element |

**Skeleton Patterns:**

| Element | Shape | Size |
|---|---|---|
| Text line | Rectangle | Full width, 14px height |
| Avatar | Circle | 40px diameter |
| Image | Rectangle | Full width, aspect ratio match |
| Button | Rectangle | 120px × 48px |
| Card | Rectangle | Full width, 120px height |

#### 15.2 Pull-to-Refresh

| Property | Value |
|---|---|
| Color | `eco.primary` |
| Background | `eco.neutral.100` |
| Displacement | 80px |
| Spring | 0.2 overscroll |

---

### 16. Empty States

| Property | Value |
|---|---|
| Illustration | 120px × 120px, centered |
| Illustration Color | `eco.neutral.300` or `eco.primaryContainer` |
| Title Style | `headlineSmall`, `eco.neutral.700` |
| Description Style | `bodyMedium`, `eco.neutral.500` |
| CTA Button | Primary button |
| Spacing | 24px between illustration, title, description, CTA |
| Alignment | Center |

**Empty State Patterns:**

| Context | Illustration | Title | CTA |
|---|---|---|---|
| No listings | Empty box | "No listings yet" | "Create Listing" |
| No search results | Magnifying glass | "No results found" | "Clear Filters" |
| No posts | Empty feed | "No posts yet" | "Create Post" |
| No notifications | Bell | "All caught up!" | — |
| No saved items | Bookmark | "No saved items" | "Browse Marketplace" |

---

## Part C: Patterns

### 17. Form Pattern

| Element | Behavior |
|---|---|
| Layout | Single column, full width fields |
| Label | Floating label (Material 3 style) |
| Required indicator | Asterisk (*) after label |
| Error message | Below field, `bodySmall`, `eco.error` |
| Validation | On blur (first field), on submit (rest) |
| Submit button | Full width, primary button, sticky at bottom |
| Keyboard | Appropriate type per field (email, number, text) |
| Scroll | Fields scroll into view when keyboard opens |

**Form Field Order (Create Listing):**
1. Title (required)
2. Description (required)
3. Price (required, number)
4. Category (required, dropdown)
5. Condition (required, radio chips)
6. Images (required, min 1)
7. Location (required)

### 18. Search Pattern

| Element | Behavior |
|---|---|
| Search bar | Fixed at top, expands on focus |
| Recent searches | Shown when search bar focused (max 5) |
| Filters | Chip row below search bar (horizontally scrollable) |
| Results | List or grid below filters |
| Empty results | "No results" empty state with clear filters CTA |
| Clear | X button in search bar, clears query |

**Filter Chips:**

| Filter | Options |
|---|---|
| Category | Textbooks, Electronics, Furniture, Clothing, Sports, Others |
| Condition | New, Good, Fair, Used |
| Price Range | Under ₹500, ₹500–1000, ₹1000–2000, ₹2000+ |
| Sort | Recent, Price Low-High, Price High-Low, Popular |

### 19. Error Pattern

| Error Type | Display | Action |
|---|---|---|
| Network error | Full screen with retry button | Retry |
| API error (4xx) | Snackbar with message | Dismiss |
| API error (5xx) | Snackbar with retry | Retry |
| Auth error | Redirect to login | Re-authenticate |
| Validation error | Inline below field | Fix input |
| Permission error | Dialog with explanation | Dismiss / Settings |

### 20. Offline Pattern

| Element | Behavior |
|---|---|
| Status bar | "Offline" banner below app bar (yellow background) |
| Cached data | Displayed normally with "Cached" label |
| Queued actions | Badge on relevant icon ("1 pending") |
| Pull-to-refresh | Shows "Reconnecting..." instead of spinner |
| Submit actions | "Will post when online" snackbar, queued locally |

### 21. Dark Mode Theme

All tokens in Part A have dark mode equivalents. Key differences:

| Property | Light | Dark |
|---|---|---|
| Background | `#FFFFFF` | `#121212` |
| Surface | `#F9FAFB` | `#1E1E1E` |
| On Background | `#111827` | `#F3F4F6` |
| On Surface | `#1F2937` | `#E5E7EB` |
| Primary | `#10B981` | `#34D399` |
| Primary Container | `#D1FAE5` | `#064E3B` |
| Outline | `#D1D5DB` | `#4B5563` |
| Shadow | Black with low opacity | Black with high opacity |

---

## Document Reference

This document references:
- 15_Brand_Identity.md (colors, typography, visual language)

This document is referenced by:
- 17_Screen_Specifications.md
- 18_Responsive_Design.md
- 19_Accessibility_Specification.md
