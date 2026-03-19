# Feature Spec: User Connectivity (012)

Connect the Web Creator and the Mobile Questioner via automated SMS and Email communications.

## 1. Overview
The **User Connectivity** feature acts as the "nervous system" of M8. It handles the dispatch of invitation links to Questioners and approval links to Guardians (as specified in **PRD Section 7.3**). In Phase 1, we will use **Supabase Edge Functions** integrated with **Resend** (Email) and **Twilio** (SMS) to automate these flows.

## 2. Notification Flows (Phase 1)
| Trigger | Event | Medium | Payload |
|:---|:---|:---|:---|
| **Author Checkout** | New Gift sent | SMS/Email | "New M8 from [Author]! View: [DeepLink]" |
| **Questioner Setup** | Underage Registration | Email | "Your child has registered for M8. Please verify: [Link]" |
| **Gift Delivery** | Underage Recipient | Email | "[Questioner] received a mystical gift. Review needed: [Link]" |
| **Guardian Reject** | Gift Denied | Dashboard | Update Gift status to 'REJECTED' (Notification in Author UI) |

## 3. Guardian Review Logic
### Decision: "Entire Set" Review (MVP)
To maintain the mystical "set" integrity, the Guardian in Phase 1 reviews and approves/rejects the **entire set as a single unit**. 
- **Reasoning**: If a Guardian rejects 2 of 8 answers, the Author's original creative vision/sequence is broken. 
- **Future-proofing**: Phase 2 may allow "Edit & Approve" for Guardians, but for now, it's a binary choice.

### Feedback Loop
If a Guardian rejects a gift:
1.  **Status Update**: `gifts.status` → `REJECTED`.
2.  **Author UI**: The Author's "Gifts Log" highlights the rejection with a status reason (e.g., "Filtered by Guardian").

## 4. Technical Architecture
- **Supabase Edge Functions**: We will use `/functions/send-notification` in Deno.
- **Providers**:
  - **Email**: Resend (API Key based).
  - **SMS**: Twilio (Account SID & Auth Token).
- **Triggers**: Database Webhooks on `gifts` table inserts/updates.

## 5. User Stories
### US 12.1: Automated Invitations
As an **Author**, I want the platform to automatically text the Questioner my deep link immediately after I finish the checkout process, so I don't have to manually copy-paste links.

### US 12.2: Guardian Review Call-to-Action
As a **Guardian**, I want to receive a direct email link whenever a gift is sent to my child, allowing me to view the content without having to sign in to the app.

### US 12.3: Rejection Transparency
As an **Author**, I want to see if my gifted set was rejected by a Guardian so I can revise the content and try again without wondering why it was never accepted.
