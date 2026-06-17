
I am applying for a pitch competition but I need a company idea. 

I recent create a 6 part workshop focused on how non-technical founders can commuter with developers. 

I want to either turn this into an e-book or publish it into a book. The company idea is to create a business that helps people create e books , publish books and distribute it through the platform. The platform is equipped with a marketing that help authors distribute and get paid through the platform. 

The application is due 4/10/26 at 11:59pm est time. 

I need a name and a website build for it 
 Provide thoughts on how you would improve and this idea. 

https://investfest.com/open-pitch-faqs/

Show more
9:05 PM

Fetched: Get Tickets
Fetched: Get Tickets
Great — I read the competition details. Here's what you need to know and my full plan:

Key competition facts: The winning startup receives a $125,000 investment for 7% equity, and the deadline is today, April 10, 2026. It must be a Delaware C Corp and is focused on early-stage tech founders. 
investfest

🏢 Company Name: Penly
"Write it. Publish it. Get Paid."

Tagline alternatives: Inkflow or Folio — but Penly is clean, memorable, and brand-ready.

💡 Idea Improvements
Your core idea is solid, but here's how to sharpen it for a $125K pitch:

1. Niche first, then expand. Start with non-technical founders & entrepreneurs (your workshop audience). This gives you a clear, defensible beachhead market before going broad.

2. Add AI-powered tools. Let authors paste raw notes or workshop content → Penly drafts it into a formatted e-book. This is your tech moat and what makes it a "tech company" for InvestFest's criteria.

3. The real money is distribution + royalties. Build a marketplace where readers can buy books directly. You take a platform cut (e.g., 15%). Authors get higher royalties than Amazon KDP (which takes 30–65%).

4. Community = retention. Add author communities, launch support, and co-marketing between authors on the platform.

5. Your workshop is your proof. Lead with: "I built a 6-part workshop, converted it to Penly, and here's what happened." That's real traction.

Now let me build the website. This will take a moment.


Viewed a file, created a file, read a file
Viewed a file, created a file, read a file
Here's your full breakdown:

🏷️ Company Name: Penly
Tagline: Write It. Publish It. Get Paid.

Clean, memorable, and feels like a natural brand — "pen" + the idea of a platform ("ly" like Spotify, Shopify, etc.).

🌐 Website
The landing page is live above. It includes a hero, how-it-works, full feature grid, pricing tiers, and a waitlist CTA.

💡 Key Improvements to Pitch
Your current idea is strong — here's how to make it pitch-winning:

1. Lead with your own story as traction. You built a 6-part workshop and needed this tool — that's the origin story investors love. "I was the first user."

2. Make AI your tech moat. The AI drafting feature (workshop notes → book) is what separates you from Gumroad or Lulu. That's your defensible edge.

3. Own your royalty angle. Amazon KDP takes 30–65%. Penly gives authors 85%. That's a clear, tangible reason to switch.

4. Define the market clearly for the pitch. The self-publishing market is $1B+ and growing. Non-technical founders, coaches, and consultants are an underserved niche within it.

5. InvestFest alignment. The Earn Your Leisure audience is your customer — Black entrepreneurs, wealth-builders, and creators who have knowledge worth monetizing. That's a powerful room to pitch this in.

Good luck tonight — deadline is 11:59 PM EST! 🔥


Penly
Code · HTML 
1) Create a mega Prompt that I can take and paste in Base44 or Lovable enhance this website.
2) Take the appropriate role and create a PRD, Datamodel, Backlog, and a sprintplan all in .md format that I can copy and paste to github.

10:22 PM

Reading the docx skill for document creation
Reading the docx skill for document creation
Now I'll create all four deliverables simultaneously. Let me build them all out.


Created 5 files, ran a command, read a file
Created 5 files, ran a command, read a file
All five files are ready. Here's what you have:

📦 What Was Delivered
1. MEGA_PROMPT_Penly.md — Paste this directly into Base44 or Lovable. It includes the full design system (colors, fonts, tokens), every page to build (9 pages), all components, the complete database schema, AI integration code, animations, responsive breakpoints, and stretch goals. It's written as a direct instruction to the AI builder.

2. PRD.md — Product Requirements Document covering the problem, vision, success metrics, target users, all feature requirements in table format, non-functional requirements, risks, and launch phases. Written from the perspective of a Product Manager.

3. DATA_MODEL.md — Full PostgreSQL schema with 12 tables, all indexes, foreign key relationships, Row Level Security policies for Supabase, business rules, and an ER diagram in text form. Copy and run straight in Supabase SQL editor.

