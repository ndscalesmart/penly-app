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
