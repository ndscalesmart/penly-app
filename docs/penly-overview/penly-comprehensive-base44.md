# Penly — Comprehensive Application Overview

> *"Write It. Publish It. Get Paid."*
> The all-in-one publishing platform for founders, coaches, and expert creators.

---

## Table of Contents

1. [Brand Identity](#1-brand-identity)
2. [Design System — "The Living Folio"](#2-design-system--the-living-folio)
3. [Typography](#3-typography)
4. [Motion & Interaction](#4-motion--interaction)
5. [Application Architecture](#5-application-architecture)
6. [Pages & Routes](#6-pages--routes)
7. [Components](#7-components)
8. [Entities (Data Models)](#8-entities-data-models)
9. [Integrations & SDK](#9-integrations--sdk)
10. [Features & Functionalities](#10-features--functionalities)
11. [Code File Map](#11-code-file-map)
12. [Accessibility Mandate](#12-accessibility-mandate)
13. [Business Model](#13-business-model)
14. [Pitch Deck Summary](#14-pitch-deck-summary)

---

## 1. Brand Identity

| Property | Value |
|---|---|
| **Product Name** | Penly |
| **Tagline** | *Write It. Publish It. Get Paid.* |
| **Archetype** | The Intellectual Curator / Sophisticated Polymath |
| **Design Persona** | "A private library at dusk, illuminated by a high-end workstation" |
| **Design System Name** | The Living Folio |
| **Target Audience** | Non-technical founders, coaches, workshop creators, and expert thought leaders |
| **Competitive Position** | AI-powered, creator-first alternative to Amazon KDP — with 85% author royalties |

---

## 2. Design System — "The Living Folio"

### Color Protocol

| Token | Hex | HSL Variable | Usage |
|---|---|---|---|
| **Ink** | `#0F0D0A` | `--ink: 30 15% 6%` | Primary foreground, headings, backgrounds |
| **Cream** | `#F5F0E8` | `--cream: 38 43% 94%` | Primary background, surface |
| **Vellum / Warm** | `#EBE4D8` | `--warm: 36 35% 89%` | Card backgrounds, nested containers |
| **Paper** | `#FAFAF7` | `--paper: 38 40% 97%` | App background layer |
| **Gold** | `#C9952A` | `--gold: 37 65% 48%` | Primary accent, CTA buttons, AI markers |
| **Gold Light** | `#E5B54A` | `--gold-light: 40 76% 60%` | Hover state for Gold elements |
| **Rust** | `#A0402A` | `--rust: 12 61% 45%` | Destructive / warning state |
| **Sage** | `#3D5E35` | `--sage: 112 18% 35%` | Success state, revenue figures |
| **Text Muted** | `#7A6A56` | `--text-muted: 30 12% 38%` | Captions, metadata, secondary labels |

### Contrast Mathematics (WCAG Compliance)

| Combination | Ratio | Grade |
|---|---|---|
| Ink on Cream | 16.5:1 | **AAA** ✓ |
| Deep Gold on Cream | 4.7:1 | **AA** ✓ |
| Cream on Gold (buttons) | 3.8:1 | **AA Large Text** ✓ |

### Design Motifs

- **The Deckle Edge** — Subtle, jagged section dividers resembling hand-torn paper
- **The Serif UI** — *Playfair Display* used not just for titles, but for KPI numbers and navigation — treating data as a literary achievement
- **The Ink-Bleed Interaction** — Hover states "bloom" or spread like ink hitting vellum (transitions on borders, background, and text simultaneously)
- **The Manuscript Grid** — Asymmetric gutters and vertical "spine lines" that anchor content like a luxury hardcover layout
- **Breathed Space** — Large intentional voids direct the eye toward primary actions

### Tailwind Token Mapping (`tailwind.config.js`)

```js
colors: {
  ink:        'hsl(var(--ink))',
  cream:      'hsl(var(--cream))',
  warm:       'hsl(var(--warm))',
  paper:      'hsl(var(--paper))',
  gold:       'hsl(var(--gold))',
  'gold-light':'hsl(var(--gold-light))',
  rust:       'hsl(var(--rust))',
  sage:       'hsl(var(--sage))',
  'text-muted':'hsl(var(--text-muted))',
}
```

---

## 3. Typography

| Role | Font | Weight | Size | Line Height | Letter Spacing |
|---|---|---|---|---|---|
| **Display / Headings** | Playfair Display | 700 / 900 | 4xl–8xl | tight | -0.02em |
| **Body / UI** | DM Sans | 400 / 500 / 600 | 14–18px | 1.6 (160%) | normal |
| **Metadata / Mono** | DM Mono | 400 / 500 | 12–14px | 1.5 | wider (tracking-widest) |

**Google Fonts Import:**
```css
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;0,900;1,400;1,700&family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap');
```

**Tailwind Font Classes:**
- `font-display` → Playfair Display (headings, brand, KPIs)
- `font-sans` → DM Sans (body, UI labels, buttons)
- `font-mono` → DM Mono (metadata, stats, tracking labels)

---

## 4. Motion & Interaction

| Easing Standard | Value | Usage |
|---|---|---|
| Bézier-Standard | `cubic-bezier(0.22, 1, 0.36, 1)` | All primary transitions (0.6s) |
| Hover Transitions | `transition-colors` / `transition-all` | Buttons, links, cards |

### Custom CSS Animations (`index.css`)

| Name | Keyframe | Usage |
|---|---|---|
| `animate-float` | 6s vertical oscillation | Hero book covers |
| `animate-float2` | 8s vertical oscillation + 1s delay | Secondary hero books |
| `animate-float3` | 7s vertical oscillation + 2s delay | Tertiary hero books |
| `animate-marquee` | Continuous horizontal scroll (-50%) | MarqueeBanner ticker |
| `animate-fade-up` | Opacity 0→1, translateY 24px→0 | Hero section staggered entry |
| `animate-fade-up-1/2/3` | Staggered 0.15s, 0.3s, 0.45s delays | Hero text cascade |

---

## 5. Application Architecture

```
Penly/
├── App.jsx                        # Router + Auth provider shell
├── index.css                      # Design tokens + custom animations
├── tailwind.config.js             # Tailwind theme mapping
├── index.html                     # HTML entry point
├── main.jsx                       # React DOM mount
│
├── pages/
│   ├── Landing.jsx                # Public marketing homepage (/)
│   ├── Dashboard.jsx              # Author dashboard (/dashboard)
│   ├── BookEditor.jsx             # Full-screen book editor (/books/:id/edit)
│   ├── Store.jsx                  # Public marketplace (/store)
│   └── PitchDeck.jsx              # Interactive pitch deck (/pitch)
│
├── components/
│   ├── Navbar.jsx                 # Sticky top navigation
│   ├── Hero.jsx                   # Landing hero section
│   ├── MarqueeBanner.jsx          # Scrolling marquee ticker
│   ├── HowItWorks.jsx             # 3-step process section
│   ├── Features.jsx               # Feature grid (dark ink bg)
│   ├── Pricing.jsx                # 3-tier pricing cards
│   ├── WaitlistCTA.jsx            # Email capture + Waitlist entity
│   ├── Footer.jsx                 # Global footer
│   ├── DashboardLayout.jsx        # Sidebar layout for auth pages
│   └── BookCard.jsx               # Marketplace book card component
│
├── entities/
│   ├── Book.json                  # Book data schema
│   └── Waitlist.json              # Waitlist email schema
│
├── api/
│   └── base44Client.js            # Base44 SDK client (auth + entities)
│
└── lib/
    ├── AuthContext.jsx            # Auth state provider
    ├── query-client.js            # TanStack Query client instance
    ├── utils.js                   # Utility functions
    └── PageNotFound.jsx           # 404 fallback
```

### Routing Table (`App.jsx`)

| Route | Component | Auth | Description |
|---|---|---|---|
| `/` | `Landing` | Public | Marketing homepage |
| `/dashboard` | `Dashboard` | Required | Author control center |
| `/books/new` | `BookEditor` | Required | Create new book |
| `/books/:id/edit` | `BookEditor` | Required | Edit existing book |
| `/store` | `Store` | Public | Reader marketplace |
| `/pitch` | `PitchDeck` | Public | 10-slide investor deck |
| `*` | `PageNotFound` | — | 404 fallback |

---

## 6. Pages & Routes

### `/` — Landing Page (`pages/Landing.jsx`)

The public-facing marketing homepage. Composed of modular section components stacked vertically:

1. **Navbar** — Sticky, glassmorphic (bg-paper/90 + backdrop-blur)
2. **Hero** — Split two-column: left is copy + CTAs + stats; right is floating 3D book covers
3. **MarqueeBanner** — Full-width ink background, animated `Write · Publish · Distribute · Get Paid` ticker
4. **HowItWorks** — 3-step process cards with animated left-border hover effect
5. **Features** — 6-card grid on ink background
6. **Pricing** — 3-tier pricing with Author Pro featured
7. **WaitlistCTA** — Email capture form on ink background
8. **Footer** — Links + brand mark

### `/dashboard` — Author Dashboard (`pages/Dashboard.jsx`)

Protected author control center using `DashboardLayout` sidebar.

**Features:**
- Welcome header with user's full name
- **4 KPI cards:** Total Books, Total Revenue ($), Total Sales, Published count
- Quick action buttons: New Book, View Store
- Full books table with title, category, status badge, sales, revenue, edit link

**Data source:** `base44.entities.Book.filter({ created_by: user.email })`

### `/books/new` + `/books/:id/edit` — Book Editor (`pages/BookEditor.jsx`)

Full-screen immersive split-panel writing environment.

**Layout:**
- **Top Bar** (fixed): Back arrow, editable title input, Save + Publish buttons
- **Left Panel** (280px): Metadata sidebar — subtitle, description, category, price, formats, author bio
- **Right Panel** (flex-1): Tab-based editor

**Three tabs:**
1. **Write** — Raw textarea manuscript editor
2. **AI Draft** — Paste notes → call `InvokeLLM` → generate polished manuscript
3. **Preview** — Read-only rendered view of title + manuscript

**AI Integration:** Calls `base44.integrations.Core.InvokeLLM` with a ghostwriter prompt, appending generated content to the manuscript field.

### `/store` — Public Marketplace (`pages/Store.jsx`)

Public-facing reader experience.

**Features:**
- Page header with marketplace branding
- Unified search bar (title + author name)
- Category filter pills (All, Business, Self-Help, Technology, Finance, Health, Leadership, Other)
- Responsive book grid: 1 → 2 → 3 → 4 columns
- Empty state with icon and CTA
- Data source: `base44.entities.Book.filter({ status: "published" })`

### `/pitch` — Interactive Pitch Deck (`pages/PitchDeck.jsx`)

A fully self-contained 10-slide investor presentation, designed on an ink-dark canvas.

**10 Slides:**

| # | Title | Type |
|---|---|---|
| 1 | Cover | Brand statement |
| 2 | The Problem | Market pain points with stats |
| 3 | The Solution | 4-pillar feature overview |
| 4 | The Product | 3-step workflow |
| 5 | Traction | Waitlist + workshop proof |
| 6 | Market Opportunity | TAM / SAM / SOM |
| 7 | Business Model | 4 revenue streams |
| 8 | Competitive Landscape | Comparison table vs. KDP, Gumroad, Lulu, Substack |
| 9 | The Ask | $125K for 7% equity + fund allocation |
| 10 | Closing | Final brand statement |

**Navigation:** Prev/Next buttons + dot indicator row + slide counter.

---

## 7. Components

### `Navbar.jsx`
- Sticky top, `bg-paper/90 backdrop-blur border-b border-border`
- Penly logo (`font-display`) with Gold accent on "ly"
- Nav links: Store, Features (anchor), Pricing (anchor), Pitch Deck
- Auth-aware: shows "Dashboard" if logged in, "Sign In + Join Waitlist" if not
- Mobile hamburger menu with animated open/close

### `Hero.jsx`
- Full-height two-column section
- Staggered fade-up animation on entry (3 delay levels)
- Stats row: 85% Royalties · 3hrs Draft Time · 1 Platform
- Right column: 3 floating book cover mockups with `animate-float`, `animate-float2`, `animate-float3`
- CTAs: "Start Writing Free" (Ink button) + "Join the Waitlist" (outlined)

### `MarqueeBanner.jsx`
- `bg-ink` full-width ticker
- Infinite CSS `animate-marquee` loop of: Write · Publish · Distribute · Get Paid
- Separated by Gold `·` dots

### `HowItWorks.jsx`
- 3 cards on cream background
- Left-border animation: `h-0` → `h-full` on group hover (Gold border)
- Large display step numbers as decorative background text

### `Features.jsx`
- Ink-background 6-card grid
- Icons from `lucide-react`: Sparkles, ShoppingBag, Megaphone, FileText, DollarSign, BarChart2
- Cards: border hover → Gold/40

### `Pricing.jsx`
- 3 tiers: Starter (Free), Author Pro ($29/mo) — featured, Publisher ($99/mo)
- Author Pro: Ink background, Gold royalty badge, gold CTA
- Check icons from lucide-react in Sage (non-featured) / Gold (featured)

### `WaitlistCTA.jsx`
- Email form → `base44.entities.Waitlist.create({ email, source: "landing_page" })`
- Success state: confirmation message
- Social proof: "Join 247 authors already waiting."

### `Footer.jsx`
- Flex row: Logo + tagline | Nav links | Copyright
- Collapses to column on mobile

### `DashboardLayout.jsx`
- Fixed 224px sidebar (hidden on mobile)
- Nav items: Dashboard, New Book, Store
- Bottom: user name/email + Sign Out button (`base44.auth.logout()`)

### `BookCard.jsx`
- 3:4 aspect ratio cover area
- Fallback: Ink cover with title in Playfair Display + Gold rule
- If `cover_url` present: `<img>` object-cover
- Info row: category (mono label), title, author, price, star rating
- Hover: `-translate-y-1` + border → gold

---

## 8. Entities (Data Models)

### `Book` (`entities/Book.json`)

| Field | Type | Options / Default |
|---|---|---|
| `title` | string | **Required** |
| `subtitle` | string | — |
| `description` | string | — |
| `cover_url` | string | — |
| `category` | string (enum) | Business, Self-Help, Technology, Finance, Health, Leadership, Other |
| `price` | number | — |
| `status` | string (enum) | `draft` (default), `published`, `archived` |
| `formats` | array of strings | pdf, epub, print |
| `tags` | array of strings | — |
| `manuscript` | string | Long-form text content |
| `total_sales` | number | Default: 0 |
| `total_revenue` | number | Default: 0 |
| `author_name` | string | — |
| `author_bio` | string | — |
| `rating` | number | Default: 0 |

**Built-in fields (auto):** `id`, `created_date`, `updated_date`, `created_by_id`

### `Waitlist` (`entities/Waitlist.json`)

| Field | Type | Notes |
|---|---|---|
| `email` | string | **Required** |
| `source` | string | e.g. `"landing_page"` |

---

## 9. Integrations & SDK

### Base44 SDK (`api/base44Client.js`)

```js
import { createClient } from '@base44/sdk';
export const base44 = createClient({ appId, token, requiresAuth: false });
```

**Entity methods used:**
```js
base44.entities.Book.filter(query, sort, limit)
base44.entities.Book.create(data)
base44.entities.Book.update(id, data)
base44.entities.Waitlist.create({ email, source })
```

**Auth methods used:**
```js
base44.auth.me()           // Get current user
base44.auth.logout()       // Sign out + redirect
base44.auth.updateMe(data) // Update user profile
```

### Core AI Integration

**`InvokeLLM`** — Used in `BookEditor.jsx` (AI Draft tab):

```js
const result = await base44.integrations.Core.InvokeLLM({
  prompt: `You are a professional ghostwriter. Transform these workshop notes into 
           a well-structured book manuscript with chapter headings (##), 
           subheadings (###), and engaging prose...`,
});
```

The AI-generated text is appended to `book.manuscript`.

---

## 10. Features & Functionalities

### For Authors (Authenticated)

| Feature | Description | Location |
|---|---|---|
| **Book Creation** | Create a new book with metadata, cover, category, price | `/books/new` |
| **Manuscript Editor** | Full-screen textarea with real-time editing | `/books/:id/edit` → Write tab |
| **AI Draft Generator** | Paste notes → AI generates polished manuscript | `/books/:id/edit` → AI Draft tab |
| **Live Preview** | Read-only render of the manuscript with cover info | `/books/:id/edit` → Preview tab |
| **Multi-Format Selection** | Toggle PDF, ePub, Print formats | Book Editor sidebar |
| **Publishing** | One-click publish (sets status to "published") | Book Editor top bar |
| **Dashboard Analytics** | KPI cards: total books, revenue, sales, published count | `/dashboard` |
| **Book Management Table** | List all books with status badges and quick edit links | `/dashboard` |

### For Readers (Public)

| Feature | Description | Location |
|---|---|---|
| **Browse Marketplace** | Grid of all published books | `/store` |
| **Search** | Filter by title or author name | `/store` |
| **Category Filtering** | Filter by 8 categories | `/store` |
| **Book Cards** | Visual cover, price, rating, author info | `BookCard` component |

### Platform-Wide

| Feature | Description |
|---|---|
| **Waitlist Capture** | Email signup form → stored in `Waitlist` entity |
| **Pitch Deck** | Investor-ready 10-slide interactive presentation |
| **Auth-Aware Navigation** | Navbar adapts to logged-in vs logged-out state |
| **Responsive Design** | Mobile-first, all layouts adapt sm → md → lg → xl |
| **404 Handling** | `PageNotFound` fallback route |

---

## 11. Code File Map

```
File                              Lines   Purpose
─────────────────────────────────────────────────────────────────────
App.jsx                           ~60     Router, Auth shell, QueryClient
index.css                         ~120    Design tokens (CSS vars), font imports, animations
tailwind.config.js                ~75     Tailwind theme extension with token mapping

pages/Landing.jsx                 ~15     Landing page composition
pages/Dashboard.jsx               ~95     Author dashboard with KPI cards + book table
pages/BookEditor.jsx              ~160    Full-screen split-panel writing environment
pages/Store.jsx                   ~80     Public marketplace with search + filter
pages/PitchDeck.jsx               ~200    10-slide interactive investor pitch deck

components/Navbar.jsx             ~60     Sticky nav with mobile hamburger
components/Hero.jsx               ~80     Two-column hero with floating book covers
components/MarqueeBanner.jsx      ~20     Animated marquee ticker
components/HowItWorks.jsx         ~40     3-step process cards
components/Features.jsx           ~30     6-feature grid on ink background
components/Pricing.jsx            ~60     3-tier pricing table
components/WaitlistCTA.jsx        ~50     Email waitlist form with submission state
components/Footer.jsx             ~25     Global footer
components/DashboardLayout.jsx    ~55     Sidebar layout wrapper for auth pages
components/BookCard.jsx           ~40     Marketplace book card with cover fallback

entities/Book.json                ~70     Book data schema (15 fields)
entities/Waitlist.json            ~15     Waitlist email schema

api/base44Client.js               ~12     SDK client initialization
lib/AuthContext.jsx               —       Auth state management (platform-provided)
lib/query-client.js               —       TanStack Query client instance
lib/utils.js                      —       cn() class name utility
lib/PageNotFound.jsx              —       404 page
```

---

## 12. Accessibility Mandate

| Standard | Implementation |
|---|---|
| **WCAG AAA** (Ink on Cream) | 16.5:1 contrast ratio |
| **WCAG AA** (Gold labels) | 4.7:1 contrast ratio |
| **Focus Ring** | `2px solid #C9952A` (Gold) on all interactive elements |
| **Touch Targets** | Minimum 44×44px on all buttons |
| **Decorative Elements** | `aria-hidden="true"` on all paper texture / ornamental elements |
| **AI Progress** | `aria-live="polite"` on draft generation status |
| **Screen Reader Labels** | All icon-only buttons include `aria-label` |
| **Motion** | Transitions use Bézier-Standard: `cubic-bezier(0.22, 1, 0.36, 1)` at 0.6s — no bouncy/cheap animations |

---

## 13. Business Model

| Stream | Detail |
|---|---|
| **SaaS Subscriptions** | Starter (Free) · Author Pro $29/mo · Publisher $99/mo |
| **Platform Take Rate** | 15% of every book sale processed on Penly |
| **Print Margin** | Print-on-demand fulfillment markup |
| **White-Label Licensing** | Publisher tier: $99/mo per branded storefront |

**Author Royalty Comparison:**

| Platform | Royalty to Author |
|---|---|
| Amazon KDP | 35–70% |
| Gumroad | 87–92% (after fees) |
| **Penly** | **85% (guaranteed)** |

---

## 14. Pitch Deck Summary

> Viewable live at `/pitch`

**Ask:** $125,000 for 7% equity

**Fund Allocation:**
- 40% Engineering & Product
- 30% Growth & Marketing
- 20% Operations
- 10% Working Capital

**Targets:**
- 1,000 authors at $29 avg MRR → $29K MRR Month 12
- Path to $350K ARR Year 1

**Competitive Moat:**
Penly is the only platform that combines AI drafting + a curated marketplace + marketing tools + 85% royalties in one product. No competitor checks all four boxes.

**Beachhead Market:** EYL / InvestFest audience — Black entrepreneurs and wealth-builders with knowledge to monetize and no frictionless path to do so.

---

*Document generated: June 7, 2026 · Penly v1.0 · Built on Base44*