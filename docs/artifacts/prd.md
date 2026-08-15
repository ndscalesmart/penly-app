# Product Requirements Document (PRD)
## Penly — The Expert Publishing Platform
**Version:** 1.0  
**Author:** Product Team  
**Status:** Draft  
**Last Updated:** April 10, 2026

---

## 1. Executive Summary

Penly is an all-in-one platform that empowers non-technical founders, coaches, consultants, and expert creators to transform their knowledge — workshops, courses, frameworks — into published books and e-books. Penly provides AI-assisted drafting, multi-format publishing, marketplace distribution, built-in marketing tools, and direct monetization with best-in-class royalty rates.

**Tagline:** Write It. Publish It. Get Paid.

---

## 2. Problem Statement

### The Gap in the Market

The self-publishing market exceeds $1 billion annually and is growing, yet expert creators face three compounding problems:

**Problem 1 — Creation friction.** Most experts have knowledge locked in workshops, slide decks, and notes. Turning that into a structured, publishable book requires either expensive ghostwriters or months of unguided effort.

**Problem 2 — Platform extraction.** Amazon KDP takes 30–65% of royalties. Gumroad charges transaction fees. No single platform handles writing, formatting, AND selling.

**Problem 3 — Distribution opacity.** Authors on existing platforms have no direct relationship with their readers, no email list ownership, and no marketing tools built in.

### Why Now

Generative AI has made it feasible to provide intelligent writing assistance at scale. The creator economy has normalized direct monetization. And an entire generation of expert founders — especially in the Black entrepreneurship space — is primed to monetize their IP.

---

## 3. Vision & Goals

### Vision
Become the go-to platform for expert creators to publish, distribute, and profit from their knowledge — owning their reader relationships and keeping the majority of their revenue.

### Success Metrics (12-month targets)
| Metric | Target |
|--------|--------|
| Waitlist signups | 2,500 |
| Registered authors (launch) | 500 |
| Published books | 750 |
| Gross Merchandise Volume (GMV) | $250,000 |
| Monthly Recurring Revenue | $15,000 |
| Author avg. monthly earnings | $300 |

---

## 4. Target Users

### Primary: The Expert Founder
- Non-technical founders with proprietary frameworks
- Coaches and consultants packaging their methodology
- Workshop/course creators looking for passive income
- Age 28–50, business-savvy, digitally fluent
- **Pain:** "I have the knowledge but I don't know how to turn it into a book, and I don't want to deal with Amazon."

### Secondary: The Aspiring Author
- First-time authors with no prior publishing experience
- Professionals building personal brands through books
- **Pain:** "Traditional publishing is gatekept and slow. I want to own my work."

### Reader / Buyer (Marketplace Customer)
- Entrepreneurs, founders, and learners seeking expert knowledge
- Prefers curated, practitioner-led content over academic texts
- Willing to pay a premium for actionable, experience-backed books

---

## 5. Core Features & Requirements

### 5.1 Authentication & Onboarding
**Priority: P0**

| Requirement | Details |
|-------------|---------|
| Email/password signup | Standard registration with email verification |
| Google OAuth | One-click sign in with Google |
| Onboarding flow | 3-step wizard: profile setup → plan selection → first book prompt |
| Author username | Sets public store URL (penly.co/@username) |

### 5.2 Book Editor
**Priority: P0**

| Requirement | Details |
|-------------|---------|
| Rich text editor | TipTap-based WYSIWYG with headings, lists, bold/italic, tables |
| Manuscript autosave | Saves every 30 seconds to prevent loss |
| Cover image upload | Drag-and-drop, JPG/PNG, auto-resize to 1600x2400px |
| Metadata management | Title, subtitle, description, category, tags, price |
| Format selection | Toggle: PDF e-book / ePub / Print-on-Demand |
| Chapter structure | Add/reorder/delete chapters in sidebar |
| Word count | Live word count display |

### 5.3 AI Drafting Assistant
**Priority: P0**

| Requirement | Details |
|-------------|---------|
| Paste-to-draft | User pastes workshop notes, bullet points, or outline |
| Claude API integration | Anthropic claude-sonnet-4-20250514 for generation |
| Streaming output | Response streams live into the editor |
| Tone controls | Formal / Conversational / Academic selector |
| Accept / Edit / Regenerate | Author controls final output |
| Chapter-level drafting | Draft one chapter at a time |

