# Feature Specification: Wearable Layouts & Haptics Optimization

**Feature Branch**: `003-wearable-optimization`  
**Created**: 2026-03-18  
**Status**: Done
**Input**: Integrated Workflow `[/cross-platform-wearable]`

## User Scenarios & Testing

### User Story 1 - Circular UI Safety (Priority: P1)

As a WearOS/watchOS user, I want the M8 orb properly centered and padded so that the text and liquid aren't clipped by the round screen edges.

**Acceptance Criteria**:
1. **Given** the app is running on a round screen, **When** the `OrbView` is rendered, **Then** it MUST apply dynamic padding (15-20%) based on the circular inset detection.
2. **Given** a rectangular screen, **When** rendered, **Then** it SHOULD retain standard margins (24dp).

---

### User Story 2 - Haptic Sensory Language (Priority: P1)

As a user, I want to feel the "turbulence" of the orb through vibration to enhance the mystical immersion.

**Acceptance Criteria**:
1. **Given** the orb enters the `Violent Chaos` state, **When** continuous shaking occurs, **Then** the device MUST execute `HapticFeedback.heavyImpact()`.
2. **Given** an answer is successfully selected and starts "floating up", **When** it enters the viewport, **Then** the device MUST execute a subtle `HapticFeedback.selectionClick()`.

---

### User Story 3 - Power Strategy / AOD Mode (Priority: P2)

As a wearable user, I want the app to consume minimal battery when the screen is dimmed or in "Always-On Display" mode.

**Acceptance Criteria**:
1. **Given** the device enters a low-power/ambient state, **When** rendering the `OrbPainter`, **Then** it MUST disable liquid wave simulation and render only a 1px wireframe stroke of the orb.

## Requirements

### Functional Requirements
- **FR-001**: System MUST detect screen shape (round vs. rect) using `MediaQuery.of(context).displayFeatures` or `isRound`.
- **FR-002**: System MUST bridge `OrbController` state transitions to the `HapticFeedback` system.
- **FR-003**: System MUST provide a `isAODMode` flag to `OrbPainter` to toggle between "Ink-Glow" and "Wireframe" rendering.

### Performance Standards
- **Haptic Latency**: Vibrate event MUST trigger within <50ms of state change.
- **AOD Efficiency**: Drawing overhead MUST decrease by >80% when in wireframe mode.

## Success Criteria

- **SC-001**: 100% visibility of the answer triangle on circular simulated devices (e.g., Pixel Watch emulator).
- **SC-002**: Tactile confirmation of shake vigor aligns with visual turbulence.
