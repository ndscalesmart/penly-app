# End-to-end tests

Playwright specs covering whole user flows. Run via `./scripts/run_tests.sh`
(or `npx playwright test` from `web/`).

## What runs without a backend

`playwright.config.ts` boots a production build with **placeholder Supabase
credentials**. Everything in `smoke.spec.ts` is backend-independent:

- page rendering and navigation
- client-side validation (password rule, native email validation)
- accessible names on every input
- middleware route protection — anonymous visitors bounced from
  `/dashboard`, `/books`, `/library`, `/admin`

This is what CI runs. It needs no secrets and creates no data.

## What needs real credentials

Flows that hit Supabase for real — completing a signup, verifying an email,
Google OAuth, admin access, and later Stripe checkout — need live credentials
and a **disposable test project**, never production.

Guard those specs so they skip cleanly when credentials are absent:

```ts
test.skip(
  !process.env.E2E_SUPABASE_URL,
  "needs a live test Supabase project",
);
```

Run them locally with:

```bash
vercel env pull .env.local        # from web/
E2E_SUPABASE_URL=... npx playwright test
```

**Never point these at production.** Signup specs create real user rows.
