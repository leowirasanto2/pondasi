import Foundation
import SwiftData

@Model
final class SetRecord {
    var order: Int
    var weightKg: Double
    var reps: Int
    var completedAt: Date
    var exerciseEntry: ExerciseEntry?

    init(order: Int, weightKg: Double, reps: Int) {
        self.order = order
        self.weightKg = weightKg
        self.reps = reps
        self.completedAt = Date()
    }

    var displayWeight: String {
        weightKg == 0 ? "BW" : String(format: "%.1g kg", weightKg)
    }
}
