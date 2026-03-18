# Feature Specification: Dynamic Answer Response Engine

**Feature Branch**: `002-dynamic-responses`  
**Created**: 2026-03-18  
**Status**: Draft  
**Input**: User description: "Implement the Dynamic Answer Response engine"

## Clarifications

### Session 2026-03-18
- **Q**: How much should the "Mood" influence the answer selection? → **A**: 2.0x Multiplier (Custom 2).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Classic Offline Answers (Priority: P1) 🎯 MVP

The user shakes the device and receives one of the 20 classic Magic 8-Ball answers from a local static source. This ensures the app is functional without any internet connection.

**Why this priority**: Core utility. The app is useless without a response engine.

**Independent Test**: Can be tested by disabling Wi-Fi/data and shaking the device; the orb should consistently provide a classic answer.

**Acceptance Scenarios**:

1. **Given** the app is offline, **When** a shake event is completed, **Then** the system MUST select an answer from the 20 classic responses stored locally.
2. **Given** the answer is selected, **When** it is displayed in the orb, **Then** it MUST match the classic phrasing (e.g., "IT IS CERTAIN", "REPLY HAZY, TRY AGAIN").

---

### User Story 2 - Supabase Dynamic Integration (Priority: P2)

The engine attempts to fetch a "Current Answer Set" from a Supabase database. This allows the M8 "Soul" to change daily or for special events without an app update.

**Why this priority**: Provides the "Magic" feel of a living application and fulfills the project's backend integration goal.

**Independent Test**: Mocking a Supabase response with a custom answer (e.g., "THE STARS ARE ALREADY ALIGNED") and verifying it appears in the orb.

**Acceptance Scenarios**:

1. **Given** an internet connection is available, **When** the app starts, **Then** it SHOULD synchronize a remote answer set from Supabase and cache it locally.
2. **Given** a new remote answer set is synced, **When** a shake occurs, **Then** the engine SHOULD prioritize the remote set over the classic set if a "Special Event" flag is active.

---

### User Story 3 - Answer Categorization & Mood (Priority: P2)

Answers are categorized into "Positive", "Neutral", and "Negative". The engine tracks the "Orb Mood" and adjusts the probability of certain categories.

**Why this priority**: Enhances the premium interactive feel and "Zero UI" mysterious personality.

**Independent Test**: Verifying that if "Mood" is set to "Gloomy", Negative answers appear with higher frequency in unit tests.

**Acceptance Scenarios**:

1. **Given** a Mood state of "Energetic", **When** a shake occurs, **Then** the probability of a "Positive" category answer MUST be increased by a 2.0x weight multiplier.
2. **Given** a shake occurs, **When** an answer is selected, **Then** its category property MUST be logged for internal state tracking.

---

### Edge Cases

- **Empty Remote Set**: If Supabase returns 0 records, the engine MUST fallback to the Local Classic set immediately.
- **Connection Timeout**: If Supabase takes >2s to respond, the engine MUST proceed with the local cache or classic set to avoid delaying the "Revealing" animation phase.
- **Malformed Data**: If JSON from Supabase is malformed, the system MUST log an error and use the classic set.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a `ResponseEngine` that decouples answer selection from the UI layer.
- **FR-002**: System MUST include a local `assets/answers.json` containing the 20 classic M8 responses.
- **FR-003**: System MUST provide an `AnswerProvider` interface to support multiple sources (Local, Supabase).
- **FR-004**: System MUST implement a "Weighting" algorithm for selection based on category flags.
- **FR-005**: System MUST include an `AnswerRepository` that persists/caches remote answers using `flutter_secure_storage` or a local DB.

### Key Entities

- **`Answer`**: Represents a single response (Text, Category, Weight, Source).
- **`AnswerSet`**: A collection of answers with a metadata tag (e.g., "Classic", "Halloween 2026").
- **`ResponseEngine`**: The core logic component that picks the next answer based on current project state (Mood, Interaction history).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Answer selection latency MUST be <10ms when utilizing local/cached data.
- **SC-002**: Fallback to classic set MUST happen in <50ms upon any network or sync error.
- **SC-003**: Selection distribution MUST match the weighted category probabilities within a 5% margin of error across 1000 simulated shakes.
