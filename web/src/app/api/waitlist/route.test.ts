import { describe, it, expect, vi, beforeEach } from "vitest";

// Mocked at the module boundary — a unit test never touches live Supabase/Resend.
const insert = vi.fn();
const sendWaitlistConfirmation = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: async () => ({ from: () => ({ insert }) }),
}));

vi.mock("@/lib/resend", () => ({
  sendWaitlistConfirmation: (email: string) => sendWaitlistConfirmation(email),
}));

const { POST } = await import("./route");

function post(body: unknown) {
  return new Request("http://localhost/api/waitlist", {
    method: "POST",
    body: typeof body === "string" ? body : JSON.stringify(body),
  });
}

describe("POST /api/waitlist (PENLY-070)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    insert.mockResolvedValue({ error: null });
  });

  it("accepts a valid email and reports ok", async () => {
    const res = await POST(post({ email: "author@penly.co" }));

    expect(res.status).toBe(200);
    await expect(res.json()).resolves.toEqual({ status: "ok" });
    expect(insert).toHaveBeenCalledWith({
      email: "author@penly.co",
      source: "landing_page",
    });
  });

  it("normalizes email case and surrounding whitespace", async () => {
    await POST(post({ email: "  Author@Penly.CO  " }));

    expect(insert).toHaveBeenCalledWith({
      email: "author@penly.co",
      source: "landing_page",
    });
  });

  it("sends the confirmation email after a successful insert", async () => {
    await POST(post({ email: "author@penly.co" }));

    expect(sendWaitlistConfirmation).toHaveBeenCalledWith("author@penly.co");
  });

  it.each([
    ["missing @", "authorpenly.co"],
    ["missing domain dot", "author@penly"],
    ["empty", ""],
    ["whitespace only", "   "],
    ["embedded space", "author @penly.co"],
  ])("rejects an invalid email (%s) with 400", async (_label, email) => {
    const res = await POST(post({ email }));

    expect(res.status).toBe(400);
    expect(insert).not.toHaveBeenCalled();
  });

  it("rejects a malformed JSON body with 400", async () => {
    const res = await POST(post("not-json"));

    expect(res.status).toBe(400);
    expect(insert).not.toHaveBeenCalled();
  });

  it("reports a duplicate signup as 'dupe', not an error", async () => {
    insert.mockResolvedValue({ error: { code: "23505" } });

    const res = await POST(post({ email: "author@penly.co" }));

    expect(res.status).toBe(200);
    await expect(res.json()).resolves.toEqual({ status: "dupe" });
  });

  it("does not email on a duplicate signup", async () => {
    insert.mockResolvedValue({ error: { code: "23505" } });

    await POST(post({ email: "author@penly.co" }));

    expect(sendWaitlistConfirmation).not.toHaveBeenCalled();
  });

  it("returns 500 when the insert fails for any other reason", async () => {
    vi.spyOn(console, "error").mockImplementation(() => {});
    insert.mockResolvedValue({ error: { code: "42501", message: "denied" } });

    const res = await POST(post({ email: "author@penly.co" }));

    expect(res.status).toBe(500);
    expect(sendWaitlistConfirmation).not.toHaveBeenCalled();
  });
});
