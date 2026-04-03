import SwiftUI

struct ExerciseLibraryView: View {
    @StateObject private var vm = ExerciseLibraryViewModel()
    var isPickerMode: Bool = false
    var onSelect: ((Exercise) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                muscleGroupFilter

                if vm.groupedExercises.isEmpty {
                    ForEach(vm.filteredExercises) { exercise in
                        exerciseRow(exercise)
                    }
                } else {
                    ForEach(vm.groupedExercises, id: \.0) { group, exercises in
                        Section(group.displayName) {
                            ForEach(exercises) { exercise in
                                exerciseRow(exercise)
                            }
                        }
                    }
                }
            }
            .navigationTitle(isPickerMode ? "Add Exercise" : "Exercise Library")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $vm.searchText, prompt: "Search exercises…")
            .toolbar {
                if isPickerMode {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func exerciseRow(_ exercise: Exercise) -> some View {
        if isPickerMode, let onSelect {
            Button {
                onSelect(exercise)
            } label: {
                exerciseLabel(exercise)
            }
            .buttonStyle(.plain)
        } else {
            exerciseLabel(exercise)
        }
    }

    private func exerciseLabel(_ exercise: Exercise) -> some View {
        HStack {
            Image(systemName: exercise.muscleGroup.systemImage)
                .foregroundStyle(Color.accentColor)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name).font(.body)
                Text(exercise.muscleGroup.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    private var muscleGroupFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(label: "All", group: nil)
                ForEach(MuscleGroup.allCases, id: \.self) { group in
                    filterChip(label: group.displayName, group: group)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
        }
        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .listRowBackground(Color.clear)
    }

    private func filterChip(label: String, group: MuscleGroup?) -> some View {
        let selected = vm.selectedMuscleGroup == group
        return Button {
            vm.selectedMuscleGroup = group
        } label: {
            Text(label)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(selected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
