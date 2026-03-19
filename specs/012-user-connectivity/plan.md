# Implementation Plan: User Connectivity (012)

Phase 1 focus: SMS/Email automation using Supabase Edge Functions with Resend & Twilio.

## Phase 1: Infrastructure & Dispatchers

### P1: Database Configuration
- [ ] **T12.1: Add `rejection_reason` to `gifts` table.**
  - Allow Guardians to optionally provide an explanation (e.g., "Inappropriate for age").
- [ ] **T12.2: Create `notifications_log` table (Optional)** 
  - To track successfully delivered SMS/Emails for debugging.

### P2: Supabase Edge Functions
- [ ] **T12.3: `send-notification` (Deno)**
  - Integrate **Twilio SDK** and **Resend SDK**.
  - Dispatch based on `HTTP POST` request containing target, type, and payload.
- [ ] **T12.4: Database Webhook (Gifts Insert)**
  - Auto-trigger on `gifts` table insertions to fire the `send-notification` function.

### P3: Guardian UI Refinement
- [ ] **T12.5: Update `approve/page.tsx` for Rejection.**
  - Add a rejection button and logic to update the `gifts` status with a reason.
- [ ] **T12.6: Author Dashboard Notification UI.**
  - Highlight "REJECTED" gifts in the `GiftsLog` component within `AuthorDashboard`.

## Phase 2: User Persistence & Scaling (Out of Scope)
- SMS/Email rate limiting.
- Multiple-recipient/Group M8s.
- Custom Email Templates (HTML/Mystical aesthetic).
- Phase 2: "Edit & Approve" for Guardians instead of binary Reject.
