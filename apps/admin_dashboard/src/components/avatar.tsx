import { initials } from "@/lib/format";

const roleBg: Record<string, string> = {
  super_admin: "bg-warning text-white",
  admin: "bg-primary text-white",
  moderator: "bg-info text-white",
  organization: "bg-[#0d9488] text-white",
  ngo: "bg-success text-white",
};

export function Avatar({
  name,
  photo,
  role,
  size = 40,
}: {
  name?: string | null;
  photo?: string | null;
  role?: string | null;
  size?: number;
}) {
  const style = { width: size, height: size };
  if (photo) {
    return (
      // eslint-disable-next-line @next/next/no-img-element
      <img
        src={photo}
        alt={name ?? "avatar"}
        className="shrink-0 rounded-full object-cover"
        style={style}
      />
    );
  }
  return (
    <div
      className={`flex shrink-0 items-center justify-center rounded-full font-semibold ${role ? (roleBg[role] ?? "bg-surface-2 text-ink-muted") : "bg-surface-2 text-ink-muted"}`}
      style={{ ...style, fontSize: size * 0.42 }}
    >
      {initials(name ?? "?")}
    </div>
  );
}
