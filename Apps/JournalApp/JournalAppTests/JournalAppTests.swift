//
//  JournalAppTests.swift
//  JournalAppTests
//
//  Created by Leo Wirasanto Laia on 02/04/26.
//

import Testing
import Foundation
import SwiftData
@testable import JournalApp

@MainActor
struct EntryDetailViewModelTests {

    // MARK: - Helpers

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: JournalEntry.self, EntryComment.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    private func makeEntry(in container: ModelContainer, text: String = "Hello world") -> JournalEntry {
        let entry = JournalEntry(title: "Test", text: text)
        container.mainContext.insert(entry)
        return entry
    }

    // MARK: - selectComment

    @Test func selectComment_setsID_whenNoneSelected() {
        let vm = EntryDetailViewModel()
        let id = UUID()

        vm.selectComment(id)

        #expect(vm.selectedCommentID == id)
    }

    @Test func selectComment_togglesOff_whenSameIDSelected() {
        let vm = EntryDetailViewModel()
        let id = UUID()

        vm.selectComment(id)
        vm.selectComment(id)

        #expect(vm.selectedCommentID == nil)
    }

    @Test func selectComment_switchesToNewID_whenDifferentIDSelected() {
        let vm = EntryDetailViewModel()
        let first = UUID()
        let second = UUID()

        vm.selectComment(first)
        vm.selectComment(second)

        #expect(vm.selectedCommentID == second)
    }

    // MARK: - requestComment / cancelComment

    @Test func requestComment_setsRange_andClearsInput() {
        let vm = EntryDetailViewModel()
        vm.commentInput = "stale text"

        vm.requestComment(for: NSRange(location: 0, length: 5))

        #expect(vm.pendingCommentRange == NSRange(location: 0, length: 5))
        #expect(vm.commentInput == "")
    }

    @Test func cancelComment_clearsRange_andInput() {
        let vm = EntryDetailViewModel()
        vm.requestComment(for: NSRange(location: 0, length: 5))
        vm.commentInput = "draft"

        vm.cancelComment()

        #expect(vm.pendingCommentRange == nil)
        #expect(vm.commentInput == "")
    }

    // MARK: - addComment

    @Test func addComment_appendsComment_whenInputAndRangeValid() throws {
        let container = try makeContainer()
        let entry = makeEntry(in: container)
        let vm = EntryDetailViewModel()

        vm.requestComment(for: NSRange(location: 0, length: 5))
        vm.commentInput = "  great point  "
        vm.addComment(to: entry, context: container.mainContext)

        #expect(entry.comments.count == 1)
        let comment = try #require(entry.comments.first)
        #expect(comment.commentText == "great point") // trimmed
        #expect(comment.highlightStart == 0)
        #expect(comment.highlightEnd == 5)
        // After adding, pending state is cleared.
        #expect(vm.pendingCommentRange == nil)
        #expect(vm.commentInput == "")
    }

    @Test func addComment_doesNothing_whenInputEmpty() throws {
        let container = try makeContainer()
        let entry = makeEntry(in: container)
        let vm = EntryDetailViewModel()

        vm.requestComment(for: NSRange(location: 0, length: 5))
        vm.commentInput = ""
        vm.addComment(to: entry, context: container.mainContext)

        #expect(entry.comments.isEmpty)
        // Pending range should remain so the user can keep typing.
        #expect(vm.pendingCommentRange == NSRange(location: 0, length: 5))
    }

    @Test func addComment_doesNothing_whenInputIsOnlyWhitespace() throws {
        let container = try makeContainer()
        let entry = makeEntry(in: container)
        let vm = EntryDetailViewModel()

        vm.requestComment(for: NSRange(location: 0, length: 5))
        vm.commentInput = "    "
        vm.addComment(to: entry, context: container.mainContext)

        #expect(entry.comments.isEmpty)
    }

    @Test func addComment_doesNothing_whenNoPendingRange() throws {
        let container = try makeContainer()
        let entry = makeEntry(in: container)
        let vm = EntryDetailViewModel()

        vm.commentInput = "no range set"
        vm.addComment(to: entry, context: container.mainContext)

        #expect(entry.comments.isEmpty)
    }

    // MARK: - deleteComment

    @Test func deleteComment_removesFromEntry() throws {
        let container = try makeContainer()
        let entry = makeEntry(in: container)
        let vm = EntryDetailViewModel()

        vm.requestComment(for: NSRange(location: 0, length: 3))
        vm.commentInput = "first"
        vm.addComment(to: entry, context: container.mainContext)

        let comment = try #require(entry.comments.first)
        vm.deleteComment(comment, from: entry, context: container.mainContext)

        #expect(entry.comments.isEmpty)
    }
}
