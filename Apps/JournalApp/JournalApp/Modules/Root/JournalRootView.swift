import SwiftUI

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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingCompose = true
                        } label: {
                            Image(systemName: "plus")
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
