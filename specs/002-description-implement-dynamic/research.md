# Research: Dynamic Answer Response & Weighting

**Feature**: `002-orb-responses`  
**Date**: 2026-03-18

## Technical Decisions

### Decision: Weighted Random Choice Algorithm
- **Choose**: **Cumulative Weight Sum** approach.
- **Rationale**: Efficiently handles arbitrary weights (Positive x2.0, Neutral x1.0) and categories. Implementation involves building a list of cumulative weights and utilizing binary search or a simple loop for selection.
- **Implementation**:
    - `List<Answer>` answers = loaded set.
    - `sum = answers.fold(0, (s, a) => s + (a.baseWeight * moodMultiplier(a.category)))`.
    - `r = Random().nextDouble() * sum`.
    - Find first cumulative sum index > `r`.

### Decision: Supabase Sync Strategy
- **Choose**: **Sync-on-Startup + Local Cache**.
- **Rationale**: The Magic 8-Ball experience should feel immediate. Waiting for a network request *after* a shake (during the "Revealing" phase) feels sluggish and breaks the "Zero UI" principle. Loading and caching on app startup ensures offline readiness and zero latency during the actual interaction.
- **Alternatives considered**: Realtime push (excessive socket usage for static answers).

### Decision: Local Classic Dataset Storage
- **Choose**: **Asset JSON File**.
- **Rationale**: Easiest way to bundle the 20 original Magic 8-Ball answers. These are immutable and should always be available as the ultimate fallback.

## Summary of Findings

1.  **Mood Weights**: "Energetic" mood should influence only the "Positive" category. If "Gloomy", it should influence "Negative".
2.  **Supabase Schema**: A simple `answers` table with fields `text`, `category` (ENUM: POS, NEU, NEG), `weight` (int).
3.  **Error Handling**: If Supabase sync fails, a `SilentFallback` strategy MUST be used (user doesn't see a "Sync Failed" error; it just uses the local classic set).
