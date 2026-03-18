# Implementation Plan: Wearable Optimization

**Feature Branch**: `003-wearable-optimization`  
**Status**: Done

## Architecture

- **Presentation Layer**: `OrbView` uses `MediaQuery` to detect watch-sized dimensions.
- **Rendering Layer**: `OrbPainter` supports a `isAODMode` wireframe mode.
- **Controller Layer**: `OrbController` integrates `HapticFeedback` on state changes.

## Development Phases

### Phase 1: Haptic Sensory Language
- Add `services.dart` to `OrbController`.
- Trigger `heavyImpact` for `Violent Chaos`.
- Trigger `selectionClick` for answer shows.

### Phase 2: Circular UI Safety
- Replace fixed padding with dynamic scale factor (15-20% for width < 320).

### Phase 3: Battery Optimization (AOD)
- Implement `isAODMode` in `OrbPainter` to disable liquid waves and pulse.
