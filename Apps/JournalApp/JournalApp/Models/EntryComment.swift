import Foundation
import SwiftData

@Model final class EntryComment {
    var id: UUID
    var commentText: String
    /// UTF-16 code unit offset where the highlight starts in the parent entry's text.
    var highlightStart: Int
    /// UTF-16 code unit offset where the highlight ends (exclusive).
    var highlightEnd: Int
    var createdAt: Date

    init(commentText: String, highlightStart: Int, highlightEnd: Int) {
        self.id = UUID()
        self.commentText = commentText
        self.highlightStart = highlightStart
        self.highlightEnd = highlightEnd
        self.createdAt = Date()
    }
}
