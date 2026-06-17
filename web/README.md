# Penly — Web App (Sprint 1 scaffold)

Next.js 15 (App Router) + Supabase + Tailwind, implementing the **Sprint 1 — Foundation & Auth** slice of the [sprint plan](../docs/artifacts/sprintplan.md).

## What's already wired

| Sprint 1 story | Status in scaffold |
|---|---|
| Project scaffold (Next + Supabase + Tailwind) | ✅ done |
| Design system / tokens ("The Living Folio") | ✅ `globals.css` + `tailwind.config.ts` |
| DB migrations (all 12 tables from data model) | ✅ `supabase/migrations/0001_init.sql` |
| RLS policies + auth→profile trigger | ✅ `supabase/migrations/0002_rls_and_auth.sql` |
| PENLY-001 Registration (email/password) | ✅ `/signup` |
| PENLY-002 Google OAuth | ✅ button + `/auth/callback` |
| PENLY-070 Waitlist capture | ✅ landing page form |
| Protected routes (middleware) | ✅ `/dashboard` guarded |
| PENLY-003 Onboarding wizard | ⬜ stub — routes to dashboard for now |
| CI/CD (GitHub Actions → Vercel) | ⬜ add when repo is created |
| Sentry | ⬜ Sprint 1 checklist item |

## Setup

```bash
# 1. Install deps
cd penly-app/web
npm install

# 2. Configure env
cp .env.example .env.local
#    → fill in NEXT_PUBLIC_SUPABASE_URL + NEXT_PUBLIC_SUPABASE_ANON_KEY
```

### Run the database migrations

**Option A — Supabase cloud (fastest):**
Open your project's SQL Editor and run, in order:
1. `supabase/migrations/0001_init.sql`
2. `supabase/migrations/0002_rls_and_auth.sql`

**Option B — Supabase CLI (local Postgres in Docker):**
```bash
npm i -g supabase           # if not installed
supabase init               # if not already initialized
supabase start              # boots local stack
supabase db reset           # applies all migrations in ./supabase/migrations
```

### Enable Google OAuth
In Supabase → Authentication → Providers → Google, add your Google client ID/secret,
and set the redirect URL to `http://localhost:3000/auth/callback` (and your prod URL).

### Run the app
```bash
npm run dev      # http://localhost:3000
```

## Smoke test (Sprint 1 Definition of Done)
- [ ] Join the waitlist from `/` → row appears in `waitlist` table
- [ ] Sign up at `/signup` → `auth.users` + `public.users` rows created (trigger)
- [ ] Sign in at `/login` → redirected to `/dashboard`
- [ ] Visit `/dashboard` while logged out → redirected to `/login`
- [ ] "Continue with Google" completes and lands on `/dashboard`

## Stack notes
- **Auth:** `@supabase/ssr` cookie-based sessions; `cookies()` is async in Next 15.
- **Profiles:** `public.users.id` is FK-linked 1:1 to `auth.users.id`; the
  `handle_new_user` trigger provisions the profile row so RLS `auth.uid() = id` holds.
- **Design tokens** mirror `docs/penly-overview/penly-comprehensive-base44.md`.

## Next sprints
Track work via the [GitHub Issues kit](../github/README.md). Sprint 2 = book editor
(TipTap), Sprint 3 = AI drafting (Claude) + export, Sprint 4/5 = marketplace + Stripe
(see the [rebalance](../docs/artifacts/sprint4-5-rebalance.md)).
