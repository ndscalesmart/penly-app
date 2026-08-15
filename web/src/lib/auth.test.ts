import { describe, it, expect, vi, beforeEach } from "vitest";

// `redirect()` throws in Next to halt rendering; emulate that so a test can
// prove execution actually stops rather than falling through to the next line.
class RedirectError extends Error {
  constructor(public to: string) {
    super(`NEXT_REDIRECT:${to}`);
  }
}

const redirect = vi.fn((to: string) => {
  throw new RedirectError(to);
});
const getUser = vi.fn();
const single = vi.fn();

vi.mock("next/navigation", () => ({
  redirect: (to: string) => redirect(to),
}));

vi.mock("@/lib/supabase/server", () => ({
  createClient: async () => ({
    auth: { getUser },
    from: () => ({ select: () => ({ eq: () => ({ single }) }) }),
  }),
}));

const { requireAdmin } = await import("./auth");

const ADMIN = { id: "u-1" };

describe("requireAdmin — authorization gate", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    getUser.mockResolvedValue({ data: { user: ADMIN } });
    single.mockResolvedValue({
      data: { role: "admin", full_name: "Ada", email: "ada@penly.co" },
    });
  });

  it("returns the user and profile for an admin", async () => {
    const result = await requireAdmin();

    expect(result.user).toEqual(ADMIN);
    expect(result.profile).toMatchObject({ role: "admin" });
    expect(redirect).not.toHaveBeenCalled();
  });

  it("sends an unauthenticated visitor to /login with a return path", async () => {
    getUser.mockResolvedValue({ data: { user: null } });

    await expect(requireAdmin()).rejects.toThrow("NEXT_REDIRECT");
    expect(redirect).toHaveBeenCalledWith("/login?redirect=/admin");
  });

  it("does not query the users table when unauthenticated", async () => {
    getUser.mockResolvedValue({ data: { user: null } });

    await expect(requireAdmin()).rejects.toThrow();
    expect(single).not.toHaveBeenCalled();
  });

  it.each([
    ["a standard author", "author"],
    ["an unknown role", "editor"],
  ])("redirects %s away from /admin", async (_label, role) => {
    single.mockResolvedValue({ data: { role } });

    await expect(requireAdmin()).rejects.toThrow("NEXT_REDIRECT");
    expect(redirect).toHaveBeenCalledWith("/dashboard");
  });

  it("redirects when the profile row is missing entirely", async () => {
    single.mockResolvedValue({ data: null });

    await expect(requireAdmin()).rejects.toThrow("NEXT_REDIRECT");
    expect(redirect).toHaveBeenCalledWith("/dashboard");
  });

  it("fails closed when the profile lookup errors", async () => {
    single.mockResolvedValue({ data: null, error: { message: "RLS denied" } });

    await expect(requireAdmin()).rejects.toThrow("NEXT_REDIRECT");
    expect(redirect).toHaveBeenCalledWith("/dashboard");
  });
});
