# Implementation Design: M8

## 1. Technology Stack Selection

### 1.1 Multi-Platform App (The Questioner Interface)
* **Framework:** **Flutter** (Google).
  * **Reasoning:** Superior performance for the "Zero UI" hardware-accelerated animations (the fluid/floating orb text). Flutter's Skia/Impeller engine provides 60/120fps consistency across iOS, watchOS (Apple Watch), Android, WearOS (Google Pixel Watch, Samsung Galaxy Watch), and notably, compiles natively for **Windows and MacOS** desktop environments as required by the PRD.
* **State Management:** Riverpod or BLoC (to handle the complex sensor-triggered state transitions from "idle" to "shaking" to "revealing", as well as UI button triggers for desktop users).
* **Sensor Integration:** `sensors_plus` plugin for high-precision accelerometer data to distinguish between "light" vs "violent" shakes on mobile and wearables (Apple Watch, Pixel Watch, Galaxy Watch). For desktop platforms, an equivalent accessible on-screen control (e.g., a "Shake" button) will trigger the same animation logic.

### 1.2 Web Application (Author & Questioner Dashboards)
* **Frontend:** **Next.js** (React) with **Tailwind CSS**.
  * **Reasoning:** Fast development, SEO-friendly, and powerful enough to build a desktop-grade dashboard. This app will serve:
    * **Authors:** Creating sets, duplicating previous sets, accessing the "Common Answers" bank, and viewing the real-time "device simulation" previews.
    * **Questioners:** The web management interface to view historical sets, reload valid sets, review expired sets, and reset their M8 device.
* **Design Pattern:** Component-driven development, using a central state for the 8-answer set that reacts instantly in the side-preview mockups.
* **Payments:** **Stripe Elements** for embedded payment processing for Author checkout.

### 1.3 Shared Backend (BaaS)
* **Platform:** **Supabase** (PostgreSQL + Auth + Storage).
  * **Reasoning:** High speed to market for Phase 1. Provides a relational PostgreSQL DB (ideal for User -> AnswerSet -> Answer), built-in Auth with email/phone support, and easy-to-use Edge Functions for SMS/Email invitation logic.

## 2. Codebase Architecture

### 2.1 Repository Strategy (Monorepo)
We will follow a monorepo structure to share types, business logic, and assets easily between the multi-platform app and the web dashboards.
* `/apps/m8_app/`: Flutter codebase (Questioner app for Mobile, WearOS, Desktop).
* `/apps/m8_web/`: Next.js codebase (Dashboards for Authors and Questioners).
* `/packages/shared/`: Shared TypeScript types for Data Objects and API definitions.
* `/supabase/`: Database migrations, security policies (RLS), and Edge Functions.

## 3. Data Integration & API Design

### 3.1 Authentication Workflow
1. Author signs in on Web -> JWT stored.
2. Questioner registers on Mobile -> Date of Birth verified -> JWT stored.

### 3.2 The Invitation Lifecycle
1. **Creation:** Author drafts AnswerSet (`Status: Draft`), with the frontend enforcing the 70-character limit per answer. Optionally selects from a "Common Answers" bank.
2. **Profanity Filter:** Before saving a final draft, a Supabase Edge Function calls a content-moderation API to reject inappropriate text.
3. **Payment:** Author pays via Stripe Hook -> AnswerSet updated (`Status: Paid`).
4. **Dispatch:** Supabase Edge Function triggers SMS/Email with a deep link (e.g., `m8ball://accept?set_id=123`).
5. **Acceptance:** Questioner opens link -> Client queries API. If underage, status shifts to `PendingReview`. If approved/adult, Acceptance logic triggers (Light vs Violent shake).

### 3.3 Data Rules & Database Constraints
* **Character Limits:** Enforced via `CHECK (length(response_text) <= 70)` on the Supabase `Answers` table to guarantee text fits the physical window.
* **Expiration Date Logic:** AnswerSets will include an `expiration_date`. The Mobile App and Web App will check this timestamp locally to decide whether a set can be loaded or if it should revert to default.

## 4. UI/UX Implementation Details

### 4.1 The "Mystic Orb" Animation
* **Mechanism:** A Shader-based or Canvas-based animation in Flutter.
* **Logic:** Offset the text triangles based on a pseudo-random fluid motion algorithm.
* **Hardware Acceleration:** Ensure the `OrbPainter` runs on the GPU to maintain smoothness during the physical shake.

### 4.2 Sensor Calibration (Phase 1)
* **Light Shake:** Defined as a sustained G-force between 1.2g and 2.5g for >200ms.
* **Violent Shake:** Defined as a peak G-force >4.0g or high-frequency rapid direction changes.

## 5. Security & Compliance
* **Row Level Security (RLS):** Supabase policies will ensure Questioners can only read AnswerSets targeting their specific contact info (Email/Phone).
* **Parental Approval Gateway:** A boolean flag on the `User` profile (`isUnderage`). If true, the `AnswerSet.Status` remains `PendingReview` until a separate Admin/Guardian API call is made.

---
*Document Version: 0.1*
*Status: Draft Design*
