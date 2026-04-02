# PondasiApp — Super App Shell

See root `CLAUDE.md` for overall architecture and conventions.

## Role

PondasiApp is a thin container. It owns:
- App lifecycle and entry point
- Root SwiftData `ModelContainer` (shared across verticals)
- Top-level navigation / tab routing to each vertical
- No business logic of its own

## Key Files

| File | Purpose |
|---|---|
| `PondasiApp/PondasiAppApp.swift` | App entry point, ModelContainer setup |
| `PondasiApp/ContentView.swift` | Root UI / vertical routing |
| `PondasiApp/Tester.swift` | Dev sandbox — safe to delete |
| `Podfile` | Declares all vertical pod deps |

## Dependencies (Podfile)

```ruby
pod 'PondasiContracts', :path => '../Core/PondasiContracts'
pod 'CreativityApp',    :path => '../Apps/CreativityApp'
pod 'WorkoutApp',       :path => '../Apps/WorkoutApp'
pod 'JournalApp',       :path => '../Apps/JournalApp'
```

After changing any vertical's public API or adding new pods: run `pod install` from this directory.

## Development

Always open: `PondasiApp.xcworkspace` (not `.xcodeproj`)

```bash
cd PondasiApp && pod install
open PondasiApp.xcworkspace
```

## SwiftData

The root `ModelContainer` is initialized here with all models from all verticals. When a vertical adds a new `@Model`, register it in the container here.

## What NOT to add here

- Business logic — belongs in the relevant vertical
- Shared types or protocols — belongs in `PondasiContracts`
- Data models — belongs in the vertical that owns them
