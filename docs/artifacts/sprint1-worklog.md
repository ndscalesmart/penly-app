# Sprint 1 — Worklog
## Penly · Foundation & Authentication
**Sprint window:** Week 1–2 (per [sprintplan.md](./sprintplan.md))
**Status:** In progress
**Last updated:** 2026-06-16

This log records work completed, mapped to backlog tickets where applicable. Columns:
**Task / Objective** · **Feature / Resource** · **Approach**.

---

## Phase 1 — Planning & Scaffold · 2026-06-07

| Task / Objective | Feature / Resource | Approach |
|---|---|---|
| Decide scope & timeline | Roadmap analysis | Reviewed all 7 project `.md` docs; compared a compressed 45-day plan vs. the documented 16-week / 118-pt plan. **Decision: keep the full 16-week / 118-pt scope.** |
| De-risk the heaviest sprint | [sprint4-5-rebalance.md](./sprint4-5-rebalance.md) | Sprint 4 was overloaded (32 pts). Moved Stripe Connect + Download Library → S5, Publish → S3; S4 down to ~21–24 pts. No P0 milestone slips. |
| Make the backlog actionable | [github/](../../github/) import kit | Authored `create-issues.sh` (25 issues, 9 epic labels, P0–P3, point labels, 8 sprint milestones) + `issues.csv` fallback. Sprint assignments reflect the rebalance. |
| Stand up the app skeleton | `web/` — Next.js 15 + Supabase + Tailwind | Hand-built scaffold (App Router, TS). Applied "The Living Folio" design tokens (CSS vars + Tailwind theme) from the comprehensive doc. Playfair/DM Sans/DM Mono via `next/font`. |
| Auth foundation | PENLY-001 / PENLY-002 | `@supabase/ssr` cookie sessions. Email/password signup (8+/upper/number rule) + Google OAuth button + `/auth/callback` exchange. Lazy client init so static pages prerender without env. |
| Waitlist capture | PENLY-070 (partial) | Client `waitlist-form.tsx` inserts to `public.waitlist`; success + duplicate (`23505`) states. *(Confirmation email deferred — see Phase 2 backlog.)* |
| Route protection | Auth middleware | `middleware.ts` refreshes the Supabase session and guards `/dashboard`, `/books`, `/library`; redirects to `/login`. |
| Data layer | DB migrations (12 tables) | Authored schema from [data-model.md](./data-model.md), **FK-ordered** so it applies in one pass. Added RLS policies for every table + a `handle_new_user` trigger linking `auth.users` → `public.users` so `auth.uid() = id` holds. |
| Verify scaffold | `npm run build` | Build passes — 9 routes compiled, middleware bundled, static prerender green. Fixed implicit-`any` on Supabase cookie callbacks and lazy-inited the client to fix prerender. |

---

## Phase 2 — Supabase Provisioning & Verification · 2026-06-16

| Task / Objective | Feature / Resource | Approach |
|---|---|---|
| Create cloud backend | Supabase project `cqvcgzjbqgjcdgsorvgd` (West US / Oregon) | Wrote `.env.local` with project URL + anon key. |
| Make migrations CLI-compatible | `supabase/migrations/*` | Renamed `0001/0002` → 14-digit timestamp names (`20260607130000_init`, `20260607130100_rls_and_auth`) so the CLI recognizes them; also built `apply_all.sql` one-shot fallback. |
| Apply schema to cloud | `supabase db push` | After several link/auth false starts, authenticated the CLI, **linked** the project, and pushed both migrations. Confirmed via `supabase migration list` — both present Local **and** Remote (no drift). |
| Verify schema + RLS live | anon REST API | `GET /books` → `200 []` (tables exist). `POST /waitlist` (return=minimal) → `201` (anon INSERT policy works). Read-back blocked (no anon SELECT on waitlist — by design). Duplicate email → `409 23505` (UNIQUE enforced). |
| Enable social login | Google OAuth provider | Turned on in Supabase Auth → Providers; redirect `…/auth/callback`. |
| Verify waitlist end-to-end | PENLY-070 | Joined the waitlist from the UI. Confirmed **3 rows** via `supabase inspect db table-stats`; the submitted email is visible in Dashboard → Table Editor. |