### 5.4 Publishing & Export
**Priority: P0**

| Requirement | Details |
|-------------|---------|
| PDF export | Clean, print-ready PDF with typography formatting |
| ePub export | Standard ePub 3.0 compatible with Kindle and iBooks |
| One-click publish | Sets book live on Penly marketplace |
| Unpublish / Archive | Author can take book down without deleting |
| ISBN assignment | Optional: Penly assigns ISBN for print titles (Pro+) |

### 5.5 Marketplace
**Priority: P0**

| Requirement | Details |
|-------------|---------|
| Book discovery page | Browse all published books with search + filter |
| Category filters | Business, Self-Help, Tech, Finance, Health, Other |
| Book detail page | Cover, description, ToC preview, author bio, reviews |
| Search | Full-text search across title, description, author |
| Ratings & reviews | 1–5 star with written review, verified purchase only |

### 5.6 Payments & Royalties
**Priority: P0**

| Requirement | Details |
|-------------|---------|
| Stripe Checkout | Buyer pays via Stripe-hosted checkout |
| Stripe Connect | Authors onboard as connected accounts for direct payouts |
| Royalty rates | Starter: 75% / Pro: 85% / Publisher: 90% |
| Payout schedule | Weekly automatic payouts to connected bank account |
| Revenue dashboard | Lifetime earnings, this month, per-book breakdown |
| Purchase library | Buyers access their purchased books anytime |

### 5.7 Marketing Suite
**Priority: P1**

| Requirement | Details |
|-------------|---------|
| Launch page builder | Form-based landing page per book, hosted at penly.co/book/slug |
| Email capture widget | Embeddable waitlist widget with JavaScript snippet |
| Discount codes | Create codes with % off, expiry, and usage limit |
| Pre-order mode | Collect payment before publish date |
| Social share | Auto-generated OG image per book for social sharing |

### 5.8 Analytics
**Priority: P1**

| Requirement | Details |
|-------------|---------|
| Sales dashboard | Revenue over time (7/30/90 day) with line chart |
| Book performance | Sales, views, conversion rate per title |
| Reader demographics | Geography, referral source |
| Email list stats | Waitlist/capture list size per book |

### 5.9 Author Public Profile
**Priority: P1**

| Requirement | Details |
|-------------|---------|
| Public store page | penly.co/@username — lists all published books |
| Author bio & avatar | Customizable profile with social links |
| Follow system | Readers follow authors for new release notifications |

---

## 6. Non-Functional Requirements

| Category | Requirement |
|----------|-------------|
| Performance | Page load < 2s (LCP), API response < 500ms p95 |
| Uptime | 99.9% availability SLA |
| Security | SOC2-ready: encryption at rest + in transit, row-level security |
| GDPR | Data export + deletion for EU users |
| Accessibility | WCAG 2.1 AA compliance |
| Mobile | Fully responsive — all core flows work on mobile |
| Scale | Designed to handle 10,000 concurrent users at launch |

---

## 7. Out of Scope (v1)

- Native iOS/Android apps
- Audio book support
- Multi-language support (English only at launch)
- Amazon KDP integration
- Co-authoring mode
- Subscription reader model

---

## 8. Dependencies

| Dependency | Purpose |
|------------|---------|
| Anthropic Claude API | AI manuscript drafting |
| Stripe | Payments, Connect payouts |
| Supabase | Auth, database, file storage |
| Resend | Transactional email |
| Google Fonts | Playfair Display, DM Sans, DM Mono |

---

## 9. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Low AI draft quality | Medium | High | Fine-tune prompts per category; allow full manual editing |
| Stripe Connect onboarding friction | Medium | Medium | Pre-fill author data; provide walkthrough docs |
| Low marketplace discovery | High | High | Launch with SEO-optimized pages; cross-promote author audiences |
| Copyright infringement by authors | Low | High | ToS requires author ownership; DMCA process in place |

---

## 10. Launch Plan

| Phase | Timeline | Milestone |
|-------|---------|-----------|
| Phase 0 — Build | Weeks 1–8 | MVP complete, internal testing |
| Phase 1 — Closed Beta | Weeks 9–10 | 50 authors from waitlist, feedback loop |
| Phase 2 — Open Beta | Week 11–12 | Public launch, InvestFest pitch exposure |
| Phase 3 — Growth | Month 4+ | Paid marketing, author referral program |
