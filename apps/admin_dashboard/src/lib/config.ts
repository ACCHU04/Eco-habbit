/**
 * Environment configuration. All values can be overridden via env vars.
 * See `.env.example`.
 */
export const config = {
  /** Base URL of the EcoHabit API (global prefix `/api/v1` already included). */
  apiBaseUrl:
    process.env.NEXT_PUBLIC_API_BASE_URL ??
    "https://eco-habbit.onrender.com/api/v1",

  firebase: {
    apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY ?? "",
    authDomain:
      process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN ?? "echo-habbit.firebaseapp.com",
    projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID ?? "echo-habbit",
    appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID ?? "",
  },
} as const;
