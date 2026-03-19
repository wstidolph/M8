# Implementation Plan: Demonstration Mode (013)

Phase 1: Seed Data, Interceptor Logic, and Reset RPC.

## Phase 1: Infrastructure & Automation

### P1: Database Configuration
- [ ] **T13.1: Create `demo_notifications` table.**
  - Columns: `id, recipient, type, body, occurred_at`.
- [ ] **T13.2: Update `profiles` table with `is_demo_mode` boolean.**
- [ ] **T13.3: Create `reset_mystical_state()` RPC.**
  - Clears `gifts`, `transactions`, `answers`.
  - Re-seeds 8 answers for "Standard Set" and "The Future" sets.

### P2: Edge Function Interceptor (012 Enhancement)
- [ ] **T13.4: Modify `send_connectivity` logic.**
  - If target is a "Demo User" or if in Demo Mode, write to `demo_notifications` instead of (or in addition to) trying to hit Twilio API.

### P3: Demo UI (Author Dashboard)
- [ ] **T13.5: Create `DemoDrawer.tsx` component.**
  - Subscribes to `demo_notifications` in real-time using Supabase.
  - Shows an "Incoming SMS/Email" overlay during the checkout demo.
- [ ] **T13.6: Demo Tools Overlay.**
  - Include "Reset Environment" button (calling P1 RPC).
  - Include "Switch Persona" quick links (Mocks `supabase.auth.setSession` for the demo).

## Phase 2: Refined Assets
- Pre-made "Mystic" answer sets (Standard, Zen, Chaotic).
- Realistic seed images/avatars for the Demo Personas (if needed for Phase 2).