4. BACKLOG.md — 25 user stories across 9 epics with priority levels (P0–P3), story point estimates, and full acceptance criteria with checkboxes. Ready to import into GitHub Issues, Linear, or Notion.

5. SPRINT_PLAN.md — 8-sprint (16-week) roadmap from zero to public launch, with per-sprint stories, velocity targets, technical notes, a global Definition of Done, branch/deployment strategy, and team ceremonies.

Good luck tonight — you've now got everything an investor would want to see a founding team produce. 🔥


Mega prompt penly
Document · MD 

Prd
Document · MD 

Data model
Document · MD 

Backlog
Document · MD 

Sprint plan
Document · MD 




Claude is AI and can make mistakes. Please double-check responses.
Backlog · MD
Copy

# Product Backlog
## Penly — Full Feature Backlog
**Version:** 1.0  
**Last Updated:** April 10, 2026  
**Format:** Epic > Story > Acceptance Criteria
 
---
 
## Priority Levels
- **P0** — Must ship in MVP (Sprints 1–4)
- **P1** — Ship before public launch (Sprints 5–6)
- **P2** — Post-launch enhancement
- **P3** — Future consideration
 
---
 
## Epic 1: Authentication & User Management
 
### PENLY-001 — User Registration
**Priority:** P0 | **Estimate:** 3 pts
 
**As a** new visitor,  
**I want to** create an account with my email and password,  
**So that** I can access the platform as an author or reader.
 
**Acceptance Criteria:**
- [ ] Registration form accepts email, password, full name
- [ ] Password validation: min 8 chars, 1 uppercase, 1 number
- [ ] Email verification sent on signup
- [ ] Duplicate email shows error message
- [ ] Successful signup redirects to onboarding wizard
- [ ] User row created in `users` table with `role: 'reader'`
 
---
 
### PENLY-002 — Google OAuth Login
**Priority:** P0 | **Estimate:** 2 pts
 
**As a** user,  
**I want to** sign in with my Google account,  
**So that** I don't have to remember a separate password.
 
**Acceptance Criteria:**
- [ ] "Continue with Google" button on login and signup pages
- [ ] First-time OAuth creates new user record
- [ ] Returning OAuth user logs in to existing account
- [ ] Profile picture pulled from Google account
- [ ] Redirect to dashboard on success
 
---
 
### PENLY-003 — Author Onboarding Wizard
**Priority:** P0 | **Estimate:** 5 pts
 
**As a** newly registered user who wants to publish,  
**I want to** complete a guided setup,  
**So that** my profile and account are ready to publish.
 
**Acceptance Criteria:**
- [ ] Step 1: Set username (validates URL availability at penly.co/@username)
- [ ] Step 2: Add bio, avatar upload, optional website/social links
- [ ] Step 3: Plan selection (Starter, Pro, Publisher) — Starter auto-selected
- [ ] Skip option available on steps 2 and 3
- [ ] Completion sets `role: 'author'` on user record
- [ ] User lands on empty dashboard with "Create your first book" CTA
 
---
 
### PENLY-004 — User Profile Settings
**Priority:** P1 | **Estimate:** 3 pts
 
**As an** author,  
**I want to** edit my profile information,  
**So that** readers can learn about me on my public page.
 
**Acceptance Criteria:**
- [ ] Edit name, bio, avatar, website, social links
- [ ] Change email with re-verification flow
- [ ] Change password with current password confirmation
- [ ] Username change (max 2 changes per year)
- [ ] Changes saved with success confirmation
 
---
 
## Epic 2: Book Editor
 
### PENLY-010 — Create New Book
**Priority:** P0 | **Estimate:** 3 pts
 
**As an** author,  
**I want to** create a new book project,  
**So that** I have a workspace to write and configure my book.
 
**Acceptance Criteria:**
- [ ] "New Book" button from dashboard
- [ ] Prompt for title (required) and category on creation
- [ ] Auto-generates URL slug from title
- [ ] Creates book record with `status: 'draft'`
- [ ] Redirects to book editor immediately
 
---
 
### PENLY-011 — Rich Text Manuscript Editor
**Priority:** P0 | **Estimate:** 8 pts
 
**As an** author,  
**I want to** write my manuscript in a clean editor,  
**So that** I can format my book professionally without knowing HTML.
 
**Acceptance Criteria:**
- [ ] TipTap editor with formatting toolbar: H1/H2/H3, bold, italic, underline, lists (ordered + unordered), blockquote, link, image embed
- [ ] Chapter panel on left sidebar: add, rename, reorder, delete chapters
- [ ] Active chapter content loads in editor
- [ ] Live word count shown in bottom bar
- [ ] Autosave every 30 seconds (visual indicator "Saved" / "Saving...")
- [ ] Unsaved changes warning on navigation away
- [ ] Full-screen / distraction-free mode toggle
 
