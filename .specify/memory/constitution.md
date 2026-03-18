# M8 Project Constitution

The M8 platform is a 21st-century digital-social reincarnation of the classic mystical oracle. This constitution defines the non-negotiable principles of its architecture, design, and user experience.

## Core Principles

### I. Zero UI & Physical Interaction (NON-NEGOTIABLE)
The core Questioner experience MUST revolve around invisible, physical interactions. 
- **Physical-First**: Primary interaction triggers are high-precision sensor events (Light Shake vs. Violent Shake).
- **Invisible Interface**: On-screen controls MUST be minimized to avoid breaking the mystical immersion. 
- **Feedback**: Use Haptic Sensory Language (selection clicks, heavy impacts) to replace visual confirmations.

### II. Mystic Premium Aesthetics & Performance
M8 MUST feel like a high-end digital artifact, not a standard mobile app.
- **Palette**: Strictly adhere to the "Deep Space" visual identity (Background: `0xFF000814`, Liquid: `0xFF1D4ED8`, Glow: `0xFF60A5FA`).
- **Typography**: Google Fonts *Outfit* (Semi-bold, spacing 1.5) for the Orb; *Inter* for administrative UI.
- **Glassmorphism**: Use `BackdropFilter` (sigma 15) for all overlays to maintain depth.
- **Performance**: Animated components (CustomPainter) MUST target 60fps minimum. Repaint Boundaries MUST be used to isolate high-frequency renders.

### III. Offline-First Resilience
The ability to consult the orb is a fundamental utility that MUST NOT depend on active connectivity.
- **Persistence**: All dynamic answer sets MUST be cached locally (e.g., `flutter_secure_storage`).
- **Graceful Fallback**: If remote sync (Supabase) fails, the system MUST revert to local cache or the "Classic Answers" pool without interrupting the user flow.

### IV. Privacy, Safety & Age Verification
M8 deals with direct communication ("Gifts"); thus, user safety is paramount.
- **Consent Gateway**: Date of Birth (DOB) verification is mandatory for all members.
- **Parental Review**: Underage Questioners MUST have a Guardian-monitored gateway for accepting custom answer sets.
- **Data Sovereignty**: Use Supabase Row Level Security (RLS) to ensure users can ONLY access invitations specifically targeting their verified phone/email.

### V. Cross-Platform Native Excellence
M8 MUST adapt perfectly to the form factor’s unique constraints while sharing a core logic engine.
- **Wearable-First**: Prioritize circular UI safety (15%+ insets) and battery-efficient AOD (Always-On Display) modes.
- **Desktop Parity**: Provide "Shake Simulation" on non-mobile platforms via clear but non-intrusive UI triggers.

## Technical Constraints

- **Stack**: Flutter 3.x (Core), Supabase (Backend/Auth), Riverpod (State).
- **Feature Lifecycle**: Every feature follows the `speckit` lifecycle: `spec.md` -> `plan.md` -> `tasks.md`.
- **Quality Gates**: All feature merges to `main` REQUIRE verified documentation coverage and successfully passed unit/widget tests.

## Governance
This constitution supersedes all individual implementation plans. Any conflict between a proposed feature and these principles MUST be resolved in favor of the constitution. Amendments require a formal version update.

**Version**: 1.0.0 | **Ratified**: 2026-03-18 | **Last Amended**: 2026-03-18
