# Task Checklist: Demonstration Mode (013)

- [ ] **T13.1: Database Infrastructure Extensions** (P1)
  - [ ] Create `demo_notifications` table in Supabase.
  - [ ] Add `is_demo_mode` column to `profiles` table.
- [ ] **T13.2: Seed Procedure (SQL)** (P1)
  - [ ] Create `reset_mystical_state()` RPC.
  - [ ] Implement `clear_and_seed_demo_state` SQL script.
- [ ] **T13.3: Connectivity Interceptor** (P2)
  - [ ] Modify `send_connectivity` Edge Function to write to `demo_notifications` if target provides `DEMO` flag or is a demo user.
- [ ] **T13.4: Demo Toolbox UI** (P3)
  - [ ] Create `DemoDrawer.tsx` to visualize "Intercepted" SMS/Email.
  - [ ] Add a "Demo Status" overlay in the corner of the Author Dashboard.
  - [ ] Implement a "Switch Persona" mockup (simulated auth switch).
- [ ] **T13.5: Final Demo Validation** (P4)
  - [ ] Walk through the complete flow (Author -> Checkout -> Notification Intercept -> Guardian portal) using only the "Mock" path.
