# EcoHabit Admin Dashboard

Web admin dashboard for the EcoHabit platform. Built with Next.js (App Router),
TypeScript, Tailwind CSS, and Firebase Authentication. Mirrors the admin panel
that is built into the Flutter mobile app.

## Prerequisites

1. **Firebase web app** — Register a web app in the `echo-habbit` Firebase
   console (Project Settings → Your apps → **Add web app**). Enable **Google
   Sign-In** under Authentication → Sign-in method.
2. **Admin account** — In Supabase, set your user's `role` to `admin` or
   `super_admin` and `status` to `active`.

## Setup

```bash
npm install
cp .env.example .env.local   # fill in the Firebase values
npm run dev                  # http://localhost:3000
```

## Scripts

| Command          | Description                    |
| ---------------- | ------------------------------ |
| `npm run dev`    | Development server             |
| `npm run build`  | Production build               |
| `npm run start`  | Serve production build         |
| `npm run lint`   | Run ESLint                     |

## Pages

| Route               | Description                                     |
| ------------------- | ----------------------------------------------- |
| `/login`            | Google Sign-In                                  |
| `/admin`            | Dashboard (stats, quick actions, role breakdown) |
| `/admin/users`      | User search, role/status filters, pagination    |
| `/admin/users/[id]` | User detail with role/status actions            |
| `/admin/reports`    | Report queue with Resolve / Dismiss             |
| `/admin/audit`      | Admin action audit log                          |

## Auth

The backend requires a Firebase ID token sent as `Authorization: Bearer <token>`
and only grants access to users whose Supabase role is `admin` or `super_admin`.
The web app obtains the token via the Firebase JS SDK and refreshes it on 401.
Non-admins are redirected back to `/login`.

## Deploying to Vercel

1. Push this repo to GitHub.
2. In Vercel, import the repository.
3. Set **Root Directory** to `apps/admin_dashboard`.
4. Add the environment variables from `.env.example` (all `NEXT_PUBLIC_*`).
5. Deploy.
