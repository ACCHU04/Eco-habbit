"use client";

import { useCallback, useEffect, useState } from "react";
import { Pagination } from "@/components/pagination";
import { EmptyState, ErrorState, LoadingState } from "@/components/state-views";
import { api } from "@/lib/api";
import { formatDateTime, shortId, titleCase } from "@/lib/format";
import type { AuditEntry, Pagination as PaginationType } from "@/lib/types";

const PAGE_SIZE = 50;

const actionMeta: Record<string, { icon: string; tone: string }> = {
  change_role: { icon: "🛡", tone: "text-primary" },
  change_status: { icon: "⏻", tone: "text-warning" },
  delete_post: { icon: "📄", tone: "text-[#8b5cf6]" },
  delete_listing: { icon: "🛍", tone: "text-warning" },
  resolve_report_resolved: { icon: "🚩", tone: "text-info" },
  resolve_report_dismissed: { icon: "🚩", tone: "text-zinc-500" },
};

function actionTone(action: string): string {
  const match = Object.keys(actionMeta).find((k) => action.includes(k));
  return match ? actionMeta[match].tone : "text-ink-muted";
}

function actionIcon(action: string): string {
  if (action.includes("role")) return "🛡";
  if (action.includes("status")) return "⏻";
  if (action.includes("post")) return "📄";
  if (action.includes("listing")) return "🛍";
  if (action.includes("report")) return "🚩";
  return "🔒";
}

export default function AuditLogPage() {
  const [entries, setEntries] = useState<AuditEntry[]>([]);
  const [pagination, setPagination] = useState<PaginationType | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async (p: number) => {
    try {
      const res = await api.get<{ entries: AuditEntry[]; pagination: PaginationType }>(
        "/admin/audit-log",
        { page: p, limit: PAGE_SIZE },
      );
      setEntries(res.entries);
      setPagination(res.pagination);
      setError(null);
    } catch (e) {
      setEntries([]);
      setError(e instanceof Error ? e.message : "Failed to load audit log");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    let cancelled = false;
    api
      .get<{ entries: AuditEntry[]; pagination: PaginationType }>("/admin/audit-log", {
        page: 1,
        limit: PAGE_SIZE,
      })
      .then((res) => {
        if (cancelled) return;
        setEntries(res.entries);
        setPagination(res.pagination);
        setError(null);
      })
      .catch((e) => {
        if (cancelled) return;
        setEntries([]);
        setError(e instanceof Error ? e.message : "Failed to load audit log");
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, []);

  const retry = () => {
    setLoading(true);
    load(1);
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-ink">Audit Log</h1>
          <p className="mt-1 text-sm text-ink-muted">
            History of admin actions across the platform
          </p>
        </div>
        <button
          className="rounded-lg border border-line px-4 py-2 text-sm font-medium text-ink transition-colors hover:bg-surface-2"
          onClick={retry}
        >
          ↻ Refresh
        </button>
      </div>

      <div className="overflow-hidden rounded-xl border border-line bg-white shadow-sm">
        {loading ? (
          <LoadingState label="Loading audit log…" />
        ) : error ? (
          <ErrorState message={error} onRetry={retry} />
        ) : entries.length === 0 ? (
          <EmptyState title="No audit entries yet" subtitle="Admin actions will appear here." />
        ) : (
          <>
            <ul className="divide-y divide-line">
              {entries.map((e) => (
                <li key={e.id} className="flex items-start gap-4 px-4 py-3">
                  <span className={`mt-0.5 text-lg ${actionTone(e.action)}`}>
                    {actionIcon(e.action)}
                  </span>
                  <div className="min-w-0 flex-1">
                    <p className="text-sm font-semibold text-ink">
                      {titleCase(e.action)}
                    </p>
                    <p className="mt-0.5 text-xs text-ink-muted">
                      {titleCase(e.resource_type)} · {shortId(e.resource_id)}
                      {e.admin?.full_name ? ` · by ${e.admin.full_name}` : ""}
                    </p>
                    {e.reason ? (
                      <p className="mt-1 line-clamp-2 text-xs text-ink-muted">
                        {e.reason}
                      </p>
                    ) : null}
                  </div>
                  <span className="shrink-0 text-xs text-ink-muted">
                    {formatDateTime(e.created_at)}
                  </span>
                </li>
              ))}
            </ul>
            {pagination ? (
              <Pagination
                page={pagination.page}
                totalPages={pagination.total_pages}
                total={pagination.total}
                onPageChange={(p) => {
                  setLoading(true);
                  load(p);
                }}
              />
            ) : null}
          </>
        )}
      </div>
    </div>
  );
}
