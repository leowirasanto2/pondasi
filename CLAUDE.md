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

## CocoaPods Workflow

Each module has its own `Podfile`. Always run `pod install` from the relevant module directory:

```bash
# Super app (installs all verticals)
cd PondasiApp && pod install

# Individual vertical (for standalone development)
cd Apps/JournalApp && pod install
cd Apps/CreativityApp && pod install
cd Apps/WorkoutApp && pod install

# Contracts (rarely needed — no external deps)
cd Core/PondasiContracts && pod install
```

Always open the `.xcworkspace`, never the `.xcodeproj` directly.

Integration pattern: each vertical publishes a `.podspec`; PondasiApp's `Podfile` references them via local paths:
```ruby
pod 'CreativityApp', :path => '../Apps/CreativityApp'
```

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

## Current State

All mini-apps are Xcode boilerplate (generated templates). Only `Profile` and `ProfilePicture` models exist in PondasiContracts. Active development starts from scratch on top of this scaffolding.
