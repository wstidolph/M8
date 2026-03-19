# Task Checklist: Author Library & Gifting Ecosystem (008)

- [ ] **T008.1: Backend Infrastructure (Migration)** (P1)
  - [ ] Add `is_deleted` (boolean) to `public.answer_sets`.
  - [ ] Create `public.gifts` table (gift_id, set_id, author_id, contact, status, timestamps).
  - [ ] Enable RLS for `gifts` table (Author access).
- [ ] **T008.2: Library Dashboard (Next.js)** (P1)
  - [ ] Fetch all non-deleted `AnswerSets` for the current `user.id`.
  - [ ] Implement "Delete Set" (Soft Delete).
  - [ ] Implement "Clone Set" (Select a set, duplicate it into a new set_id).
- [ ] **T008.3: Gifting Pipeline (Supabase)** (P1)
  - [ ] Create "Send to Questioner" form (Select set from library, input email/phone).
  - [ ] Insert new `gift_id` into `public.gifts`.
  - [ ] Generate the unique distribution link (`m8ball://accept?id={gift_id}`).
- [ ] **T008.4: Gift Tracking History** (P2)
  - [ ] Build the "Sent Gifts" log view in the Web App.
  - [ ] Show status badges for `ACTIVE`, `DELETED`, `EXPIRED`.
  - [ ] Add "Revoke Gift" action (Soft delete gift).
- [ ] **T008.5: Questioner Sync Upgrade (Mobile)** (P2)
  - [ ] Update `invitation_handler.dart` to check `gift` status before accepting.
  - [ ] Fetch set via `gift_id` relationship.

## Acceptance Criteria
- [ ] Author can duplicate an "8-Answer Set" in under 1 second.
- [ ] Deleting a set does NOT hide existing gifts already sent from that set's history.
- [ ] A Questioner cannot use a "Revoked" (Deleted) gift.
