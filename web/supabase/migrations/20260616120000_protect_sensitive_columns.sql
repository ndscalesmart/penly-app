-- Harden users table: prevent self-service edits to privileged columns.
--
-- The "Users manage own profile" RLS policy allows a user to UPDATE their own
-- row — which, without column restrictions, would let anyone set their own
-- role to 'admin' or change their royalty_rate. Column-level GRANTs fix this:
-- authenticated users may only update non-privileged profile fields. The
-- service role (admin operations, dashboard, handle_new_user trigger) bypasses
-- these grants and RLS entirely.

REVOKE UPDATE ON public.users FROM anon, authenticated;

GRANT UPDATE (
  username,
  full_name,
  bio,
  avatar_url,
  website_url,
  twitter_handle
) ON public.users TO authenticated;

-- Privileged columns intentionally NOT granted (only the service role may set
-- them): role, plan, plan_expires_at, royalty_rate, total_earnings,
-- stripe_customer_id, stripe_account_id, stripe_onboarded, email_verified,
-- is_active.
