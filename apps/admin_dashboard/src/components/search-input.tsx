"use client";

import { useRef, useState } from "react";

export function SearchInput({
  initialValue = "",
  placeholder,
  onDebouncedChange,
  onClear,
}: {
  initialValue?: string;
  placeholder?: string;
  onDebouncedChange: (value: string) => void;
  onClear?: () => void;
}) {
  const [text, setText] = useState(initialValue);
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);

  return (
    <div className="relative">
      <span className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-ink-muted">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <circle cx="11" cy="11" r="7" />
          <path d="m21 21-4.35-4.35" />
        </svg>
      </span>
      <input
        type="text"
        value={text}
        placeholder={placeholder}
        onChange={(e) => {
          setText(e.target.value);
          if (timer.current) clearTimeout(timer.current);
          timer.current = setTimeout(() => onDebouncedChange(e.target.value), 350);
        }}
        className="h-11 w-full rounded-full border border-line bg-surface-2 pl-10 pr-10 text-sm text-ink outline-none transition-colors focus:border-primary"
      />
      {text ? (
        <button
          aria-label="Clear search"
          className="absolute right-3 top-1/2 -translate-y-1/2 text-ink-muted hover:text-ink"
          onClick={() => {
            setText("");
            if (timer.current) clearTimeout(timer.current);
            onDebouncedChange("");
            onClear?.();
          }}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M18 6 6 18M6 6l12 12" />
          </svg>
        </button>
      ) : null}
    </div>
  );
}
