import Foundation
import SwiftData

@Model final class JournalEntry {
    var id: UUID
    var date: Date
    var title: String
    var text: String
    var voiceFilePath: String?

    @Relationship(deleteRule: .cascade) var comments: [EntryComment] = []

    init(title: String, text: String) {
        self.id = UUID()
        self.date = Date()
        self.title = title
        self.text = text
    }
}
