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
