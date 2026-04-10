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
                Section {
                    ForEach(section.entries) { entry in
                        Button {
                            path.append(JournalDestination.entryDetail(entry))
                        } label: {
                            EntryCardView(entry: entry)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .accessibilityIdentifier("entry_row_\(entry.id.uuidString)")
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            viewModel.delete(section.entries[offset], context: modelContext)
                        }
                    }
                } header: {
                    Text(section.title)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .padding(.leading, 4)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .accessibilityIdentifier("entry_list")
        .overlay {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No Entries Yet",
                    systemImage: "book.closed",
                    description: Text("Tap the pencil icon to write your first entry.")
                )
            }
        }
    }
}

// MARK: - EntryCardView

private struct EntryCardView: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(entry.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Spacer()
                Text(entry.date, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            if !entry.text.isEmpty {
                Text(entry.text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .lineSpacing(2)
            }

            HStack(spacing: 12) {
                Label(entry.date.formatted(.dateTime.month(.abbreviated).day().year()), systemImage: "calendar")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)

                if !entry.comments.isEmpty {
                    Label("\(entry.comments.count)", systemImage: "bubble.left")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Spacer()
            }
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    let container = try! ModelContainer(
        for: JournalEntry.self, EntryComment.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    container.mainContext.insert(JournalEntry(title: "Morning Thoughts", text: "Had a great start to the day. The weather was beautiful and I felt very motivated."))
    container.mainContext.insert(JournalEntry(title: "Afternoon Slump", text: "Feeling a bit tired after lunch."))
    return NavigationStack {
        EntryListView(path: .constant(NavigationPath()))
            .navigationTitle("Journal")
    }
    .modelContainer(container)
}
