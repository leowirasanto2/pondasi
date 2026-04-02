# Pondasi

A local-first iOS "Personal OS" — a private space where filmmaking, physical training, and personal reflection converge. Multiple focused mini-apps ("verticals") run under one shell, each usable standalone or embedded in the super app.

https://github.com/leowirasanto2/pondasi/raw/initial-setup/assets/demo.mov

## Verticals

| App | Description |
|---|---|
| **Journal** | Text and voice journaling with AI summarization (future) |
| **Creativity** | Filmmaking tools — mood board, storyboard, shot list |
| **Workout** | Exercise logging with AI coach (future) |

## Architecture

```
PondasiApp (super app shell)
├── CreativityApp    — filmmaking vertical
├── JournalApp       — journaling vertical
├── WorkoutApp       — workout vertical
└── PondasiContracts — shared protocols, models, contracts
```

Verticals are fully independent — they communicate only through `PondasiContracts`. No cross-vertical imports.

## Tech Stack

- **Language**: Swift 6.0 (strict concurrency)
- **UI**: SwiftUI
- **Storage**: SwiftData (local-first, no backend)
- **Dependencies**: CocoaPods with local path pods
- **Minimum OS**: iOS 17.0

## Getting Started

### Prerequisites

- Xcode 26+
- CocoaPods (`gem install cocoapods`)

### Run the super app

```bash
cd PondasiApp
pod install
open PondasiApp.xcworkspace
```

### Run a vertical standalone

```bash
cd Apps/JournalApp   # or CreativityApp / WorkoutApp
pod install
open JournalApp.xcworkspace
```

> Always open the `.xcworkspace`, never the `.xcodeproj` directly.

## Project Structure

```
.
├── PondasiApp/             # Super app shell
├── Apps/
│   ├── JournalApp/
│   ├── CreativityApp/
│   └── WorkoutApp/
├── Core/
│   └── PondasiContracts/   # Shared types and protocols
└── .github/workflows/      # CI — runs tests for all modules
```

## CI

All pull requests into `main` must pass tests for every module before merge. See `.github/workflows/ci.yml`.
