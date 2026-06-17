import { requireAdmin } from "@/lib/auth";
import { createAdminClient } from "@/lib/supabase/admin";

// CSV export of the full waitlist. Admin-gated (re-checked here, not just in
// the layout, since route handlers don't inherit the layout guard).
function cell(v: unknown): string {
  const s = v == null ? "" : String(v);
  return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
}

export async function GET() {
  await requireAdmin();
  const admin = createAdminClient();
  const { data } = await admin
    .from("waitlist")
    .select("email, name, source, referrer, created_at")
    .order("created_at", { ascending: false });

  const rows = data ?? [];
  const header = "email,name,source,referrer,created_at\n";
  const body = rows
    .map((r) =>
      [r.email, r.name, r.source, r.referrer, r.created_at].map(cell).join(","),
    )
    .join("\n");

  return new Response(header + body, {
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": 'attachment; filename="penly-waitlist.csv"',
    },
  });
}
