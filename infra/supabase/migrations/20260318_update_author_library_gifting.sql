-- Feature: Author Library & Gifting (008)
-- Purpose: Support for Templates, Cloning, and Gift Tracking.

-- 1. Soft Deletion Support for AnswerSets
ALTER TABLE public.answer_sets 
ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN NOT NULL DEFAULT FALSE;

-- 2. Gifts Table (Delivery Log & Instance)
CREATE TABLE IF NOT EXISTS public.gifts (
    gift_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    set_id UUID NOT NULL REFERENCES public.answer_sets(set_id), -- Template Source
    author_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE, -- Sender
    target_contact TEXT NOT NULL, -- Email or Phone Identity
    status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'DELETED', 'EXPIRED')),
    sent_at TIMESTAMPTZ DEFAULT NOW(),
    expires_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '30 days')
);

-- 3. Enable RLS
ALTER TABLE public.gifts ENABLE ROW LEVEL SECURITY;

-- 4. POLICIES: Gifts
-- Author can see and manage their sent gifts
CREATE POLICY "Authors can manage their own sent gifts" 
ON public.gifts 
FOR ALL 
USING (auth.uid() = author_id);

-- Anyone can READ a gift if they have the gift_id (for Deep Link acceptance)
CREATE POLICY "Public Read Access for Gifts"
ON public.gifts
FOR SELECT
USING (TRUE);

-- 5. Updated RLS: AnswerSets
-- Author can select non-deleted sets
CREATE POLICY "Authors see own non-deleted sets"
ON public.answer_sets
FOR SELECT
USING (auth.uid() = author_id AND NOT is_deleted);

-- 6. Trigger for updated_at (Gifts)
CREATE TRIGGER update_gifts_modtime
BEFORE UPDATE ON public.gifts
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();
