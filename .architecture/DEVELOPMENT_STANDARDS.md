# Development Standards — Penly

**Status:** Active
**Last updated:** 2026-08-15
**Applies to:** everything under `penly-app/`

This is the document referenced by
[standard-practice.md](./docs/standard-practice/standard-practice.md). Where the
two disagree, this file wins for *how* code is written; `standard-practice.md`
wins for *workflow around* a change.

---

## 0. Working agreement

Penly is built as a studio collaboration.

- **No decisions without the product owner's consent.** Architecture, schema,
  dependencies, branch/deploy changes, and anything touching money or user data
  are proposed first, executed after approval.
- **No guessing.** A claim about the system's behavior is either verified
  (command run, file read, response observed) or stated as unverified. "It
  should work" is not a status.
- **Verify before concluding.** Debugging ends with evidence, not a plausible
  theory.

---

## 1. Stack (verified in repo)

| Layer | Choice | Notes |
|---|---|---|
| Framework | Next.js 15, App Router | React 19, TypeScript strict |
| Styling | Tailwind CSS 3 | "The Living Folio" tokens as CSS vars |
| Auth / DB / Storage | Supabase (`@supabase/ssr`) | Cookie sessions; RLS on every table |
| Email | Resend | Best-effort, never blocks a user action |
| AI | Anthropic Claude API | Sprint 3 — not yet integrated |
| Payments | Stripe + Connect | Sprint 4/5 — not yet integrated |
| Hosting | Vercel | Env vars are the source of truth for secrets |
| Tests | Vitest + Testing Library + Playwright | See §5 |

Adding a runtime dependency requires approval. Prefer the platform (Next.js,
Supabase, the standard library) over a new package.

---

## 2. Code conventions

**TypeScript**
- `strict` stays on. No `any` — use `unknown` and narrow. No `@ts-ignore`
  without a comment naming the reason.
- Explicit types on exported function signatures; inference is fine internally.

**Next.js / React**
- Server Components by default. `"use client"` only when the component needs
  state, effects, or browser APIs — and as far down the tree as possible.
- Route handlers return `NextResponse.json` with an explicit status.
- Never import a server-only module from a Client Component. Anything reading
  `SUPABASE_SERVICE_ROLE_KEY` lives in `src/lib/supabase/admin.ts` and is server-only.

**Naming & layout**
- Files kebab-case (`auth-form.tsx`), components PascalCase, functions camelCase.
- `src/app/` routes · `src/components/` shared UI · `src/lib/` logic and clients.

**Comments**
- Explain *why*, not *what*. Existing code comments cite the ticket
  (`// PENLY-070 — server-side waitlist join`) — keep that convention.

---

## 3. Database & security

- Every table has **RLS enabled** with explicit policies. A table without a
  policy is a bug, not a default-open convenience.
- **Privileged columns are service-role only.** `users.role`, `plan`,
  `royalty_rate`, and Stripe fields are protected by column-level GRANTs
  (migration `20260616120000`). Any new privileged column gets the same
  treatment in the same migration that adds it.
- Migrations are **append-only** and named `YYYYMMDDHHMMSS_description.sql` so
  the Supabase CLI orders them correctly. Never edit an applied migration —
  write a new one.
- Migrations must be **FK-ordered** so a fresh database applies in one pass.
- After `supabase db push`, confirm with `supabase migration list` that Local
  and Remote match. Drift is a blocker.

**Secrets** — full runbook in [web/SECRETS.md](../web/SECRETS.md).
- `NEXT_PUBLIC_*` values are public by design; RLS is the real guard.
- The four true secrets (`SUPABASE_SERVICE_ROLE_KEY`, `RESEND_API_KEY`,
  `ANTHROPIC_API_KEY`, `STRIPE_SECRET_KEY`/`STRIPE_WEBHOOK_SECRET`) live only in
  Vercel, scoped per environment. Never committed, never in a Client Component.
- Add every secret to **all three** Vercel scopes (Production, Preview,
  Development) or `vercel env pull` silently omits it locally.

---

## 4. Git & branching