---
 
### PENLY-012 — Book Metadata Editor
**Priority:** P0 | **Estimate:** 3 pts
 
**As an** author,  
**I want to** fill in my book's details,  
**So that** readers can find and understand my book in the marketplace.
 
**Acceptance Criteria:**
- [ ] Cover image upload (drag-and-drop, JPG/PNG, auto-cropped to 1600x2400)
- [ ] Title, subtitle, description fields
- [ ] Long description with basic rich text
- [ ] Category dropdown (Business, Self-Help, Tech, Finance, Health, Other)
- [ ] Tags input (max 10 tags)
- [ ] Price input with USD currency (minimum $0, maximum $999)
- [ ] Format toggles: PDF E-Book / ePub / Print-on-Demand
- [ ] All metadata saved independently from manuscript
 
---
 
### PENLY-013 — AI Drafting Assistant
**Priority:** P0 | **Estimate:** 13 pts
 
**As an** author,  
**I want to** paste my workshop notes and get a book draft generated,  
**So that** I can go from raw ideas to a structured manuscript quickly.
 
**Acceptance Criteria:**
- [ ] "AI Draft" tab in editor panel
- [ ] Textarea accepts pasted workshop notes, outline, or bullet points (max 10,000 chars)
- [ ] Tone selector: Conversational / Professional / Academic
- [ ] Target audience field (optional)
- [ ] "Generate Draft" button calls Claude API with streaming
- [ ] Streaming text displays in real time with cursor animation
- [ ] Token usage shown after generation
- [ ] Author can: Accept Draft (inserts into editor) / Regenerate / Discard
- [ ] AI draft session logged to `ai_drafts` table
- [ ] Error handling if API call fails (retry option shown)
- [ ] Pro and Publisher plans: unlimited drafts; Starter: 3 drafts/month
 
---
 
### PENLY-014 — Export Book
**Priority:** P0 | **Estimate:** 8 pts
 
**As an** author,  
**I want to** export my book to PDF and ePub formats,  
**So that** I can distribute it to readers.
 
**Acceptance Criteria:**
- [ ] "Export" button in editor toolbar
- [ ] PDF export: apply Playfair Display typography, chapter page breaks, title page, ToC
- [ ] ePub export: valid ePub 3.0 compatible with major e-readers
- [ ] Export progress indicator (can take 10–30 seconds)
- [ ] Download link delivered; file stored in Supabase Storage
- [ ] `books.pdf_url` and `books.epub_url` updated on export
- [ ] Re-export available after manuscript changes
 
---
 
### PENLY-015 — Publish Book
**Priority:** P0 | **Estimate:** 3 pts
 
**As an** author,  
**I want to** publish my book to the marketplace,  
**So that** readers can find and purchase it.
 
**Acceptance Criteria:**
- [ ] "Publish" button in editor (enabled only when cover + title + price + at least 1 format export exists)
- [ ] Pre-publish checklist shown: cover ✓, description ✓, price ✓, content ✓
- [ ] On confirm: `status` set to `'published'`, `published_at` set to now
- [ ] Book appears in marketplace immediately
- [ ] Author notified via email: "Your book is live!"
- [ ] "Unpublish" option available to revert to draft
 
---
 
## Epic 3: Marketplace
 
### PENLY-020 — Marketplace Browse Page
**Priority:** P0 | **Estimate:** 5 pts
 
**As a** reader,  
**I want to** browse available books,  
**So that** I can discover expert knowledge to buy.
 
**Acceptance Criteria:**
- [ ] Grid of BookCards (cover, title, author, price, avg rating)
- [ ] Category filter pills at top
- [ ] Price range filter (Free / Under $10 / $10–$25 / $25+)
- [ ] Format filter (PDF / ePub / Print)
- [ ] Sort: Newest / Top Rated / Best Selling
- [ ] Pagination or infinite scroll (20 books per page)
- [ ] Empty state per filter with "No books found" message
 
---
 
### PENLY-021 — Book Search
**Priority:** P0 | **Estimate:** 3 pts
 
**As a** reader,  
**I want to** search for books by keyword,  
**So that** I can find specific topics or authors.
 
**Acceptance Criteria:**
- [ ] Search bar in marketplace header
- [ ] Full-text search across: title, subtitle, description, author name, tags
- [ ] Results update as user types (debounced 300ms)
- [ ] "No results" state with suggestions
- [ ] Search term highlighted in results
 
