# Tasks: Dynamic Answer Response Engine

**Input**: Design documents from `/specs/002-description-implement-dynamic/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and directory structure

- [ ] T001 Create directory structure in `apps/m8_app/lib/src/features/responses/` (domain, infrastructure/providers, application, presentation)
- [ ] T002 Verify and register dependencies (`supabase_flutter`, `flutter_riverpod`, `flutter_secure_storage`) in `apps/m8_app/pubspec.yaml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core domain models and interface abstractions

- [ ] T003 [P] Define `Answer` domain model and `AnswerCategory` enum in `apps/m8_app/lib/src/features/responses/domain/answer.dart`
- [ ] T004 [P] Define `AnswerSource` abstract interface in `apps/m8_app/lib/src/features/responses/domain/answer_source.dart`
- [ ] T005 [P] Define `OrbMood` enum in `apps/m8_app/lib/src/features/responses/domain/orb_mood.dart`

**Checkpoint**: Foundation ready - domain logic can be implemented independently.

---

## Phase 3: User Story 1 - Classic Offline Answers (Priority: P1) 🎯 MVP

**Goal**: Establish the base response library with local fallback.

**Independent Test**: Shaking the device (or simulating a shake) returns one of the 20 classic Magic 8-Ball answers even if the device is offline.

### Implementation for User Story 1

- [ ] T006 [P] [US1] Create the 20 original Magic 8-Ball responses in `apps/m8_app/assets/classic_answers.json`
- [ ] T007 [P] [US1] Implement `LocalAnswerProvider` utilizing the JSON asset in `apps/m8_app/lib/src/features/responses/infrastructure/providers/local_answer_provider.dart`
- [ ] T008 [US1] Implement `ResponseEngine` with basic random selection in `apps/m8_app/lib/src/features/responses/application/response_engine.dart`
- [ ] T009 [US1] Connect `ResponseEngine` to the existing `OrbController` to replace hardcoded strings in `apps/m8_app/lib/src/features/orb/presentation/orb_controller.dart`

**Checkpoint**: User Story 1 (Offline Engine) is fully functional and testable.

---

## Phase 4: User Story 2 - Supabase Dynamic Integration (Priority: P2)

**Goal**: Seamless synchronization with a remote answer database.

**Independent Test**: Mocking a Supabase record and seeing it correctly cached and selected after a sync.

### Implementation for User Story 2

- [ ] T010 [P] [US2] Implement `SupabaseAnswerProvider` with error handling in `apps/m8_app/lib/src/features/responses/infrastructure/providers/supabase_answer_provider.dart`
- [ ] T011 [US2] Create facade `AnswerRepository` for caching provider results in `apps/m8_app/lib/src/features/responses/infrastructure/answer_repository.dart`
- [ ] T012 [US2] Add startup synchronization logic (Sync-on-Startup) to `apps/m8_app/lib/src/features/responses/presentation/response_controller.dart`

**Checkpoint**: Remote dynamic answers are functional and persist via local cache.

---

## Phase 5: User Story 3 - Answer Categorization & Mood (Priority: P2)

**Goal**: Influence answer selection based on the mystical "Orb Mood".

**Independent Test**: Use a unit test to verify that "Positive" answers are twice as frequent when mood is "Energetic".

### Implementation for User Story 3

- [ ] T013 [P] [US3] Implement `Cumulative Weight Selection` algorithm in `apps/m8_app/lib/src/features/responses/application/response_engine.dart`
- [ ] T014 [US3] Integrate `OrbMood` into the `ResponseEngine` selection loop in `apps/m8_app/lib/src/features/responses/application/response_engine.dart`

**Checkpoint**: Full mood-influenced weighting engine is complete.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Performance and validation.

- [ ] T015 [P] Profile selection latency (<10ms target) across all platforms
- [ ] T016 [P] Write comprehensive unit tests for weighting distribution accuracy (1000-trial simulation)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Must finish before any implementation.
- **Foundational (Phase 2)**: Mandatory blocker for all subsequent phases.
- **User Story 1 (Phase 3)**: MVP - must complete before US2/US3.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup + Foundational.
2. Complete US1 (Offline Answers).
3. **STOP and VALIDATE**: Confirm the orb provides responses without network.
