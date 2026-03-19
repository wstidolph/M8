# Implementation Plan: Parental Review Gateway (009)

**Feature Branch**: `009-parental-review-gateway`  
**Status**: Planning

## Architecture

- **Auth Layer**: Create Table `profiles` triggered by `auth.users` creation.
- **Review Logic**: Add `PENDING_REVIEW` to `gift_status` enum in the database.
- **Workflow**: 
  - Author sends Gift -> Database Check (is recipient underage?) -> Set status to `PENDING_REVIEW`.
  - Guardian reviews -> Set status to `ACTIVE`.

## Development Phases

### Phase 1: Database Extensions (P1)
- Create `profiles` table with `date_of_birth` and `guardian_email`.
- Add Trigger: Automatically insert profile when a new user signs up.
- Add `CHECK` constraints to ensure `guardian_email` exists for users under 13.
- Update `gifts` status enum to include `PENDING_REVIEW`.

### Phase 2: Interception Web Layer (P1)
- Add "Approval Mode" to the Author Dashboard (simulated for now, allowing anyone to act as a guardian for testing).
- Modify the "Checkout & Send" logic to check if a target recipient profile exists and if they are underage.

### Phase 3: Flutter Questioner Restriction (P1)
- Update `AnswerRepository` (Mobile) to query `gifts` status.
- Filter out anything not `ACTIVE`.
- Show "Waiting for Parental Review" in the `AcceptanceScreen`.

### Phase 4: Approval Flow Simulation (P2)
- Create a minimal "Guardian Portal" mock (web page) to approve/reject gifts.
- Integrate "Approval" with the Supabase Gift status.

## Data Model (009 Extensions)

```sql
ALTER TABLE gifts DROP CONSTRAINT gifts_status_check;
ALTER TABLE gifts ADD CONSTRAINT gifts_status_check 
CHECK (status IN ('ACTIVE', 'DELETED', 'EXPIRED', 'PENDING_REVIEW', 'REJECTED'));
```
