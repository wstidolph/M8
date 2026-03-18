---
description: Supabase architecture for gifts, invitations, and age-verification.
---

# M8 Backend & Distribution Strategy

## 1. Schema Management (Supabase)
- **Table `answer_sets`**: 
  - Columns: `id`, `author_id`, `label`, `is_pending_review` (boolean), `status` (draft/active).
  - RLS: Ensure only the `author` can edit, but any `invitee` (via token) can read.
- **Table `answers`**: FK to `answer_sets`. Strictly enforce the **70 character limit**.

## 2. Invitation Flow
- **UUID Generation**: Generate unique `invite_id` tokens for deep-link generation upon payment.
- **Protocol**: `m8ball://accept?id={uuid}`.
- **Deep Linking**: Use the `app_links` package to register intent filters for both iOS and Android.

## 3. Age-Gate Logic
- **DOB Check**: If `Questioner.dob < 13 years`, automatically set `is_pending_review = true`.
- **Parental Logic**: The `answer_set` must remain in a `pending` state until a `parent_approved` update is triggered via the Supabase Admin API.