**Decided 2026-08-15** — this supersedes the `dev → qa → uat → main` flow in the
original `standard-practice.md`. Rationale: one Supabase project exists; a
four-tier flow needs four environments and buys nothing before real money is in
the system.

```
main       →  Production   (Vercel production)
staging    →  Staging      (Vercel preview; sprint reviews happen here)
feature/*  →  PR into staging
hotfix/*   →  PR directly into main, then back-merge to staging
```

- Never commit directly to `main` or `staging`.
- Branch names: `feature/<sprint-or-ticket>-<slug>`, e.g.
  `feature/penly-003-onboarding-wizard`.
- Rebase or merge `staging` into your branch before opening a PR; no conflicts
  at review time.
- Push feature branches to `origin` daily. Work that exists only on one laptop
  is unbacked work.

**Revisit trigger:** before Stripe goes live (Sprint 4), reassess whether
`qa`/`uat` tiers are needed for payment testing.

**PRs require:** passing CI (typecheck, build, unit, e2e), a filled-in
[PR template](../.github/PULL_REQUEST_TEMPLATE.md), and product-owner approval.

---

## 5. Testing

`scripts/run_tests.sh` is the single entry point — it runs typecheck → unit →
e2e, and is what CI runs.

| Layer | Tool | Location | Covers |
|---|---|---|---|
| Unit | Vitest | `web/src/**/*.test.ts` | Pure logic: validation, formatting, royalty math |
| Component | Vitest + Testing Library | `web/src/**/*.test.tsx` | Rendering, user interaction, error and loading states |
| E2E | Playwright | `web/e2e/*.spec.ts` | Whole flows: signup, login, waitlist, later checkout |

**The rule:** every new or changed function ships with a test. Where that is
genuinely impractical (thin wrappers over a third-party SDK, pure JSX layout),
say so in the PR rather than skipping silently.

**What must always be tested**
- Auth and authorization gates (`requireAdmin`, middleware redirects)
- Anything validating user input
- Anything touching money, royalties, or payouts
- Anything that could leak another user's data

**Practices**
- Tests assert observable behavior, not implementation details. Query by role
  and label — the same handles a screen reader uses.
- Network calls are mocked at the module boundary (`vi.mock`). Unit tests never
  hit a live Supabase, Stripe, or Resend endpoint.
- A failing test is a blocker. Never `.skip` to get a merge through; fix it or
  revert the change.

---

## 6. Accessibility & responsiveness

Non-negotiable per the PRD (WCAG 2.1 AA):
- Every input has a label or `aria-label`. Every error message has `role="alert"`.
- Keyboard reachable, visible focus, logical tab order.
- Color is never the only signal.
- Verified at 375px, 768px, and 1280px before a story is Done.

---

## 7. Definition of Done

A story is Done when:

- [ ] Code peer-reviewed and merged to `staging`
- [ ] Unit tests written for new/changed logic; `./scripts/run_tests.sh` green
- [ ] Feature verified working in the staging environment
- [ ] No console errors or warnings in the browser
- [ ] Responsive at 375 / 768 / 1280px
- [ ] Accessible: labels, focus, ARIA where needed
- [ ] Error states handled (empty data, API failure, validation)
- [ ] Relevant docs updated — worklog entry at minimum
- [ ] Product owner has accepted the story

---

## 8. Before deployment

1. `./scripts/run_tests.sh` passes locally
2. `supabase migration list` shows no Local/Remote drift
3. Required env vars exist in the target Vercel scope
4. Deploy is `git pull`, not `git reset --hard` — orphaned files survive; check
   for drift after deploying

## 9. Debugging production

Verify the service is actually running before investigating code. Then reproduce
before theorizing, and confirm the fix with evidence — not by reasoning that it
should now work.

---

## 10. Documentation

- Every work session appends to the sprint worklog
  (`docs/artifacts/sprint<N>-worklog.md`) using the existing
  **Task / Objective · Feature / Resource · Approach** table format.
- Decisions that change direction get a dated doc in `.architecture/docs/`.
- Known gaps are written down, not remembered.
