import SwiftUI

struct ComposeEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ComposeEntryViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("What's on your mind?", text: $viewModel.title)
                        .accessibilityIdentifier("tf_entry_title")
                }
                Section("Entry") {
                    TextEditor(text: $viewModel.body)
                        .frame(minHeight: 200)
                        .accessibilityIdentifier("te_entry_body")
                }
                if FeatureFlags.isVoiceEnabled {
                    Section("Voice") {
                        VoiceRecorderView()
                    }
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("btn_compose_cancel")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save(context: modelContext)
                        dismiss()
                    }
                    .disabled(!viewModel.isSaveEnabled)
                    .accessibilityIdentifier("btn_compose_save")
                }
            }
        }
    }
}
