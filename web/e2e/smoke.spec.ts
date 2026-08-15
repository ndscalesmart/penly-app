import { test, expect } from "@playwright/test";

// Sprint 1 smoke coverage. Runs against placeholder Supabase credentials, so
// everything here is backend-independent: rendering, navigation, client-side
// validation, and middleware route protection.

test.describe("Landing page (PENLY-070)", () => {
  test("renders the hero and the primary calls to action", async ({ page }) => {
    await page.goto("/");

    await expect(
      page.getByRole("heading", { name: /Write It\. Publish It\./i }),
    ).toBeVisible();
    await expect(page.getByRole("link", { name: "Start Writing Free" })).toBeVisible();
    await expect(page.getByRole("link", { name: "Sign in" })).toBeVisible();
  });

  test("waitlist input is labelled and rejects a malformed email natively", async ({
    page,
  }) => {
    await page.goto("/");
    const email = page.getByLabel("Email address");

    await expect(email).toBeVisible();
    await email.fill("not-an-email");
    await page.getByRole("button", { name: "Join Waitlist" }).click();

    // Native constraint validation blocks submit — the form is still showing.
    await expect(page.getByRole("button", { name: "Join Waitlist" })).toBeVisible();
    await expect(email).toHaveJSProperty("validity.valid", false);
  });

  test("navigates to signup from the hero CTA", async ({ page }) => {
    await page.goto("/");
    await page.getByRole("link", { name: "Start Writing Free" }).click();

    await expect(page).toHaveURL(/\/signup$/);
    await expect(
      page.getByRole("heading", { name: "Create your account" }),
    ).toBeVisible();
  });
});

test.describe("Auth pages (PENLY-001 / PENLY-002)", () => {
  test("signup enforces the password rule in the browser", async ({ page }) => {
    await page.goto("/signup");

    await page.getByLabel("Full name").fill("Ada Lovelace");
    await page.getByLabel("Email").fill("ada@penly.co");
    await page.getByLabel("Password").fill("weakpass");
    await page.getByRole("button", { name: "Sign up" }).click();

    // Scoped to the form: Next's route announcer is also role="alert".
    await expect(page.locator("form").getByRole("alert")).toContainText(
      "Password needs 8+ chars, one uppercase letter, and a number.",
    );
  });

  test("both auth pages offer Google sign-in", async ({ page }) => {
    for (const path of ["/login", "/signup"]) {
      await page.goto(path);
      await expect(
        page.getByRole("button", { name: "Continue with Google" }),
      ).toBeVisible();
    }
  });

  test("login and signup cross-link to each other", async ({ page }) => {
    await page.goto("/login");
    await page.getByRole("link", { name: "Create one" }).click();
    await expect(page).toHaveURL(/\/signup$/);

    await page.getByRole("link", { name: "Sign in" }).click();
    await expect(page).toHaveURL(/\/login$/);
  });

  test("every auth input has an accessible name (WCAG 2.1 AA)", async ({ page }) => {
    await page.goto("/signup");

    for (const label of ["Full name", "Email", "Password"]) {
      await expect(page.getByLabel(label)).toBeVisible();
    }
  });
});

test.describe("Route protection (middleware)", () => {
  // The middleware refreshes the Supabase session and bounces anonymous
  // visitors. With no valid session cookie these must never render.
  for (const path of ["/dashboard", "/books", "/library", "/admin"]) {
    test(`redirects an anonymous visitor away from ${path}`, async ({ page }) => {
      await page.goto(path);

      await expect(page).toHaveURL(/\/login/);
    });
  }
});
