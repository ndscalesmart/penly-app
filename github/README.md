# Penly — GitHub Issues Import Kit

Bootstraps the full 25-story backlog into GitHub Issues, with labels, point estimates,
priorities, and 8 sprint milestones. Sprint assignments reflect the
[Sprint 4/5 rebalance](../docs/artifacts/sprint4-5-rebalance.md).

## Option A — One command (recommended)

Uses the `gh` CLI to create labels, milestones, and all 25 issues with full
acceptance-criteria checklists.

```bash
# 1. Authenticate if you haven't
gh auth login

# 2. From inside your Penly repo:
chmod +x create-issues.sh
./create-issues.sh

# ...or target a specific repo:
REPO=your-org/penly ./create-issues.sh
```

Re-running is safe-ish: labels/milestones use `--force` / idempotent calls, but
**issues are NOT deduplicated** — running twice creates duplicate issues.

## Option B — CSV import

`issues.csv` is a flat summary (ticket, title, epic, priority, points, sprint).
Use it with a CSV→Issues tool such as
[`github-csv-tools`](https://github.com/gavinr/github-csv-tools), or import into
Linear/Notion/Jira. The CSV does **not** include the acceptance-criteria bodies —
use Option A for full issue bodies.

## What gets created

| Item | Count |
|------|-------|
| Issues | 25 |
| Milestones | 8 (Sprint 1–8) |
| Priority labels | P0, P1, P2, P3 |
| Epic labels | 9 (auth, editor, marketplace, payments, dashboard, marketing, profile, waitlist, admin) |
| Point labels | points:1/2/3/5/8/13 |

**Total: 118 story points** across the 25 stories.

## Verify

```bash
gh issue list --limit 30
gh issue list --label P0          # MVP-critical only
gh issue list --milestone "Sprint 1 — Foundation & Auth"
```