---
 
### PENLY-022 — Book Detail Page
**Priority:** P0 | **Estimate:** 5 pts
 
**As a** reader,  
**I want to** view full details of a book,  
**So that** I can decide whether to purchase.
 
**Acceptance Criteria:**
- [ ] Cover image, title, subtitle, author name + avatar
- [ ] Description with "Read more" expand
- [ ] Price + format badges + "Buy Now" button
- [ ] Table of contents preview (first 3 chapters)
- [ ] Author bio section with "View profile" link
- [ ] Average rating + star breakdown
- [ ] All reviews listed (paginated, 10 per page)
- [ ] "Share" button with OG image for social
- [ ] If already purchased: "Download" button replaces "Buy Now"
 
---
 
### PENLY-023 — Write a Review
**Priority:** P1 | **Estimate:** 3 pts
 
**As a** reader who purchased a book,  
**I want to** leave a star rating and written review,  
**So that** other readers can make informed decisions.
 
**Acceptance Criteria:**
- [ ] "Write a Review" CTA on book page (only for verified purchasers)
- [ ] 1–5 star selector
- [ ] Optional review title and body (min 20 chars if providing text)
- [ ] Submit creates `reviews` record with `is_verified: true`
- [ ] Review appears immediately on book page
- [ ] Author email notification on new review
- [ ] One review per book per user enforced
 
---
 
## Epic 4: Payments
 
### PENLY-030 — Book Purchase Flow
**Priority:** P0 | **Estimate:** 8 pts
 
**As a** reader,  
**I want to** purchase a book,  
**So that** I can access the content I want.
 
**Acceptance Criteria:**
- [ ] "Buy Now" button opens Stripe Checkout
- [ ] Checkout shows book title, cover, price, author
- [ ] Discount code field in checkout
- [ ] Payment succeeds → `purchases` + `purchase_items` records created
- [ ] Buyer receives email receipt
- [ ] Book added to buyer's library
- [ ] Author notified of sale via email
- [ ] `books.total_sales` and `books.total_revenue` incremented
 
---
 
### PENLY-031 — Stripe Connect Onboarding
**Priority:** P0 | **Estimate:** 5 pts
 
**As an** author,  
**I want to** connect my bank account via Stripe,  
**So that** I can receive payouts from my book sales.
 
**Acceptance Criteria:**
- [ ] "Set Up Payouts" CTA in dashboard and settings
- [ ] Launches Stripe Connect onboarding (account creation or login)
- [ ] On completion: `stripe_account_id` and `stripe_onboarded: true` set
- [ ] Payout status badge shown on dashboard: "Payouts Active" ✓
- [ ] Authors without Stripe onboarding cannot publish books (warning shown)
 
---
 
### PENLY-032 — Buyer Download Library
**Priority:** P0 | **Estimate:** 3 pts
 
**As a** buyer,  
**I want to** access all my purchased books,  
**So that** I can download them in the formats I paid for.
 
**Acceptance Criteria:**
- [ ] `/library` page lists all purchased books
- [ ] Per book: cover, title, author, purchase date, format download buttons
- [ ] Download links are signed URLs (expires in 1 hour, re-generatable)
- [ ] Links available indefinitely (buyer keeps access forever)
- [ ] Empty state: "Your library is empty — browse the marketplace"
 
---
 
### PENLY-033 — Discount Code Creation
**Priority:** P1 | **Estimate:** 3 pts
 
**As an** author,  
**I want to** create discount codes for my books,  
**So that** I can run promotions and reward my audience.
 
**Acceptance Criteria:**
- [ ] Discount code form in Marketing Hub
- [ ] Fields: code (auto-generate option), type (% or fixed $), value, applies to (specific book or all), expiry date, max uses
- [ ] Code validated: unique per author, alphanumeric, 4–20 chars
- [ ] Active codes listed with uses/max, expiry, status
- [ ] Author can deactivate code instantly
- [ ] Code applied at Stripe Checkout (Stripe Coupon API)
 
---
 
## Epic 5: Author Dashboard
 
### PENLY-040 — Dashboard Overview
**Priority:** P0 | **Estimate:** 5 pts
 
**As an** author,  
**I want to** see my performance at a glance,  
**So that** I understand how my books are doing.
 
