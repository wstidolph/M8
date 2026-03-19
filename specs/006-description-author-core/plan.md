# Implementation Plan: Author Identity & Core Dashboard (006)

**Feature Branch**: `006-author-core-auth`  
**Status**: Planning

## Architecture

- **Auth Provider**: `SupabaseAuth` (using `supabase-js` in Next.js).
- **Middleware Layer**: Next.js App Router middleware to protect `/dashboard`.
- **State Pattern**: `React Provider` or `Server Actions` to handle the Answer Set data lifecycle.
- **Preview Logic**: Shared `DevicePreview` component with a `mode` prop (Phone vs Watch).

## Development Phases

### Phase 1: Authentication Layer (P1)
- Install any missing Supabase Auth helpers (e.g., `ssr` if using Next.js 14+).
- Create `/login` and `/sign-up` routes in `apps/m8_web/src/app/`.
- Implement a `Header` component with "Sign In/Out" states.

### Phase 2: Secure Data Flow (P1)
- Refactor `handleCheckout` in `page.tsx` to:
  - Integrate with the **Library Sidebar (Feature 008)** data lifecycle.
  - Get a real `user.id` from `supabase.auth.getUser()`.
  - Prefer explicit `upsert` only for drafts; full save initiates the distribution gift flow.
- Update PostgreSQL RLS policies in Supabase (CLI/SQL) to enforce that only verified Authors can manipulate their own AnswerSets.

### Phase 3: Premium Simulation Dashboard (P2)
- Extract the "Smartphone Frame" into a dedicated `DeviceFrame` component.
- Add reaching logic for **Circular Watch** mode (Clip-path: `circle(50% at 50% 50%)`).
- Implement CSS `@keyframes` for the **Orb Pulsate** effect (Principle II).
- Integrate **Outfit** and **Inter** font pairings from Google Fonts across the web app.

### Phase 4: Validation & Pre-Check (P2)
- Implement `Zod` or similar front-end validation for the 8-answer inputs.
- Adhere to the `70-character` limit via HTML attributes and reactive character counters.
- Block the "Save" action if the `TargetContact` field is malformed.
