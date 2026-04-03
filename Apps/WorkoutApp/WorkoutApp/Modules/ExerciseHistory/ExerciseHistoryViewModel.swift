import SwiftUI
import SwiftData
import Combine

@MainActor
final class ExerciseHistoryViewModel: ObservableObject {
    @Published var entries: [ExerciseEntry] = []
    let exerciseName: String

    private let modelContext: ModelContext

    init(exerciseName: String, modelContext: ModelContext) {
        self.exerciseName = exerciseName
        self.modelContext = modelContext
        fetchEntries()
    }

    func fetchEntries() {
        let name = exerciseName
        let descriptor = FetchDescriptor<ExerciseEntry>(
            predicate: #Predicate { $0.exerciseName == name }
        )
        let all = (try? modelContext.fetch(descriptor)) ?? []
        entries = all
            .filter { $0.session?.finishedAt != nil }
            .sorted { ($0.session?.startedAt ?? .distantPast) > ($1.session?.startedAt ?? .distantPast) }
    }

    var personalBest: SetRecord? {
        entries.flatMap { $0.sets }.max { $0.weightKg < $1.weightKg }
    }
}
