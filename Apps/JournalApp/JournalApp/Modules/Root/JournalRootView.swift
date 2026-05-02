import SwiftUI
import SwiftData

enum JournalDestination: Hashable {
    case entryDetail(JournalEntry)
}

struct JournalRootView: View {
    @State private var path = NavigationPath()
    @State private var showingCompose = false

    var body: some View {
        NavigationStack(path: $path) {
            EntryListView(path: $path)
                .navigationTitle("Journal")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingCompose = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .fontWeight(.semibold)
                        }
                        .accessibilityIdentifier("btn_new_entry")
                    }
                }
                .navigationDestination(for: JournalDestination.self) { destination in
                    switch destination {
                    case .entryDetail(let entry):
                        EntryDetailView(entry: entry)
                    }
                }
        }
        .sheet(isPresented: $showingCompose) {
            ComposeEntryView()
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: JournalEntry.self, EntryComment.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let entry = JournalEntry(title: "Morning Thoughts", text: "Had a great start to the day.")
    container.mainContext.insert(entry)
    return JournalRootView()
        .modelContainer(container)
}
