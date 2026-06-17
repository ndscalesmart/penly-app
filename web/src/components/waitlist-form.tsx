"use client";

import { useState } from "react";

// PENLY-070 — Waitlist Email Capture (posts to /api/waitlist, which inserts
// the row and sends a Resend confirmation email server-side).
export function WaitlistForm() {
  const [email, setEmail] = useState("");
  const [state, setState] = useState<"idle" | "loading" | "done" | "dupe" | "error">(
    "idle",
  );

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setState("loading");
    try {
      const res = await fetch("/api/waitlist", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });
      const data = (await res.json()) as { status?: string };
      if (data.status === "ok") setState("done");
      else if (data.status === "dupe") setState("dupe");
      else setState("error");
    } catch {
      setState("error");
    }
  }

  if (state === "done")
    return <p className="text-sage">You&apos;re on the list! 🎉</p>;
  if (state === "dupe")
    return <p className="text-text-muted">You&apos;re already on the list!</p>;

  return (
    <form onSubmit={onSubmit} className="flex w-full max-w-md gap-2">
      <input
        type="email"
        required
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        placeholder="you@example.com"
        aria-label="Email address"
        className="flex-1 rounded-full border border-border bg-cream px-5 py-3 text-ink placeholder:text-text-muted"
      />
      <button
        type="submit"
        disabled={state === "loading"}
        className="rounded-full bg-gold px-6 py-3 font-medium text-ink transition-colors ease-folio hover:bg-gold-light disabled:opacity-60"
      >
        {state === "loading" ? "..." : "Join Waitlist"}
      </button>
      {state === "error" && (
        <p className="text-rust" role="alert">
          Something went wrong.
        </p>
      )}
    </form>
  );
}
