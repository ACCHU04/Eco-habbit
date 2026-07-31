"use client";

import { config } from "./config";
import type { ApiEnvelope } from "./types";

export class ApiError extends Error {
  status: number;
  constructor(status: number, message: string) {
    super(message);
    this.name = "ApiError";
    this.status = status;
  }
}

let authToken: string | null = null;
let refreshTokenFn: (() => Promise<string | null>) | null = null;

export function setAuthToken(token: string | null): void {
  authToken = token;
}

/** Called on 401; should return a fresh ID token or null. */
export function setTokenRefresher(fn: (() => Promise<string | null>) | null): void {
  refreshTokenFn = fn;
}

async function parseError(res: Response): Promise<ApiError> {
  let message = `Request failed (${res.status})`;
  let code = res.status;
  try {
    const body = (await res.json()) as {
      error?: { code?: number; message?: string };
      message?: string;
    };
    if (body.error?.message) message = body.error.message;
    else if (body.message) message = body.message;
    if (body.error?.code) code = body.error.code;
  } catch {
    // Non-JSON body; keep default message.
  }
  return new ApiError(code, message);
}

async function request<T>(
  method: string,
  path: string,
  options: { body?: unknown; query?: Record<string, string | number | boolean | undefined> } = {},
  allowRetry = true,
): Promise<T> {
  const query = options.query ? `?${new URLSearchParams(
    Object.entries(options.query)
      .filter(([, v]) => v !== undefined && v !== "")
      .map(([k, v]) => [k, String(v)]),
  ).toString()}` : "";

  const res = await fetch(`${config.apiBaseUrl}${path}${query}`, {
    method,
    headers: {
      "Content-Type": "application/json",
      ...(authToken ? { Authorization: `Bearer ${authToken}` } : {}),
    },
    body: options.body !== undefined ? JSON.stringify(options.body) : undefined,
  });

  if (res.status === 401 && allowRetry && refreshTokenFn) {
    const fresh = await refreshTokenFn();
    if (fresh) return request<T>(method, path, options, false);
  }

  if (!res.ok) {
    throw await parseError(res);
  }

  const envelope = (await res.json()) as ApiEnvelope<T>;
  if (!envelope.success) {
    throw new ApiError(res.status, envelope.message ?? "Request failed");
  }
  return envelope.data;
}

export const api = {
  get<T>(path: string, query?: Record<string, string | number | boolean | undefined>): Promise<T> {
    return request<T>("GET", path, { query });
  },
  put<T>(path: string, body?: unknown): Promise<T> {
    return request<T>("PUT", path, { body });
  },
  post<T>(path: string, body?: unknown): Promise<T> {
    return request<T>("POST", path, { body });
  },
  delete<T>(path: string, query?: Record<string, string | number | boolean | undefined>): Promise<T> {
    return request<T>("DELETE", path, { query });
  },
};
