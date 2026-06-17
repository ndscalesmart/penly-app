import { Resend } from "resend";

// Until a sending domain is verified in Resend, you can only send from
// onboarding@resend.dev (and only to your own account email). Once your
// domain is verified, set RESEND_FROM="Penly <hello@penly.co>".
const FROM = process.env.RESEND_FROM ?? "Penly <onboarding@resend.dev>";

// Best-effort: never throws. A failed/disabled email must not fail the signup.
export async function sendWaitlistConfirmation(email: string): Promise<void> {
  const key = process.env.RESEND_API_KEY;
  if (!key) {
    console.warn("[resend] RESEND_API_KEY not set — skipping confirmation email");
    return;
  }
  try {
    const resend = new Resend(key);
    await resend.emails.send({
      from: FROM,
      to: email,
      subject: "You're on the Penly waitlist 🎉",
      html: `
        <div style="font-family:system-ui,sans-serif;max-width:480px;margin:0 auto;padding:24px;color:#0F0D0A">
          <h1 style="font-size:28px;margin:0 0 8px">Pen<span style="color:#C9952A">ly</span></h1>
          <p style="font-size:18px;font-weight:600;margin:0 0 16px">You're on the list. 🎉</p>
          <p style="line-height:1.6;color:#7A6A56">
            Thanks for joining the Penly waitlist. We're building the all-in-one
            platform for founders, coaches, and expert creators to
            <strong>write, publish, and get paid</strong> — with 85% royalties.
          </p>
          <p style="line-height:1.6;color:#7A6A56">
            We'll email you the moment your access is ready.
          </p>
          <p style="margin-top:24px;color:#7A6A56">— The Penly team</p>
        </div>`,
    });
  } catch (e) {
    console.error("[resend] failed to send waitlist confirmation:", e);
  }
}
