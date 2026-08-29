"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Sidebar } from "@/components/sidebar";
import { useAuth } from "@/components/auth-provider";
import { LoadingState, ErrorState } from "@/components/state-views";
import { api, ApiError } from "@/lib/api";

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();
  const router = useRouter();
  const [verified, setVerified] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (loading) return;
    if (!user) {
      router.replace("/login");
      return;
    }
    let cancelled = false;
    api
      .get<{ total_users: number }>("/admin/dashboard")
      .then(() => {
        if (!cancelled) {
          setVerified(true);
          setError(null);
        }
      })
      .catch((e) => {
        if (cancelled) return;
        if (e instanceof ApiError && e.status === 403) {
          setError(
            "Your account does not have admin access. Please contact a super admin.",
          );
        } else {
          setError(e instanceof Error ? e.message : "Failed to verify admin access.");
        }
      });
    return () => {
      cancelled = true;
    };
  }, [user, loading, router]);

  if (loading || (user && !verified && !error)) {
    return <LoadingState label="Checking admin access…" />;
  }

  if (!user) return null;

  if (error) {
    return (
      <div className="flex min-h-full items-center justify-center p-4">
        <div className="w-full max-w-sm">
          <ErrorState message={error} />
        </div>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen">
      <Sidebar />
      <main className="min-w-0 flex-1">
        <div className="mx-auto w-full max-w-6xl px-4 py-6 md:px-8">{children}</div>
      </main>
    </div>
  );
}
