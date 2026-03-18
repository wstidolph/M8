# Implementation Plan: Mystic Orb Animation & Liquid Simulation

**Branch**: `001-orb-animation` | **Date**: 2026-03-18 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-orb-animation/spec.md`

## Summary

This feature implements the core visual identity of M8: the "Mystic Orb". It utilizes hardware-accelerated Flutter `CustomPainter` and `Shader` code to render a fluid liquid simulation that responds to physical device motion (shaking) and orchestrates the floating reveal of answer text.

## Technical Context

**Language/Version**: Flutter 3.x / Dart 3.x  
**Primary Dependencies**: `sensors_plus`, `flutter_riverpod`  
**Storage**: N/A  
**Testing**: `flutter_test`, `integration_test`  
**Target Platform**: iOS, Android, WearOS, watchOS, Windows, MacOS  
**Project Type**: mobile-app / cross-platform  
**Performance Goals**: 60 fps (standard), 120 fps (ProMotion)  
**Constraints**: <16ms frame-latency for sensor-to-visual response  
**Scale/Scope**: 1 high-fidelity CustomPainter widget with state management.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I. Zero UI Performance**: Orbital rendering MUST use `RepaintBoundary` to isolate animations.
- **II. Hardware Acceleration**: All fluid wave calculations MUST be GPU-optimized (use Fragment Shaders if necessary).
- **III. Accessibility**: Text MUST be scalable and centered regardless of screen physical dimensions.

## Project Structure

### Documentation (this feature)

```text
specs/001-orb-animation/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (generated later)
```

### Source Code (repository root)

```text
apps/m8_app/lib/src/features/orb/
├── presentation/
│   ├── orb_view.dart          # Main widget
│   ├── orb_painter.dart       # CustomPainter logic
│   └── orb_controller.dart    # StateNotifier for animation states
├── domain/
│   └── orb_state.dart         # Enums & data models
└── infrastructure/
    └── sensor_service.dart    # Accelerometer integration
```

**Structure Decision**: Standard Feature-First structure inside the existing `orb` feature directory in `m8_app`.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Custom Shaders | 120fps Fluid simulation | Standard Path animations/Canvas operations too CPU-heavy for complex fluid. |
