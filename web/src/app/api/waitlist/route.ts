import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { sendWaitlistConfirmation } from "@/lib/resend";

// PENLY-070 — server-side waitlist join: insert + confirmation email.
// Moved server-side so the Resend key stays off the client and dupes are
// handled uniformly.
export async function POST(request: Request) {
  let email = "";
  try {
    const body = await request.json();
    email = String(body?.email ?? "").trim().toLowerCase();
  } catch {
    return NextResponse.json({ status: "error" }, { status: 400 });
  }

  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) {
    return NextResponse.json({ status: "error" }, { status: 400 });
  }

  const supabase = await createClient();
  const { error } = await supabase
    .from("waitlist")
    .insert({ email, source: "landing_page" });

  if (error) {
    if (error.code === "23505") return NextResponse.json({ status: "dupe" });
    console.error("[waitlist] insert failed:", error);
    return NextResponse.json({ status: "error" }, { status: 500 });
  }

  // Best-effort — does not block or fail the response.
  await sendWaitlistConfirmation(email);

  return NextResponse.json({ status: "ok" });
}
