# Sprint 4 / 5 Rebalance
## Fixing the overloaded Marketplace + Payments sprint
**Version:** 1.0
**Supersedes:** Sprint 4 & Sprint 5 tables in [sprintplan.md](./sprintplan.md)
**Last Updated:** June 7, 2026

---

## The problem

In the original [sprintplan.md](./sprintplan.md), **Sprint 4 carries 32 points** against a team velocity of ~20 pts/sprint — a 60% overcommit. The sprint plan itself flags this ("Sprint 4 is the heaviest. Consider moving PENLY-032 to Sprint 5 if needed."). Left as-is, Sprint 4 slips, and the slip cascades into the public-launch date.

Sprint 5 was light by comparison at 20 pts but front-loaded with P1 work that can absorb a P0 spillover.

---

## The fix

Move the buyer-facing, lower-coupling work out of Sprint 4 so the sprint focuses on the **revenue-critical path** (browse → buy → connect payouts). Defer one P1 story from Sprint 5 to keep Sprint 5 at a realistic load.

### Rebalanced Sprint 4 — Marketplace & Payments (revenue path)
**Goal:** A reader can discover a book and pay for it; an author can connect a payout account.
**Velocity Target:** 24 pts *(still above 20 — see mitigation)*

| Ticket | Story | Points | Priority | Why it stays in S4 |
|--------|-------|--------|----------|--------------------|
| PENLY-015 | Publish Book | 3 | P0 | Gates everything downstream |
| PENLY-020 | Marketplace Browse Page | 5 | P0 | Discovery is required to buy |
| PENLY-021 | Book Search | 3 | P0 | Discovery |
| PENLY-022 | Book Detail Page | 5 | P0 | The "buy" entry point |
| PENLY-030 | Book Purchase Flow (Stripe) | 8 | P0 | The revenue event |
| **Total** | | **24** | | |

### Rebalanced Sprint 5 — Payouts, Dashboard & Closed Beta
**Goal:** Authors get paid, see their numbers, and 50 beta authors are invited.
**Velocity Target:** 24 pts

| Ticket | Story | Points | Priority | Notes |
|--------|-------|--------|----------|-------|
| PENLY-031 | Stripe Connect Onboarding | 5 | P0 | **Moved from S4** — coupled to payouts, not checkout |
| PENLY-032 | Buyer Download Library | 3 | P0 | **Moved from S4** (per plan's own note) |
| PENLY-040 | Dashboard Overview | 5 | P0 | |
| PENLY-023 | Write a Review | 3 | P1 | |
| PENLY-033 | Discount Code Creation | 3 | P1 | |
| — | Closed beta invite system (invite codes) | 1 | P0 | |
| **Total** | | **20** | | |

### Spillover into Sprint 6
Two P1 stories move from Sprint 5 → Sprint 6 to make room:

| Ticket | Story | Points | Priority |
|--------|-------|--------|----------|
| PENLY-041 | Per-Book Analytics | 5 | P1 |
| PENLY-004 | User Profile Settings | 3 | P1 |

Sprint 6 was 18 pts; adding 8 makes it 26 — so push **PENLY-051 Email Capture Widget (3 pts, P1)** to the Sprint 8 growth bucket, leaving Sprint 6 at 23.

---

## Net effect

| Sprint | Before | After | Change |
|--------|--------|-------|--------|
| S4 | 32 | 24 | −8 |
| S5 | 20 | 20 | even |
| S6 | 18 | 23 | +5 |
| S8 | 20 | 23 | +3 |

No P0 work is dropped or delayed past its milestone — the buy/sell loop still completes by **end of Sprint 5 (Week 10)**, and public launch holds at **Week 12**.

---

## Remaining risk & mitigation

Even at 24 pts, **S4 and S5 run hot**. Options, in order of preference:

1. **Bring in a contractor for the Stripe work** (PENLY-030/031, 13 pts combined). Payments is the highest-risk, most self-contained block — ideal to outsource to a specialist for ~2 weeks.
2. **Pull PENLY-015 (Publish, 3 pts) forward into Sprint 3**, where the publish flow naturally follows export. This drops S4 to 21 pts.
3. **Accept a 1-week buffer** between S4 and S5 (explicit, planned — not a silent slip).

**Recommendation:** Do #2 (move Publish to S3, it belongs there) **and** budget for #1 if the Stripe sandbox work isn't progressing by mid-Sprint 4. That puts S4 at a clean 21 pts.
