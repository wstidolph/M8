# Implementation Plan: Invitation Flow (010)

**Feature Branch**: `010-flutter-invitation-acceptance`  
**Status**: Done (Updated 2026-03-31)

## Architecture

1. **InvitationOverlay**: A Flutter `Stack` element in `OrbView`.
2. **ConfirmationVisual**: A stateless widget that encapsulates the floating text, shapes, and long-press detection.
3. **SensorService**: Detects `light` and `violent` shakes.

## Implementation Phases

### Phase 1: Vibration & Initial Shake (Done)
- [x] Basic shake detection for light and violent gestures.
- [x] Full-screen static modals for "Accept" and "Reject".

### Phase 2: Zero UI Refinement (Swim-Up Confirmation)
- [x] Create `ConfirmationVisual` with `onLongPress` listener.
- [x] Replicate the "Answer" manifestation physics (drift, rise, 3D rotation).
- [x] Update `InvitationOverlay` to use the "Trigger Confirmation" logic.
- [x] Add auto-dismissal (5s) for pending confirmations.

### Phase 3: Demo Cleanup
- [x] Update `DEMO_SCRIPT.md` with new interaction narrative.
- [x] Final haptic feedback polish.

## Data Model (010 Extensions)
- **Status Change**: Upon acceptance, `gifts.status` remains or update?
- **Current logic**: Local persistence update via `AnswerRepository.setCustomAnswers`.
