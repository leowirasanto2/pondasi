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
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                bodySection
                if viewModel.pendingCommentRange != nil {
                    commentInputView
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                if !sortedComments.isEmpty {
                    commentsSection
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(Color(.systemBackground))
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(entry.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if FeatureFlags.isVoiceEnabled {
                ToolbarItem(placement: .navigationBarTrailing) {
                    VoiceRecorderView()
                }
            }
        }
        .accessibilityIdentifier("entry_detail")
        .animation(.easeInOut(duration: 0.2), value: viewModel.pendingCommentRange != nil)
    }

    // MARK: Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.title)
                .font(.title2.bold())
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.caption)
                Text(entry.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                    .font(.subheadline)
            }
            .foregroundStyle(.secondary)
        }
    }

    // MARK: Body

    private var bodySection: some View {
        SelectableTextView(
            text: entry.text,
            comments: sortedComments,
            selectedCommentID: viewModel.selectedCommentID,
            onCommentRequested: { range in
                viewModel.requestComment(for: range)
            }
        )
        .font(.body)
    }

    // MARK: Comment Input

    @ViewBuilder
    private var commentInputView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("New Comment", systemImage: "bubble.left")
                .font(.subheadline.bold())
                .foregroundStyle(.primary)

            TextEditor(text: $viewModel.commentInput)
                .frame(height: 80)
                .scrollContentBackground(.hidden)
                .padding(10)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .accessibilityIdentifier("te_comment_input")

            HStack {
                Button("Cancel") {
                    viewModel.cancelComment()
                }
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("btn_comment_cancel")

                Spacer()

                Button("Add Comment") {
                    viewModel.addComment(to: entry, context: modelContext)
                }
                .disabled(viewModel.commentInput.trimmingCharacters(in: .whitespaces).isEmpty)
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .accessibilityIdentifier("btn_comment_add")
            }
        }
        .padding(16)
        .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: Comments Section

    @ViewBuilder
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Comments", systemImage: "bubble.left.and.bubble.right")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            ForEach(sortedComments) { comment in
                CommentBubbleView(
                    comment: comment,
                    isSelected: viewModel.selectedCommentID == comment.id,
                    onTap: { viewModel.selectComment(comment.id) },
                    onDelete: { viewModel.deleteComment(comment, from: entry, context: modelContext) }
                )
                .accessibilityIdentifier("comment_bubble_\(comment.id.uuidString)")
            }
        }
        .accessibilityIdentifier("comments_section")
    }
}

// MARK: - CommentBubbleView

private struct CommentBubbleView: View {
    let comment: EntryComment
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Color.yellow.opacity(isSelected ? 1 : 0.5))
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 4) {
                Text(comment.commentText)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Text(comment.createdAt.formatted(.dateTime.month(.abbreviated).day().hour().minute()))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption.bold())
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(12)
        .background(Color.yellow.opacity(isSelected ? 0.18 : 0.06), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.yellow.opacity(isSelected ? 0.5 : 0), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .onTapGesture { onTap() }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: JournalEntry.self, EntryComment.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let entry = JournalEntry(
        title: "Morning Thoughts",
        text: "Today was a productive day. I managed to finish the journaling feature and it looks great. SwiftUI makes building beautiful UIs so straightforward."
    )
    let comment = EntryComment(commentText: "Remember this feeling!", highlightStart: 0, highlightEnd: 25)
    entry.comments.append(comment)
    container.mainContext.insert(entry)
    return NavigationStack {
        EntryDetailView(entry: entry)
    }
    .modelContainer(container)
}
