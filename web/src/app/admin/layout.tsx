import Link from "next/link";
import { requireAdmin } from "@/lib/auth";

export default async function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { profile } = await requireAdmin();

  return (
    <div className="min-h-screen">
      <header className="flex items-center justify-between border-b border-border bg-cream px-6 py-4">
        <div className="flex items-center gap-3">
          <Link href="/admin" className="font-display text-xl font-bold">
            Pen<span className="text-gold">ly</span>
          </Link>
          <span className="rounded-full bg-ink px-2 py-0.5 font-mono text-[10px] uppercase tracking-widest text-cream">
            Admin
          </span>
        </div>
        <div className="flex items-center gap-4 font-mono text-xs uppercase tracking-widest text-text-muted">
          <span>{profile?.email}</span>
          <Link href="/dashboard" className="hover:text-ink">
            Dashboard
          </Link>
        </div>
      </header>
      <main className="mx-auto max-w-5xl px-6 py-10">{children}</main>
    </div>
  );
}
