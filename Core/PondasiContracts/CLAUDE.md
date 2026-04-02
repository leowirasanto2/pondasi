# PondasiContracts — Shared Core

See root `CLAUDE.md` for overall architecture and conventions.

## Role

The single source of truth for types, protocols, and contracts shared across all verticals. Every vertical and PondasiApp imports this module. Nothing imports verticals.

## Rules

1. **No external dependencies** — this module must stay dependency-free
2. **No vertical imports** — never import CreativityApp, JournalApp, or WorkoutApp
3. **All public** — every type exported here must have `public` access modifier
4. **Stable API** — breaking changes here break all verticals; version carefully

## Key Files

| File | Purpose |
|---|---|
| `PondasiContracts/Models/Profile.swift` | `Profile` and `ProfilePicture` structs — only models so far |

## Existing Models

```swift
public struct Profile: Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let profilePicture: ProfilePicture
}

public struct ProfilePicture: Equatable {
    let id: String
    let fileName: String
    let filePath: String
}
```

## Source Layout

Podspec sources point to `Sources/**/*`. New shared code should go in a `Sources/` directory structure:

```
Sources/
  Models/       # Shared data models
  Protocols/    # Shared protocols / interfaces
  Types/        # Value types, enums, typealiases
```

> Note: Current files live under `PondasiContracts/` (Xcode target folder). A `Sources/` migration is needed before the podspec source path is accurate.

## Planned Additions (future)

- `MiniAppManifest` protocol — for vertical registration in PondasiApp
- `VerticalRoute` — typed navigation destinations
- Shared AI result types (when AI features land)

## Development

```bash
cd Core/PondasiContracts && pod install
open PondasiContracts.xcodeproj
```
