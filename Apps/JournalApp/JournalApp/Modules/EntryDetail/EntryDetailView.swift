import SwiftUI
import SwiftData

struct EntryDetailView: View {
    let entry: JournalEntry
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = EntryDetailViewModel()

    private var sortedComments: [EntryComment] {
        entry.comments.sorted { $0.createdAt < $1.createdAt }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.title)
                        .font(.title2)
                        .bold()
                    Text(entry.date, style: .date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Selectable body
                SelectableTextView(
                    text: entry.text,
                    comments: sortedComments,
                    onCommentRequested: { range in
                        viewModel.requestComment(for: range)
                    }
                )

                // Comment input (appears when a text range is pending)
                if viewModel.pendingCommentRange != nil {
                    commentInputView
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                // Comments list
                if !sortedComments.isEmpty {
                    commentsSection
                }
            }
            .padding()
        }
        .navigationTitle("Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if FeatureFlags.isVoiceEnabled {
                ToolbarItem(placement: .navigationBarTrailing) {
                    VoiceRecorderView()
                }
            }
        }
        .accessibilityIdentifier("entry_detail")
        .animation(.easeInOut, value: viewModel.pendingCommentRange != nil)
    }

    // MARK: Comment Input

    @ViewBuilder
    private var commentInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add Comment")
                .font(.headline)
            TextEditor(text: $viewModel.commentInput)
                .frame(height: 80)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
                .accessibilityIdentifier("te_comment_input")
            HStack {
                Button("Cancel") {
                    viewModel.cancelComment()
                }
                .accessibilityIdentifier("btn_comment_cancel")
                Spacer()
                Button("Add") {
                    viewModel.addComment(to: entry, context: modelContext)
                }
                .disabled(viewModel.commentInput.trimmingCharacters(in: .whitespaces).isEmpty)
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("btn_comment_add")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: Comments Section

    @ViewBuilder
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Comments")
                .font(.headline)
            ForEach(sortedComments) { comment in
                CommentBubbleView(comment: comment) {
                    viewModel.deleteComment(comment, from: entry, context: modelContext)
                }
                .accessibilityIdentifier("comment_bubble_\(comment.id.uuidString)")
            }
        }
        .accessibilityIdentifier("comments_section")
    }
}

// MARK: - CommentBubbleView

private struct CommentBubbleView: View {
    let comment: EntryComment
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(comment.commentText)
                .font(.body)
            Text(comment.createdAt, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
        .overlay(alignment: .topTrailing) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .padding(6)
        }
    }
}