---

## Phase 3 — Waitlist Email & Admin Portal · 2026-06-16

| Task / Objective | Feature / Resource | Approach |
|---|---|---|
| Close the waitlist loop | PENLY-070 (email) | Moved the join server-side: new `POST /api/waitlist` inserts the row and triggers a Resend confirmation email. Form now `fetch`es the route instead of inserting from the client, keeping the Resend key off the browser. Email send is best-effort (never fails the signup; no-ops if `RESEND_API_KEY` unset). |
| Stand up an admin area (none existed) | `/admin` portal | Built from scratch: `requireAdmin()` gate (auth + `users.role='admin'`), `/admin` waitlist table with live count, and `/admin/waitlist/export` CSV. Reads use a **service-role** client (`lib/supabase/admin.ts`, server-only) to bypass RLS. `/admin` added to middleware-protected prefixes; conditional "Admin" link on the dashboard. |
| Close a privilege-escalation hole | Migration `20260616120000` | The own-row UPDATE policy would have let a user self-set `role='admin'`. Added column-level GRANTs: authenticated users can update only non-privileged profile fields; `role`/`plan`/`royalty_rate`/Stripe/etc. are service-role-only. Applied via `supabase db push`. |
| Verify | `npm run build` | Passes — 11 routes incl. `/admin`, `/admin/waitlist/export`, `/api/waitlist`. |

**Pending to activate these features:** add `SUPABASE_SERVICE_ROLE_KEY` and `RESEND_API_KEY` to `.env.local`, and promote the first admin (see below).

### First-admin bootstrap
1. Sign up a normal account at `/signup`.
2. In Supabase → SQL Editor (service role, bypasses the column grants):
   ```sql
   update public.users set role = 'admin' where email = 'YOUR_EMAIL';
   ```
3. Reload `/dashboard` — an **Admin** link appears; `/admin` is now reachable.

---

## Phase 4 — Secrets Management · 2026-06-16

| Task / Objective | Feature / Resource | Approach |
|---|---|---|
| Stop storing secrets in plaintext `.env` | Strategy decision | Clarified that `NEXT_PUBLIC_*` (Supabase URL, anon key, Stripe publishable) are **public by design**, not secrets — only 4 values are truly sensitive (service-role, Resend, Anthropic, Stripe secret). **Chose Vercel Environment Variables as the source of truth** (encrypted, per-environment) over a committed/plaintext file. |
| Document the workflow | [web/SECRETS.md](../../web/SECRETS.md) | Runbook: which vars are secret, add them in Vercel (dashboard or `vercel env add`), and `vercel env pull .env.local` for local dev. The local file is gitignored and disposable; production never reads a file. Noted Doppler / 1Password `op run` as zero-plaintext upgrades. |
| Keep linkage out of git | [web/.gitignore](../../web/.gitignore) | Added `.vercel/`. |
| Wire it up | Vercel project | Ran `vercel login` + `vercel link`; added env vars; `vercel env pull`. |

**Open item:** `SUPABASE_SERVICE_ROLE_KEY` and `RESEND_API_KEY` were added to Production/Preview but not the **Development** scope, so `vercel env pull` (defaults to Development) didn't fetch them locally — admin + email stay inert locally until they're added to Development and re-pulled. Production is unaffected.

---

## Phase 5 — Standards Reconciliation & Test Harness · 2026-08-15

