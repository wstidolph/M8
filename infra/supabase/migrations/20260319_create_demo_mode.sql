-- Feature: Demonstration Mode (013)
-- Purpose: Sandbox environment for stakeholder walkthroughs.

-- 1. Demo Notifications Interceptor Table
CREATE TABLE IF NOT EXISTS public.demo_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient TEXT NOT NULL,
    type TEXT NOT NULL,
    body TEXT NOT NULL,
    payload JSONB,
    occurred_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for Demo Notifications (Only Admins/Demo users can read)
ALTER TABLE public.demo_notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can subscribe to their own intercepted notifications"
ON public.demo_notifications
FOR SELECT
USING (TRUE); -- For MVP Demo, we allow anyone signed in to see the interceptor log

-- 2. Add is_demo_mode to Profiles
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_demo_mode BOOLEAN DEFAULT FALSE;

-- 3. The "Mystical Reset" RPC
CREATE OR REPLACE FUNCTION public.reset_mystical_state()
RETURNS JSONB AS $$
DECLARE
    v_author_id UUID;
    v_set_id UUID;
BEGIN
    -- 1. Clean Slate (for demo tables)
    DELETE FROM public.transactions;
    DELETE FROM public.gifts;
    DELETE FROM public.answers;
    DELETE FROM public.answer_sets;
    DELETE FROM public.demo_notifications;

    -- 2. Ensure Seed Author is confirmed and identified
    UPDATE auth.users SET email_confirmed_at = NOW() WHERE email = 'john@m8.com';

    v_author_id := (SELECT id FROM profiles WHERE email = 'john@m8.com' LIMIT 1);
    
    IF v_author_id IS NULL THEN
        -- If user doesn't exist, we skip seeding sets but return success
        RETURN jsonb_build_object('success', true, 'message', 'Tables cleared. (Author profile not found; sign up as john@m8.com then reset again)');
    END IF;

    -- 3. Intercept Reset Notification
    INSERT INTO public.demo_notifications (recipient, type, body)
    VALUES ('john@m8.com', 'AUTH_BYPASS', 'Mystical Reset triggered: john@m8.com has been automatically confirmed.');

    -- 4. Seed "Standard Set"
    v_set_id := gen_random_uuid();
    INSERT INTO public.answer_sets (set_id, author_id, label, status, target_method)
    VALUES (v_set_id, v_author_id, 'Standard Set', 'ACTIVE', 'SMS');

    INSERT INTO public.answers (answer_id, set_id, response_text, sequence_order)
    VALUES 
        (gen_random_uuid(), v_set_id, 'Yes, absolutely', 0),
        (gen_random_uuid(), v_set_id, 'It is decidedly so', 1),
        (gen_random_uuid(), v_set_id, 'Without a doubt', 2),
        (gen_random_uuid(), v_set_id, 'Yes - definitely', 3),
        (gen_random_uuid(), v_set_id, 'Reply hazy, try again', 4),
        (gen_random_uuid(), v_set_id, 'Concentrate and ask again', 5),
        (gen_random_uuid(), v_set_id, 'Don''t count on it', 6),
        (gen_random_uuid(), v_set_id, 'My sources say no', 7);

    RETURN jsonb_build_object('success', true, 'message', 'Mystical state reset and re-seeded.');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
