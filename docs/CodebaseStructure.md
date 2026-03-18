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
  * `User` interfaces and Zod validation schemas.
  * `AnswerSet`, `Answer`, and `Invitation` types.
  * Specialized Enums for `AnswerSetStatus`, `UserRole`, etc.

### 3.4 supabase/
* **Purpose:** Configuration and business logic for the backend-as-a-service.
* **Responsibilities:**
  * **Migrations:** Initial SQL schema migrations defining the PostgreSQL tables and types.
  * **RLS:** Initial Row Level Security policies to protect user data.
  * **Edge Functions:** Deno Edge Functions (Logic for outbound SMS/Email triggers).

## 4. Current Progress & Notes
* The Flutter codebase `m8_app` requires initialization via the `flutter create` command once the host machine environment has the Flutter SDK set up.
* **Completed:** Root monorepo structure, `@m8/shared` package identification, Next.js `m8_web` scaffold with integrated Supabase client, and initial PostgreSQL schema migration.