**Acceptance Criteria:**
- [ ] Stats cards: Total Books, Total Revenue (lifetime), Sales This Month, Active Readers
- [ ] Revenue chart: line chart last 30 days (x=date, y=revenue)
- [ ] Books table: title, status badge, sales count, revenue, published date
- [ ] Recent activity feed: last 10 events (sale, review, follow)
- [ ] Quick action buttons: "New Book", "View Store", "Marketing"
- [ ] "Payouts" section: pending balance, next payout date
 
---
 
### PENLY-041 — Per-Book Analytics
**Priority:** P1 | **Estimate:** 5 pts
 
**As an** author,  
**I want to** drill into analytics for each book,  
**So that** I can understand what's working.
 
**Acceptance Criteria:**
- [ ] Navigate to analytics from books table row
- [ ] Sales over time chart (7/30/90 days)
- [ ] Revenue over time chart
- [ ] Views vs conversions funnel
- [ ] Traffic sources (direct, referral, marketplace search)
- [ ] Geographic distribution (country breakdown)
- [ ] Reviews summary: avg rating, rating distribution bar chart
 
---
 
## Epic 6: Marketing Suite
 
### PENLY-050 — Launch Page Builder
**Priority:** P1 | **Estimate:** 8 pts
 
**As an** author,  
**I want to** create a dedicated launch page for my book,  
**So that** I can drive pre-launch interest before publishing.
 
**Acceptance Criteria:**
- [ ] Form-based page builder (no drag-and-drop required for MVP)
- [ ] Fields: headline, subheadline, book cover, description, author name, CTA button text
- [ ] Auto-publishes to penly.co/launch/[slug]
- [ ] Embeds email capture form (connected to author's list)
- [ ] Shows countdown timer to launch date (if pre-order set)
- [ ] Author can preview before publishing page
- [ ] Basic analytics: views and signups
 
---
 
### PENLY-051 — Email Capture Widget
**Priority:** P1 | **Estimate:** 3 pts
 
**As an** author,  
**I want to** embed a waitlist widget on my own website,  
**So that** I can collect reader emails before launch.
 
**Acceptance Criteria:**
- [ ] Widget configuration: select book, CTA text, success message
- [ ] Generates embeddable JavaScript snippet (`<script>` tag)
- [ ] Widget submits emails to author's book-specific list in Penly
- [ ] Author sees list with email, date captured, source
- [ ] Export list as CSV
 
---
 
## Epic 7: Author Public Profile
 
### PENLY-060 — Public Author Profile Page
**Priority:** P1 | **Estimate:** 5 pts
 
**As a** reader,  
**I want to** visit an author's profile page,  
**So that** I can see all their books and learn about them.
 
**Acceptance Criteria:**
- [ ] Public URL: penly.co/@username
- [ ] Author name, avatar, bio, social links
- [ ] Follower count
- [ ] All published books in a grid
- [ ] "Follow" button (for logged-in readers)
- [ ] Follow stores to `follows` table, reader notified on new book publish
 
---
 
## Epic 8: Waitlist & Marketing Site
 
### PENLY-070 — Waitlist Email Capture
**Priority:** P0 | **Estimate:** 2 pts
 
**As a** marketing-site visitor,  
**I want to** join the Penly waitlist,  
**So that** I'm notified when the platform launches.
 
**Acceptance Criteria:**
- [ ] Email input + "Join Waitlist" button on landing page CTA section
- [ ] Email stored to `waitlist` table on submit
- [ ] Duplicate email shows "You're already on the list!" message
- [ ] Success state: "You're on the list! 🎉" + count of total waitlisters
- [ ] Confirmation email sent via Resend
 
---
 
## Epic 9: Admin (Internal)
 
### PENLY-080 — Admin Dashboard
**Priority:** P2 | **Estimate:** 8 pts
 
Internal dashboard for Penly team to monitor platform health.
 
**Acceptance Criteria:**
- [ ] Total users, books, purchases, GMV metrics
- [ ] User lookup by email
- [ ] Flag/remove books (content moderation)
- [ ] View waitlist list + export CSV
- [ ] Impersonate user (with audit log)
 
---
 
## Backlog Summary
 
| Epic | Stories | Total Points | Priority |
|------|---------|-------------|----------|
| Auth & Users | 4 | 13 | P0–P1 |
| Book Editor | 6 | 34 | P0 |
| Marketplace | 4 | 16 | P0–P1 |
| Payments | 4 | 19 | P0–P1 |
| Author Dashboard | 2 | 10 | P0–P1 |
| Marketing Suite | 2 | 11 | P1 |
| Author Profile | 1 | 5 | P1 |
| Waitlist | 1 | 2 | P0 |
| Admin | 1 | 8 | P2 |
| **Total** | **25** | **118** | |
 
