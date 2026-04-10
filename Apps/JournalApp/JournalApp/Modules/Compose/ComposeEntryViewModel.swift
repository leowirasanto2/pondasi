import Foundation
import SwiftData

@MainActor
final class ComposeEntryViewModel: ObservableObject {
    @Published var title = ""
    @Published var body = ""

    var isSaveEnabled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func save(context: ModelContext) {
        let entry = JournalEntry(
            title: title.trimmingCharacters(in: .whitespaces),
            text: body
        )
        context.insert(entry)
    }
}
