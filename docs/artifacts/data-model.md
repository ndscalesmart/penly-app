# Data Model
## Penly — Database Schema & Entity Relationships
**Version:** 1.0  
**Database:** PostgreSQL (via Supabase)  
**Last Updated:** April 10, 2026

---

## Entity Relationship Overview

```
users (authors & readers)
  │
  ├──< books (one author, many books)
  │      │
  │      ├──< book_chapters
  │      ├──< reviews
  │      ├──< discount_codes
  │      └──< purchase_items >──< purchases >── users (buyers)
  │
  ├──< follows (user follows user)
  └──< waitlist
```

---

## Table Definitions

### `users`
Stores both authors and readers. Role is determined by the `role` field and plan.

```sql
CREATE TABLE users (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email             TEXT UNIQUE NOT NULL,
  username          TEXT UNIQUE,                        -- sets public URL: penly.co/@username
  full_name         TEXT,
  bio               TEXT,
  avatar_url        TEXT,
  website_url       TEXT,
  twitter_handle    TEXT,
  role              TEXT NOT NULL DEFAULT 'reader',     -- 'reader' | 'author' | 'admin'
  plan              TEXT NOT NULL DEFAULT 'starter',    -- 'starter' | 'pro' | 'publisher'
  plan_expires_at   TIMESTAMPTZ,
  stripe_customer_id      TEXT,                        -- Stripe customer (for billing)
  stripe_account_id       TEXT,                        -- Stripe Connect (for payouts)
  stripe_onboarded        BOOLEAN DEFAULT FALSE,
  royalty_rate      DECIMAL(4,3) DEFAULT 0.75,         -- 0.75 | 0.85 | 0.90
  total_earnings    DECIMAL(10,2) DEFAULT 0.00,
  email_verified    BOOLEAN DEFAULT FALSE,
  is_active         BOOLEAN DEFAULT TRUE,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
```

---

### `books`
Core entity. Each book belongs to one author.

```sql
CREATE TABLE books (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Content
  title             TEXT NOT NULL,
  subtitle          TEXT,
  slug              TEXT UNIQUE NOT NULL,               -- URL-safe: penly.co/store/slug
  description       TEXT,
  long_description  TEXT,
  
  -- Assets
  cover_url         TEXT,
  manuscript_url    TEXT,                               -- Master manuscript file (storage)
  pdf_url           TEXT,                               -- Exported PDF
  epub_url          TEXT,                               -- Exported ePub
  
  -- Classification
  category          TEXT,                               -- 'business' | 'self-help' | 'tech' | 'finance' | 'health' | 'other'
  tags              TEXT[],
  language          TEXT DEFAULT 'en',
  
  -- Pricing
  price             DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  currency          TEXT DEFAULT 'USD',
  is_free           BOOLEAN GENERATED ALWAYS AS (price = 0.00) STORED,
  
  -- Formats
  formats           TEXT[] DEFAULT ARRAY['pdf'],        -- ['pdf', 'epub', 'print']
  
  -- Publishing
  status            TEXT NOT NULL DEFAULT 'draft',      -- 'draft' | 'published' | 'archived'
  published_at      TIMESTAMPTZ,
  preorder_date     TIMESTAMPTZ,                        -- If set, book is in pre-order mode
  isbn              TEXT,
  
  -- Stats (denormalized for performance)
  total_sales       INT DEFAULT 0,
  total_revenue     DECIMAL(10,2) DEFAULT 0.00,
  avg_rating        DECIMAL(3,2),
  review_count      INT DEFAULT 0,
  view_count        INT DEFAULT 0,
  
  -- Meta
  word_count        INT DEFAULT 0,
  page_count        INT,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_books_author_id ON books(author_id);
CREATE INDEX idx_books_status ON books(status);
CREATE INDEX idx_books_category ON books(category);
CREATE INDEX idx_books_slug ON books(slug);
CREATE INDEX idx_books_published_at ON books(published_at DESC);
```

---

### `book_chapters`
Ordered chapters within a book's manuscript.

