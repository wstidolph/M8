# Data Model: Mystic Orb Animation & Liquid Simulation

**Feature**: `001-orb-animation`  
**Date**: 2026-03-18

## Domain Models

### `OrbState` (Enum)
Represents the discrete states of the orb's interaction cycle and animation logic.
- `Idle`: Subtle breathing animation.
- `Turbulent`: Reactive wave motion (Light Shake).
- `Chaotic`: High-energy splash motion (Violent Shake).
- `Revealing`: Transition from chaotic to answer display.
- `Presenting`: Answer triangle and text are visible.

### `OrbConfiguration` (Value Object)
Configuration parameters for the physics simulation and visual identity.
- `liquidColor`: `Color` (`0xFF1D4ED8`)
- `backgroundColor`: `Color` (`0xFF000814`)
- `glowColor`: `Color` (`0xFF60A5FA`)
- `viscositySpeed`: `double` (base speed of waves)
- `dampeningPeriod`: `Duration` (500-1000ms)
- `answerDisplayDuration`: `Duration` (7000ms)

### `WaveLayer` (Internal Data Object)
Internal mathematical representation for a single wave layer.
- `frequency`: `double`
- `amplitude`: `double`
- `phaseOffset`: `double`
- `fillLevel`: `double` (0.0 to 1.0)

## State Transitions

| From | Interaction | To | Logic |
| :--- | :--- | :--- | :--- |
| `Idle` | Shake (G > 1.2) | `Turbulent` | Trigger change in wave amplitude. |
| `Turbulent` | Shake (G > 4.0) | `Chaotic` | Trigger chaos mode (multi-axis turbulence). |
| `Chaotic` | Shake Stops | `Revealing` | Wait for dampening period (~750ms). |
| `Revealing` | Animation End | `Presenting` | Float the answer triangle into view. |
| `Presenting` | 7s Timeout | `Idle` | Float answer out/down and reset turbulence. |
