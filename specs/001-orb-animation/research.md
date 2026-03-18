# Research: Mystic Orb & Liquid Simulation

**Feature**: `001-orb-animation`  
**Date**: 2026-03-18

## Technical Decisions

### Decision: State-Based Acceleration Thresholds
- **Choose**: `sensors_plus` combined with a `Stream` of `UserAccelerometerEvent`.
- **Rationale**: Provides high-frequency sensor data (User Motion, excluding gravity) with low overhead.
- **Alternatives considered**: Standard `AccelerometerEvent` (requires manual gravity subtraction which is error-prone).

### Decision: 2D Fluid Simulation Approach
- **Choose**: **Sine-Wave Multi-Layer (Sinu-Viscous) animation** with `CustomPainter`.
- **Rationale**: For initial implementation, layering 2-3 sine waves with varying frequencies and phase offsets provides a highly convincing "liquid" look with Minimal CPU/GPU overhead. 120fps is easily achievable on almost all target platforms without the complexity of a full GPGPU fluid simulation.
- **Alternatives considered**: 
  - **Full Fragment Shaders**: More flexible (e.g., raymarching metaballs) but harder to debug and requires higher-end GPU support on low-end WearOS.
  - **Lottie/SVG**: Too static; doesn't allow real-time response to physical shake intensity.

### Decision: Dampening Implementation
- **Choose**: **Elastic Dampening**.
- **Rationale**: As clarified by the user, we'll implement a 500-1000ms decay window where turbulence level (`T`) decays as `T = T_max * exp(-t / tau)` where `tau` is the decay constant calibrated to the range.
- **Alternatives considered**: Linear decay (feels robotic).

## Summary of Findings

1.  **Sensor Baseline**: `UserAccelerometerEvent` thresholds should be dampened by a low-pass filter to prevent "jitter" in the Idle state.
2.  **Visual Layering**: The orb should consist of:
    - Background "Liquid" layer (Deep Space).
    - Mid-ground "Wave" layer (Electric Blue).
    - Foreground "Glow/Triangle" layer (Soft Azure).
3.  **Performance Check**: Use `RepaintBoundary` and avoid `path.addArc` calls inside the loop; use `drawCircle` or pre-calculated path segments.
