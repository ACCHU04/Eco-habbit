"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/components/auth-provider";

export default function LoginPage() {
  const { user, loading, configured, error, signIn } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!loading && user) router.replace("/admin");
  }, [user, loading, router]);

  return (
    <div className="flex min-h-full items-center justify-center bg-surface px-4">
      <div className="w-full max-w-sm">
        <div className="flex flex-col items-center">
          <span className="flex h-16 w-16 items-center justify-center rounded-2xl bg-primary text-3xl text-white shadow-md">
            ♻
          </span>
          <h1 className="mt-4 text-3xl font-bold text-ink">EcoHabit</h1>
          <p className="mt-1 text-sm text-ink-muted">Admin Dashboard</p>
        </div>

        <div className="mt-8 rounded-xl border border-line bg-white p-6 shadow-sm">
          <p className="text-center text-sm text-ink-muted">
            Sign in with your Google account. Only accounts with the{" "}
            <span className="font-medium text-ink">admin</span> or{" "}
            <span className="font-medium text-ink">super admin</span> role can
            access this dashboard.
          </p>

          {error ? (
            <p className="mt-4 rounded-lg bg-danger/10 px-3 py-2 text-center text-sm text-danger">
              {error}
            </p>
          ) : null}

          {!configured ? (
            <p className="mt-4 rounded-lg bg-warning/10 px-3 py-2 text-center text-sm text-[#b45309]">
              Firebase web app is not configured. Add the{" "}
              <code className="rounded bg-surface-2 px-1">NEXT_PUBLIC_FIREBASE_*</code>{" "}
              environment variables and restart.
            </p>
          ) : (
            <button
              disabled={loading}
              onClick={async () => {
                const u = await signIn();
                if (u) router.replace("/admin");
              }}
              className="mt-5 flex h-12 w-full items-center justify-center gap-3 rounded-lg border border-line font-medium text-ink transition-colors hover:bg-surface-2 disabled:opacity-50"
            >
              <svg width="18" height="18" viewBox="0 0 48 48">
                <path fill="#FFC107" d="M43.6 20.1H42V20H24v8h11.3C33.7 32.7 29.2 36 24 36c-6.6 0-12-5.4-12-12s5.4-12 12-12c3.1 0 5.9 1.2 8 3l5.7-5.7C34 6.1 29.3 4 24 4 13 4 4 13 4 24s9 20 20 20 20-9 20-20c0-1.3-.1-2.6-.4-3.9z"/>
                <path fill="#FF3D00" d="m6.3 14.7 6.6 4.8C14.7 15.1 19 12 24 12c3.1 0 5.9 1.2 8 3l5.7-5.7C34 6.1 29.3 4 24 4 16.3 4 9.7 8.3 6.3 14.7z"/>
                <path fill="#4CAF50" d="M24 44c5.2 0 9.9-2 13.4-5.2l-6.2-5.2C29.2 35.1 26.7 36 24 36c-5.2 0-9.6-3.3-11.3-8l-6.5 5C9.5 39.6 16.2 44 24 44z"/>
                <path fill="#1976D2" d="M43.6 20.1H42V20H24v8h11.3c-.8 2.2-2.2 4.2-4.1 5.6l6.2 5.2C36.9 39.2 44 34 44 24c0-1.3-.1-2.6-.4-3.9z"/>
              </svg>
              Continue with Google
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
