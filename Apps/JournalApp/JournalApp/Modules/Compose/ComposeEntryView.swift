import SwiftUI
import Combine
import SwiftData

struct ComposeEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ComposeEntryViewModel()
    @FocusState private var focusedField: Field?

    private enum Field { case title, body }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    TextField("Title", text: $viewModel.title, axis: .vertical)
                        .font(.title2.bold())
                        .focused($focusedField, equals: .title)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .body }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .accessibilityIdentifier("tf_entry_title")

                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)

                    TextField("What's on your mind?", text: $viewModel.body, axis: .vertical)
                        .font(.body)
                        .lineSpacing(4)
                        .focused($focusedField, equals: .body)
                        .padding(.horizontal, 20)
                        .accessibilityIdentifier("te_entry_body")

                    if FeatureFlags.isVoiceEnabled {
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        HStack {
                            Text("Voice Note")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            VoiceRecorderView()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    }

                    Spacer(minLength: 120)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollDismissesKeyboard(.interactively)
            .background(Color(.systemBackground))
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("btn_compose_cancel")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save(context: modelContext)
                        dismiss()
                    }
                    .disabled(!viewModel.isSaveEnabled)
                    .fontWeight(.semibold)
                    .accessibilityIdentifier("btn_compose_save")
                }
            }
            .onAppear { focusedField = .title }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: JournalEntry.self, EntryComment.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    return ComposeEntryView()
        .modelContainer(container)
}
