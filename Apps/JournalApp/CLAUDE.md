# JournalApp — Journaling Vertical

See root `CLAUDE.md` for overall architecture and conventions.

## Role

A personal journaling tool supporting both text and voice entries. Runs as a standalone app and as an embedded vertical inside PondasiApp.

## Domain Scope (Current)

- Create journal entries (free-form text)
- Tag entries for organization
- Browse entries in a timeline/list view
- Voice recording attached to entries (transcription — future)

## Key Files

| File | Purpose |
|---|---|
| `JournalApp/JournalAppApp.swift` | Standalone app entry point |
| `JournalApp/ContentView.swift` | Root view (currently boilerplate) |
| `JournalApp.podspec` | Module spec for PondasiApp integration |

## Dependencies

- `PondasiContracts` — shared types only
- No other vertical imports

## Storage

SwiftData. Models go in `Models/` folder decorated with `@Model`. Persist locally; no sync.

Example model shape (to be implemented):
```swift
@Model final class JournalEntry {
    var id: UUID
    var date: Date
    var text: String
    var tags: [String]
    var voiceFilePath: String?  // local file URL
}
```

## Podspec

```ruby
# JournalApp.podspec
s.source_files = 'Sources/**/*'
s.dependency 'PondasiContracts'
```

Public API for PondasiApp integration must be `public`.

## Development (Standalone)

```bash
cd Apps/JournalApp && pod install
open JournalApp.xcodeproj
```

## Current State

Xcode template boilerplate only. All domain models and UI are to be built.

## Out of Scope

- AI summarization (Claude/GPT) — future
- Voice-to-text transcription — future
- Cloud sync or export — future
