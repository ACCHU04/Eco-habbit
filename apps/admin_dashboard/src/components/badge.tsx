import { titleCase } from "@/lib/format";
import type { Role, UserStatus, ReportStatus } from "@/lib/types";

type Tone =
  | "primary"
  | "info"
  | "warning"
  | "danger"
  | "success"
  | "teal"
  | "grey";

const toneClasses: Record<Tone, string> = {
  primary:
    "bg-[#10b981]/10 text-[#047857] border-[#10b981]/30",
  info: "bg-[#2563eb]/10 text-[#1d4ed8] border-[#2563eb]/30",
  warning: "bg-[#f59e0b]/10 text-[#b45309] border-[#f59e0b]/30",
  danger: "bg-[#dc2626]/10 text-[#b91c1c] border-[#dc2626]/30",
  success: "bg-[#059669]/10 text-[#047857] border-[#059669]/30",
  teal: "bg-[#0d9488]/10 text-[#0f766e] border-[#0d9488]/30",
  grey: "bg-zinc-500/10 text-zinc-600 border-zinc-400/40",
};

export function Badge({
  label,
  tone = "grey",
  className = "",
}: {
  label: string;
  tone?: Tone;
  className?: string;
}) {
  return (
    <span
      className={`inline-flex items-center rounded-full border px-2.5 py-0.5 text-[11px] font-semibold tracking-wide ${toneClasses[tone]} ${className}`}
    >
      {label}
    </span>
  );
}

export function roleTone(role: string): Tone {
  switch (role) {
    case "super_admin":
      return "warning";
    case "admin":
      return "primary";
    case "moderator":
      return "info";
    case "organization":
      return "teal";
    case "ngo":
      return "success";
    default:
      return "grey";
  }
}

export function userStatusTone(status: string): Tone {
  switch (status) {
    case "active":
      return "success";
    case "suspended":
      return "warning";
    case "deactivated":
      return "danger";
    default:
      return "grey";
  }
}

export function reportStatusTone(status: string): Tone {
  switch (status) {
    case "pending":
      return "warning";
    case "resolved":
      return "success";
    case "dismissed":
      return "grey";
    default:
      return "grey";
  }
}

export function RoleBadge({ role }: { role: Role }) {
  return <Badge label={titleCase(role)} tone={roleTone(role)} />;
}

export function UserStatusBadge({ status }: { status: UserStatus }) {
  return (
    <Badge label={titleCase(status)} tone={userStatusTone(status)} />
  );
}

export function ReportStatusBadge({ status }: { status: ReportStatus }) {
  return (
    <Badge label={titleCase(status)} tone={reportStatusTone(status)} />
  );
}
