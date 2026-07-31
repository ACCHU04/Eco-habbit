"use client";

import { useCallback, useEffect, useState } from "react";
import { Avatar } from "@/components/avatar";
import { Badge, ReportStatusBadge } from "@/components/badge";
import { ConfirmDialog } from "@/components/confirm-dialog";
import { Pagination } from "@/components/pagination";
import { EmptyState, ErrorState, LoadingState } from "@/components/state-views";
import { api } from "@/lib/api";
import { formatDateTime, shortId, titleCase } from "@/lib/format";
import type { AdminReport, Pagination as PaginationType, ReportStatus } from "@/lib/types";

const FILTERS: { label: string; value?: ReportStatus }[] = [
  { label: "All" },
  { label: "Pending", value: "pending" },
  { label: "Resolved", value: "resolved" },
  { label: "Dismissed", value: "dismissed" },
];

const PAGE_SIZE = 20;

function contentTypeTone(type: string): string {
  if (type.includes("post")) return "bg-[#8b5cf6]/10 text-[#7c3aed] border-[#8b5cf6]/30";
  if (type.includes("listing")) return "bg-[#f59e0b]/10 text-[#b45309] border-[#f59e0b]/30";
  if (type.includes("comment")) return "bg-[#2563eb]/10 text-[#1d4ed8] border-[#2563eb]/30";
  return "bg-zinc-500/10 text-zinc-600 border-zinc-400/40";
}

export default function ReportsPage() {
  const [reports, setReports] = useState<AdminReport[]>([]);
  const [pagination, setPagination] = useState<PaginationType | null>(null);
  const [filter, setFilter] = useState<(typeof FILTERS)[number]>(FILTERS[0]);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [dialog, setDialog] = useState<{ reportId: string; status: ReportStatus } | null>(null);

  const load = useCallback(async (f: (typeof FILTERS)[number], p: number) => {
    try {
      const res = await api.get<{ reports: AdminReport[]; pagination: PaginationType }>(
        "/admin/reports",
        { status: f.value, page: p, limit: PAGE_SIZE },
      );
      setReports(res.reports);
      setPagination(res.pagination);
      setError(null);
    } catch (e) {
      setReports([]);
      setError(e instanceof Error ? e.message : "Failed to load reports");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    let cancelled = false;
    api
      .get<{ reports: AdminReport[]; pagination: PaginationType }>("/admin/reports", {
        status: undefined,
        page: 1,
        limit: PAGE_SIZE,
      })
      .then((res) => {
        if (cancelled) return;
        setReports(res.reports);
        setPagination(res.pagination);
        setError(null);
      })
      .catch((e) => {
        if (cancelled) return;
        setReports([]);
        setError(e instanceof Error ? e.message : "Failed to load reports");
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, []);

  const applyFilters = (f: (typeof FILTERS)[number], p: number) => {
    setLoading(true);
    setFilter(f);
    setPage(p);
    load(f, p);
  };

  const retry = () => {
    setLoading(true);
    load(filter, page);
  };

  const resolve = async () => {
    if (!dialog) return;
    try {
      await api.put<{ message: string }>(`/admin/reports/${dialog.reportId}`, {
        status: dialog.status,
      });
      setDialog(null);
      await load(filter, page);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update report");
      setDialog(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-ink">Reports</h1>
          <p className="mt-1 text-sm text-ink-muted">
            Review and moderate reported content
          </p>
        </div>
        <button
          className="rounded-lg border border-line px-4 py-2 text-sm font-medium text-ink transition-colors hover:bg-surface-2"
          onClick={retry}
        >
          ↻ Refresh
        </button>
      </div>

      <div className="flex flex-wrap gap-2">
        {FILTERS.map((f) => {
          const active = f === filter;
          return (
            <button
              key={f.label}
              className={`rounded-full px-4 py-2 text-sm font-medium transition-colors ${
                active
                  ? "bg-primary-container text-[#065f46]"
                  : "border border-line bg-white text-ink-muted hover:bg-surface-2"
              }`}
              onClick={() => applyFilters(f, 1)}
            >
              {f.label}
            </button>
          );
        })}
      </div>

      <div className="space-y-3">
        {loading ? (
          <LoadingState label="Loading reports…" />
        ) : error ? (
          <ErrorState message={error} onRetry={retry} />
        ) : reports.length === 0 ? (
          <EmptyState title="No reports found" subtitle="Nothing to review here." />
        ) : (
          reports.map((r) => (
            <div key={r.id} className="rounded-xl border border-line bg-white p-4 shadow-sm">
              <div className="flex flex-wrap items-center gap-2">
                <span className={`inline-flex items-center rounded-md border px-2 py-0.5 text-[11px] font-semibold ${contentTypeTone(r.content_type)}`}>
                  {titleCase(r.content_type)}
                </span>
                <Badge label={titleCase(r.reason)} tone="danger" />
                <div className="flex-1" />
                <ReportStatusBadge status={r.status} />
              </div>
              <p className="mt-3 flex items-center gap-2 text-sm text-ink-muted">
                <Avatar
                  name={r.reporter?.full_name}
                  photo={r.reporter?.profile_photo}
                  size={20}
                />
                Reported by {r.reporter?.full_name ?? "Unknown"} · {shortId(r.reporter_id)} ·{" "}
                {formatDateTime(r.created_at)}
              </p>
              {r.description ? (
                <p className="mt-2 line-clamp-3 text-sm text-ink">{r.description}</p>
              ) : null}
              {r.status === "pending" ? null : (
                <p className="mt-2 text-xs text-ink-muted">
                  Content: {shortId(r.content_id)}
                </p>
              )}
              {r.status === "pending" ? (
                <div className="mt-4 flex gap-3">
                  <button
                    className="flex-1 rounded-lg border border-line px-4 py-2 text-sm font-medium text-ink transition-colors hover:bg-surface-2"
                    onClick={() => setDialog({ reportId: r.id, status: "dismissed" })}
                  >
                    Dismiss
                  </button>
                  <button
                    className="flex-1 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-primary-dark"
                    onClick={() => setDialog({ reportId: r.id, status: "resolved" })}
                  >
                    Resolve
                  </button>
                </div>
              ) : null}
            </div>
          ))
        )}
      </div>

      {pagination ? (
        <Pagination
          page={pagination.page}
          totalPages={pagination.total_pages}
          total={pagination.total}
          onPageChange={(p) => applyFilters(filter, p)}
        />
      ) : null}

      <ConfirmDialog
        open={dialog !== null}
        title={dialog ? `${titleCase(dialog.status)} this report?` : ""}
        description="This action is recorded in the audit log."
        confirmLabel={dialog ? titleCase(dialog.status) : "Confirm"}
        onCancel={() => setDialog(null)}
        onConfirm={resolve}
      />
    </div>
  );
}
