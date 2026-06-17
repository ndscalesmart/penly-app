# Secrets management — Vercel as source of truth

Secrets live **encrypted in Vercel**, scoped per environment. Production reads
them directly (no file ever). For local dev, `vercel env pull` fetches a
**gitignored, disposable** `.env.local` — delete it any time and re-pull.

## What's actually secret

| Variable | Secret? | Notes |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | No | Public by design (ships in browser) |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | No | Public by design; RLS is the real guard |
| `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` | No | Public by design |
| `NEXT_PUBLIC_SITE_URL` | No | — |
| `SUPABASE_SERVICE_ROLE_KEY` | **Yes** | Bypasses RLS — server only |
| `RESEND_API_KEY` | **Yes** | — |
| `RESEND_FROM` | No | Just an address |
| `ANTHROPIC_API_KEY` | **Yes** | Sprint 3 |
| `STRIPE_SECRET_KEY` | **Yes** | Sprint 4 |
| `STRIPE_WEBHOOK_SECRET` | **Yes** | Sprint 4 |

The `NEXT_PUBLIC_*` values still need to exist in Vercel (build needs them) —
they're just not sensitive.

## One-time setup

```bash
cd penly-app/web
vercel login            # browser auth — token stays local
vercel link             # create/select the Penly Vercel project
```

## Add the variables (do this in Vercel, not in a file)

**Easiest — dashboard:** Vercel → your project → Settings → Environment
Variables → add each var, tick **Production**, **Preview**, and **Development**.

**Or CLI** (prompts for the value; nothing written to disk):
```bash
vercel env add SUPABASE_SERVICE_ROLE_KEY      # paste value, choose environments
vercel env add RESEND_API_KEY
# ...repeat for each
```

## Local development

```bash
vercel env pull .env.local   # regenerates the gitignored local file from Vercel
npm run dev
```

Re-run `vercel env pull` whenever you change a value in Vercel. The file is
disposable — it's never committed and can be deleted safely.

## Rules
- Never `git add` `.env*.local` or `.vercel/` (both gitignored).
- Rotate a key by changing it in Vercel, then `vercel env pull` again.
- `SUPABASE_SERVICE_ROLE_KEY` must only be imported by server code
  (`src/lib/supabase/admin.ts`) — never a Client Component.
