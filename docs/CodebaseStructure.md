# M8 Codebase Architecture

This document tracks the directory layout and architectural boundaries for the M8 monorepo project.

## 1. Monorepo Overview

The M8 repository is organized as a unified monorepo to seamlessly share types, utility functions, and configurations across the different environments (Web, Mobile, Wearable, Desktop). 

We are utilizing **npm workspaces** as defined in the root `package.json` to manage dependencies across the sub-projects.

## 2. Directory Structure

```plaintext
/
├── apps/
│   ├── m8_app/             # Flutter Questioner app (Mobile, WearOS, Desktop)
│   └── m8_web/             # Next.js Web app (Author Creator & Questioner Dashboard)
├── packages/
│   └── shared/             # Shared TypeScript types for Database records and API endpoints
├── supabase/
│   ├── migrations/         # PostgreSQL schema logic
│   └── functions/          # Deno Edge Functions (SMS/Email triggers)
├── docs/                   # Architectural & Technical documentation
├── assets/                 # Repository-wide static files (e.g., PRD mockups)
└── PRD.md                  # Master Product Requirements Document
```

## 3. Sub-Project Details

### 3.1 apps/m8_app
* **Purpose:** The primary Questioner interface where the core M8 experience happens (shaking for an answer).
* **Technology:** Flutter.
* **Target Platforms:** iOS, watchOS, Android, WearOS, Windows, MacOS.
* **Responsibilities:**
  * Sensor (accelerometer) interpretation for shake thresholds.
  * Rendering the GPU-accelerated "Mystic Orb" floating-text animation.
  * Decoding the deep link URL received via SMS/Email (`m8ball://accept?set_id=123`).

### 3.2 apps/m8_web
* **Purpose:** The web dashboards used by both "Authors" and "Questioners".
* **Technology:** Next.js, React, Tailwind CSS, TypeScript.
* **Target Platforms:** Desktop browsers.
* **Responsibilities:**
  * **Author Context:** Creating AnswerSets (max 70 chars per line), picking common answers, duplicating history, simulating the mobile orb view, and handling Stripe checkout.
  * **Questioner Context:** Logging in to view historically received AnswerSets, reloading past sets, and reviewing expired sets.

### 3.3 packages/shared
* **Purpose:** A pure TypeScript package that defines the strict shapes of our database objects based on the PRD boundaries.
* **Key Exports:**
  * `User` interfaces
  * `AnswerSet` and `Answer` types
  * Validation schemas (Zod or plain TS) for API requests.

### 3.4 supabase/
* **Purpose:** Configuration and business logic for the backend-as-a-service.
* **Responsibilities:**
  * Database schema definitions (Tables, Foreign Keys).
  * Row Level Security (RLS) policies to ensure Questioners only see sets gifted to their Phone Number / Email.
  * Edge Functions containing the logic to trigger outbound SMS/Emails when an Author completes a payment via Stripe.

## 4. Work In Progress Notes
* The Flutter codebase `m8_app` requires initialization via the `flutter create` command once the host machine environment has the Flutter SDK set up.
* Next steps involve laying out the database models into `/packages/shared` and creating the corresponding SQL files in `/supabase/migrations`.
