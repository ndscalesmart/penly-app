"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

// PENLY-001 (registration) + PENLY-002 (Google OAuth).
// Onboarding wizard (PENLY-003) is a separate Sprint 1 story; new authors are
// routed to /dashboard here as a placeholder until the wizard lands.
export function AuthForm({ mode }: { mode: "login" | "signup" }) {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [fullName, setFullName] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const isSignup = mode === "signup";

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);
    const supabase = createClient();

    if (isSignup) {
      // Password rule (PENLY-001): min 8 chars, 1 uppercase, 1 number
      if (!/^(?=.*[A-Z])(?=.*\d).{8,}$/.test(password)) {
        setError("Password needs 8+ chars, one uppercase letter, and a number.");
        setLoading(false);
        return;
      }
      const { error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: { full_name: fullName },
          emailRedirectTo: `${location.origin}/auth/callback`,
        },
      });
      if (error) setError(error.message);
      else router.push("/dashboard");
    } else {
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });
      if (error) setError(error.message);
      else router.push("/dashboard");
    }
    setLoading(false);
  }

  async function withGoogle() {
    const supabase = createClient();
    await supabase.auth.signInWithOAuth({
      provider: "google",
      options: { redirectTo: `${location.origin}/auth/callback` },
    });
  }

  return (
    <main className="mx-auto flex min-h-screen max-w-md flex-col justify-center gap-6 px-6">
      <Link href="/" className="font-display text-2xl font-bold">
        Pen<span className="text-gold">ly</span>
      </Link>
      <h1 className="font-display text-3xl font-bold">
        {isSignup ? "Create your account" : "Welcome back"}
      </h1>

      <button
        onClick={withGoogle}
        className="rounded-lg border border-border bg-cream py-3 font-medium transition-colors ease-folio hover:border-gold"
      >
        Continue with Google
      </button>

      <div className="flex items-center gap-3 text-text-muted">
        <span className="h-px flex-1 bg-border" />
        <span className="font-mono text-xs uppercase tracking-widest">or</span>
        <span className="h-px flex-1 bg-border" />
      </div>

      <form onSubmit={onSubmit} className="flex flex-col gap-3">
        {isSignup && (
          <input
            required
            value={fullName}
            onChange={(e) => setFullName(e.target.value)}
            placeholder="Full name"
            aria-label="Full name"
            className="rounded-lg border border-border bg-cream px-4 py-3"
          />
        )}
        <input
          type="email"
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="Email"
          aria-label="Email"
          className="rounded-lg border border-border bg-cream px-4 py-3"
        />
        <input
          type="password"
          required
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          placeholder="Password"
          aria-label="Password"
          className="rounded-lg border border-border bg-cream px-4 py-3"
        />
        {error && (
          <p className="text-sm text-rust" role="alert">
            {error}
          </p>
        )}
        <button
          type="submit"
          disabled={loading}
          className="rounded-lg bg-ink py-3 font-medium text-cream transition-colors ease-folio hover:bg-gold disabled:opacity-60"
        >
          {loading ? "..." : isSignup ? "Sign up" : "Sign in"}
        </button>
      </form>

      <p className="text-center text-sm text-text-muted">
        {isSignup ? "Already have an account? " : "New to Penly? "}
        <Link href={isSignup ? "/login" : "/signup"} className="text-gold">
          {isSignup ? "Sign in" : "Create one"}
        </Link>
      </p>
    </main>
  );
}
