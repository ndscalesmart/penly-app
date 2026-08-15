import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

// Gate for admin-only server components and route handlers.
// Returns the admin's user + profile, or redirects: unauthenticated → /login,
// non-admin → /dashboard. `role` is read via RLS (a user can read their own row).
export async function requireAdmin() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login?redirect=/admin");

  const { data: profile } = await supabase
    .from("users")
    .select("role, full_name, email")
    .eq("id", user.id)
    .single();

  if (profile?.role !== "admin") redirect("/dashboard");
  return { user, profile };
}
