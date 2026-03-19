-- Feature: Atomic Checkout (Quality Fix)
-- Purpose: Ensures Gift creation and Transaction recording happen together or not at all.

CREATE OR REPLACE FUNCTION public.process_gift_checkout(
    p_set_id UUID,
    p_author_id UUID,
    p_target_contact TEXT,
    p_status TEXT,
    p_amount DECIMAL,
    p_provider TEXT,
    p_txn_id UUID
) RETURNS JSONB AS $$
DECLARE
    v_gift_id UUID;
BEGIN
    -- 1. Create the Gift
    INSERT INTO public.gifts (set_id, author_id, target_contact, status)
    VALUES (p_set_id, p_author_id, p_target_contact, p_status)
    RETURNING gift_id INTO v_gift_id;

    -- 2. Create the Transaction record
    INSERT INTO public.transactions (txn_id, user_id, gift_id, amount, provider, status)
    VALUES (p_txn_id, p_author_id, v_gift_id, p_amount, p_provider, 'SUCCEEDED');

    RETURN jsonb_build_object('success', true, 'gift_id', v_gift_id);
EXCEPTION WHEN OTHERS THEN
    RAISE LOG 'Checkout Failure: %', SQLERRM;
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
