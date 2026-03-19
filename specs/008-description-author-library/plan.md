# Implementation Plan: Author Library & Gifting Ecosystem (008)

**Feature Branch**: `008-author-library-gifting`  
**Status**: Planning

## 1. Architecture Overview
- **Storage**: Supabase Postgres for templates and gift history.
- **Backend Logic**: Supabase Edge Functions for sending the invitations (Gifting Flow).
- **Frontend**: Next.js 16 (App Router) for the Author Dashboard.
- **Mobile**: Flutter for the Questioner receiving the gift.

## 2. Development Phases

### Phase 1: Library Infrastructure (P1)
- Refactor `AnswerSets` into a template-driven model.
- Implement **Soft Delete** (`is_deleted` column in SQL).
- Implement **The Clone Action** (Select existing `AnswerSet`, replicate answers into a new `AnswerSet` with a "Copy of..." label).

### Phase 2: Gifting & Distribution Pipeline (P1)
- Create the `gifts` table to track delivery.
- Implement "Send to Questioner" (Select a library set, input Target Contact, create `gift_id`).
- Generate unique **Distribution Tokens** for the deep-link protocol (`m8ball://accept?id={gift_id}`).

### Phase 3: Gift Tracking & Status (P2)
- Build the "Author Log" view showing sent gifts and their status (Active/Expired).
- Implement **Expiration Logic** (Gifts automatically transition to `EXPIRED` status after 30 days).
- Add "Revoke Gift" (Author soft-deletes a `gift_id` to block further access).

### Phase 4: Mobile Integration (P3)
- Update Flutter app to:
  - Fetch custom sets using `gift_id` instead of `set_id` directly (Feature 007 upgrade).
  - Verify if the `gift` status is `ACTIVE` before allowing use.

## 3. Database Migration Strategy
- Migration: `20260318_update_author_library_gifting.sql`.
- Add `is_deleted` to `public.answer_sets`.
- Add `public.gifts` table with FK to `public.answer_sets(set_id)`.
- Enable RLS policies.
