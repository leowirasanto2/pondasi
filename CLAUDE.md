# Pondasi — Super App Monorepo

A local-first iOS super app that hosts multiple focused mini-apps ("verticals") under one shell. Each vertical runs standalone and is also embeddable in the main app.

## Architecture

```
PondasiApp (super app shell)
├── depends on → CreativityApp  (filmmaking vertical)
├── depends on → JournalApp     (journaling vertical)
├── depends on → WorkoutApp     (workout vertical)
│
└── all verticals depend on → PondasiContracts (shared core)
```

Verticals must NOT import each other. All shared types flow through `PondasiContracts` only.

## Module Map

| Module | Path | Role |
|---|---|---|
| PondasiApp | `PondasiApp/` | Shell/container super app |
| PondasiContracts | `Core/PondasiContracts/` | Shared protocols, models, contracts |
| CreativityApp | `Apps/CreativityApp/` | Filmmaking vertical (mood board, storyboard, shot list) |
| JournalApp | `Apps/JournalApp/` | Journaling vertical (text + voice, AI summarization — future) |
| WorkoutApp | `Apps/WorkoutApp/` | Workout vertical (exercise logging, AI coach — future) |

## Tech Stack

- **Language**: Swift 6.0 (strict concurrency enabled)
- **UI**: SwiftUI
- **Storage**: SwiftData (local-first, no backend)
- **Dependency manager**: CocoaPods with local path deps
- **Minimum OS**: iOS 17.0
- **Xcode**: 26.x (uses `FileSystemSynchronizedRootGroup`)

## CocoaPods Notes

- Each module has its own `Podfile`. Run `pod install` from the relevant module directory.
- Always open `.xcworkspace`, never `.xcodeproj`.
- Each vertical publishes a `.podspec`; PondasiApp references them via `pod 'X', :path => '../Apps/X'`.

## Conventions

- **Models**: `@Model` classes live in `Models/` subfolder
- **Source layout**: Podspec-exported sources go in `Sources/` dir; app-target files live under the app name folder
- **Access control**: Only expose what PondasiApp needs — default to `internal`, use `public` deliberately
- **PondasiContracts**: All shared types must be `public`. No external dependencies allowed in this module.
- **Swift 6 concurrency**: Use `@MainActor`, `Sendable`, and structured concurrency. Avoid `DispatchQueue` unless interfacing with legacy APIs.
- **No cross-vertical imports**: Verticals import `PondasiContracts` only, never each other.

## Scope (Current Sprint)

**In scope:**
- SwiftData local storage for all verticals
- SwiftUI views and navigation
- Shared type definitions in PondasiContracts
- CocoaPods integration between verticals and super app

**Out of scope (future):**
- AI/ML features (Claude, GPT, Core ML personalization)
- Backend sync or cloud storage
- Push notifications
- `Manifest.yml` — placeholder file, ignore for now

## Collaboration Rules

These rules govern how Claude assists in this project to conserve tokens and keep the human in control.

1. **Never run `pod install` or any `git` commands** (pull, push, fetch, rebase, etc.). State the exact command and wait for the user to confirm it completed before proceeding.

2. **Never read files speculatively.** Ask the user which files are relevant. Only read after explicit permission or direction.

3. **Never read a whole file when a snippet suffices.** If only a specific type/function is needed, ask the user to paste just that part.

4. **Always confirm before acting on assumptions.** List what context is missing and wait for the user's go-ahead before proceeding.

5. **Start a new conversation per task.** Do not carry unrelated context across tasks — remind the user to use `/clear` when switching topics mid-session.

## PR Drafting

When asked to draft a PR description, use this format. Do not invent extra sections.

```
## Summary
<what changed and why, in prose. List new/modified/deleted files at the end.>

## Test Plan
<action-level checklist. Do NOT enumerate step-by-step UI taps.
Use coarse "Validate X" items, e.g. "Validate build successfully from Xcode",
"Validate Cmd+U passes", "Validate tapping each tile presents the mini-app
without crashing". One checkbox per validation, not per tap.>

## Demo
<screen recording / screenshots, or "(Attach screen recording or screenshots.)" placeholder>
```

Tone notes:

- Summary is prose with bullets where helpful, not a wall of headings.
- Test Plan items describe *what to validate*, not *how to click through it*. Trust the reviewer to run the app.
- Skip "Known limitations" / "Non-goals" / "How to test" subsections unless the user asks.
- Skip the commit/branch commands at the bottom unless the user asks.

## Current State

- **PondasiContracts**: `Profile`, `ProfilePicture`, `MiniApp` (with `MiniAppID`-based id), `MiniAppID`, `ActivityFeedItem`, and the `MiniAppActivityProvider` protocol.
- **JournalApp**: real domain — `JournalEntry` + `EntryComment` SwiftData models, full text/voice composition flow, list, detail, comments. Exposes `JournalAppEntry(deepLinkEntryID:)`, `JournalAppSchema.models`, and `JournalActivityProvider`.
- **WorkoutApp**: real domain — `WorkoutSession`, `ExerciseEntry`, `SetRecord`, `Exercise`, `MuscleGroup`. Active workout flow, exercise library, history. Exposes `WorkoutAppEntry(deepLinkSessionID:)`, `WorkoutAppSchema.models`, and `WorkoutActivityProvider`.
- **CreativityApp**: still scaffolding. Wired in PondasiApp's tile grid via a `CreativityComingSoonView` placeholder.
- **PondasiApp**: shared `ModelContainer` aggregates `JournalAppSchema.models + WorkoutAppSchema.models`. `LandingView` is the root, presents mini-apps via `.sheet(item:)` with `.presentationDetents([.large])`. `LandingViewModel` aggregates feed items from registered providers, sorts by timestamp.
- **Tests**: `EntryDetailViewModelTests` (Swift Testing) covers the journal entry detail VM. JournalApp UI tests are disabled (scheme `skipped="YES"` + `#if false`); snapshot tests planned for a follow-up branch.
- **Dead code to clean up later**: `PondasiApp/PondasiApp/ContentView.swift` and `PondasiApp/PondasiApp/Item.swift` (Xcode template leftovers, not referenced).
