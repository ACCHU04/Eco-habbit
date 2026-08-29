export function StatCard({
  icon,
  label,
  value,
  tone = "primary",
}: {
  icon: React.ReactNode;
  label: string;
  value: number | string;
  tone?: "primary" | "info" | "warning" | "success" | "secondary";
}) {
  const tones: Record<string, string> = {
    primary: "text-primary",
    info: "text-info",
    warning: "text-warning",
    success: "text-success",
    secondary: "text-[#0d9488]",
  };
  return (
    <div className="rounded-xl border border-line bg-white p-4 shadow-sm">
      <div className="flex items-start justify-between">
        <span className={`text-3xl ${tones[tone]}`}>{icon}</span>
      </div>
      <p className="mt-3 text-2xl font-bold text-ink">{value}</p>
      <p className="mt-1 text-xs text-ink-muted">{label}</p>
    </div>
  );
}
