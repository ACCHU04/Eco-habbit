"use client";

import Link from "next/link";
import { useCallback, useEffect, useRef, useState } from "react";
import { Avatar } from "@/components/avatar";
import { RoleBadge, UserStatusBadge } from "@/components/badge";
import { Pagination } from "@/components/pagination";
import { SearchInput } from "@/components/search-input";
import { EmptyState, ErrorState, LoadingState } from "@/components/state-views";
import { api } from "@/lib/api";
import type { AdminUser, Pagination as PaginationType } from "@/lib/types";

type Filter = { label: string; role?: string; status?: string };

const FILTERS: Filter[] = [
  { label: "All" },
  { label: "Student", role: "student" },
  { label: "Moderator", role: "moderator" },
  { label: "Admin", role: "admin" },
  { label: "Suspended", status: "suspended" },
];

const PAGE_SIZE = 20;

export default function UsersPage() {
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [pagination, setPagination] = useState<PaginationType | null>(null);
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState<Filter>(FILTERS[0]);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const requestId = useRef(0);

  const load = useCallback(async (s: string, f: Filter, p: number) => {
    const id = ++requestId.current;
    try {
      const res = await api.get<{ users: AdminUser[]; pagination: PaginationType }>("/admin/users", {
        search: s,
        role: f.role,
        status: f.status,
        page: p,
        limit: PAGE_SIZE,
      });
      if (id !== requestId.current) return;
      setUsers(res.users);
      setPagination(res.pagination);
      setError(null);
    } catch (e) {
      if (id !== requestId.current) return;
      setUsers([]);
      setError(e instanceof Error ? e.message : "Failed to load users");
    } finally {
      if (id === requestId.current) setLoading(false);
    }
  }, []);

  useEffect(() => {
    const id = ++requestId.current;
    api
      .get<{ users: AdminUser[]; pagination: PaginationType }>("/admin/users", {
        search: "",
        role: undefined,
        status: undefined,
        page: 1,
        limit: PAGE_SIZE,
      })
      .then((res) => {
        if (id !== requestId.current) return;
        setUsers(res.users);
        setPagination(res.pagination);
        setError(null);
      })
      .catch((e) => {
        if (id !== requestId.current) return;
        setUsers([]);
        setError(e instanceof Error ? e.message : "Failed to load users");
      })
      .finally(() => {
        if (id === requestId.current) setLoading(false);
      });
  }, []);

  const applyFilters = (s: string, f: Filter, p: number) => {
    setLoading(true);
    setSearch(s);
    setFilter(f);
    setPage(p);
    load(s, f, p);
  };

  const retry = () => {
    setLoading(true);
    load(search, filter, page);
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-ink">User Management</h1>
          <p className="mt-1 text-sm text-ink-muted">
            Search, review and manage user accounts
          </p>
        </div>
        <button
          className="rounded-lg border border-line px-4 py-2 text-sm font-medium text-ink transition-colors hover:bg-surface-2"
          onClick={retry}
        >
          ↻ Refresh
        </button>
      </div>

      <div className="flex flex-col gap-3">
        <SearchInput
          initialValue={search}
          placeholder="Search users…"
          onDebouncedChange={(v) => applyFilters(v, filter, 1)}
        />
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
                onClick={() => applyFilters(search, f, 1)}
              >
                {f.label}
              </button>
            );
          })}
        </div>
      </div>

      <div className="overflow-hidden rounded-xl border border-line bg-white shadow-sm">
        {loading ? (
          <LoadingState label="Loading users…" />
        ) : error ? (
          <ErrorState message={error} onRetry={retry} />
        ) : users.length === 0 ? (
          <EmptyState
            title="No users found"
            subtitle="Try adjusting your search or filters."
          />
        ) : (
          <>
            <ul className="divide-y divide-line">
              {users.map((u) => (
                <li key={u.id}>
                  <Link
                    href={`/admin/users/${u.id}`}
                    className="flex items-center gap-3 px-4 py-3 transition-colors hover:bg-surface"
                  >
                    <Avatar name={u.full_name} photo={u.profile_photo} role={u.role} />
                    <div className="min-w-0 flex-1">
                      <p className="truncate text-sm font-semibold text-ink">
                        {u.full_name}
                      </p>
                      <p className="truncate text-xs text-ink-muted">
                        {u.email} · {u.college || "No college"}
                      </p>
                    </div>
                    <div className="hidden items-center gap-2 sm:flex">
                      <RoleBadge role={u.role} />
                      <UserStatusBadge status={u.status} />
                    </div>
                    <span className="text-ink-muted">›</span>
                  </Link>
                </li>
              ))}
            </ul>
            {pagination ? (
              <Pagination
                page={pagination.page}
                totalPages={pagination.total_pages}
                total={pagination.total}
                onPageChange={(p) => applyFilters(search, filter, p)}
              />
            ) : null}
          </>
        )}
      </div>
    </div>
  );
}
