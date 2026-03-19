# Implementation Plan: Dynamic Answer Response Engine

**Branch**: `002-orb-responses` | **Date**: 2026-03-18 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/002-description-implement-dynamic/spec.md`

## Summary

This feature implements the backend "Soul" of M8 by providing a flexible, offline-first response engine. It decouples answer selection from the UI layer, supporting weighted categories and seamless synchronization with Supabase for dynamic content updates.

## Technical Context

**Language/Version**: Flutter 3.x / Dart 3.x  
**Primary Dependencies**: `supabase_flutter`, `flutter_riverpod`, `flutter_secure_storage`  
**Storage**: Local cache (JSON assets) + SecureStorage for session-based overrides.  
**Testing**: `flutter_test` (Unit tests for weighting logic)  
**Target Platform**: Cross-platform (iOS, Android, WearOS, Desktop)  
**Project Type**: mobile-app  
**Performance Goals**: <10ms for answer selection; <50ms for error fallback.  
**Constraints**: MUST be fully functional offline using classic M8 answers.

## Constitution Check

- **I. Library-First**: Selection logic MUST be decoupled from Flutter widgets to allow for pure unit testing.
- **II. Zero UI Performance**: Selection engine MUST NOT block the UI thread; use asynchronous initialization but synchronous selection from cache.
- **III. Accessibility**: All remote answers MUST support localized variants if future-proofing is required.

## Project Structure

### Documentation (this feature)

```text
specs/002-description-implement-dynamic/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
apps/m8_app/lib/src/features/responses/
├── domain/
│   ├── answer.dart            # Data model for responses
│   └── answer_source.dart     # Interface for answer providers
├── infrastructure/
│   ├── providers/
│   │   ├── local_answer_provider.dart
│   │   └── supabase_answer_provider.dart
│   └── answer_repository.dart # Facade for selection & caching
├── application/
│   └── response_engine.dart   # Selection algorithm/weighting
└── presentation/
    └── response_controller.dart # Riverpod integration
```

**Structure Decision**: Standard Clean Architecture / Feature-First structure inside `responses` module.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Weighted Randomness | Mood-based personality | Simple `Random.nextInt()` doesn't support the "Orb Mood" principle. |
