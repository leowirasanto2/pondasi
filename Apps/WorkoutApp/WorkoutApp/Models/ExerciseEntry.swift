import Foundation
import SwiftData

@Model
final class ExerciseEntry {
    var exerciseName: String
    var muscleGroup: String
    var order: Int

    @Relationship(deleteRule: .cascade, inverse: \SetRecord.exerciseEntry)
    var sets: [SetRecord] = []

    var session: WorkoutSession?

    init(exerciseName: String, muscleGroup: String, order: Int) {
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.order = order
    }

    var orderedSets: [SetRecord] {
        sets.sorted { $0.order < $1.order }
    }
}
