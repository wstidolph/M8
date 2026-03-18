---
description: Optimization for WearOS and watchOS circular layouts.
---

# Wearable Constraints (watchOS/WearOS)

## 1. Circular UI Insets
- **SafeArea Scaling**: Use `MediaQuery` to detect `isRound` on Android/WearOS.
- **Insets**: On circular screens, pad the orb by 15-20% to avoid clipping at the 4 corners.

## 2. Haptic Language
- **Accept**: Execute `HapticFeedback.heavyImpact()`.
- **Reject**: Execute a triple-pulse vibration `HapticFeedback.vibrate()` (Heavy).
- **Idle**: Subtle `HapticFeedback.selectionClick()` when the answer first "floats" into view.

## 3. Power Strategy
- **Always-On Display (AOD)**: If the system enters AOD mode, disable liquid simulation and only render a static "Orb Wireframe" (stroke only) to save battery.
