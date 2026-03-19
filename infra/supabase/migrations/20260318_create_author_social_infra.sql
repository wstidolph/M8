-- Feature: Author Social Infrastructure (007)
-- Purpose: Backend logic for custom Answer Sets, Invitations, and Distribution.

-- 1. Answer Sets (The Container)
CREATE TABLE IF NOT EXISTS public.answer_sets (
    set_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    label TEXT NOT NULL DEFAULT 'Mystic Responses',
    target_method TEXT NOT NULL, -- 'EMAIL' or 'PHONE'
    is_pending_review BOOLEAN NOT NULL DEFAULT FALSE,
    status TEXT NOT NULL CHECK (status IN ('DRAFT', 'ACTIVE', 'ARCHIVED')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Answers (The Content)
CREATE TABLE IF NOT EXISTS public.answers (
    answer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    set_id UUID NOT NULL REFERENCES public.answer_sets(set_id) ON DELETE CASCADE,
    response_text TEXT NOT NULL CHECK (char_length(response_text) <= 70),
    sequence_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Invitation Tokens (Distribution)
CREATE TABLE IF NOT EXISTS public.invitations (
    invite_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    set_id UUID NOT NULL REFERENCES public.answer_sets(set_id) ON DELETE CASCADE,
    author_id UUID REFERENCES auth.users(id),
    is_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    claimed_by UUID REFERENCES auth.users(id),
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.answer_sets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;

-- POLICIES: Answer Sets
-- Author can do everything to their own sets
CREATE POLICY "Authors full access to own sets" 
ON public.answer_sets 
FOR ALL 
USING (auth.uid() = author_id);

-- Anyone with a valid invitation can READ the set (used by Questioner)
-- Naive view: if you have the set_id, you can read. 
-- In production, we'd join with public.invitations.
CREATE POLICY "Invitee read access"
ON public.answer_sets
FOR SELECT
USING (TRUE); -- Refine later with JWT role checks

-- POLICIES: Answers
-- Author full access
CREATE POLICY "Authors full access to own answers"
ON public.answers
FOR ALL
USING (EXISTS (
    SELECT 1 FROM public.answer_sets 
    WHERE public.answer_sets.set_id = public.answers.set_id 
    AND public.answer_sets.author_id = auth.uid()
));

-- Invitee read access
CREATE POLICY "Invitee answer read access"
ON public.answers
FOR SELECT
USING (TRUE);

-- Trigger for update_at
CREATE TRIGGER update_answer_sets_modtime
BEFORE UPDATE ON public.answer_sets
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();
