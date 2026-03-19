# Task Checklist: User Connectivity (012)

- [x] **T12.1: Database Infrastructure Extensions** (P1)
  - [x] Add `rejection_reason` to `gifts` table in Supabase.
  - [x] Add `notification_status` column to `gifts` for tracking delivery.
- [x] **T12.2: Guardian Review logic refinement** (P1)
  - [x] Update `src/app/guardian/approve/page.tsx` with **Reject & Feedback** button.
  - [x] Implement `handleReject` logic updating gift status to 'REJECTED'.
- [x] **T12.3: SMS/Email Dispatchers (Supabase Edge Functions)** (P2)
  - [x] Create `/supabase/functions/send_connectivity/index.ts`.
  - [x] Integrate **Resend** (Email) for Questioners/Guardians.
  - [x] Integrate **Twilio** (SMS) for Author distributions.
- [x] **T12.4: Database Automation** (P2)
  - [x] Create `notify_on_gift_create` trigger on `gifts` table.
  - [x] Fire the Edge Function automatically when a new gift is inserted.
- [x] **T12.5: Author Feedback UI** (P3)
  - [x] Update `GiftsLog.tsx` in Author Dashboard to show rejected status/reason.
  - [x] Highlight "Gift Rejection" in the library view.
