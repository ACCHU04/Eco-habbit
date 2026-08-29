# EcoHabit Landing Page

A stunning, fully responsive marketing landing page for the EcoHabit platform.

## Overview

This is a static HTML/CSS/JS landing page for EcoHabit — an AI-powered circular economy platform for college students.

## Features

- 🎨 **Modern Design** — Glassmorphism nav, gradient hero, floating phone mockup
- ✨ **Micro-animations** — Scroll reveal, counter animation, parallax orbs, floating chips
- 📱 **Fully Responsive** — Mobile-first, hamburger menu, adaptive grid layouts
- ♿ **Accessible** — Semantic HTML5, ARIA labels, keyboard navigable
- ⚡ **Zero dependencies** — Pure HTML + CSS + Vanilla JS (no frameworks)
- 🔍 **SEO optimised** — Meta tags, Open Graph, structured headings

## Sections

| Section | Description |
|---|---|
| Nav | Sticky glassmorphism header with smooth scroll links |
| Hero | Full-screen hero with animated phone mockup & floating chips |
| Trust bar | College logos marquee |
| Features | 6-card feature grid with hover effects |
| How it works | 4-step process with connectors |
| Impact stats | Animated counters on an emerald dark background |
| Testimonials | 3-column student quote cards |
| Download CTA | Dark section with App Store / Play Store buttons |
| Footer | Multi-column footer with social links |

## How to Run

Simply open `index.html` in any modern browser:

```bash
# Option 1: Direct open
start index.html

# Option 2: Use a local server (recommended for full feature support)
npx serve .
# or
python -m http.server 8080
```

Then visit `http://localhost:8080`.

## File Structure

```
landing_page/
├── index.html     # Page markup
├── styles.css     # All styles (design tokens, layout, animations)
├── script.js      # Interactions (reveal, counters, nav, parallax)
└── README.md      # This file
```

## Contribution

Created by **Chandrika18** as part of the `chandrika-contribution` branch.

- Brand colours (`#10b981` green, `#059669` dark green) match the admin dashboard design system
- Typography uses **Inter** (same as admin dashboard)
- Component vocabulary (cards, badges, buttons) is consistent with the overall design language
