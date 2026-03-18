---
description: Logic for shake detection and interaction thresholds.
---

# Sensor Processing (sensors_plus)

## 1. Magnitude Calculation
- **Net Acceleration**: `Magnitude = sqrt(x² + y² + z²)`.
- **Normalization**: Subtract 9.81 m/s² (gravity) to get relative movement.

## 2. Threshold Mapping
- **Light Shake (Accept)**: Consistent 1.5g to 2.5g for > 300ms.
- **Violent Shake (Reject)**: Peak > 4.5g combined with high-frequency direction reversals.
- **Trigger**: Debounce by 500ms after a successful shake to prevent accidental double-activations.

## 3. Noise Floor
- Ignore all magnitude signals < 0.2g to save battery and prevent false triggers during walking.
