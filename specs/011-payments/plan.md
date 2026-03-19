# Implementation Plan: Payments (011)

**Feature Branch**: `011-payments`  
**Status**: Planning

## Architecture

- **Mock Payment Workflow**: Author UI triggers a `PaymentService.mockCheckout()` which adds a row to `transactions` and updates `gifts.status`.
- **Payment Abstraction**: The backend for `gifts` will eventually wait for a successful transaction record before distribution is enabled.

## Development Phases

### Phase 1: Transactions Database (P1)
- Create `transactions` table in Supabase.
- Link `transactions` to `gifts`.
- RLS: Authors can only see their own transactions.

### Phase 2: Mock Checkout UI (P1)
- Create `MockPaymentModal.tsx` component.
- Visual elements: Card number placeholder, "2.00" price tag, "Confirm" loading states.
- Mocking a 1.5s delay to simulate gateway communication.

### Phase 3: Gift Activation Integration (P1)
- Update "Checkout & Send" logic in `page.tsx` (`handleCheckout`) to be multi-step:
  1. Draft created.
  2. Transaction record created (`Status: PENDING`).
  3. Payment UI shown.
  4. On success, `transactions.status` -> `SUCCEEDED` and `gifts.status` updated.

### Phase 4: Author Transaction History (P2)
- Add a new "Transactions" tab/section in the Web Dashboard.
- Show rows: Date, Amount, Gift Label, Status.

## Data Model (011 Extensions)

```sql
CREATE TABLE IF NOT EXISTS public.transactions (
    txn_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    gift_id UUID REFERENCES public.gifts(gift_id),
    amount DECIMAL(10,2) NOT NULL DEFAULT 2.00,
    currency TEXT NOT NULL DEFAULT 'USD',
    provider TEXT NOT NULL DEFAULT 'MOCK',
    status TEXT NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SUCCEEDED', 'FAILED')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```
