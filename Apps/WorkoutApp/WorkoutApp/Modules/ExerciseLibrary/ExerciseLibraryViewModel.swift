import SwiftUI
import Combine

@MainActor
final class ExerciseLibraryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedMuscleGroup: MuscleGroup? = nil

    var filteredExercises: [Exercise] {
        ExerciseLibrary.all.filter { exercise in
            let matchesGroup = selectedMuscleGroup.map { exercise.muscleGroup == $0 } ?? true
            let matchesSearch = exercise.matches(query: searchText)
            return matchesGroup && matchesSearch
        }
    }

    var groupedExercises: [(MuscleGroup, [Exercise])] {
        if selectedMuscleGroup != nil || !searchText.isEmpty {
            return []
        }
        return MuscleGroup.allCases.compactMap { group in
            let exercises = ExerciseLibrary.exercises(for: group)
            return exercises.isEmpty ? nil : (group, exercises)
        }
    }
}
