# Task Checklist: Parental Review Gateway (009)

- [x] **T009.1: Database Infrastructure Extensions** (P1)
  - [x] Create `profiles` table with `date_of_birth` and `guardian_email`.
  - [x] Create `auth.users` profile trigger.
  - [x] Add `CHECK` constraints for status enum: `PENDING_REVIEW` and `REJECTED`.
- [x] **T009.2: Age-Verification Web Integration** (P1)
  - [x] Add `date_of_birth` input to signup/profile management in `auth/page.tsx`.
  - [x] Block "Checkout" for recipients who are under 13 but have no linked guardian (or auto-tag as `PENDING_REVIEW`).
- [ ] **T009.3: Flutter Restriction Interface** (P1)
  - [x] Update `AnswerRepository` to filter gifts by `status == 'ACTIVE'`.
  - [ ] Implement `ParentalGatingScreen` (Overlay) when a gift is `PENDING_REVIEW`.
- [x] **T009.4: Simple Guardian portal** (P2)
  - [x] Create a page (mock) `/guardian/approve?id={gift_id}`.
  - [x] Allow clicking "Approve" to move status to `ACTIVE`.
