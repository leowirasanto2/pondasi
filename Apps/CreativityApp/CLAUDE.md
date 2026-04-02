# CreativityApp — Filmmaking Vertical

See root `CLAUDE.md` for overall architecture and conventions.

## Role

A standalone filmmaking workflow tool. Helps plan and organize film projects through:
- **Mood Board** — visual reference collection
- **Storyboard** — scene-by-scene visual sequence
- **Shot List** — detailed per-shot production checklist

Runs as a standalone app and as an embedded vertical inside PondasiApp.

## Domain Scope (Current)

Filmmaking pre-production only:
- Create and manage film projects
- Build mood boards with images and notes
- Create storyboards with panels and scene descriptions
- Build shot lists with camera angles, lens, duration, and notes

## Key Files

| File | Purpose |
|---|---|
| `CreativityApp/CreativityAppApp.swift` | Standalone app entry point |
| `CreativityApp/ContentView.swift` | Root view (currently boilerplate) |
| `CreativityApp.podspec` | Module spec for PondasiApp integration |

## Dependencies

- `PondasiContracts` — shared types only
- No other vertical imports

## Storage

SwiftData. Models go in `Models/` folder decorated with `@Model`. Persist locally; no sync.

## Podspec

```ruby
# CreativityApp.podspec
s.source_files = 'Sources/**/*'
s.dependency 'PondasiContracts'
```

Public API for PondasiApp (e.g., entry-point view, route) must be `public`.

## Development (Standalone)

```bash
cd Apps/CreativityApp && pod install
open CreativityApp.xcodeproj
```

## Current State

Xcode template boilerplate only. All domain models and UI are to be built.

## Out of Scope

- AI-assisted shot suggestions — future
- Cloud sync or sharing — future
- Video/audio playback — future
