# Tasks: Mystic Orb Animation & Liquid Simulation

**Input**: Design documents from `/specs/001-orb-animation/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Create feature directory structure in `apps/m8_app/lib/src/features/orb/`
- [X] T002 Verify Dart/Flutter environment and specific dependencies (`sensors_plus`, `flutter_riverpod`) in `apps/m8_app/pubspec.yaml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure for sensor handling and animation state

- [X] T003 [P] Define `OrbState` enum and data structures in `apps/m8_app/lib/src/features/orb/domain/orb_state.dart`
- [X] T004 [P] Implement `SensorService` to wrap `UserAccelerometerEvent` streams in `apps/m8_app/lib/src/features/orb/infrastructure/sensor_service.dart`
- [X] T005 Implement `OrbController` (Riverpod StateNotifier) to bridge sensors and animation states in `apps/m8_app/lib/src/features/orb/presentation/orb_controller.dart`

**Checkpoint**: Foundation ready - sensor data correctly drives internal state.

---

## Phase 3: User Story 1 - Mystic Orb idle state (Priority: P1) 🎯 MVP

**Goal**: Establish the base visual identity with smooth, hardware-accelerated fluid motion.

**Independent Test**: Running the app shows a centered, breathing blue orb at 60/120fps.

### Implementation for User Story 1

- [X] T006 [P] [US1] Implement `OrbPainter` with multi-layered sine-wave liquid rendering in `apps/m8_app/lib/src/features/orb/presentation/orb_painter.dart`
- [X] T007 [US1] Build `OrbView` widget utilizing `RepaintBoundary` and `AnimationController` in `apps/m8_app/lib/src/features/orb/presentation/orb_view.dart`
- [X] T008 [US1] Integrate `OrbView` as the primary screen component in `apps/m8_app/lib/main.dart`

**Checkpoint**: User Story 1 (Idle state) is fully functional and testable independently.

---

## Phase 4: User Story 2 - Liquid response to physical shake (Priority: P1)

**Goal**: Reactive fluid simulation that responds to physical force intensities.

**Independent Test**: Shaking the device increases wave amplitude; stopping causes a 1s elastic settle.

### Implementation for User Story 2

- [X] T009 [US2] Implement Shake intensity logic (Light: 1.2g-2.5g vs Violent: >4.0g) in `apps/m8_app/lib/src/features/orb/presentation/orb_controller.dart`
- [X] T010 [US2] Implement Elastic Dampening logic (500-1000ms decay) for return-to-idle in `apps/m8_app/lib/src/features/orb/presentation/orb_controller.dart`
- [X] T011 [US2] Update `OrbPainter` to support dynamic turbulence and "Glow-Ink" particle trails in `apps/m8_app/lib/src/features/orb/presentation/orb_painter.dart`

**Checkpoint**: Interactive shake response is fully implemented.

---

## Phase 5: User Story 3 - Answer revelation animation (Priority: P2)

**Goal**: Graceful emergence of the answer triangle after a shake sequence.

**Independent Test**: After shaking, a triangle floats up, stays for 7s, then auto-dismisses.

### Implementation for User Story 3

- [X] T012 [P] [US3] Create `AnswerVisual` widget (Triangle container + Outfit Typography) in `apps/m8_app/lib/src/features/orb/presentation/components/answer_visual.dart`
- [X] T013 [US3] Implement "Float-up" and "Float-down" animation orchestration in `apps/m8_app/lib/src/features/orb/presentation/orb_controller.dart`
- [X] T014 [US3] Add 7-second auto-dismiss timer lifecycle in `apps/m8_app/lib/src/features/orb/presentation/orb_controller.dart`

**Checkpoint**: Full interaction loop (Idle -> Shake -> Reveal -> Dismiss -> Idle) is complete.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Performance optimization and documentation.

- [X] T015 [P] Profile GPU/CPU usage on target smartwatch and mobile devices to ensure zero frame drops
- [X] T016 [P] Update `docs/MobileImplementationDesign.md` with final sensor thresholds and animation timings
- [X] T017 Final cleanup of animation controller listeners to prevent memory leaks

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Can start immediately.
- **Foundational (Phase 2)**: BLOCKS all user stories (needs sensor/state logic).
- **User Stories (Phase 3+)**: Proceed in priority order. US1 (Idle) is the blocker for US2/US3 visuals.

### Parallel Opportunities

- T003 (Domain) and T004 (Infrastructure) can be done in parallel.
- T006 (Painter) can be started as soon as T003/T004 are drafted.
- T012 (Answer Visual) can be built in parallel with US1/US2 development.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup + Foundational.
2. Complete User Story 1 (Idle State).
3. **STOP and VALIDATE**: Confirm 60fps performance on target hardware.

### Incremental Delivery

1. Foundation ready.
2. Idle State → Test independently.
3. Interactive Shake → Test independently.
4. Answer Reveal → Final composite test.
