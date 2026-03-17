# Implementation Design: M8

## 1. Technology Stack Selection

### 1.1 Mobile App (The Questioner Interface)
* **Framework:** **Flutter** (Google).
  * **Reasoning:** Superior performance for the "Zero UI" hardware-accelerated animations (the fluid/floating orb text). Flutter's Skia/Impeller engine provides 60/120fps consistency across iOS, Android, and WearOS. Excellent multi-platform support for smartwatches out-of-the-box.
* **State Management:** Riverpod or BLoC (to handle the complex sensor-triggered state transitions from "idle" to "shaking" to "revealing").
* **Sensor Integration:** `sensors_plus` plugin for high-precision accelerometer data to distinguish between "light" vs "violent" shakes.

### 1.2 Author Web App (The Creator Interface)
* **Frontend:** **Next.js** (React) with **Tailwind CSS**.
  * **Reasoning:** Fast development, SEO-friendly, and powerful enough to build a desktop-grade dashboard with real-time "device simulation" previews.
* **Design Pattern:** Component-driven development, using a central state for the 8-answer set that reacts instantly in the side-preview mockups.
* **Payments:** **Stripe Elements** for embedded payment processing.

### 1.3 Shared Backend (BaaS)
* **Platform:** **Supabase** (PostgreSQL + Auth + Storage).
  * **Reasoning:** High speed to market for Phase 1. Provides a relational PostgreSQL DB (ideal for User -> AnswerSet -> Answer), built-in Auth with email/phone support, and easy-to-use Edge Functions for SMS/Email invitation logic.

## 2. Codebase Architecture

### 2.1 Repository Strategy (Monorepo)
We will follow a monorepo structure to share types, business logic, and assets easily between the mobile app and the web dashboard.
* `/apps/m8_mobile/`: Flutter codebase.
* `/apps/m8_author_web/`: Next.js codebase.
* `/packages/shared/`: Shared TypeScript types for Data Objects and API definitions.
* `/supabase/`: Database migrations, security policies (RLS), and Edge Functions.

## 3. Data Integration & API Design

### 3.1 Authentication Workflow
1. Author signs in on Web -> JWT stored.
2. Questioner registers on Mobile -> Date of Birth verified -> JWT stored.

### 3.2 The Invitation Lifecycle
1. **Creation:** Author drafts AnswerSet (`Status: Draft`).
2. **Payment:** Author pays via Stripe Hook -> AnswerSet updated (`Status: Paid`).
3. **Dispatch:** Supabase Edge Function triggers SMS/Email with a deep link (e.g., `m8ball://accept?set_id=123`).
4. **Acceptance:** Questioner opens link -> Mobile App queries API -> Acceptance logic triggered.

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
