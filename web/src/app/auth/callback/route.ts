import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// OAuth + email-verification callback: exchanges the code for a session,
// then redirects to the dashboard (or the originally requested page).
export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const redirect = searchParams.get("redirect") ?? "/dashboard";

  if (code) {
    const supabase = await createClient();
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) return NextResponse.redirect(`${origin}${redirect}`);
  }

  return NextResponse.redirect(`${origin}/login?error=auth`);
}
