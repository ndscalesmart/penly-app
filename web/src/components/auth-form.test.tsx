import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

const push = vi.fn();
const signUp = vi.fn();
const signInWithPassword = vi.fn();
const signInWithOAuth = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({ push }),
}));

vi.mock("@/lib/supabase/client", () => ({
  createClient: () => ({
    auth: { signUp, signInWithPassword, signInWithOAuth },
  }),
}));

const { AuthForm } = await import("./auth-form");

// jsdom has no window.location.origin default worth relying on; the component
// reads it for the OAuth/verification redirect.
const origin = "http://localhost:3000";

async function fillSignup(password: string) {
  const user = userEvent.setup();
  await user.type(screen.getByLabelText("Full name"), "Ada Lovelace");
  await user.type(screen.getByLabelText("Email"), "ada@penly.co");
  await user.type(screen.getByLabelText("Password"), password);
  await user.click(screen.getByRole("button", { name: "Sign up" }));
  return user;
}

describe("AuthForm — signup (PENLY-001)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    signUp.mockResolvedValue({ error: null });
  });

  it.each([
    ["too short", "Ab1cdef"],
    ["no uppercase", "abcdefg1"],
    ["no number", "Abcdefgh"],
  ])("blocks a weak password (%s) before calling Supabase", async (_l, pw) => {
    render(<AuthForm mode="signup" />);
    await fillSignup(pw);

    expect(signUp).not.toHaveBeenCalled();
    expect(await screen.findByRole("alert")).toHaveTextContent(
      "Password needs 8+ chars, one uppercase letter, and a number.",
    );
  });

  it("accepts a password meeting all three rules", async () => {
    render(<AuthForm mode="signup" />);
    await fillSignup("Abcdefg1");

    expect(signUp).toHaveBeenCalledWith({
      email: "ada@penly.co",
      password: "Abcdefg1",
      options: {
        data: { full_name: "Ada Lovelace" },
        emailRedirectTo: `${origin}/auth/callback`,
      },
    });
  });

  it("routes to the dashboard on a successful signup", async () => {
    render(<AuthForm mode="signup" />);
    await fillSignup("Abcdefg1");

    expect(push).toHaveBeenCalledWith("/dashboard");
  });

  it("surfaces a Supabase signup error and does not navigate", async () => {
    signUp.mockResolvedValue({ error: { message: "User already registered" } });
    render(<AuthForm mode="signup" />);
    await fillSignup("Abcdefg1");

    expect(await screen.findByRole("alert")).toHaveTextContent(
      "User already registered",
    );
    expect(push).not.toHaveBeenCalled();
  });
});

describe("AuthForm — login", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    signInWithPassword.mockResolvedValue({ error: null });
  });

  it("does not enforce the signup password rule on login", async () => {
    const user = userEvent.setup();
    render(<AuthForm mode="login" />);
    await user.type(screen.getByLabelText("Email"), "ada@penly.co");
    await user.type(screen.getByLabelText("Password"), "old-weak-password");
    await user.click(screen.getByRole("button", { name: "Sign in" }));

    expect(signInWithPassword).toHaveBeenCalledWith({
      email: "ada@penly.co",
      password: "old-weak-password",
    });
    expect(screen.queryByRole("alert")).not.toBeInTheDocument();
  });

  it("shows no full-name field in login mode", () => {
    render(<AuthForm mode="login" />);

    expect(screen.queryByLabelText("Full name")).not.toBeInTheDocument();
  });

  it("surfaces invalid credentials as an alert", async () => {
    signInWithPassword.mockResolvedValue({
      error: { message: "Invalid login credentials" },
    });
    const user = userEvent.setup();
    render(<AuthForm mode="login" />);
    await user.type(screen.getByLabelText("Email"), "ada@penly.co");
    await user.type(screen.getByLabelText("Password"), "wrong");
    await user.click(screen.getByRole("button", { name: "Sign in" }));

    expect(await screen.findByRole("alert")).toHaveTextContent(
      "Invalid login credentials",
    );
    expect(push).not.toHaveBeenCalled();
  });
});

describe("AuthForm — Google OAuth (PENLY-002)", () => {
  beforeEach(() => vi.clearAllMocks());

  it("starts the Google flow with the callback redirect", async () => {
    const user = userEvent.setup();
    render(<AuthForm mode="signup" />);
    await user.click(screen.getByRole("button", { name: "Continue with Google" }));

    expect(signInWithOAuth).toHaveBeenCalledWith({
      provider: "google",
      options: { redirectTo: `${origin}/auth/callback` },
    });
  });
});

describe("AuthForm — accessibility", () => {
  it("labels every input (WCAG 2.1 AA)", () => {
    render(<AuthForm mode="signup" />);

    expect(screen.getByLabelText("Full name")).toBeInTheDocument();
    expect(screen.getByLabelText("Email")).toBeInTheDocument();
    expect(screen.getByLabelText("Password")).toBeInTheDocument();
  });
});
