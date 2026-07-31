"use client";

import { initializeApp, getApps, getApp, type FirebaseApp } from "firebase/app";
import {
  getAuth,
  signInWithPopup,
  signOut,
  GoogleAuthProvider,
  type Auth,
  type User,
} from "firebase/auth";
import { config } from "./config";

let app: FirebaseApp | null = null;
let auth: Auth | null = null;

export function isFirebaseConfigured(): boolean {
  return Boolean(
    config.firebase.apiKey &&
      config.firebase.authDomain &&
      config.firebase.projectId &&
      config.firebase.appId,
  );
}

function getFirebaseApp(): FirebaseApp {
  if (!isFirebaseConfigured()) {
    throw new Error(
      "Firebase web app is not configured. Set NEXT_PUBLIC_FIREBASE_* env vars.",
    );
  }
  if (app) return app;
  app = getApps().length ? getApp() : initializeApp({ ...config.firebase });
  return app;
}

export function getFirebaseAuth(): Auth {
  if (!auth) auth = getAuth(getFirebaseApp());
  return auth;
}

export async function signInWithGoogle(): Promise<User> {
  const a = getFirebaseAuth();
  const provider = new GoogleAuthProvider();
  provider.addScope("email");
  provider.addScope("profile");
  const result = await signInWithPopup(a, provider);
  return result.user;
}

export async function signOutUser(): Promise<void> {
  if (auth) await signOut(auth);
}

export async function getCurrentUser(): Promise<User | null> {
  if (!auth) {
    try {
      getFirebaseAuth();
    } catch {
      return null;
    }
  }
  if (!auth) return null;
  return auth.currentUser;
}

export async function getIdToken(forceRefresh = false): Promise<string | null> {
  try {
    const a = getFirebaseAuth();
    const user = a.currentUser;
    if (!user) return null;
    return await user.getIdToken(forceRefresh);
  } catch {
    return null;
  }
}

export function onAuthStateChanged(
  callback: (user: User | null) => void,
): () => void {
  if (!isFirebaseConfigured()) {
    callback(null);
    return () => {};
  }
  return getFirebaseAuth().onAuthStateChanged(callback);
}

export type { User };
