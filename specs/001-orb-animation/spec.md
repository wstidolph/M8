# Feature Specification: Mystic Orb Animation & Liquid Simulation

**Feature Branch**: `001-orb-animation`  
**Created**: 2026-03-18  
**Status**: Draft  
**Input**: User description: "Implement the hardware-accelerated Mystic Orb animation and liquid simulation for the Questioner view."

## Clarifications

### Session 2026-03-18
- **Q**: How quickly should the simulation return to the "Idle" state once shaking stops (dampening)? → **A**: Elastic (500-1000ms) - realistic fluid inertia.
- **Q**: When should the answer disappear or "sink" back into the liquid? → **A**: Timed Auto-Dismiss (7s).
- **Q**: What should the visual "weight" of the liquid feel like? → **A**: Glow-Ink (Semi-translucent with particle-like trails).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Mystic Orb idle state (Priority: P1)

As a Questioner, I want to see a beautiful, flowing mystic orb when I open the app, so that I immediately feel the premium and mysterious atmosphere of M8.

**Why this priority**: Core visual identity of the product ("Zen mode").
**Independent Test**: Opening the app on a mobile or wearable device shows the orb rendering smoothly without interaction.

**Acceptance Scenarios**:

1. **Given** the M8 app is launched, **When** no user interaction is occurring, **Then** the orb should display a subtle, rhythmic "breathing" or "gentle wave" liquid animation.
2. **Given** the app is open, **When** monitoring frame rate, **Then** the animation MUST maintain a minimum of 60fps (120fps on supported devices).

---

### User Story 2 - Liquid response to physical shake (Priority: P1)

As a Questioner, I want the liquid inside the orb to react realistically to my physical movements, so the experience feels tactile and immersive.

**Why this priority**: Essential to the "Digital Magic Eightball" metaphor.
**Independent Test**: Shaking the device or using the simulation button triggers a visible change in the liquid's turbulence level.

**Acceptance Scenarios**:

1. **Given** the orb is in idle state, **When** a "Light Shake" (sustained G-force 1.2g–2.5g) is detected, **Then** the liquid simulation should transition to a turbulent state with increased wave frequency.
2. **Given** the orb is in idle or turbulent state, **When** a "Violent Shake" (G-force >4.0g) is detected, **Then** the liquid should display high-energy, chaotic motion or "splashing" effects within the orb boundaries.

---

### User Story 3 - Answer revelation animation (Priority: P2)

As a Questioner, I want the revealed answer to float gracefully within the orb, so that the message feels like it's emerging from the mystical liquid.

**Why this priority**: Primary goal of the interaction sequence.
**Independent Test**: After a shake sequence, the answer triangle and text emerge into the center of the orb.

**Acceptance Scenarios**:

1. **Given** a shake interaction is completed, **When** the system selects an answer, **Then** a floating triangle component containing the answer text should "float up" to the center of the orb window and persist for exactly 7 seconds before auto-dismissing.
2. **Given** the answer is visible, **When** the liquid is still moving, **Then** the answer triangle should subtly sway/bob in sync with the residual wave motion.

---

### Edge Cases

- **Rapid State Fluttering**: System MUST prevent rapid flickering between "Idle" and "Turbulent" states when physical force is near the sensor threshold (hysteresis/debounce).
- **Infinite Shaking**: System MUST throttle computational load if the device is shaken continuously for more than 10 seconds.
- **Orientation Flipping**: System MUST handle 180-degree device rotation without disrupting the liquid simulation coordinate system.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST render a circular orb container using hardware-accelerated graphics (e.g., Shaders or Canvas with RepaintBoundary).
- **FR-002**: Liquid simulation MUST use the project-defined palette: Deep Space (`0xFF000814`) background, Electric Blue (`0xFF1D4ED8`) liquid, and Soft Azure (`0xFF60A5FA`) glow.
- **FR-003**: Background liquid motion MUST be based on combined sine-waves or noise functions to simulate a semi-viscous fluid.
- **FR-004**: System MUST differentiate between "Idle", "Light Turbulence", and "Violent Chaos" states based on accelerometer intensity, with an elastic dampening period (500-1000ms) when motion stops.
- **FR-005**: Liquid simulation MUST maintain a visually "Glow-Ink" feel, being semi-translucent with particle-like trails in turbulent states.
- **FR-006**: Answer text MUST be rendered using the *Outfit* typeface (Semi-bold) with letter spacing increased by 1.5.
- **FR-007**: The orb MUST scale fluidly across square (WearOS), portrait (Phone), and landscape (Desktop) orientations while maintaining a 1:1 aspect ratio for the orb itself.

### Key Entities

- **OrbState**: Represents the current physical state of the simulation (Idle, Turbulent, Chaotic, Revealing).
- **LiquidLayer**: A mathematical representation of the fluid surface (height maps, wave offsets).
- **AnswerVisual**: The 2D/3D component containing the triangle and floating text.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Animation performance MUST reach stable 60fps on mid-range Android (2022+) and iOS devices.
- **SC-002**: Animation performance MUST reach stable 120fps on ProMotion/High-refresh rate displays.
- **SC-003**: State transition latency (from physical shake detection to visual turbulence) MUST be under 16ms (frame-perfect).
- **SC-004**: Answer text legibility: All answers (max 70 chars) MUST be fully readable within the orb's "floating window" without clipping on screen sizes down to 240px (WearOS small).

## Assumptions

- We assume the use of Flutter's `CustomPainter` combined with `AnimationController` for initial implementation, potentially moving to Fragment Shaders if performance targets aren't met on wearables.
- We assume standard accelerometer polling rates on target mobile/wearable devices are sufficient for state transitions.
