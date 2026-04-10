import SwiftUI
import SwiftData

struct EntryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    @Binding var path: NavigationPath
    @StateObject private var viewModel = EntryListViewModel()

    var body: some View {
        let sections = viewModel.sections(from: entries)
        List {
            ForEach(sections, id: \.title) { section in
                Section(section.title) {
                    ForEach(section.entries) { entry in
                        Button {
                            path.append(JournalDestination.entryDetail(entry))
                        } label: {
                            EntryRowView(entry: entry)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("entry_row_\(entry.id.uuidString)")
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            viewModel.delete(section.entries[offset], context: modelContext)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .accessibilityIdentifier("entry_list")
        .overlay {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No Entries",
                    systemImage: "book.closed",
                    description: Text("Tap + to write your first entry.")
                )
            }
        }
    }
}

private struct EntryRowView: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.title)
                .font(.headline)
            if !entry.text.isEmpty {
                Text(entry.text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Text(entry.date, style: .date)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}
