"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/components/auth-provider";
import { LoadingState } from "@/components/state-views";

/** Redirects logged-in admins away from the login page. */
export default function Home() {
  const { user, loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (loading) return;
    router.replace(user ? "/admin" : "/login");
  }, [user, loading, router]);

  return <LoadingState />;
}
