import Foundation
import SwiftData

@Model
final class WorkoutSession {
    var id: UUID
    var name: String
    var startedAt: Date
    var finishedAt: Date?
    var notes: String

    @Relationship(deleteRule: .cascade, inverse: \ExerciseEntry.session)
    var exercises: [ExerciseEntry] = []

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.startedAt = Date()
        self.notes = ""
    }

    var isActive: Bool { finishedAt == nil }

    var orderedExercises: [ExerciseEntry] {
        exercises.sorted { $0.order < $1.order }
    }

    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }

    var duration: TimeInterval {
        let end = finishedAt ?? Date()
        return end.timeIntervalSince(startedAt)
    }
}
