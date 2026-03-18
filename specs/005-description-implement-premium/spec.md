# Feature Specification: Premium Zero UI & Glassmorphism

**Feature Branch**: `005-premium-aesthetics`  
**Created**: 2026-03-18  
**Status**: Done
**Input**: Integrated Workflow `[/app-design-zero-ui]`

## User Scenarios & Testing

### User Story 1 - Mystic Depth (Priority: P1)

As a seeker, I want the orb to feel like a deep-space artifact with smooth, ink-like liquid behavior and a subtle azure glow.

**Acceptance Criteria**:
1. **Given** the orb is idle, **When** rendering `OrbPainter`, **Then** the background MUST be `0xFF000814` and liquid MUST use `0xFF1D4ED8` with varying opacities for depth.
2. **Given** any motion, **When** turbulence > 0, **Then** the "Soft Azure" (`0xFF60A5FA`) glow MUST pulsate and emit particles.

---

### User Story 2 - Glassmorphic History (Priority: P1)

As a user, I want to see my past answers in a beautiful, premium drawer that blurs the intense orb behind it.

**Acceptance Criteria**:
1. **Given** I swipe up or tap the screen, **When** the History drawer opens, **Then** it MUST use a `BackdropFilter` with `sigmaX: 15, sigmaY: 15`.
2. **Given** the drawer background, **When** rendered, **Then** it MUST be semi-transparent (`withValues(alpha: 0.1)`) to create a "Frosted Glass" effect.

---

### User Story 3 - High-Performance Animation (Priority: P1)

As a mobile user, I want the liquid simulation to remain butter-smooth (60+ FPS) even during complex chaos.

**Acceptance Criteria**:
1. **Given** the `OrbPainter` is rendering, **When** processing sine waves, **Then** it MUST reuse `Path` objects where possible and avoid redundant allocations within the `paint` loop.

## Requirements

### Functional Requirements
- **FR-001**: Implement a `HistoryDrawer` component using `ImageFilter.blur`.
- **FR-002**: Standardize UI typography to **Inter** for lists/buttons and **Outfit** (spacing 1.5) for the Orb answer.
- **FR-003**: Optimize `OrbPainter` by moving static path metadata outside the dynamic computation loop.

### Design Tokens
- **Background**: `0xFF000814`
- **Liquid**: `0xFF1D4ED8`
- **Glow**: `0xFF60A5FA`
- **Glass sigma**: 15.0

## Success Criteria

- **SC-001**: 60fps steady performance on mid-range devices.
- **SC-002**: "Premium" aesthetic confirmed via Glassmorphism and Outfit/Inter font pairing.
