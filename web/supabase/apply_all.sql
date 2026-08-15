-- Penly — full schema (0001 + 0002 combined for one-shot SQL Editor paste)

-- Penly — initial schema
-- Source of truth: docs/artifacts/data-model.md
-- Tables are ordered to satisfy foreign-key dependencies in a single migration.

-- ---------------------------------------------------------------------------
-- users  (app profile table; id is linked 1:1 to auth.users — see 0002 trigger)
-- ---------------------------------------------------------------------------
CREATE TABLE users (
  id                UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email             TEXT UNIQUE NOT NULL,
  username          TEXT UNIQUE,
  full_name         TEXT,
  bio               TEXT,
  avatar_url        TEXT,
  website_url       TEXT,
  twitter_handle    TEXT,
  role              TEXT NOT NULL DEFAULT 'reader',     -- 'reader' | 'author' | 'admin'
  plan              TEXT NOT NULL DEFAULT 'starter',    -- 'starter' | 'pro' | 'publisher'
  plan_expires_at   TIMESTAMPTZ,
  stripe_customer_id TEXT,
  stripe_account_id  TEXT,
  stripe_onboarded   BOOLEAN DEFAULT FALSE,
  royalty_rate      DECIMAL(4,3) DEFAULT 0.75,
  total_earnings    DECIMAL(10,2) DEFAULT 0.00,
  email_verified    BOOLEAN DEFAULT FALSE,
  is_active         BOOLEAN DEFAULT TRUE,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);

