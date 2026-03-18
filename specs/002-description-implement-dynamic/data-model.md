# Data Model: Dynamic Answer Response Engine

**Feature**: `002-orb-responses`  
**Date**: 2026-03-18

## Domain Models

### `AnswerCategory` (Enum)
Represents the three classic Magic 8-Ball response types.
- `positive`: "Yes-leaning" answers (e.g., "It is certain").
- `neutral`: "Wait/Ask again" answers (e.g., "Reply hazy, try again").
- `negative`: "No-leaning" answers (e.g., "Very doubtful").

### `Answer` (Data Model)
Represents a single response candidate.
- `text`: `String` (The actual answer text).
- `category`: `AnswerCategory`.
- `baseWeight`: `double` (Default: 1.0).
- `source`: `String` (e.g., "Classic", "Supabase").

### `OrbMood` (Enum)
System-wide state influencing selection probability.
- `idle`: (x1.0 for all).
- `energetic`: (x2.0 for `positive`).
- `gloomy`: (x2.0 for `negative`).

## Persistence Schema

### `assets/classic_answers.json` (Static Asset)
```json
[
  {"text": "It is certain", "category": "positive"},
  {"text": "Reply hazy, try again", "category": "neutral"},
  {"text": "Very doubtful", "category": "negative"}
]
```

### Table: `dynamic_answers` (Supabase Schema)
- `id`: `uuid`.
- `text`: `text`.
- `category`: `enum` (pos, neu, neg).
- `is_active`: `boolean`.
- `weight`: `float8` (Default: 1.0).
