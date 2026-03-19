# Feature Implementation Registry

This directory contains the technical specifications and implementation plans for each building block of Project M8. Each feature is numbered to track the development roadmap.

## 🧭 Feature Map

| ID | Feature Name | PRD Ref | Description | Status |
|:---|:---|:---|:---|:---|
| 001 | [Orb Animation](./001-orb-animation) | 4.1 | Shader-based mystical orb, fluid motion, and floating text. | ✅ Complete |
| 002 | [Implement Dynamic](./002-implement-dynamic) | 4.3 | Dynamic Answer Response Engine with mood weighting. | ✅ Complete |
| 003 | [Optimize M8](./003-optimize-m8) | 5 | Hardware-accelerated painting & frame-rate stability. | ✅ Complete |
| 004 | [Calibrate Sensors](./004-calibrate-sensors) | 4.1 | High-precision shake detection for Light vs Violent. | ✅ Complete |
| 005 | [Implement Premium](./005-implement-premium) | 10 | Zero UI, Outfit font, glassmorphism, and performance. | ✅ Complete |
| 006 | [Author Core](./006-author-core) | 4.2 | Dashboard, Supabase Auth, Middleware, and Simulator. | ✅ Complete |
| 008 | [Author Library](./008-author-library) | 7.1 | AnswerSet templates, cloning, and gifting history. | ✅ Complete |
| 009 | [Parental Review](./009-parental-review-gateway) | 4.3 | Age verification (DOB), Gated gifts, and Guardian portal. | ✅ Complete |
| 010 | [Invitation Flow](./010-flutter-invitation-acceptance) | 7.2 | Flutter-side gesture acceptance (Shake to Accept). | ✅ Complete |
| 011 | [Payments](./011-payments) | 6 | Mocked transaction workflow & $2/set monetization. | 📅 In Progress |

---

### 📋 Specification Convention
Each feature directory must contain:
1. `spec.md`: The technical requirements.
2. `plan.md`: The architectural implementation steps.
3. `tasks.md`: A granular checklist with [ ] or [x].

### ⚖️ Technical Standards
- **Mobile**: Flutter 3.x / Dart 3.x + `sensors_plus`, `flutter_riverpod`.
- **Web**: Next.js 16 + Tailwind CSS.
- **Backend**: Supabase PostgreSQL + Auth + Edge Functions.
