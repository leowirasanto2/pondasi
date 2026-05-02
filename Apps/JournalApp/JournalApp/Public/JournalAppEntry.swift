import SwiftUI
import SwiftData
import PondasiContracts

/// Public entry point consumed by PondasiApp.
///
/// Pass `deepLinkEntryID` to navigate directly to a specific journal entry's
/// detail view on appear.
public struct JournalAppEntry: View {
    private let deepLinkEntryID: UUID?

    public init(deepLinkEntryID: UUID? = nil) {
        self.deepLinkEntryID = deepLinkEntryID
    }

    public var body: some View {
        JournalRootView(deepLinkEntryID: deepLinkEntryID)
    }
}

/// All SwiftData model types JournalApp persists.
/// PondasiApp must include these in its shared ModelContainer schema.
public enum JournalAppSchema {
    public static var models: [any PersistentModel.Type] {
        [JournalEntry.self, EntryComment.self]
    }
}

/// Activity provider for the super-app's feed.
@MainActor
public struct JournalActivityProvider: MiniAppActivityProvider {
    public init() {}

    public var miniAppID: MiniAppID { .journal }

    public func recentActivities(in context: ModelContext, limit: Int) -> [ActivityFeedItem] {
        var descriptor = FetchDescriptor<JournalEntry>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        descriptor.fetchLimit = limit

        let entries = (try? context.fetch(descriptor)) ?? []
        return entries.map { entry in
            ActivityFeedItem(
                id: entry.id,
                kind: .journal,
                title: entry.title,
                subtitle: Self.summary(for: entry.text),
                timestamp: entry.date,
                metadata: [
                    "type": entry.voiceFilePath != nil ? "voice" : "text"
                ]
            )
        }
    }

    /// Trim entry body to a short feed-friendly excerpt.
    private static func summary(for text: String, maxLength: Int = 140) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= maxLength { return trimmed }
        return String(trimmed.prefix(maxLength)) + "…"
    }
}
