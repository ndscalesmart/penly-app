import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

// Protected author dashboard skeleton. Middleware already guards /dashboard,
// but we re-check on the server and load the profile row.
export default async function DashboardPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("users")
    .select("full_name, username, plan, role")
    .eq("id", user.id)
    .single();

  const name = profile?.full_name ?? user.email;

  return (
    <main className="mx-auto max-w-5xl px-6 py-12">
      <header className="mb-10 flex items-center justify-between">
        <div>
          <p className="font-mono text-xs uppercase tracking-widest text-text-muted">
            Dashboard
          </p>
          <h1 className="font-display text-4xl font-bold">Welcome, {name}</h1>
        </div>
        <div className="flex items-center gap-4">
          {profile?.role === "admin" && (
            <Link
              href="/admin"
              className="font-mono text-sm uppercase tracking-widest text-gold hover:text-ink"
            >
              Admin
            </Link>
          )}
          <form action="/auth/signout" method="post">
            <button className="font-mono text-sm uppercase tracking-widest text-text-muted hover:text-rust">
              Sign out
            </button>
          </form>
        </div>
      </header>

      <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
        {[
          ["Total Books", "0"],
          ["Total Revenue", "$0"],
          ["Sales This Month", "0"],
          ["Plan", profile?.plan ?? "starter"],
        ].map(([label, value]) => (
          <div key={label} className="rounded-xl border border-border bg-cream p-5">
            <p className="font-mono text-xs uppercase tracking-widest text-text-muted">
              {label}
            </p>
            <p className="mt-2 font-display text-3xl font-bold">{value}</p>
          </div>
        ))}
      </div>

      <p className="mt-12 text-text-muted">
        Your library is empty.{" "}
        <span className="text-gold">Create your first book →</span> (Book editor
        ships in Sprint 2.)
      </p>
    </main>
  );
}
