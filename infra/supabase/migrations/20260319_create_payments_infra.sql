-- Feature: Payments (011)
-- Purpose: Transaction tracking for monetization.

-- 1. Transactions Table
CREATE TABLE IF NOT EXISTS public.transactions (
    txn_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    gift_id UUID REFERENCES public.gifts(gift_id),
    amount DECIMAL(10,2) NOT NULL DEFAULT 2.00,
    currency TEXT NOT NULL DEFAULT 'USD',
    provider TEXT NOT NULL DEFAULT 'MOCK',
    status TEXT NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SUCCEEDED', 'FAILED')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Index for quick lookup in history
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON public.transactions(user_id);

-- 3. Enable RLS
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- 4. POLICIES: Transactions
-- Author can see their own payments
CREATE POLICY "Authors can see own transactions" 
ON public.transactions 
FOR SELECT 
USING (auth.uid() = user_id);

-- Create policy for insertion (Author initiates txn)
CREATE POLICY "Authors can initiate transactions"
ON public.transactions
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Create policy for update (Author completes txn via Mock/Real)
CREATE POLICY "Authors can update own transactions"
ON public.transactions
FOR UPDATE
USING (auth.uid() = user_id);

-- 5. Trigger for updated_at
CREATE TRIGGER update_transactions_modtime
BEFORE UPDATE ON public.transactions
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();
