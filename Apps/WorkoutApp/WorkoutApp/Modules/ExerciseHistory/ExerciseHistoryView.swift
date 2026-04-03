import SwiftUI
import SwiftData

struct ExerciseHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var vm: ExerciseHistoryViewModel

    init(exerciseName: String, modelContext: ModelContext) {
        self._vm = StateObject(wrappedValue: ExerciseHistoryViewModel(exerciseName: exerciseName, modelContext: modelContext))
    }

    var body: some View {
        List {
            if let pb = vm.personalBest {
                Section("Personal Best") {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(.yellow)
                        Text("\(pb.displayWeight) × \(pb.reps) reps")
                            .font(.headline)
                    }
                }
            }

            if vm.entries.isEmpty {
                ContentUnavailableView(
                    "No history yet",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("Complete a workout with this exercise to see history.")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(vm.entries) { entry in
                    Section {
                        ForEach(Array(entry.orderedSets.enumerated()), id: \.offset) { index, set in
                            HStack {
                                Text("Set \(index + 1)")
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                                    .frame(width: 48, alignment: .leading)
                                Text(set.displayWeight)
                                    .font(.body)
                                Spacer()
                                Text("\(set.reps) reps")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } header: {
                        if let date = entry.session?.startedAt {
                            Text(date.formatted(date: .long, time: .omitted))
                        }
                    }
                }
            }
        }
        .navigationTitle(vm.exerciseName)
        .navigationBarTitleDisplayMode(.large)
        .onAppear { vm.fetchEntries() }
    }
}
