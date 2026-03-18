# Implementation Plan: Sensor Calibration

**Feature Branch**: `004-sensor-calibration`  
**Status**: Done

## Tech Stack
- `sensors_plus`
- `Stopwatch` / `Timer` for duration logic.

## Logic Overview

### SensorService
- Monitors `userAccelerometerEventStream`.
- Map magnitude -> G-force.
- **Sustained check**: If within [1.5, 3.5] for 300ms, emit `light`.
- **Peak check**: If >4.5, emit `violent`.

### Controller Debounce
- Track `_lastInteractionEnd`.
- Ignore sensor inputs for 500ms post-interaction.
