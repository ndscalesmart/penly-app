#!/usr/bin/env bash
#
# Penly — GitHub Issues bootstrap
# Creates labels, milestones (8 sprints), and all 25 backlog issues.
#
# Prereqs:
#   - gh CLI authenticated:  gh auth login
#   - Run from inside the target repo, OR set REPO below.
#
# Usage:
#   chmod +x create-issues.sh
#   ./create-issues.sh                 # uses current repo
#   REPO=owner/penly ./create-issues.sh
#
set -euo pipefail

REPO="${REPO:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"
echo "Target repo: $REPO"

label() { gh label create "$1" --repo "$REPO" --color "$2" --description "$3" --force >/dev/null 2>&1 || true; }

echo "==> Creating labels..."
# Priority
label "P0" "B60205" "Must ship in MVP (Sprints 1-4)"
label "P1" "D93F0B" "Ship before public launch (Sprints 5-6)"
label "P2" "FBCA04" "Post-launch enhancement"
label "P3" "0E8A16" "Future consideration"
# Epics
label "epic:auth"        "1D76DB" "Authentication & User Management"
label "epic:editor"      "1D76DB" "Book Editor"
label "epic:marketplace" "1D76DB" "Marketplace"
label "epic:payments"    "1D76DB" "Payments"
label "epic:dashboard"   "1D76DB" "Author Dashboard"
label "epic:marketing"   "1D76DB" "Marketing Suite"
label "epic:profile"     "1D76DB" "Author Public Profile"
label "epic:waitlist"    "1D76DB" "Waitlist & Marketing Site"
label "epic:admin"       "1D76DB" "Admin (Internal)"
# Points
for p in 1 2 3 5 8 13; do label "points:$p" "C5DEF5" "Story point estimate: $p"; done

echo "==> Creating milestones (Sprints 1-8)..."
milestone() {
  gh api "repos/$REPO/milestones" -f title="$1" -f description="$2" >/dev/null 2>&1 || true
}
milestone "Sprint 1 — Foundation & Auth"        "Wk 1-2: Dev env live"
milestone "Sprint 2 — Book Editor Core"          "Wk 3-4: Authors can write"
milestone "Sprint 3 — AI Drafting & Publishing"  "Wk 5-6: Authors can publish"
milestone "Sprint 4 — Marketplace & Payments"    "Wk 7-8: Readers can buy (rebalanced)"
milestone "Sprint 5 — Payouts, Dashboard & Beta" "Wk 9-10: Authors get paid (rebalanced)"
milestone "Sprint 6 — Marketing & Profiles"      "Wk 11-12: Public launch"
milestone "Sprint 7 — Polish & Hardening"        "Wk 13-14: Production-grade"
milestone "Sprint 8 — Growth Features (v1.1)"    "Wk 15-16: Retention & growth"

issue() {
  local title="$1"; local milestone="$2"; local labels="$3"; local body="$4"
  echo "  - $title"
  gh issue create --repo "$REPO" --title "$title" --milestone "$milestone" --label "$labels" --body "$body" >/dev/null
}

echo "==> Creating issues..."

# ---------------- EPIC 1: AUTH ----------------
issue "PENLY-001 — User Registration" "Sprint 1 — Foundation & Auth" "P0,epic:auth,points:3" \
"**As a** new visitor, **I want to** create an account with my email and password, **so that** I can access the platform as an author or reader.

