# Claude Code Instructions - Development

## Standards

Follow all standards in [DEVELOPMENT_STANDARDS.md](../../DEVELOPMENT_STANDARDS.md).

## Before Every Code Change

1. Read all and any relevant docs in order to receive updated comments on required task(s)
2. Read the file before modifying it
3. Every new or changed function must have unit tests

## Before Suggesting Deployment

1. Run pre-deployment test
2. Run full test suite: `./scripts/run_tests.sh`
3. Check relevant migrations — `supabase migration list` must show no Local/Remote drift
4. Confirm required env vars exist in the target Vercel scope

## After Every Code Change
1. Document work completed and update relevant docs

## When Debugging Production Issues

Always verify the service is running before investigating code.

## Infrastructure

- Deploy does `git pull` not `git reset --hard` — orphan files survive

## Git Workflow

*Decided 2026-08-15 — two tiers, not four. One Supabase project exists; extra
tiers buy nothing until real money is in the system. Revisit before Stripe goes
live in Sprint 4.*

- Never commit directly to `main` or `staging`
- Always use feature branches: `feature/<ticket>-<slug>`
- Promotion flow: `feature/*` → `staging` → `main`
- Hotfixes: `hotfix/*` → `main`, then back-merge to `staging`
- Push feature branches to `origin` daily — unpushed work is unbacked work
- Check for code drift before push and after deployment