```sql
CREATE TABLE book_chapters (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id       UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  title         TEXT NOT NULL,
  content       TEXT,                                   -- Rich text / HTML content
  order_index   INT NOT NULL DEFAULT 0,
  word_count    INT DEFAULT 0,
  is_preview    BOOLEAN DEFAULT FALSE,                  -- Show in marketplace preview
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_chapters_book_id ON book_chapters(book_id);
CREATE UNIQUE INDEX idx_chapters_book_order ON book_chapters(book_id, order_index);
```

---

### `purchases`
A single checkout transaction. Can contain multiple books.

```sql
CREATE TABLE purchases (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  buyer_id              UUID REFERENCES users(id),       -- NULL for guest purchases
  buyer_email           TEXT NOT NULL,
  
  -- Payment
  stripe_payment_id     TEXT UNIQUE NOT NULL,
  stripe_session_id     TEXT,
  
  -- Totals
  subtotal              DECIMAL(10,2) NOT NULL,
  discount_amount       DECIMAL(10,2) DEFAULT 0.00,
  total_amount          DECIMAL(10,2) NOT NULL,
  currency              TEXT DEFAULT 'USD',
  
  -- State
  status                TEXT DEFAULT 'pending',          -- 'pending' | 'completed' | 'refunded'
  purchased_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_purchases_buyer_id ON purchases(buyer_id);
CREATE INDEX idx_purchases_status ON purchases(status);
```

---

### `purchase_items`
Line items within a purchase (one per book).

```sql
CREATE TABLE purchase_items (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  purchase_id         UUID NOT NULL REFERENCES purchases(id) ON DELETE CASCADE,
  book_id             UUID NOT NULL REFERENCES books(id),
  author_id           UUID NOT NULL REFERENCES users(id),
  
  -- Pricing snapshot at time of purchase
  price_paid          DECIMAL(10,2) NOT NULL,
  discount_code_id    UUID REFERENCES discount_codes(id),
  formats_purchased   TEXT[] NOT NULL,                   -- ['pdf', 'epub']
  
  -- Revenue split
  platform_fee        DECIMAL(10,2) NOT NULL,
  author_earnings     DECIMAL(10,2) NOT NULL,
  
  -- Payout
  payout_id           UUID REFERENCES payouts(id),       -- Set when paid out
  payout_status       TEXT DEFAULT 'pending'             -- 'pending' | 'paid'
);

CREATE INDEX idx_purchase_items_book_id ON purchase_items(book_id);
CREATE INDEX idx_purchase_items_author_id ON purchase_items(author_id);
CREATE INDEX idx_purchase_items_purchase_id ON purchase_items(purchase_id);
```

---

### `reviews`
Verified purchase reviews for books.

```sql
CREATE TABLE reviews (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id         UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  reviewer_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  purchase_item_id UUID REFERENCES purchase_items(id),   -- Ensures verified purchase
  
  rating          INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  title           TEXT,
  body            TEXT,
  
  is_verified     BOOLEAN DEFAULT FALSE,
  is_featured     BOOLEAN DEFAULT FALSE,
  
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(book_id, reviewer_id)                           -- One review per book per reader
);

CREATE INDEX idx_reviews_book_id ON reviews(book_id);
CREATE INDEX idx_reviews_reviewer_id ON reviews(reviewer_id);
```

---

### `discount_codes`
Author-created discount codes for their books.

```sql
CREATE TABLE discount_codes (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  book_id           UUID REFERENCES books(id),           -- NULL = applies to all author's books
  
  code              TEXT NOT NULL,
  discount_type     TEXT NOT NULL DEFAULT 'percent',     -- 'percent' | 'fixed'
  discount_value    DECIMAL(10,2) NOT NULL,              -- e.g. 20 = 20% or $20
  
  max_uses          INT,                                 -- NULL = unlimited
  uses              INT DEFAULT 0,
  
  is_active         BOOLEAN DEFAULT TRUE,
  expires_at        TIMESTAMPTZ,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(author_id, code)
);

CREATE INDEX idx_discount_codes_code ON discount_codes(code);
CREATE INDEX idx_discount_codes_author_id ON discount_codes(author_id);
```

