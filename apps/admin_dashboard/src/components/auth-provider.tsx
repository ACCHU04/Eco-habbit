"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import {
  getCurrentUser,
  getIdToken,
  onAuthStateChanged,
  signInWithGoogle,
  signOutUser,
  isFirebaseConfigured,
  type User,
} from "@/lib/firebase";
import { setAuthToken, setTokenRefresher } from "@/lib/api";

interface AuthContextValue {
  user: User | null;
  /** True while we're still resolving the persisted session. */
  loading: boolean;
  configured: boolean;
  error: string | null;
  signIn: () => Promise<User | null>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setAuthToken(null);
    setTokenRefresher(async () => {
      const token = await getIdToken(true);
      if (token) setAuthToken(token);
      return token;
    });

    const unsubscribe = onAuthStateChanged(async (nextUser) => {
      setUser(nextUser);
      if (nextUser) {
        const token = await nextUser.getIdToken();
        setAuthToken(token);
      } else {
        setAuthToken(null);
      }
      setLoading(false);
    });

    return () => {
      unsubscribe();
      setTokenRefresher(null);
      setAuthToken(null);
    };
  }, []);

  const signIn = useCallback(async () => {
    setError(null);
    try {
      const u = await signInWithGoogle();
      const token = await u.getIdToken();
      setAuthToken(token);
      return u;
    } catch (e) {
      const msg = e instanceof Error ? e.message : "Google Sign-In failed";
      if (msg.includes("popup-closed")) {
        setError("Sign-in cancelled.");
      } else {
        setError(msg);
      }
      return null;
    }
  }, []);

  const signOut = useCallback(async () => {
    setAuthToken(null);
    await signOutUser();
    setUser(null);
  }, []);

  const value = useMemo<AuthContextValue>(
    () => ({
      user,
      loading,
      configured: isFirebaseConfigured(),
      error,
      signIn,
      signOut,
    }),
    [user, loading, error, signIn, signOut],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}

export { getCurrentUser };