| Task / Objective | Feature / Resource | Approach |
|---|---|---|
| Fix a broken standards reference | [.architecture/DEVELOPMENT_STANDARDS.md](../../.architecture/DEVELOPMENT_STANDARDS.md) | `standard-practice.md` pointed at a file that did not exist. Authored it: working agreement (consent + no-guessing), stack, TS/React conventions, DB & RLS rules, secrets, git, testing, a11y, Definition of Done, deploy and debug procedure. Fixed the link path and the mis-numbered pre-deployment list. |
| Settle the branch strategy | `standard-practice.md` · DEVELOPMENT_STANDARDS §4 | Two docs conflicted: `dev → qa → uat → main` vs `feature/* → staging → main`. **Decision: `feature/* → staging → main`** — only one Supabase project exists, and four tiers buy nothing before real money is in the system. Revisit before Stripe (Sprint 4). |
| Make the test rule enforceable | Vitest + Testing Library + Playwright | No test framework existed, so "every new or changed function must have unit tests" was unenforceable. Added `vitest.config.mts` (jsdom, `@/` alias, v8 coverage) + `vitest.setup.ts`. JSX needed an explicit `oxc.jsx.runtime = "automatic"` — tsconfig's `jsx: "preserve"` leaves JSX untransformed for the runner. |
| Avoid shipping a known-vulnerable runner | `npm audit` | The first install pulled vitest 2.x (**critical** advisory) and a vite-5 chain via `@vitejs/plugin-react` + `vite-tsconfig-paths` (**high**). Moved to vitest 4.1.10 and dropped both packages — the alias is 3 lines of config, and the React plugin only provides Fast Refresh, which tests don't use. Both advisories cleared. |
| Cover the existing Sprint 1 logic | 30 unit/component tests | `api/waitlist/route.test.ts` (12) — validation, normalization, dupe-as-`23505`, error paths, and that email only sends on real inserts. `auth-form.test.tsx` (11) — password rule, OAuth redirect, error surfacing, login/signup differences, labelling. `auth.test.ts` (7) — `requireAdmin` gate, including that it **fails closed** on a missing row or RLS error. |
| Cover the flows end-to-end | `e2e/smoke.spec.ts` — 11 Playwright tests | Runs a production build on port 3100 with **placeholder** Supabase creds, so CI needs no secrets and creates no data: rendering, navigation, client-side validation, input labelling, and middleware protection of `/dashboard`, `/books`, `/library`, `/admin`. Live-credential flows are documented as guarded/skipped in [e2e/README.md](../../web/e2e/README.md). |
| One entry point, wired to CI | [scripts/run_tests.sh](../../scripts/run_tests.sh) · `ci.yml` | `run_tests.sh` runs typecheck → unit → e2e (`--unit` / `--e2e` to narrow); this is the path `standard-practice.md` already referenced. CI now also runs unit + e2e, triggers on `staging`, and uploads the Playwright report on failure. |
| Verify | `./scripts/run_tests.sh` | **Green — typecheck clean, 30 unit passed, 11 e2e passed.** |

**Flagged, not actioned (needs a decision):**
- Pre-existing **high** advisories in `next@15.1.4`, `postcss`, `sharp` — a Next upgrade is a separate call.
- `next build` warns it inferred the workspace root as `/Users/nducasse` because a stray `package-lock.json` sits in the home directory. Fixable via `outputFileTracingRoot` in `next.config.mjs`, or by removing that file.

---

## Sprint 1 ticket status

| Ticket | Story | Status |
|---|---|---|
| — | Project scaffold (Next + Supabase + Tailwind) | ✅ Done |
| — | Design system / tokens | ✅ Done |
| — | DB migrations + RLS | ✅ Done & applied to cloud |
| PENLY-001 | User Registration (email/password) | ✅ Code complete (needs end-to-end signup test) |
| PENLY-002 | Google OAuth | ✅ Code + provider enabled |
| PENLY-070 | Waitlist Email Capture | 🟡 Capture done & verified; **confirmation email pending** |
| PENLY-003 | Author Onboarding Wizard | ⬜ Stub (routes to dashboard) |
| — | CI/CD (GitHub Actions → Vercel) | ⬜ Not started (needs repo) |
| — | Sentry error monitoring | ⬜ Not started |

---

## Known gaps / follow-ups
- **Waitlist confirmation email (Resend)** — PENLY-070 acceptance criterion, not yet built.
- **No admin portal / admin credentials exist** — `role='admin'` is in the schema but there is no admin UI or admin user yet.
- **Google sign-in** depends on the provider config above; needs an end-to-end click-through test.
- **Test rows** in `waitlist` (`verify-*@penly.co`) from verification — safe to delete in Table Editor.
- **Secrets still empty** in `.env.local`: `SUPABASE_SERVICE_ROLE_KEY`, `ANTHROPIC_API_KEY`, Stripe keys, `RESEND_API_KEY`.
