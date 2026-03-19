# Feature Specification: Sensor Calibration

**Feature Branch**: `004-sensor-calibration`  
**Created**: 2026-03-18  
**Status**: Done
**Input**: Integrated Workflow `[/sensor-calibration]`

## User Scenarios & Testing

### User Story 1 - Precise Shake Detection (Priority: P1)

As a user, I want the orb only to react to deliberate shakes, not just simple walking or picking up the device, so that the experience feels intentional.

**Acceptance Criteria**:
1. **Given** the device is completely still or in a pocket (magnitude < 0.2g), **When** no movement occurs, **Then** the `SensorService` MUST ignore the signal to save power and prevent false triggers.
2. **Given** a deliberate shake (1.5g to 2.5g), **When** it lasts for at least 300ms, **Then** the `SensorService` SHOULD emit a `ShakeIntensity.light` event.

---

### User Story 2 - High-Vigor Detection (Priority: P1)

As a user, I want to trigger the "Chaos" state when I shake the device violently, providing a distinct sensory profile.

**Acceptance Criteria**:
1. **Given** a high-frequency movement (peak > 4.5g), **When** detected, **Then** the `SensorService` MUST immediately emit a `ShakeIntensity.violent` event.

## Requirements

### Functional Requirements
- **FR-001**: System MUST calculate net acceleration magnitude using `userAccelerometerEventStream` (already G-normalized relative to 9.81 m/s²).
- **FR-002**: System MUST implement a noise floor filter at 0.2g to ignore ambient movement.
- **FR-003**: System MUST implement a debounce mechanism of 500ms after a state transition (e.g., from `revealing` back to `idle`) to prevent phantom triggers.

### Calibration Thresholds
- **Noise Floor**: 0.2g
- **Light Shake**: 1.5g to 2.5g (sustained)
- **Violent Shake**: > 4.5g (peak)
- **Time Threshold**: 300ms (sustained light shake duration)

## Success Criteria

- **SC-001**: 0 false triggers across a 10-minute "walking simulation" test (magnitude < 0.2g).
- **SC-002**: 100% trigger accuracy for deliberate shakes sustained for over 300ms.
