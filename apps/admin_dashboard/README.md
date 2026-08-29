<div align="center">

<img src="./public/logo3d.svg" alt="EcoHabit Logo" width="180" />

# EcoHabit Admin Dashboard

**A modern, secure web-based admin console for the [EcoHabit](https://github.com/ACCHU04/Eco-habbit) circular economy platform.**

---

[![Next.js](https://img.shields.io/badge/Next.js-16-black?logo=next.js&logoColor=white)](https://nextjs.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-blue?logo=typescript&logoColor=white)](https://www.typescriptlang.org)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-v4-06B6D4?logo=tailwindcss&logoColor=white)](https://tailwindcss.com)
[![Firebase](https://img.shields.io/badge/Firebase-Auth-DDA0DD?logo=firebase&logoColor=white)](https://firebase.google.com)
[![Supabase](https://img.shields.io/badge/Supabase-DB-3FCF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![React](https://img.shields.io/badge/React-19-61DAFB?logo=react&logoColor=black)](https://react.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](#license)

</div>

---

## Overview

The EcoHabit Admin Dashboard provides platform administrators with a centralized, browser-based interface for managing users, reviewing reported content, monitoring admin actions, and viewing system-wide statistics. It mirrors the admin panel built into the [Flutter mobile app](../mobile_app/) and communicates with the same [NestJS backend API](../../services/backend_api/).

**Key capabilities at a glance:**

- Real-time platform statistics and role-based user breakdowns
- Full user search with role and status filtering
- User detail view with role promotion/demotion and status management
- Content report queue with resolve/dismiss actions
- Comprehensive admin audit log
- Firebase Google Sign-In with automatic token refresh
- Role-gated access — only `admin` and `super_admin` users can enter

---

## Demo

> **Coming Soon** — A live demo will be deployed to Vercel once the Firebase web app is fully configured.
> Run locally with `npm run dev` to try it out.

---

## Features

| Feature | Description |
|---|---|
| **Dashboard** | System-wide stats — total users, posts, pending reports, active listings — plus a role breakdown chart |
| **User Management** | Search, filter by role/status, paginate, view detail, promote/demote roles, change account status |
| **Report Moderation** | Review user-reported content, mark reports as resolved or dismissed with timestamps |
| **Audit Log** | Full history of admin actions — role changes, status changes, post/listing deletions, report resolutions |
| **Firebase Auth** | Google popup sign-in with automatic ID token refresh on 401; no hardcoded credentials |
| **Admin Gate** | Non-admin users are shown a clear "access denied" page — no data leaks |
| **Responsive** | Mobile-friendly sidebar layout that collapses on small screens |

---

## Tech Stack

| Layer | Technology | Version |
|---|---|---|
| Framework | [Next.js](https://nextjs.org) (App Router, Turbopack) | 16.2.12 |
| Language | [TypeScript](https://www.typescriptlang.org) | 5.x |
| UI | [Tailwind CSS](https://tailwindcss.com) (v4 `@theme`) | 4.x |
| Auth | [Firebase Authentication](https://firebase.google.com) (Google popup) | 12.17.0 |
| Backend | [NestJS](https://nestjs.com) REST API | — |
| Database | [Supabase](https://supabase.com) (PostgreSQL) | — |
| Runtime | [React](https://react.dev) | 19.2.4 |
| Linting | [ESLint](https://eslint.org) + `next/core-web-vitals` | 9.x |
| Deployment | [Vercel](https://vercel.com) | — |

---

## Getting Started

### Prerequisites

| Requirement | Version | Purpose |
|---|---|---|
| [Node.js](https://nodejs.org) | 20+ | Runtime |
| npm | 10+ | Package manager |
| Firebase web app | — | Register at [Firebase Console](https://console.firebase.google.com) → Project Settings → Add Web App |
| Admin account | — | Supabase `users` row with `role = 'admin'` or `'super_admin'` and `status = 'active'` |

### 1. Install dependencies

```bash
cd apps/admin_dashboard
npm install
```

### 2. Configure environment variables

```bash
cp .env.example .env.local
```

Edit `.env.local` with your Firebase web app values:

```env
NEXT_PUBLIC_API_BASE_URL=https://eco-habbit.onrender.com/api/v1
NEXT_PUBLIC_FIREBASE_API_KEY=your-api-key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=echo-habbit.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=echo-habbit
NEXT_PUBLIC_FIREBASE_APP_ID=your-web-app-id
```

> **Where to find these values:** Firebase Console → Project Settings → Your apps → select (or create) the Web app (`</>` icon) → copy the config snippet.

### 3. Start the development server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) — you'll be redirected to the login page.

---

## Environment Variables

All variables are prefixed `NEXT_PUBLIC_` (exposed to the browser by Next.js).

| Variable | Required | Description | Source |
|---|---|---|---|
| `NEXT_PUBLIC_API_BASE_URL` | Yes | Backend API base URL | Default: `https://eco-habbit.onrender.com/api/v1` |
| `NEXT_PUBLIC_FIREBASE_API_KEY` | Yes | Firebase project API key | Firebase Console → Project Settings → General |
| `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN` | No | Firebase Auth domain (auto-inferred) | Default: `echo-habbit.firebaseapp.com` |
| `NEXT_PUBLIC_FIREBASE_PROJECT_ID` | No | Firebase project ID (auto-inferred) | Default: `echo-habbit` |
| `NEXT_PUBLIC_FIREBASE_APP_ID` | Yes | Firebase **Web** app ID (`1:...:web:...`) | Firebase Console → Project Settings → Your apps → Web app |

> **Important:** Use the **Web** app ID, not Android or iOS. Without it, Firebase won't initialize and Google Sign-In will fail with "failed to fetch".

---

## Project Structure

```
src/
├── app/                          # Next.js App Router pages
│   ├── (admin)/admin/            # Admin-protected routes
│   │   ├── layout.tsx            # Admin gate + sidebar shell
│   │   ├── page.tsx              # Dashboard (stats overview)
│   │   ├── audit/page.tsx        # Audit log
│   │   ├── reports/page.tsx      # Content reports
│   │   └── users/
│   │       ├── page.tsx          # User list + search
│   │       └── [id]/page.tsx     # User detail + role/status actions
│   ├── login/page.tsx            # Google Sign-In
│   ├── layout.tsx                # Root layout (fonts, AuthProvider)
│   ├── page.tsx                  # Root redirect
│   └── globals.css               # Tailwind v4 @theme tokens
├── components/                   # Shared UI components
│   ├── auth-provider.tsx         # Firebase auth context + token sync
│   ├── avatar.tsx                # User avatar with role indicator
│   ├── badge.tsx                 # Role and status badges
│   ├── confirm-dialog.tsx        # Reusable confirmation modal
│   ├── pagination.tsx            # Page navigation
│   ├── search-input.tsx          # Debounced search field
│   ├── sidebar.tsx               # Nav sidebar with role badge
│   ├── stat-card.tsx             # Dashboard stat card
│   └── state-views.tsx           # Loading, empty, error states
└── lib/                          # Core utilities
    ├── api.ts                    # Typed HTTP client with 401 refresh
    ├── config.ts                 # Environment variable access
    ├── firebase.ts               # Firebase init + auth helpers
    ├── format.ts                 # Date, name, ID formatters
    └── types.ts                  # TypeScript interfaces
```

---

## Pages & Routes

| Route | Page | Auth Required | Description |
|---|---|---|---|
| `/login` | Login | No | Google Sign-In button; shows config warning if Firebase isn't set up |
| `/admin` | Dashboard | Yes | Total users/posts/reports/listings, quick action links, role breakdown |
| `/admin/users` | User List | Yes | Searchable, filterable user list with pagination |
| `/admin/users/[id]` | User Detail | Yes | User profile, role change, status management (super_admin-only for role edits) |
| `/admin/reports` | Reports | Yes | Pending/Resolved/Dismissed reports with action buttons |
| `/admin/audit` | Audit Log | Yes | Timestamped admin action history with action-type icons |

**Admin gate:** The admin layout (`(admin)/admin/layout.tsx`) calls `GET /admin/dashboard` on mount. A 403 renders an "access denied" message. An unauthenticated response redirects to `/login`.

---

## Authentication & Authorization

### How it works

```
Browser ──(Firebase Google popup)──► Firebase Auth
  │
  │  id token (JWT)
  ▼
Backend API (NestJS AuthGuard)
  │
  │  verifyIdToken() via Firebase Admin SDK
  │  Supabase users lookup by uid (fallback: email)
  │
  ▼
request.user = { id, uid, email, role }
  │
  │  role == 'admin' || role == 'super_admin'  →  proceed
  │  otherwise                                  →  403 Forbidden
  ▼
Admin data returned
```

### Token lifecycle

1. **Sign-in:** Firebase Google popup mints an ID token → exchanged with backend for a custom token (if new user)
2. **Requests:** ID token sent as `Authorization: Bearer <token>` header
3. **Refresh:** On HTTP 401, the client silently refreshes the token via `getIdToken(true)` and retries the failed request once
4. **Supabase role:** Backend looks up `users.role` by Firebase `uid`; falls back to `email` when uid differs between platforms (mobile uses `google_<sub>` format, web uses Firebase's native uid)

### Role hierarchy

```
student → ngo → organization → moderator → admin → super_admin
```

Only `admin` and `super_admin` can access this dashboard. `super_admin` can edit other users' roles; `admin` can only edit status.

---

## API Reference

The dashboard communicates with the EcoHabit backend at:

```
Base URL: https://eco-habbit.onrender.com/api/v1
Swagger:  https://eco-habbit.onrender.com/api/docs  (when ENABLE_SWAGGER=true)
```

### Authentication header

```
Authorization: Bearer <Firebase-ID-Token>
```

### Admin endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/admin/dashboard` | Platform-wide statistics |
| `GET` | `/admin/users` | List users (query: `search`, `role`, `status`, `page`, `limit`) |
| `GET` | `/admin/users/:id` | Single user detail |
| `PUT` | `/admin/users/:id/role` | Change user role (body: `{ role }`) |
| `PUT` | `/admin/users/:id/status` | Change user status (body: `{ status }`) |
| `GET` | `/admin/reports` | List reports (query: `status`, `page`, `limit`) |
| `PUT` | `/admin/reports/:id` | Update report status (body: `{ status }`) |
| `GET` | `/admin/audit-log` | Admin action audit log (query: `page`, `limit`) |

### Response envelope

```json
{
  "success": true,
  "data": { ... },
  "pagination": { "page": 1, "total_pages": 5, "total": 100 }
}
```

---

## Deployment (Vercel)

1. **Push to GitHub**

2. **Import in Vercel**
   - Go to [vercel.com](https://vercel.com) → New Project → Import Git Repository
   - Select this repository

3. **Configure settings**
   - **Root Directory:** `apps/admin_dashboard`
   - **Framework Preset:** Next.js (auto-detected)
   - **Build Command:** `npm run build` (default)

4. **Add environment variables**
   Copy all `NEXT_PUBLIC_*` values from `.env.local` into Vercel's environment variable panel (Settings → Environment Variables).

5. **Deploy**

6. **Add Vercel domain to Firebase**
   - Firebase Console → Authentication → Authorized domains → add your `.vercel.app` domain

---

## Scripts

| Command | Description |
|---|---|
| `npm run dev` | Start development server (Turbopack, port 3000) |
| `npm run build` | Production build |
| `npm run start` | Serve production build |
| `npm run lint` | Run ESLint (includes `react-hooks` rules) |

---

## Contributing

1. Create a feature branch from `main`
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Make your changes and ensure `npm run lint` passes with zero errors
3. Run `npm run build` to verify no type errors
4. Commit with a clear message following the [Conventional Commits](https://www.conventionalcommits.org/) format
5. Open a Pull Request against `main`

### Code style

- TypeScript strict mode — no `any` types
- Functional components with hooks only
- Tailwind CSS v4 for all styling (no inline styles)
- Server components by default; `"use client"` only when state/effects are needed
- All data fetching uses the typed `api.ts` client — no raw `fetch` in components

---

## License

This project is licensed under the [MIT License](../../LICENSE).

---

<div align="center">

**Built with care for a sustainable future.**

[EcoHabit](https://github.com/ACCHU04/Eco-habbit) · [Flutter App](../mobile_app/) · [Backend API](../../services/backend_api/) · [Documentation](../../docs/)

</div>
