"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useAuth } from "./auth-provider";
import { Avatar } from "./avatar";

const navItems = [
  { href: "/admin", label: "Dashboard", icon: "▦" },
  { href: "/admin/users", label: "Users", icon: "👤" },
  { href: "/admin/reports", label: "Reports", icon: "🚩" },
  { href: "/admin/audit", label: "Audit Log", icon: "🕒" },
];

export function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();
  const { user, signOut } = useAuth();

  return (
    <aside className="flex w-16 shrink-0 flex-col border-r border-line bg-white md:w-60">
      <div className="flex items-center gap-2.5 px-4 py-5">
        <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-primary text-lg text-white">
          ♻
        </span>
        <div className="hidden md:block">
          <p className="text-sm font-bold leading-tight text-ink">EcoHabit</p>
          <p className="text-[11px] text-ink-muted">Admin Dashboard</p>
        </div>
      </div>

      <nav className="flex-1 space-y-1 px-2 py-2 md:px-3">
        {navItems.map((item) => {
          const active = pathname === item.href || pathname.startsWith(`${item.href}/`);
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
                active
                  ? "bg-primary/10 text-primary"
                  : "text-ink-muted hover:bg-surface-2 hover:text-ink"
              }`}
            >
              <span className="w-5 text-center text-base" aria-hidden>
                {item.icon}
              </span>
              <span className="hidden md:inline">{item.label}</span>
            </Link>
          );
        })}
      </nav>

      <div className="border-t border-line p-3">
        <div className="flex items-center gap-3">
          <Avatar
            name={user?.displayName}
            photo={user?.photoURL}
            role="admin"
            size={36}
          />
          <div className="hidden min-w-0 flex-1 md:block">
            <p className="truncate text-sm font-medium text-ink">
              {user?.displayName ?? "Admin"}
            </p>
            <p className="truncate text-[11px] text-ink-muted">{user?.email}</p>
          </div>
          <button
            aria-label="Sign out"
            title="Sign out"
            onClick={() => {
              signOut();
              router.push("/login");
            }}
            className="hidden rounded-lg p-2 text-ink-muted transition-colors hover:bg-surface-2 hover:text-ink md:block"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9" />
            </svg>
          </button>
        </div>
      </div>
    </aside>
  );
}
