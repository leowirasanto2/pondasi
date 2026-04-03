import SwiftUI
import SwiftData
import Combine

@MainActor
final class ActiveWorkoutViewModel: ObservableObject {
    @Published var session: WorkoutSession
    @Published var lastPerformances: [String: ExerciseEntry] = [:]
    @Published var showExercisePicker = false

    private let modelContext: ModelContext

    init(session: WorkoutSession, modelContext: ModelContext) {
        self.session = session
        self.modelContext = modelContext
        // Prefetch last performance for all exercises already in the session
        session.exercises.forEach { fetchLastPerformance(for: $0.exerciseName) }
    }

    func addExercise(_ exercise: Exercise) {
        let order = session.exercises.count
        let entry = ExerciseEntry(
            exerciseName: exercise.name,
            muscleGroup: exercise.muscleGroup.rawValue,
            order: order
        )
        modelContext.insert(entry)
        session.exercises.append(entry)
        try? modelContext.save()
        fetchLastPerformance(for: exercise.name)
    }

    func addSet(to entry: ExerciseEntry) {
        let previousWeight = entry.orderedSets.last?.weightKg ?? 0
        let previousReps = entry.orderedSets.last?.reps ?? 10
        let set = SetRecord(order: entry.sets.count, weightKg: previousWeight, reps: previousReps)
        modelContext.insert(set)
        entry.sets.append(set)
        try? modelContext.save()
    }

    func updateSet(_ set: SetRecord, weightKg: Double, reps: Int) {
        set.weightKg = weightKg
        set.reps = reps
        try? modelContext.save()
    }

    func removeSet(_ set: SetRecord) {
        modelContext.delete(set)
        try? modelContext.save()
    }

    func removeExercise(_ entry: ExerciseEntry) {
        modelContext.delete(entry)
        try? modelContext.save()
    }

    func finishWorkout() {
        session.finishedAt = Date()
        try? modelContext.save()
    }

    func fetchLastPerformance(for exerciseName: String) {
        let name = exerciseName
        let currentID = session.id
        let descriptor = FetchDescriptor<ExerciseEntry>(
            predicate: #Predicate { $0.exerciseName == name }
        )
        let all = (try? modelContext.fetch(descriptor)) ?? []
        lastPerformances[name] = all
            .filter { $0.session?.id != currentID && $0.session?.finishedAt != nil }
            .sorted { ($0.session?.finishedAt ?? .distantPast) > ($1.session?.finishedAt ?? .distantPast) }
            .first
    }
}
