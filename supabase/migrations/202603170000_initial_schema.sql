-- Initial M8 Schema Migration

-- ==========================================
-- 1. Custom Types
-- ==========================================
CREATE TYPE user_role AS ENUM ('AUTHOR', 'QUESTIONER', 'ADMIN');
CREATE TYPE auth_method AS ENUM ('EMAIL', 'PHONE', 'OAUTH');
CREATE TYPE target_method AS ENUM ('EMAIL', 'PHONE');
CREATE TYPE answer_set_status AS ENUM ('DRAFT', 'PAID', 'PENDING_REVIEW', 'SENT', 'ACCEPTED', 'REJECTED');
CREATE TYPE payment_status AS ENUM ('PENDING', 'COMPLETED', 'FAILED');
CREATE TYPE delivery_status AS ENUM ('QUEUED', 'SENT', 'DELIVERED', 'FAILED');

-- ==========================================
-- 2. Tables
-- ==========================================

-- Users Table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_method auth_method NOT NULL,
    email_address TEXT UNIQUE,
    phone_number TEXT UNIQUE,
    role user_role NOT NULL DEFAULT 'QUESTIONER',
    is_underage BOOLEAN NOT NULL DEFAULT false,
    date_of_birth DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_login TIMESTAMPTZ
);

-- AnswerSets Table
CREATE TABLE answer_sets (
    set_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    target_method target_method NOT NULL,
    label TEXT NOT NULL,
    status answer_set_status NOT NULL DEFAULT 'DRAFT',
    expiration_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Answers Table
CREATE TABLE answers (
    answer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    set_id UUID NOT NULL REFERENCES answer_sets(set_id) ON DELETE CASCADE,
    response_text TEXT NOT NULL CHECK (char_length(response_text) <= 70),
    associated_question TEXT,
    sequence_order INT NOT NULL CHECK (sequence_order >= 0 AND sequence_order <= 7)
);

-- Invitations / Transactions Table
CREATE TABLE invitations (
    invite_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    set_id UUID NOT NULL REFERENCES answer_sets(set_id) ON DELETE CASCADE,
    target_contact TEXT NOT NULL,
    deep_link_url TEXT NOT NULL,
    payment_status payment_status NOT NULL DEFAULT 'PENDING',
    delivery_status delivery_status NOT NULL DEFAULT 'QUEUED',
    sent_at TIMESTAMPTZ
);

-- ==========================================
-- 3. Row Level Security (RLS) Stubs
-- ==========================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE answer_sets ENABLE ROW LEVEL SECURITY;
ALTER TABLE answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE invitations ENABLE ROW LEVEL SECURITY;

-- Minimal policies (to be refined in development)
-- Example: Allow users to select their own data
CREATE POLICY "Users can view their own data" ON users
FOR SELECT USING (auth.uid() = user_id);

-- Example: Authors can manage their own AnswerSets
CREATE POLICY "Authors can manage their own answer sets" ON answer_sets
FOR ALL USING (auth.uid() = author_id);

-- Example: Questioners can see answers from sets sent to their email/phone
-- (Note: auth.jwt() would be used here in a real Supabase environment)
