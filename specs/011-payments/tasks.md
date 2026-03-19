# Task Checklist: Payments (011)

- [x] **T011.1: Database Infrastructure Extensions** (P1)
  - [x] Create `transactions` table in Supabase connected to Authors/Gifts.
  - [x] Add RLS for `transactions`.
- [x] **T011.2: Mock Payment Frontend Overlay** (P1)
  - [x] Create `MockPaymentModal.tsx` in `apps/m8_web/src/components/`.
  - [x] Design: Glassmorphism, checkout spinner, and 2.00 price tag.
- [x] **T011.3: Checkout Logic Refactor** (P1)
  - [x] Update `handleCheckout` in `page.tsx` to handle the transactional workflow.
  - [x] Link successful mock payment to `gifts.status` activation.
- [x] **T011.4: Author Transaction Dashboard** (P2)
  - [x] Add "Transactions" tab in Author Dashboard UI.
  - [x] Implement `fetchTransactions` and list payments showing "MOCK" or "DEMO" status.
- [ ] **T011.5: Phase 2 Planning** (P3)
  - [ ] Placeholder for Stripe provider logic mapping.
