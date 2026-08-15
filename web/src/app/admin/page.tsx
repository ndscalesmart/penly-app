import Link from "next/link";
import { createAdminClient } from "@/lib/supabase/admin";

export const dynamic = "force-dynamic";

// Admin → Waitlist. Reads with the service-role key (bypasses RLS) so the
// team can see every signup. Gating is enforced by app/admin/layout.tsx.
export default async function AdminWaitlistPage() {
  let rows:
    | { email: string; source: string | null; created_at: string }[]
    | null = null;
  let count = 0;
  let setupError: string | null = null;

  try {
    const admin = createAdminClient();
    const res = await admin
      .from("waitlist")
      .select("email, source, created_at", { count: "exact" })
      .order("created_at", { ascending: false })
      .limit(500);
    rows = res.data ?? [];
    count = res.count ?? rows.length;
  } catch (e) {
    setupError =
      e instanceof Error ? e.message : "Failed to load waitlist.";
  }

  if (setupError) {
    return (
      <div className="rounded-xl border border-rust/30 bg-rust/5 p-6">
        <h1 className="font-display text-2xl font-bold">Setup needed</h1>
        <p className="mt-2 text-text-muted">{setupError}</p>
        <p className="mt-2 text-sm text-text-muted">
          Add <code>SUPABASE_SERVICE_ROLE_KEY</code> to{" "}
          <code>.env.local</code> (Supabase → Settings → API → service_role) and
          restart the dev server.
        </p>
      </div>
    );
  }

  return (
    <div>
      <header className="mb-8 flex items-end justify-between">
        <div>
          <p className="font-mono text-xs uppercase tracking-widest text-text-muted">
            Waitlist
          </p>
          <h1 className="font-display text-4xl font-bold">
            {count} signup{count === 1 ? "" : "s"}
          </h1>
        </div>
        <Link
          href="/admin/waitlist/export"
          className="rounded-lg bg-ink px-4 py-2 font-medium text-cream transition-colors ease-folio hover:bg-gold"
        >
          Export CSV
        </Link>
      </header>

      <div className="overflow-hidden rounded-xl border border-border">
        <table className="w-full text-left text-sm">
          <thead className="bg-cream font-mono text-xs uppercase tracking-widest text-text-muted">
            <tr>
              <th className="px-4 py-3">Email</th>
              <th className="px-4 py-3">Source</th>
              <th className="px-4 py-3">Joined</th>
            </tr>
          </thead>
          <tbody>
            {(rows ?? []).map((r) => (
              <tr key={r.email} className="border-t border-border">
                <td className="px-4 py-3">{r.email}</td>
                <td className="px-4 py-3 text-text-muted">{r.source ?? "—"}</td>
                <td className="px-4 py-3 text-text-muted">
                  {new Date(r.created_at).toLocaleString()}
                </td>
              </tr>
            ))}
            {(!rows || rows.length === 0) && (
              <tr>
                <td colSpan={3} className="px-4 py-8 text-center text-text-muted">
                  No signups yet.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
      {count > 500 && (
        <p className="mt-3 text-sm text-text-muted">
          Showing the 500 most recent. Use Export CSV for the full list.
        </p>
      )}
    </div>
  );
}