-- ---------------------------------------------------------------------------
-- books
-- ---------------------------------------------------------------------------
CREATE TABLE books (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title             TEXT NOT NULL,
  subtitle          TEXT,
  slug              TEXT UNIQUE NOT NULL,
  description       TEXT,
  long_description  TEXT,
  cover_url         TEXT,
  manuscript_url    TEXT,
  pdf_url           TEXT,
  epub_url          TEXT,
  category          TEXT,
  tags              TEXT[],
  language          TEXT DEFAULT 'en',
  price             DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  currency          TEXT DEFAULT 'USD',
  is_free           BOOLEAN GENERATED ALWAYS AS (price = 0.00) STORED,
  formats           TEXT[] DEFAULT ARRAY['pdf'],
  status            TEXT NOT NULL DEFAULT 'draft',       -- 'draft' | 'published' | 'archived'
  published_at      TIMESTAMPTZ,
  preorder_date     TIMESTAMPTZ,
  isbn              TEXT,
  total_sales       INT DEFAULT 0,
  total_revenue     DECIMAL(10,2) DEFAULT 0.00,
  avg_rating        DECIMAL(3,2),
  review_count      INT DEFAULT 0,
  view_count        INT DEFAULT 0,
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

-- ---------------------------------------------------------------------------
-- book_chapters
-- ---------------------------------------------------------------------------
CREATE TABLE book_chapters (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id       UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  title         TEXT NOT NULL,
  content       TEXT,
  order_index   INT NOT NULL DEFAULT 0,
  word_count    INT DEFAULT 0,
  is_preview    BOOLEAN DEFAULT FALSE,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_chapters_book_id ON book_chapters(book_id);
CREATE UNIQUE INDEX idx_chapters_book_order ON book_chapters(book_id, order_index);

-- ---------------------------------------------------------------------------
-- discount_codes  (referenced by purchase_items — must precede it)
-- ---------------------------------------------------------------------------
CREATE TABLE discount_codes (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  book_id           UUID REFERENCES books(id),
  code              TEXT NOT NULL,
  discount_type     TEXT NOT NULL DEFAULT 'percent',     -- 'percent' | 'fixed'
  discount_value    DECIMAL(10,2) NOT NULL,
  max_uses          INT,
  uses              INT DEFAULT 0,
  is_active         BOOLEAN DEFAULT TRUE,
  expires_at        TIMESTAMPTZ,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(author_id, code)
);
CREATE INDEX idx_discount_codes_code ON discount_codes(code);
CREATE INDEX idx_discount_codes_author_id ON discount_codes(author_id);

-- ---------------------------------------------------------------------------
-- payouts  (referenced by purchase_items — must precede it)
-- ---------------------------------------------------------------------------
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

-- ---------------------------------------------------------------------------
-- purchases
-- ---------------------------------------------------------------------------
CREATE TABLE purchases (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  buyer_id              UUID REFERENCES users(id),
  buyer_email           TEXT NOT NULL,
  stripe_payment_id     TEXT UNIQUE NOT NULL,
  stripe_session_id     TEXT,
  subtotal              DECIMAL(10,2) NOT NULL,
  discount_amount       DECIMAL(10,2) DEFAULT 0.00,
  total_amount          DECIMAL(10,2) NOT NULL,
  currency              TEXT DEFAULT 'USD',
  status                TEXT DEFAULT 'pending',          -- 'pending' | 'completed' | 'refunded'
  purchased_at          TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_purchases_buyer_id ON purchases(buyer_id);
CREATE INDEX idx_purchases_status ON purchases(status);

-- ---------------------------------------------------------------------------
-- purchase_items
-- ---------------------------------------------------------------------------
CREATE TABLE purchase_items (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  purchase_id         UUID NOT NULL REFERENCES purchases(id) ON DELETE CASCADE,
  book_id             UUID NOT NULL REFERENCES books(id),
  author_id           UUID NOT NULL REFERENCES users(id),
  price_paid          DECIMAL(10,2) NOT NULL,
  discount_code_id    UUID REFERENCES discount_codes(id),
  formats_purchased   TEXT[] NOT NULL,
  platform_fee        DECIMAL(10,2) NOT NULL,
  author_earnings     DECIMAL(10,2) NOT NULL,
  payout_id           UUID REFERENCES payouts(id),
  payout_status       TEXT DEFAULT 'pending'             -- 'pending' | 'paid'
);
CREATE INDEX idx_purchase_items_book_id ON purchase_items(book_id);
CREATE INDEX idx_purchase_items_author_id ON purchase_items(author_id);
CREATE INDEX idx_purchase_items_purchase_id ON purchase_items(purchase_id);

-- ---------------------------------------------------------------------------
-- reviews
-- ---------------------------------------------------------------------------
CREATE TABLE reviews (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id          UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  reviewer_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  purchase_item_id UUID REFERENCES purchase_items(id),
  rating           INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  title            TEXT,
  body             TEXT,
  is_verified      BOOLEAN DEFAULT FALSE,
  is_featured      BOOLEAN DEFAULT FALSE,
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(book_id, reviewer_id)
);
CREATE INDEX idx_reviews_book_id ON reviews(book_id);
CREATE INDEX idx_reviews_reviewer_id ON reviews(reviewer_id);

-- ---------------------------------------------------------------------------
-- follows
-- ---------------------------------------------------------------------------
CREATE TABLE follows (
  follower_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  following_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (follower_id, following_id),
  CHECK (follower_id != following_id)
);
CREATE INDEX idx_follows_follower ON follows(follower_id);
CREATE INDEX idx_follows_following ON follows(following_id);

-- ---------------------------------------------------------------------------
-- waitlist
-- ---------------------------------------------------------------------------
CREATE TABLE waitlist (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email       TEXT UNIQUE NOT NULL,
  name        TEXT,
  source      TEXT,
  referrer    TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_waitlist_email ON waitlist(email);
CREATE INDEX idx_waitlist_created_at ON waitlist(created_at DESC);

-- ---------------------------------------------------------------------------
-- ai_drafts
-- ---------------------------------------------------------------------------
CREATE TABLE ai_drafts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id       UUID NOT NULL REFERENCES users(id),
  book_id         UUID REFERENCES books(id),
  chapter_id      UUID REFERENCES book_chapters(id),
  input_tokens    INT,
  output_tokens   INT,
  model           TEXT DEFAULT 'claude-sonnet-4-20250514',
  prompt_summary  TEXT,
  accepted        BOOLEAN,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- book_analytics
-- ---------------------------------------------------------------------------
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


-- Penly — Row Level Security + Supabase auth integration
-- Source of truth: docs/artifacts/data-model.md (RLS section)

-- ---------------------------------------------------------------------------
-- Auto-provision a public.users row whenever an auth user is created.
-- Makes `auth.uid() = users.id` hold, which the RLS policies below rely on.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, avatar_url, email_verified)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data ->> 'full_name',
    NEW.raw_user_meta_data ->> 'avatar_url',
    NEW.email_confirmed_at IS NOT NULL
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ---------------------------------------------------------------------------
-- RLS policies
-- ---------------------------------------------------------------------------

-- users: manage own profile; published-author profiles are publicly readable
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own profile" ON users
  USING (auth.uid() = id) WITH CHECK (auth.uid() = id);
CREATE POLICY "Public can read author profiles" ON users
  FOR SELECT USING (role = 'author');

-- books: authors manage their own; published books are public
ALTER TABLE books ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authors manage own books" ON books
  USING (auth.uid() = author_id) WITH CHECK (auth.uid() = author_id);
CREATE POLICY "Public can read published books" ON books
  FOR SELECT USING (status = 'published');

-- book_chapters: author manages; preview chapters of published books are public
ALTER TABLE book_chapters ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authors manage own chapters" ON book_chapters
  USING (EXISTS (SELECT 1 FROM books b WHERE b.id = book_id AND b.author_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM books b WHERE b.id = book_id AND b.author_id = auth.uid()));
CREATE POLICY "Public can read preview chapters" ON book_chapters
  FOR SELECT USING (
    is_preview AND EXISTS (SELECT 1 FROM books b WHERE b.id = book_id AND b.status = 'published')
  );

-- purchases: buyers see their own
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Buyers see own purchases" ON purchases
  FOR SELECT USING (auth.uid() = buyer_id);

-- purchase_items: buyer sees their lines; author sees lines for their books
ALTER TABLE purchase_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Author sees own sales" ON purchase_items
  FOR SELECT USING (auth.uid() = author_id);
CREATE POLICY "Buyer sees own items" ON purchase_items
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM purchases p WHERE p.id = purchase_id AND p.buyer_id = auth.uid())
  );

-- reviews: public read; verified buyers write/update their own
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can read reviews" ON reviews
  FOR SELECT USING (true);
CREATE POLICY "Buyers can write reviews" ON reviews
  FOR INSERT WITH CHECK (auth.uid() = reviewer_id);
CREATE POLICY "Reviewers update own reviews" ON reviews
  FOR UPDATE USING (auth.uid() = reviewer_id);

-- discount_codes: author-scoped
ALTER TABLE discount_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authors manage own codes" ON discount_codes
  USING (auth.uid() = author_id) WITH CHECK (auth.uid() = author_id);

-- payouts: author read-only (writes happen via service role)
ALTER TABLE payouts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authors see own payouts" ON payouts
  FOR SELECT USING (auth.uid() = author_id);

-- follows: public read; users manage their own follow rows
ALTER TABLE follows ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can read follows" ON follows
  FOR SELECT USING (true);
CREATE POLICY "Users manage own follows" ON follows
  USING (auth.uid() = follower_id) WITH CHECK (auth.uid() = follower_id);

-- waitlist: anyone may join; no public read (service role reads for admin/export)
ALTER TABLE waitlist ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can join waitlist" ON waitlist
  FOR INSERT WITH CHECK (true);

-- ai_drafts: author-scoped
ALTER TABLE ai_drafts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authors see own drafts" ON ai_drafts
  USING (auth.uid() = author_id) WITH CHECK (auth.uid() = author_id);

-- book_analytics: author of the book may read
ALTER TABLE book_analytics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authors read own analytics" ON book_analytics
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM books b WHERE b.id = book_id AND b.author_id = auth.uid())
  );
