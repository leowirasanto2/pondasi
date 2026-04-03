import SwiftUI
import SwiftData

struct SessionListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var vm: SessionListViewModel
    @Binding var navigationPath: [WorkoutDestination]

    init(navigationPath: Binding<[WorkoutDestination]>, modelContext: ModelContext) {
        self._navigationPath = navigationPath
        self._vm = StateObject(wrappedValue: SessionListViewModel(modelContext: modelContext))
    }

    var body: some View {
        List {
            if let active = vm.activeSession {
                Section("Active") {
                    sessionRow(active)
                        .listRowBackground(Color.green.opacity(0.08))
                }
            }

            Section("History") {
                let finished = vm.sessions.filter { !$0.isActive }
                if finished.isEmpty {
                    Text("No workouts yet. Tap + to start.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                } else {
                    ForEach(finished) { session in
                        sessionRow(session)
                    }
                    .onDelete { offsets in
                        offsets.map { finished[$0] }.forEach { vm.deleteSession($0) }
                    }
                }
            }
        }
        .navigationTitle("Workouts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    vm.showNewSessionSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    navigationPath.append(.arComingSoon)
                } label: {
                    Image(systemName: "camera.viewfinder")
                }
            }
        }
        .sheet(isPresented: $vm.showNewSessionSheet) {
            newSessionSheet
        }
        .onAppear { vm.fetchSessions() }
    }

    private func sessionRow(_ session: WorkoutSession) -> some View {
        Button {
            navigationPath.append(.activeWorkout(session))
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(session.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    if session.isActive {
                        Text("Active")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                    }
                }
                HStack(spacing: 12) {
                    Label(session.startedAt.formatted(date: .abbreviated, time: .omitted),
                          systemImage: "calendar")
                    Label("\(session.totalSets) sets", systemImage: "checkmark.circle")
                    Label("\(session.exercises.count) exercises", systemImage: "dumbbell")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 2)
        }
        .buttonStyle(.plain)
    }

    private var newSessionSheet: some View {
        NavigationStack {
            Form {
                Section("Workout Name") {
                    TextField("e.g. Chest Day, Push, Leg Day…", text: $vm.newSessionName)
                        .autocorrectionDisabled()
                }
                Section {
                    Button("Start Workout") {
                        vm.startNewSession()
                    }
                    .disabled(vm.newSessionName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { vm.showNewSessionSheet = false }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
