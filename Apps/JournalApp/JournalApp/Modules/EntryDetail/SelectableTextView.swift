import SwiftUI
import UIKit

// MARK: - SelectableTextView

struct SelectableTextView: UIViewRepresentable {
    let text: String
    let comments: [EntryComment]
    var selectedCommentID: UUID?
    var onCommentRequested: (NSRange) -> Void

    func makeUIView(context: Context) -> CommentableTextView {
        let coordinator = context.coordinator
        let textView = CommentableTextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.onCommentRequested = { range in
            coordinator.onCommentRequested(range)
        }
        return textView
    }

    func updateUIView(_ uiView: CommentableTextView, context: Context) {
        context.coordinator.parent = self
        let newAttributed = buildAttributedString()
        // Only update when content changes to avoid selection reset
        if uiView.attributedText != newAttributed {
            uiView.attributedText = newAttributed
        }
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: CommentableTextView, context: Context) -> CGSize? {
        let width = proposal.width ?? uiView.window?.bounds.width ?? 375
        return uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    private func buildAttributedString() -> NSAttributedString {
        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.label
            ]
        )
        let nsLength = (text as NSString).length
        for comment in comments {
            let length = comment.highlightEnd - comment.highlightStart
            guard length > 0,
                  comment.highlightStart >= 0,
                  comment.highlightStart + length <= nsLength else { continue }
            let isSelected = comment.id == selectedCommentID
            attributed.addAttribute(
                .backgroundColor,
                value: UIColor.systemYellow.withAlphaComponent(isSelected ? 0.75 : 0.2),
                range: NSRange(location: comment.highlightStart, length: length)
            )
        }
        return attributed
    }

    // MARK: Coordinator

    final class Coordinator {
        var parent: SelectableTextView

        init(parent: SelectableTextView) {
            self.parent = parent
        }

        func onCommentRequested(_ range: NSRange) {
            parent.onCommentRequested(range)
        }
    }
}

// MARK: - CommentableTextView

final class CommentableTextView: UITextView {
    var onCommentRequested: ((NSRange) -> Void)?

    override func buildMenu(with builder: any UIMenuBuilder) {
        super.buildMenu(with: builder)
        let commentAction = UIAction(
            title: "Comment",
            image: UIImage(systemName: "bubble.left")
        ) { [weak self] _ in
            guard let self else { return }
            guard let selectedRange = self.selectedTextRange else { return }
            let start = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
            let end = self.offset(from: self.beginningOfDocument, to: selectedRange.end)
            guard end > start else { return }
            self.onCommentRequested?(NSRange(location: start, length: end - start))
        }
        builder.insertChild(
            UIMenu(
                title: "",
                image: nil,
                identifier: UIMenu.Identifier("com.pondasi.journal.comment"),
                options: .displayInline,
                children: [commentAction]
            ),
            atStartOfMenu: .standardEdit
        )
    }
}
