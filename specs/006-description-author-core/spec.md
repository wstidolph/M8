# Feature Specification: Author Identity & Core Dashboard

**Feature Branch**: `006-author-core-auth`  
**Created**: 2026-03-18  
**Status**: Draft  
**Ref PRD**: Section 2.2, 4.2, 7.1

## 1. Overview
The **Author Dashboard** is the web portal for creators to craft, test, and manage mystical "Answer Sets". This specification transitions the dashboard from a mock prototype to a production-ready application by implementing **Supabase Auth**, **Session Persistence**, and **Profile-linked Data Management**.

## 2. User Scenarios & Testing

| ID | Scenario | Success Criteria |
|----|----------|------------------|
| **US1** | **Secure Sign-In** | Author can sign up/in via email. After login, they access the private dashboard with their real `userId`. |
| **US2** | **Draft Persistence** | Author can save an Answer Set as a "Draft". Upon logout and re-login, the draft is restored from Supabase. |
| **US3** | **Data Validation** | Input is strictly limited to 70 characters. The "Checkout" button is disabled if required target contact (Email/Phone) is missing. |
| **US4** | **Multi-Profile Preview** | Author can toggle between **Smartphone** and **Watch** circular preview modes in the real-time simulation panel. |

## 3. Implementation Requirements

### 3.1 Authentication (L1)
- **Supabase Integration**: Next.js App Router compatible `middleware.ts` to protect `/dashboard` routes.
- **Identity Retention**: Replace all `mockAuthorId` references with the `user.id` from the Supabase session.

### 3.2 Core Dashboard Logic (L1)
- **Draft Management**:
  - `Upsert` logic: If a draft exists, update it. If not, create a new one.
  - Status management: Answer Sets must start at status `Draft`.
- **Validation Schema**:
  - `AnswerSets.target_method` must be correctly derived (Email regex vs Phone).
  - `Answers.response_text` must be <= 70 chars.

### 3.3 Visual Experience (L2) - Premium Zero UI
- **Responsive Layout**: Adhere to the **M8 Constitution (Principle II)**.
- **Device Simulation**:
  - **Smartphone Profile**: 9:16 aspect ratio (e.g., 360x640px viewport).
  - **Watch Profile**: 1:1 square viewport with a **circular mask** and 15% insets (Workflow `[/cross-platform-wearable]`).
- **Orb Performance**: 
  - **Real-time Orbit**: Text updates with zero latency.
  - **Pulsating Ambience**: The orb MUST implement a subtle opacity/scale pulse (1.0 to 1.05 range) to signal it's "Listening" or "Prophesying". (Constitution Principle II Alignment).
  - **Pure Mode**: Simulator MUST strip all developer/author meta (IDs, labels, buttons) for a constitutional Zero UI preview.

## 4. Acceptance Criteria
- [ ] Sign-up / Sign-in redirects successfully to the dashboard.
- [ ] Author cannot save a set with a single answer > 70 characters.
- [ ] Answer Sets in Supabase include the correct `author_id` foreign key.
- [ ] Simulator "Pure Mode" successfully hides all navigational creator UI.
- [ ] Watch preview correctly applies a circular clip-path (PRD mockup alignment).

## 5. Metadata
- **Platform**: Web (Next.js)
- **Backend**: Supabase (PostgreSQL, Auth, RLS)
- **Performance**: Instant UI responsiveness for text inputs.
