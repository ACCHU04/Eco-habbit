"use client";

import { useParams, useRouter } from "next/navigation";
import { useCallback, useEffect, useState } from "react";
import { Avatar } from "@/components/avatar";
import { RoleBadge, UserStatusBadge } from "@/components/badge";
import { ConfirmDialog } from "@/components/confirm-dialog";
import { ErrorState, LoadingState } from "@/components/state-views";
import { api } from "@/lib/api";
import { formatDate } from "@/lib/format";
import type { AdminUser } from "@/lib/types";

interface DialogState {
  title: string;
  description: string;
  confirmLabel: string;
  danger?: boolean;
  run: () => Promise<void>;
}

export default function UserDetailPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const [user, setUser] = useState<AdminUser | null>(null);
  const [currentRole, setCurrentRole] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [dialog, setDialog] = useState<DialogState | null>(null);
  const [toast, setToast] = useState<string | null>(null);

  const load = useCallback(async () => {
    try {
      const [u, me] = await Promise.all([
        api.get<AdminUser>(`/admin/users/${params.id}`),
        api.get<{ role: string }>("/users/me").catch(() => null),
      ]);
      setUser(u);
      setCurrentRole(me?.role ?? null);
      setError(null);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load user");
    } finally {
      setLoading(false);
    }
  }, [params.id]);

  useEffect(() => {
    let cancelled = false;
    Promise.all([
      api.get<AdminUser>(`/admin/users/${params.id}`),
      api.get<{ role: string }>("/users/me").catch(() => null),
    ])
      .then(([u, me]) => {
        if (cancelled) return;
        setUser(u);
        setCurrentRole(me?.role ?? null);
        setError(null);
      })
      .catch((e) => {
        if (cancelled) return;
        setError(e instanceof Error ? e.message : "Failed to load user");
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [params.id]);

  const retry = () => {
    setLoading(true);
    load();
  };

  useEffect(() => {
    if (!toast) return;
    const t = setTimeout(() => setToast(null), 3000);
    return () => clearTimeout(t);
  }, [toast]);

  if (loading) return <LoadingState label="Loading user…" />;
  if (error || !user) return <ErrorState message={error ?? "User not found"} onRetry={retry} />;

  const isSuperAdmin = currentRole === "super_admin";
  const canEditStatus = ["admin", "super_admin"].includes(currentRole ?? "");

  const mutateRole = (role: string) => {
    setDialog({
      title: `Change role to ${role.replaceAll("_", " ")}?`,
      description: "This change takes effect immediately.",
      confirmLabel: "Change Role",
      run: async () => {
        try {
          await api.put<{ message: string }>(`/admin/users/${user.id}/role`, {
            role,
          });
          setToast("Role updated");
          await load();
        } catch (e) {
          setToast(e instanceof Error ? e.message : "Failed to update role");
        } finally {
          setDialog(null);
        }
      },
    });
  };

  const mutateStatus = (status: string, danger = false) => {
    setDialog({
      title: `Mark user as ${status}?`,
      description:
        status === "deactivated"
          ? "This action is permanent and cannot be undone."
          : "This change takes effect immediately.",
      confirmLabel: `Mark ${status}`,
      danger,
      run: async () => {
        try {
          await api.put<{ message: string }>(`/admin/users/${user.id}/status`, {
            status,
          });
          setToast("Status updated");
          await load();
        } catch (e) {
          setToast(e instanceof Error ? e.message : "Failed to update status");
        } finally {
          setDialog(null);
        }
      },
    });
  };

  const roleActions: { label: string; icon: string; run: () => void }[] = [];
  if (isSuperAdmin && user.role !== "super_admin") {
    roleActions.push({
      label: user.role === "admin" ? "Promote to Super Admin" : "Promote to Admin",
      icon: "▲",
      run: () => mutateRole(user.role === "admin" ? "super_admin" : "admin"),
    });
  }
  if (isSuperAdmin && user.role === "admin") {
    roleActions.push({ label: "Demote to Moderator", icon: "▼", run: () => mutateRole("moderator") });
  }
  if (isSuperAdmin && user.role !== "student" && user.role !== "super_admin") {
    roleActions.push({ label: "Demote to Student", icon: "✕", run: () => mutateRole("student") });
  }

  const statusActions: { label: string; icon: string; danger?: boolean; run: () => void }[] = [];
  if (canEditStatus && user.status === "active") {
    statusActions.push({ label: "Suspend User", icon: "⏸", run: () => mutateStatus("suspended") });
    statusActions.push({ label: "Deactivate User", icon: "⛔", danger: true, run: () => mutateStatus("deactivated", true) });
  }
  if (canEditStatus && user.status === "suspended") {
    statusActions.push({ label: "Reactivate User", icon: "▶", run: () => mutateStatus("active") });
  }

  return (
    <div className="max-w-2xl space-y-8">
      <button
        onClick={() => router.push("/admin/users")}
        className="text-sm text-ink-muted transition-colors hover:text-ink"
      >
        ← Back to Users
      </button>

      <div className="flex flex-col items-center gap-3 rounded-xl border border-line bg-white p-6 shadow-sm">
        <Avatar name={user.full_name} photo={user.profile_photo} role={user.role} size={72} />
        <h1 className="text-xl font-bold text-ink">{user.full_name}</h1>
        <p className="text-sm text-ink-muted">{user.email}</p>
        <div className="flex gap-2">
          <RoleBadge role={user.role} />
          <UserStatusBadge status={user.status} />
        </div>
      </div>

      {roleActions.length > 0 || statusActions.length > 0 ? (
        <section>
          <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-ink-muted">
            Actions
          </h2>
          <div className="overflow-hidden rounded-xl border border-line bg-white shadow-sm">
            {roleActions.map((a) => (
              <button
                key={a.label}
                onClick={a.run}
                className="flex w-full items-center gap-3 border-b border-line px-4 py-3 text-left text-sm font-medium text-ink transition-colors hover:bg-surface"
              >
                <span className="text-primary">{a.icon}</span>
                {a.label}
              </button>
            ))}
            {statusActions.map((a) => (
              <button
                key={a.label}
                onClick={a.run}
                className={`flex w-full items-center gap-3 border-b border-line px-4 py-3 text-left text-sm font-medium transition-colors hover:bg-surface ${
                  a.danger ? "text-danger" : "text-warning"
                }`}
              >
                <span>{a.icon}</span>
                {a.label}
              </button>
            ))}
            {roleActions.length === 0 && statusActions.length === 0 ? (
              <p className="px-4 py-3 text-sm text-ink-muted">
                No actions available for this user.
              </p>
            ) : null}
          </div>
        </section>
      ) : null}

      <section>
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-ink-muted">
          Details
        </h2>
        <div className="divide-y divide-line rounded-xl border border-line bg-white shadow-sm">
          <DetailRow label="College" value={user.college} />
          <DetailRow label="Hostel" value={user.hostel} />
          <DetailRow label="Department" value={user.department} />
          <DetailRow label="Joined" value={formatDate(user.created_at)} />
          <DetailRow label="Status" value={user.status} />
          {user.stats ? (
            <>
              <DetailRow label="Total Points" value={String(user.stats.total_points)} />
              <DetailRow label="Posts" value={String(user.stats.posts_count)} />
              <DetailRow label="Listings" value={String(user.stats.listings_count)} />
            </>
          ) : null}
        </div>
      </section>

      <ConfirmDialog
        open={dialog !== null}
        title={dialog?.title ?? ""}
        description={dialog?.description}
        confirmLabel={dialog?.confirmLabel}
        danger={dialog?.danger}
        onCancel={() => setDialog(null)}
        onConfirm={() => dialog?.run()}
      />

      {toast ? (
        <div className="fixed bottom-4 right-4 z-50 rounded-lg bg-ink px-4 py-3 text-sm text-white shadow-lg">
          {toast}
        </div>
      ) : null}
    </div>
  );
}

function DetailRow({ label, value }: { label: string; value?: string | null }) {
  return (
    <div className="flex gap-4 px-4 py-3">
      <span className="w-28 shrink-0 text-sm text-ink-muted">{label}</span>
      <span className="text-sm text-ink">{value || "—"}</span>
    </div>
  );
}