### Acceptance Criteria
- [ ] Registration form accepts email, password, full name
- [ ] Password validation: min 8 chars, 1 uppercase, 1 number
- [ ] Email verification sent on signup
- [ ] Duplicate email shows error message
- [ ] Successful signup redirects to onboarding wizard
- [ ] User row created in \`users\` table with \`role: 'reader'\`

_Epic: Auth · Points: 3 · Priority: P0_"

issue "PENLY-002 — Google OAuth Login" "Sprint 1 — Foundation & Auth" "P0,epic:auth,points:2" \
"**As a** user, **I want to** sign in with my Google account, **so that** I don't have to remember a separate password.

### Acceptance Criteria
- [ ] \"Continue with Google\" button on login and signup pages
- [ ] First-time OAuth creates new user record
- [ ] Returning OAuth user logs in to existing account
- [ ] Profile picture pulled from Google account
- [ ] Redirect to dashboard on success

_Epic: Auth · Points: 2 · Priority: P0_"

issue "PENLY-003 — Author Onboarding Wizard" "Sprint 1 — Foundation & Auth" "P0,epic:auth,points:5" \
"**As a** newly registered user who wants to publish, **I want to** complete a guided setup, **so that** my profile and account are ready to publish.

### Acceptance Criteria
- [ ] Step 1: Set username (validates URL availability at penly.co/@username)
- [ ] Step 2: Add bio, avatar upload, optional website/social links
- [ ] Step 3: Plan selection (Starter, Pro, Publisher) — Starter auto-selected
- [ ] Skip option available on steps 2 and 3
- [ ] Completion sets \`role: 'author'\` on user record
- [ ] User lands on empty dashboard with \"Create your first book\" CTA

_Epic: Auth · Points: 5 · Priority: P0_"

issue "PENLY-004 — User Profile Settings" "Sprint 6 — Marketing & Profiles" "P1,epic:auth,points:3" \
"**As an** author, **I want to** edit my profile information, **so that** readers can learn about me on my public page.

### Acceptance Criteria
- [ ] Edit name, bio, avatar, website, social links
- [ ] Change email with re-verification flow
- [ ] Change password with current password confirmation
- [ ] Username change (max 2 changes per year)
- [ ] Changes saved with success confirmation

_Epic: Auth · Points: 3 · Priority: P1 · (moved S5→S6 per rebalance)_"

# ---------------- EPIC 2: EDITOR ----------------
issue "PENLY-010 — Create New Book" "Sprint 2 — Book Editor Core" "P0,epic:editor,points:3" \
"**As an** author, **I want to** create a new book project, **so that** I have a workspace to write and configure my book.

### Acceptance Criteria
- [ ] \"New Book\" button from dashboard
- [ ] Prompt for title (required) and category on creation
- [ ] Auto-generates URL slug from title
- [ ] Creates book record with \`status: 'draft'\`
- [ ] Redirects to book editor immediately

_Epic: Editor · Points: 3 · Priority: P0_"

issue "PENLY-011 — Rich Text Manuscript Editor" "Sprint 2 — Book Editor Core" "P0,epic:editor,points:8" \
"**As an** author, **I want to** write my manuscript in a clean editor, **so that** I can format my book professionally without knowing HTML.

### Acceptance Criteria
- [ ] TipTap editor with toolbar: H1/H2/H3, bold, italic, underline, lists, blockquote, link, image embed
- [ ] Chapter panel (left sidebar): add, rename, reorder, delete chapters
- [ ] Active chapter content loads in editor
- [ ] Live word count in bottom bar
- [ ] Autosave every 30 seconds (\"Saved\" / \"Saving...\" indicator)
- [ ] Unsaved changes warning on navigation away
- [ ] Full-screen / distraction-free mode toggle

_Epic: Editor · Points: 8 · Priority: P0_"

issue "PENLY-012 — Book Metadata Editor" "Sprint 2 — Book Editor Core" "P0,epic:editor,points:3" \
"**As an** author, **I want to** fill in my book's details, **so that** readers can find and understand my book in the marketplace.

### Acceptance Criteria
- [ ] Cover image upload (drag-and-drop, JPG/PNG, auto-cropped to 1600x2400)
- [ ] Title, subtitle, description fields
- [ ] Long description with basic rich text
- [ ] Category dropdown (Business, Self-Help, Tech, Finance, Health, Other)
- [ ] Tags input (max 10 tags)
- [ ] Price input USD (min \$0, max \$999)
- [ ] Format toggles: PDF / ePub / Print-on-Demand
- [ ] Metadata saved independently from manuscript

_Epic: Editor · Points: 3 · Priority: P0_"

issue "PENLY-013 — AI Drafting Assistant" "Sprint 3 — AI Drafting & Publishing" "P0,epic:editor,points:13" \
"**As an** author, **I want to** paste my workshop notes and get a book draft generated, **so that** I can go from raw ideas to a structured manuscript quickly.

### Acceptance Criteria
- [ ] \"AI Draft\" tab in editor panel
- [ ] Textarea accepts notes/outline/bullets (max 10,000 chars)
- [ ] Tone selector: Conversational / Professional / Academic
- [ ] Target audience field (optional)
- [ ] \"Generate Draft\" calls Claude API with streaming
- [ ] Streaming text displays in real time
- [ ] Token usage shown after generation
- [ ] Accept Draft / Regenerate / Discard controls
- [ ] AI draft session logged to \`ai_drafts\` table
- [ ] Error handling with retry option
- [ ] Pro/Publisher: unlimited drafts; Starter: 3/month

_Epic: Editor · Points: 13 · Priority: P0_"

issue "PENLY-014 — Export Book (PDF + ePub)" "Sprint 3 — AI Drafting & Publishing" "P0,epic:editor,points:8" \
"**As an** author, **I want to** export my book to PDF and ePub, **so that** I can distribute it to readers.

### Acceptance Criteria
- [ ] \"Export\" button in editor toolbar
- [ ] PDF export: Playfair Display typography, chapter page breaks, title page, ToC
- [ ] ePub export: valid ePub 3.0 for major e-readers
- [ ] Export progress indicator (10-30s)
- [ ] Download link delivered; file stored in Supabase Storage
- [ ] \`books.pdf_url\` and \`books.epub_url\` updated
- [ ] Re-export available after manuscript changes

_Epic: Editor · Points: 8 · Priority: P0_"

issue "PENLY-015 — Publish Book" "Sprint 3 — AI Drafting & Publishing" "P0,epic:editor,points:3" \
"**As an** author, **I want to** publish my book to the marketplace, **so that** readers can find and purchase it.

### Acceptance Criteria
- [ ] \"Publish\" enabled only when cover + title + price + ≥1 format export exists
- [ ] Pre-publish checklist: cover, description, price, content
- [ ] On confirm: \`status='published'\`, \`published_at=now\`
- [ ] Book appears in marketplace immediately
- [ ] Author emailed: \"Your book is live!\"
- [ ] \"Unpublish\" option reverts to draft

_Epic: Editor · Points: 3 · Priority: P0 · (moved S4→S3 per rebalance)_"

# ---------------- EPIC 3: MARKETPLACE ----------------
issue "PENLY-020 — Marketplace Browse Page" "Sprint 4 — Marketplace & Payments" "P0,epic:marketplace,points:5" \
"**As a** reader, **I want to** browse available books, **so that** I can discover expert knowledge to buy.

### Acceptance Criteria
- [ ] Grid of BookCards (cover, title, author, price, avg rating)
- [ ] Category filter pills
- [ ] Price range filter (Free / Under \$10 / \$10-\$25 / \$25+)
- [ ] Format filter (PDF / ePub / Print)
- [ ] Sort: Newest / Top Rated / Best Selling
- [ ] Pagination or infinite scroll (20/page)
- [ ] Empty state per filter

_Epic: Marketplace · Points: 5 · Priority: P0_"

issue "PENLY-021 — Book Search" "Sprint 4 — Marketplace & Payments" "P0,epic:marketplace,points:3" \
"**As a** reader, **I want to** search for books by keyword, **so that** I can find specific topics or authors.

### Acceptance Criteria
- [ ] Search bar in marketplace header
- [ ] Full-text search across title, subtitle, description, author name, tags
- [ ] Results update as user types (debounced 300ms)
- [ ] \"No results\" state with suggestions
- [ ] Search term highlighted in results

_Epic: Marketplace · Points: 3 · Priority: P0_"

issue "PENLY-022 — Book Detail Page" "Sprint 4 — Marketplace & Payments" "P0,epic:marketplace,points:5" \
"**As a** reader, **I want to** view full details of a book, **so that** I can decide whether to purchase.

### Acceptance Criteria
- [ ] Cover, title, subtitle, author name + avatar
- [ ] Description with \"Read more\" expand
- [ ] Price + format badges + \"Buy Now\"
- [ ] Table of contents preview (first 3 chapters)
- [ ] Author bio section with \"View profile\"
- [ ] Average rating + star breakdown
- [ ] Reviews listed (paginated, 10/page)
- [ ] \"Share\" button with OG image
- [ ] If purchased: \"Download\" replaces \"Buy Now\"

_Epic: Marketplace · Points: 5 · Priority: P0_"

issue "PENLY-023 — Write a Review" "Sprint 5 — Payouts, Dashboard & Beta" "P1,epic:marketplace,points:3" \
"**As a** reader who purchased a book, **I want to** leave a star rating and written review, **so that** other readers can make informed decisions.

### Acceptance Criteria
- [ ] \"Write a Review\" CTA (verified purchasers only)
- [ ] 1-5 star selector
- [ ] Optional title and body (min 20 chars if text provided)
- [ ] Submit creates \`reviews\` record with \`is_verified: true\`
- [ ] Review appears immediately
- [ ] Author email notification
- [ ] One review per book per user enforced

_Epic: Marketplace · Points: 3 · Priority: P1_"

# ---------------- EPIC 4: PAYMENTS ----------------
issue "PENLY-030 — Book Purchase Flow (Stripe)" "Sprint 4 — Marketplace & Payments" "P0,epic:payments,points:8" \
"**As a** reader, **I want to** purchase a book, **so that** I can access the content I want.

### Acceptance Criteria
- [ ] \"Buy Now\" opens Stripe Checkout
- [ ] Checkout shows title, cover, price, author
- [ ] Discount code field
- [ ] Payment succeeds → \`purchases\` + \`purchase_items\` records created
- [ ] Buyer receives email receipt
- [ ] Book added to buyer's library
- [ ] Author notified of sale
- [ ] \`books.total_sales\` / \`total_revenue\` incremented

_Epic: Payments · Points: 8 · Priority: P0_"

issue "PENLY-031 — Stripe Connect Onboarding" "Sprint 5 — Payouts, Dashboard & Beta" "P0,epic:payments,points:5" \
"**As an** author, **I want to** connect my bank account via Stripe, **so that** I can receive payouts from my book sales.

### Acceptance Criteria
- [ ] \"Set Up Payouts\" CTA in dashboard and settings
- [ ] Launches Stripe Connect onboarding
- [ ] On completion: \`stripe_account_id\` + \`stripe_onboarded: true\`
- [ ] Payout status badge: \"Payouts Active\"
- [ ] Authors without Stripe onboarding cannot publish (warning shown)

_Epic: Payments · Points: 5 · Priority: P0 · (moved S4→S5 per rebalance)_"

issue "PENLY-032 — Buyer Download Library" "Sprint 5 — Payouts, Dashboard & Beta" "P0,epic:payments,points:3" \
"**As a** buyer, **I want to** access all my purchased books, **so that** I can download them in the formats I paid for.

### Acceptance Criteria
- [ ] \`/library\` lists all purchased books
- [ ] Per book: cover, title, author, purchase date, format download buttons
- [ ] Download links are signed URLs (1hr expiry, re-generatable)
- [ ] Access kept forever
- [ ] Empty state: \"Your library is empty\"

_Epic: Payments · Points: 3 · Priority: P0 · (moved S4→S5 per rebalance)_"

issue "PENLY-033 — Discount Code Creation" "Sprint 5 — Payouts, Dashboard & Beta" "P1,epic:payments,points:3" \
"**As an** author, **I want to** create discount codes for my books, **so that** I can run promotions and reward my audience.

### Acceptance Criteria
- [ ] Discount code form in Marketing Hub
- [ ] Fields: code (auto-generate), type (% or fixed \$), value, applies to, expiry, max uses
- [ ] Validated: unique per author, alphanumeric, 4-20 chars
- [ ] Active codes listed with uses/max, expiry, status
- [ ] Deactivate instantly
- [ ] Applied at Stripe Checkout (Coupon API)

_Epic: Payments · Points: 3 · Priority: P1_"

# ---------------- EPIC 5: DASHBOARD ----------------
issue "PENLY-040 — Dashboard Overview" "Sprint 5 — Payouts, Dashboard & Beta" "P0,epic:dashboard,points:5" \
"**As an** author, **I want to** see my performance at a glance, **so that** I understand how my books are doing.

### Acceptance Criteria
- [ ] Stats cards: Total Books, Total Revenue, Sales This Month, Active Readers
- [ ] Revenue line chart (last 30 days)
- [ ] Books table: title, status, sales, revenue, published date
- [ ] Recent activity feed (last 10 events)
- [ ] Quick actions: New Book, View Store, Marketing
- [ ] Payouts section: pending balance, next payout date

_Epic: Dashboard · Points: 5 · Priority: P0_"

issue "PENLY-041 — Per-Book Analytics" "Sprint 6 — Marketing & Profiles" "P1,epic:dashboard,points:5" \
"**As an** author, **I want to** drill into analytics for each book, **so that** I can understand what's working.

### Acceptance Criteria
- [ ] Navigate from books table row
- [ ] Sales over time chart (7/30/90 days)
- [ ] Revenue over time chart
- [ ] Views vs conversions funnel
- [ ] Traffic sources
- [ ] Geographic distribution
- [ ] Reviews summary + rating distribution

_Epic: Dashboard · Points: 5 · Priority: P1 · (moved S5→S6 per rebalance)_"

# ---------------- EPIC 6: MARKETING ----------------
issue "PENLY-050 — Launch Page Builder" "Sprint 6 — Marketing & Profiles" "P1,epic:marketing,points:8" \
"**As an** author, **I want to** create a dedicated launch page for my book, **so that** I can drive pre-launch interest before publishing.

### Acceptance Criteria
- [ ] Form-based page builder (no drag-and-drop for MVP)
- [ ] Fields: headline, subheadline, cover, description, author name, CTA text
- [ ] Auto-publishes to penly.co/launch/[slug]
- [ ] Embeds email capture form
- [ ] Countdown timer (if pre-order set)
- [ ] Preview before publishing
- [ ] Basic analytics: views and signups

_Epic: Marketing · Points: 8 · Priority: P1_"

issue "PENLY-051 — Email Capture Widget" "Sprint 8 — Growth Features (v1.1)" "P1,epic:marketing,points:3" \
"**As an** author, **I want to** embed a waitlist widget on my own website, **so that** I can collect reader emails before launch.

### Acceptance Criteria
- [ ] Widget config: select book, CTA text, success message
- [ ] Generates embeddable \`<script>\` snippet
- [ ] Submits emails to author's book-specific list
- [ ] Author sees list with email, date, source
- [ ] Export list as CSV

_Epic: Marketing · Points: 3 · Priority: P1 · (moved S6→S8 per rebalance)_"

# ---------------- EPIC 7: PROFILE ----------------
issue "PENLY-060 — Public Author Profile Page" "Sprint 6 — Marketing & Profiles" "P1,epic:profile,points:5" \
"**As a** reader, **I want to** visit an author's profile page, **so that** I can see all their books and learn about them.

### Acceptance Criteria
- [ ] Public URL: penly.co/@username
- [ ] Author name, avatar, bio, social links
- [ ] Follower count
- [ ] All published books in a grid
- [ ] \"Follow\" button (logged-in readers)
- [ ] Follow stores to \`follows\` table; reader notified on new publish

_Epic: Profile · Points: 5 · Priority: P1_"

# ---------------- EPIC 8: WAITLIST ----------------
issue "PENLY-070 — Waitlist Email Capture" "Sprint 1 — Foundation & Auth" "P0,epic:waitlist,points:2" \
"**As a** marketing-site visitor, **I want to** join the Penly waitlist, **so that** I'm notified when the platform launches.

### Acceptance Criteria
- [ ] Email input + \"Join Waitlist\" on landing CTA
- [ ] Email stored to \`waitlist\` table
- [ ] Duplicate email shows \"You're already on the list!\"
- [ ] Success: \"You're on the list! 🎉\" + total count
- [ ] Confirmation email via Resend

_Epic: Waitlist · Points: 2 · Priority: P0_"

# ---------------- EPIC 9: ADMIN ----------------
issue "PENLY-080 — Admin Dashboard" "Sprint 8 — Growth Features (v1.1)" "P2,epic:admin,points:8" \
"Internal dashboard for the Penly team to monitor platform health.

### Acceptance Criteria
- [ ] Total users, books, purchases, GMV metrics
- [ ] User lookup by email
- [ ] Flag/remove books (content moderation)
- [ ] View waitlist + export CSV
- [ ] Impersonate user (with audit log)

_Epic: Admin · Points: 8 · Priority: P2_"

echo ""
echo "Done. Created 25 issues across 8 milestones."
echo "View: gh issue list --repo $REPO"
