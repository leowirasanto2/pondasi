# WorkoutApp — Workout Vertical

See root `CLAUDE.md` for overall architecture and conventions.

## Role

A personal fitness tracking tool for logging workouts and tracking progress. Runs as a standalone app and as an embedded vertical inside PondasiApp.

## Domain Scope (Current)

- Log workout sessions (exercises, sets, reps, weight)
- Browse an exercise library
- View progress over time (per exercise or per muscle group)

## Key Files

| File | Purpose |
|---|---|
| `WorkoutApp/WorkoutAppApp.swift` | Standalone app entry point |
| `WorkoutApp/ContentView.swift` | Root view (currently boilerplate) |
| `WorkoutApp.podspec` | Module spec for PondasiApp integration |

## Dependencies

- `PondasiContracts` — shared types only
- No other vertical imports

## Storage

SwiftData. Models go in `Models/` folder decorated with `@Model`. Persist locally; no sync.

Example model shape (to be implemented):
```swift
@Model final class WorkoutSession {
    var id: UUID
    var date: Date
    var name: String
    var exercises: [ExerciseSet]
}

@Model final class ExerciseSet {
    var exerciseName: String
    var sets: Int
    var reps: Int
    var weightKg: Double?
}
```

## Podspec

```ruby
# WorkoutApp.podspec
s.source_files = 'Sources/**/*'
s.dependency 'PondasiContracts'
```

Public API for PondasiApp integration must be `public`.

## Development (Standalone)

```bash
cd Apps/WorkoutApp && pod install
open WorkoutApp.xcodeproj
```

## Current State

Xcode template boilerplate only. All domain models and UI are to be built.

## Out of Scope

- AI personal trainer / coaching — future
- HealthKit integration — future
- Cloud sync or social features — future
