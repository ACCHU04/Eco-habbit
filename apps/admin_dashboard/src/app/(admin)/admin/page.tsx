"use client";

import Link from "next/link";
import { useCallback, useEffect, useState } from "react";
import { StatCard } from "@/components/stat-card";
import { ErrorState, LoadingState } from "@/components/state-views";
import { api } from "@/lib/api";
import { titleCase } from "@/lib/format";
import type { DashboardStats } from "@/lib/types";

export default function DashboardPage() {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    try {
      setStats(await api.get<DashboardStats>("/admin/dashboard"));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load dashboard");
    }
  }, []);

  useEffect(() => {
    let cancelled = false;
    api
      .get<DashboardStats>("/admin/dashboard")
      .then((data) => {
        if (cancelled) return;
        setStats(data);
      })
      .catch((e) => {
        if (cancelled) return;
        setError(e instanceof Error ? e.message : "Failed to load dashboard");
      });
    return () => {
      cancelled = true;
    };
  }, []);

  const retry = () => {
    setError(null);
    load();
  };

  if (error) return <ErrorState message={error} onRetry={retry} />;
  if (!stats) return <LoadingState />;

  const breakdownEntries = Object.entries(stats.role_breakdown).filter(
    ([, count]) => count > 0,
  );

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-ink">Admin Dashboard</h1>
        <p className="mt-1 text-sm text-ink-muted">System-wide overview</p>
      </div>

      <section>
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-ink-muted">
          Overview
        </h2>
        <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
          <StatCard icon="👥" label="Total Users" value={stats.total_users} tone="primary" />
          <StatCard icon="📄" label="Total Posts" value={stats.total_posts} tone="info" />
          <StatCard
            icon="🚩"
            label="Pending Reports"
            value={stats.pending_reports}
            tone="warning"
          />
          <StatCard
            icon="🛍"
            label="Active Listings"
            value={stats.active_listings}
            tone="secondary"
          />
        </div>
      </section>

      <section>
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-ink-muted">
          Quick Actions
        </h2>
        <div className="grid gap-4 md:grid-cols-3">
          <Link
            href="/admin/users"
            className="flex items-center gap-4 rounded-xl border border-line bg-white p-4 shadow-sm transition-colors hover:border-primary"
          >
            <span className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-xl">
              👤
            </span>
            <div>
              <p className="font-medium text-ink">Manage Users</p>
              <p className="text-xs text-ink-muted">Search, roles &amp; status</p>
            </div>
          </Link>
          <Link
            href="/admin/reports"
            className="relative flex items-center gap-4 rounded-xl border border-line bg-white p-4 shadow-sm transition-colors hover:border-primary"
          >
            <span className="flex h-10 w-10 items-center justify-center rounded-lg bg-warning/10 text-xl">
              🚩
            </span>
            <div>
              <p className="font-medium text-ink">Reports</p>
              <p className="text-xs text-ink-muted">Review reported content</p>
            </div>
            {stats.pending_reports > 0 ? (
              <span className="absolute right-3 top-3 rounded-full bg-danger px-2 py-0.5 text-[11px] font-bold text-white">
                {stats.pending_reports}
              </span>
            ) : null}
          </Link>
          <Link
            href="/admin/audit"
            className="flex items-center gap-4 rounded-xl border border-line bg-white p-4 shadow-sm transition-colors hover:border-primary"
          >
            <span className="flex h-10 w-10 items-center justify-center rounded-lg bg-info/10 text-xl">
              🕒
            </span>
            <div>
              <p className="font-medium text-ink">Audit Log</p>
              <p className="text-xs text-ink-muted">Admin action history</p>
            </div>
          </Link>
        </div>
      </section>

      <section>
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-ink-muted">
          Role Breakdown
        </h2>
        {breakdownEntries.length === 0 ? (
          <p className="text-sm text-ink-muted">No users yet.</p>
        ) : (
          <div className="divide-y divide-line rounded-xl border border-line bg-white shadow-sm">
            {breakdownEntries.map(([role, count]) => (
              <div
                key={role}
                className="flex items-center justify-between px-4 py-3"
              >
                <span className="text-sm text-ink">{titleCase(role)}</span>
                <span className="text-sm font-semibold text-ink">{count}</span>
              </div>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}
