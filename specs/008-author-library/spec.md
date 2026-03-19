# Feature Specification: Author Library & Gifting Ecosystem (008)

**Feature Branch**: `008-author-library-gifting`  
**Created**: 2026-03-18  
**Status**: Formalized  
**Ref PRD**: Section 2.2, 4.2.1 (The Gifting Flow)

## 1. Overview
The **Author Library** is the persistent storage for customized mystical "Answer Sets". This feature allows Authors to manage templates, clone them for rapid iteration, and track their delivery as "Gifts" to specific recipients. This transitions the M8 platform from one-off drafted sets to a manageable mystical catalog.

## 2. User Scenarios & Testing

| ID | Scenario | Success Criteria |
|----|----------|------------------|
| **US8.1** | **Library View** | Author sees a paginated or scrollable list of all saved `AnswerSets` with labels (e.g., "From John", "Office Jokes"). |
| **US8.2** | **Full Life Cycle** | Author can **Delete** an existing set (soft-delete) or **Edit** one already in the library. |
| **US8.3** | **Rapid Cloning (T008.2)** | Author clicks "Duplicate" on an existing set. A new set is created with the same 8 answers, ready for selective modification. |
| **US8.4** | **The Gifting Pipeline** | From the library, the Author selects a set and clicks "Send to Questioner". They input the target email/phone to generate a unique **Gift Instance**. |
| **US8.5** | **Gift Tracking Dashboard** | Author can see which `AnswerSets` have been sent to which contacts, including the status of the invitation (ACTIVE / DELETED / EXPIRED). |

## 3. Implementation Requirements

### 3.1 Template Logic (L1)
- **Soft Delete**: Mark `is_deleted = true` instead of physical deletion to preserve "Gift" history for Questioners.
- **Deep-Copy Cloning**: Server-side or client-side logic to replicate the 8 child `Answers` into a new `AnswerSet`.

### 3.2 Gifting Module (L1)
- **Gift Instance**: A new table entry that links an `Author`, a `TemplateSet`, and a `QuestionerIdentity`.
- **Status Lifecycle**:
  - `ACTIVE`: The invitation link is valid and hasn't been used or expired.
  - `EXPIRED`: The link was not claimed within X days (configurable).
  - `DELETED`: The Author explicitly revoked the gift.

### 3.3 Visual Identity (L2) - Premium Zero UI
- **Library Sidebar**: A minimalist "Mystic Drawer" for saved sets.
- **Gift Log View**: A table or list view with status badges (Glassmorphism icons).
- **Smooth Transitions**: Floating action menus for Clone/Delete.

## 4. Acceptance Criteria
- [ ] Author can see at least 5 sets in the library without performance lag.
- [ ] Deleting a set does NOT break any existing gifted links already sent (Principle IV - Resilience).
- [ ] Cloning a set correctly replicates all 8 answer strings into a new database ID.
- [ ] Author is prevented from sending the same set to the same contact twice without a warning.

## 5. Metadata
- **Platform**: Web (Next.js 16)
- **Backend Integration**: Supabase Auth + Postgres RLS.
- **Governance**: Strictly adheres to **M8 Constitution v1.0.0 (Principle II & IV)**.
