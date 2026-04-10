import Foundation
import SwiftData
import UIKit

@MainActor
final class EntryDetailViewModel: ObservableObject {
    @Published var pendingCommentRange: NSRange?
    @Published var commentInput = ""

    func requestComment(for range: NSRange) {
        pendingCommentRange = range
        commentInput = ""
    }

    func cancelComment() {
        pendingCommentRange = nil
        commentInput = ""
    }

    func addComment(to entry: JournalEntry, context: ModelContext) {
        guard let range = pendingCommentRange,
              !commentInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let comment = EntryComment(
            commentText: commentInput.trimmingCharacters(in: .whitespaces),
            highlightStart: range.location,
            highlightEnd: range.location + range.length
        )
        entry.comments.append(comment)
        pendingCommentRange = nil
        commentInput = ""
    }

    func deleteComment(_ comment: EntryComment, from entry: JournalEntry, context: ModelContext) {
        entry.comments.removeAll { $0.id == comment.id }
        context.delete(comment)
    }
}
