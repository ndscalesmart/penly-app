import Link from "next/link";
import { WaitlistForm } from "@/components/waitlist-form";

// Landing placeholder — full marketing sections (Hero, HowItWorks, Features,
// Pricing) are built out in Sprint 6. Sprint 1 ships the hero + waitlist (PENLY-070).
export default function Home() {
  return (
    <main className="mx-auto flex min-h-screen max-w-3xl flex-col items-center justify-center gap-8 px-6 text-center">
      <nav className="absolute top-0 flex w-full max-w-3xl items-center justify-between px-6 py-6">
        <span className="font-display text-2xl font-bold">
          Pen<span className="text-gold">ly</span>
        </span>
        <Link
          href="/login"
          className="font-mono text-sm uppercase tracking-widest text-text-muted hover:text-ink"
        >
          Sign in
        </Link>
      </nav>

      <h1 className="animate-fade-up font-display text-5xl font-black leading-tight md:text-7xl">
        Write It. Publish It.
        <br />
        <span className="text-gold">Get Paid.</span>
      </h1>

      <p className="max-w-xl text-lg text-text-muted">
        The all-in-one publishing platform for founders, coaches, and expert
        creators. AI drafting, a curated marketplace, and 85% royalties.
      </p>

      <WaitlistForm />

      <Link
        href="/signup"
        className="rounded-full bg-ink px-8 py-3 font-sans font-medium text-cream transition-colors ease-folio hover:bg-gold"
      >
        Start Writing Free
      </Link>
    </main>
  );
}
