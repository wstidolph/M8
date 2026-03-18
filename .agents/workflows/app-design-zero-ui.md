---
description: Patterns for the M8 Zero UI, CustomPainter Orb, and Premium Aesthetics.
---

# M8 Visual Identity & Architecture

## 1. CustomPainter Performance
- **Repaint Boundaries**: Always wrap the `OrbView` in a `RepaintBoundary` to isolate orb animations from the rest of the UI tree.
- **GPU Targeting**: Ensure the fluid simulation runs at 60fps minimum. Avoid heavy path operations inside the `paint` loop; use pre-calculated points where possible.

## 2. Liquid Simulation & Palette
- **Primary Colors**: 
  - Background: Deep Space (`0xFF000814`)
  - Liquid: Electric Blue (`0xFF1D4ED8`)
  - Glow: Soft Azure (`0xFF60A5FA`)
- **Motion**: Use sine-wave based fluid height, slightly offset by a noise factor to simulate "shaking" turbulence.

## 3. Typography (Premium)
- **Standard**: Google Fonts *Inter* for administrative UI.
- **The Orb**: Google Fonts *Outfit* (Semi-bold) for the floating answer text. Increase letter spacing by 1.5 for a "high-end" digital look.

## 4. Glassmorphism
- **Modal Styles**: Use `BackdropFilter` with `ImageFilter.blur(sigmaX: 15, sigmaY: 15)`.
- **Containers**: Fill with `.withValues(alpha: 0.1)` white/grey for a frosted glass effect.