---

### `payouts`
Tracks Stripe Connect payouts to authors.

```sql
CREATE TABLE payouts (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id           UUID NOT NULL REFERENCES users(id),
  stripe_transfer_id  TEXT UNIQUE,
  
  amount              DECIMAL(10,2) NOT NULL,
  currency            TEXT DEFAULT 'USD',
  
  status              TEXT DEFAULT 'pending',            -- 'pending' | 'in_transit' | 'paid' | 'failed'
  period_start        TIMESTAMPTZ,
  period_end          TIMESTAMPTZ,
  paid_at             TIMESTAMPTZ,
  
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_payouts_author_id ON payouts(author_id);
```

---

### `follows`
Reader follows author for new release alerts.

```sql
CREATE TABLE follows (
  follower_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  following_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  
  PRIMARY KEY (follower_id, following_id),
  CHECK (follower_id != following_id)
);

CREATE INDEX idx_follows_follower ON follows(follower_id);
CREATE INDEX idx_follows_following ON follows(following_id);
```

---

### `waitlist`
Pre-launch email capture.

```sql
CREATE TABLE waitlist (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email       TEXT UNIQUE NOT NULL,
  name        TEXT,
  source      TEXT,                                      -- 'landing_page' | 'referral' | 'social'
  referrer    TEXT,                                      -- UTM or referring URL
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_waitlist_email ON waitlist(email);
CREATE INDEX idx_waitlist_created_at ON waitlist(created_at DESC);
```

---

### `ai_drafts`
Logs AI drafting sessions for quality tracking and billing.

```sql
CREATE TABLE ai_drafts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id       UUID NOT NULL REFERENCES users(id),
  book_id         UUID REFERENCES books(id),
  chapter_id      UUID REFERENCES book_chapters(id),
  
  input_tokens    INT,
  output_tokens   INT,
  model           TEXT DEFAULT 'claude-sonnet-4-20250514',
  
  prompt_summary  TEXT,                                  -- First 200 chars of input
  accepted        BOOLEAN,                               -- Did author accept the output?
  
  created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

---

### `book_analytics`
Daily analytics snapshots per book.

```sql
CREATE TABLE book_analytics (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id     UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  date        DATE NOT NULL,
  
  views       INT DEFAULT 0,
  sales       INT DEFAULT 0,
  revenue     DECIMAL(10,2) DEFAULT 0.00,
  
  UNIQUE(book_id, date)
);

CREATE INDEX idx_analytics_book_date ON book_analytics(book_id, date DESC);
```

---

## Row Level Security (Supabase RLS Policies)

```sql
-- Users can only read/update their own profile
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own profile" ON users
  USING (auth.uid() = id);

-- Books: authors manage their own; published books are public
ALTER TABLE books ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authors manage own books" ON books
  USING (auth.uid() = author_id);
CREATE POLICY "Public can read published books" ON books
  FOR SELECT USING (status = 'published');

-- Purchases: buyers see their own
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Buyers see own purchases" ON purchases
  USING (auth.uid() = buyer_id);

-- Reviews: public read, verified buyers write
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can read reviews" ON reviews
  FOR SELECT USING (true);
CREATE POLICY "Buyers can write reviews" ON reviews
  FOR INSERT WITH CHECK (auth.uid() = reviewer_id);
```

---

## Key Business Rules

1. **Royalty rates are plan-based:** Starter 75% / Pro 85% / Publisher 90%. Rate is locked at purchase time and stored in `purchase_items.author_earnings`.
2. **A review requires a verified purchase.** `reviews.purchase_item_id` must reference a completed `purchase_item` for the same book.
3. **Book slugs are immutable once published** to avoid broken URLs. Authors can unpublish but not change the slug.
4. **Discount codes are scoped per author.** An author cannot create a code that applies to another author's book.
5. **Payouts are batched weekly** and aggregate all `purchase_items` with `payout_status = 'pending'` for the author.
