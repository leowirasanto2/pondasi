import SwiftUI
import SwiftData

/// Public entry point consumed by PondasiApp.
public struct JournalAppEntry: View {
    public init() {}

    public var body: some View {
        JournalRootView()
    }
}

/// All SwiftData model types JournalApp persists.
/// PondasiApp must include these in its shared ModelContainer schema.
public enum JournalAppSchema {
    public static var models: [any PersistentModel.Type] {
        [JournalEntry.self, EntryComment.self]
    }
}
