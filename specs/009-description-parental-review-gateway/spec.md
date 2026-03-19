# Feature Specification: Parental Review Gateway (009)

**Feature Branch**: `009-parental-review-gateway`  
**Created**: 2026-03-18  
**Status**: Draft  
**Ref PRD**: Section 4.3

## 1. Overview
M8 requires strict safety for underage Questioners. This feature implements an "Age-Gated Approval Tank" where gifted answer sets directed to users under 13 must be audited and approved by a linked Guardian before they can be accepted in the orb.

## 2. User Scenarios & Testing

| ID | Scenario | Success Criteria |
|----|----------|------------------|
| **US1** | **Age Verification Setup** | Questioner registers DOB. If < 13, they MUST provide a `guardian_email` to proceed. |
| **US2** | **Gift Interception** | Author sends a gift to an underage recipient. The gift state automatically becomes `PENDING_REVIEW` instead of `ACTIVE`. |
| **US3** | **Guardian Approval** | Guardian receives an approval link (simulated via Web UI for now). Upon approval, the gift moves to `ACTIVE`. |
| **US4** | **Restricted Access** | Underage Questioner cannot accept or load a `PENDING_REVIEW` gift into their orb. |

## 3. Implementation Requirements

### 3.1 Data Model Extensions (Supabase)
- **Profiles Table**: 
  - `user_id` (PK, Auth.users.id)
  - `date_of_birth` (Date)
  - `guardian_email` (Text, optional)
  - `is_age_verified` (Boolean)
- **Gifts Table Update**: 
  - Add `PENDING_REVIEW` to the `status` enum.
  - Add `reviewed_at` and `reviewed_by` fields.

### 3.2 Gatekeeping Logic (App & Web)
- **Web Dashboard**: 
  - Author sees "Pending Review" status in Gift History if the recipient is gated.
- **Flutter App**:
  - `AnswerRepository` must filter out `PENDING_REVIEW` gifts from its pool.
  - Show a "Waiting for Parent" overlay instead of the mystical "Accept" prompt.

### 3.3 Constitution Alignment
- **Privacy & Safety (Principle IV)**: M8 deals with direct communication ("Gifts"); thus, user safety is paramount. 
- date of birth (DOB) verification is mandatory for all members.

## 4. Acceptance Criteria
- [ ] User profile persists DOB and guardian email.
- [ ] Gifts to users < 13 are created in a `PENDING_REVIEW` status.
- [ ] Guardian can toggle status to `ACTIVE` via a secured approval action.
- [ ] Questioner app correctly blocks unreviewed content.

## 5. Metadata
- **Threshold**: 13 years old.
- **Review Method**: Manual Guardian trigger.
