# Feature Specification: Payments (011)

**Feature Branch**: `011-payments`  
**Created**: 2026-03-19  
**Status**: Draft  
**Ref PRD**: Section 6, 7.1

## 1. Overview
Project M8 requires a monetization layer where Authors pay to distribute customized Answer Sets. To accelerate development and test the user flow, this feature will be implemented in two phases. 

**Phase 1 (MVP)**: A "Mock Payment" experience that stubs out the external gateway. Authors go through a full-fidelity checkout UI, but no real money is exchanged. This ensures the backend integration (Transaction -> Gift activation) is robust. 
**Phase 2**: Real integration with Stripe, Apple Pay, and Google Pay.

## 2. User Scenarios & Testing

| ID | Scenario | Success Criteria |
|----|----------|------------------|
| **US1** | **Mock Checkout Flow** | Author clicks "Checkout & Send". A demo payment overlay (mimicking Stripe) appears. |
| **US2** | **Full Distribution Loop** | Upon "Confirm Demo Payment", the AnswerSet/Gift moves to `ACTIVE` (or gated if underage). |
| **US3** | **Transaction History** | Author can see a list of payments/balances in their dashboard, even if they were simulated. |
| **US4** | **Payment Provider Flexibility** | The data model supports multiple providers (e.g., `MOCK`, `STRIPE`), allowing easy swap-in for Phase 2. |

## 3. Implementation Requirements

### 3.1 Data Model Extensions (Supabase)
- **Transactions Table**: 
  - `txn_id` (PK)
  - `user_id` (Author)
  - `gift_id` (Ref to the delivery)
  - `amount` (e.g., 2.00)
  - `currency` (e.g., USD)
  - `provider` (`MOCK`, `STRIPE`, `APPLE_PAY`)
  - `status` (`SUCCEEDED`, `FAILED`, `PENDING`)
  - `metadata` (JSON for external provider logs)

### 3.2 Frontend Logic (Next.js)
- **Checkout Modal**: A premium glassmorphic modal that intercepts the "Send" action.
- **Stubbed Gateway Service**: A Javascript class/service that simulates latent network requests and returns successful payment tokens.

## 4. Acceptance Criteria
- [ ] Author is presented with a payment UI before a gift is sent.
- [ ] Successful mock payment updates the `gifts.status`.
- [ ] Transaction history reflects the $2.00 charge in the Author dashboard.
- [ ] Database schema is decoupled from Stripe specifically to allow Phase 2 scaling.

## 5. Metadata
- **Standard Fee**: $2.00 USD per set.
- **Default Provider (Phase 1)**: `MOCK`.
