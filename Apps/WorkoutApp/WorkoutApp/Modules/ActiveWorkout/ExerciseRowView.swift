import SwiftUI

struct ExerciseRowView: View {
    let entry: ExerciseEntry
    let lastPerformance: ExerciseEntry?
    let navigationPath: Binding<[WorkoutDestination]>
    let onAddSet: () -> Void
    let onRemoveSet: (SetRecord) -> Void
    let onUpdateSet: (SetRecord, Double, Int) -> Void
    let onRemoveExercise: () -> Void

    var body: some View {
        Section {
            if let last = lastPerformance {
                PreviousPerformanceView(entry: last)
                    .listRowBackground(Color.accentColor.opacity(0.05))
            }

            ForEach(Array(entry.orderedSets.enumerated()), id: \.element.id) { index, set in
                SetRowView(
                    setNumber: index + 1,
                    set: set,
                    onUpdate: { kg, reps in onUpdateSet(set, kg, reps) },
                    onDelete: { onRemoveSet(set) }
                )
            }

            Button {
                onAddSet()
            } label: {
                Label("Add Set", systemImage: "plus.circle")
                    .font(.subheadline)
            }
        } header: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.exerciseName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    if let group = MuscleGroup(rawValue: entry.muscleGroup) {
                        Text(group.displayName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Menu {
                    Button {
                        navigationPath.wrappedValue.append(.exerciseHistory(exerciseName: entry.exerciseName))
                    } label: {
                        Label("View History", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    Button(role: .destructive) {
                        onRemoveExercise()
                    } label: {
                        Label("Remove Exercise", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
