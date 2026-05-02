import SwiftUI
import SwiftData

enum WorkoutDestination: Hashable {
    case activeWorkout(WorkoutSession)
    case exerciseHistory(exerciseName: String)
    case arComingSoon

    static func == (lhs: WorkoutDestination, rhs: WorkoutDestination) -> Bool {
        switch (lhs, rhs) {
        case (.activeWorkout(let a), .activeWorkout(let b)): return a.id == b.id
        case (.exerciseHistory(let a), .exerciseHistory(let b)): return a == b
        case (.arComingSoon, .arComingSoon): return true
        default: return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .activeWorkout(let s): hasher.combine(0); hasher.combine(s.id)
        case .exerciseHistory(let name): hasher.combine(1); hasher.combine(name)
        case .arComingSoon: hasher.combine(2)
        }
    }
}

struct WorkoutRootView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var navigationPath: [WorkoutDestination] = []

    /// Optional deep-link target. When set, the root pushes the matching
    /// session's active-workout view once on appear.
    let deepLinkSessionID: UUID?

    init(deepLinkSessionID: UUID? = nil) {
        self.deepLinkSessionID = deepLinkSessionID
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            SessionListView(navigationPath: $navigationPath, modelContext: modelContext)
                .navigationDestination(for: WorkoutDestination.self) { destination in
                    switch destination {
                    case .activeWorkout(let session):
                        ActiveWorkoutView(
                            session: session,
                            navigationPath: $navigationPath,
                            modelContext: modelContext
                        )
                    case .exerciseHistory(let name):
                        ExerciseHistoryView(exerciseName: name, modelContext: modelContext)
                    case .arComingSoon:
                        ARComingSoonView()
                    }
                }
                .task(id: deepLinkSessionID) {
                    guard let id = deepLinkSessionID else { return }
                    var descriptor = FetchDescriptor<WorkoutSession>(
                        predicate: #Predicate { $0.id == id }
                    )
                    descriptor.fetchLimit = 1
                    if let session = (try? modelContext.fetch(descriptor))?.first {
                        navigationPath.append(.activeWorkout(session))
                    }
                }
        }
    }
}

#Preview {
    WorkoutRootView()
        .modelContainer(
            try! ModelContainer(
                for: Schema(WorkoutAppSchema.models),
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
        )
}
