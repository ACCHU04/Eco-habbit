export function Pagination({
  page,
  totalPages,
  total,
  onPageChange,
}: {
  page: number;
  totalPages: number;
  total: number;
  onPageChange: (page: number) => void;
}) {
  if (totalPages <= 1) {
    return total > 0 ? (
      <p className="px-4 py-3 text-center text-xs text-ink-muted">
        {total} result{total === 1 ? "" : "s"}
      </p>
    ) : null;
  }

  return (
    <div className="flex items-center justify-between border-t border-line px-4 py-3">
      <p className="text-xs text-ink-muted">
        Page {page} of {totalPages} · {total} total
      </p>
      <div className="flex gap-2">
        <button
          className="rounded-lg border border-line px-3 py-1.5 text-sm font-medium text-ink transition-colors hover:bg-surface-2 disabled:opacity-40"
          disabled={page <= 1}
          onClick={() => onPageChange(page - 1)}
        >
          Prev
        </button>
        <button
          className="rounded-lg border border-line px-3 py-1.5 text-sm font-medium text-ink transition-colors hover:bg-surface-2 disabled:opacity-40"
          disabled={page >= totalPages}
          onClick={() => onPageChange(page + 1)}
        >
          Next
        </button>
      </div>
    </div>
  );
}
