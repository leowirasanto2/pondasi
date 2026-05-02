import SwiftUI
import SwiftData
import Combine
import PondasiContracts

/// Public entry point consumed by PondasiApp.
///
/// Pass `deepLinkSessionID` to navigate directly to a specific session's
/// active-workout view on appear.
public struct WorkoutAppEntry: View {
    private let deepLinkSessionID: UUID?

    public init(deepLinkSessionID: UUID? = nil) {
        self.deepLinkSessionID = deepLinkSessionID
    }

    public var body: some View {
        WorkoutRootView(deepLinkSessionID: deepLinkSessionID)
    }
}

/// All SwiftData model types WorkoutApp persists.
/// PondasiApp must include these in its shared ModelContainer schema.
public enum WorkoutAppSchema {
    public static var models: [any PersistentModel.Type] {
        [WorkoutSession.self, ExerciseEntry.self, SetRecord.self]
    }
}

/// Activity provider for the super-app's feed.
@MainActor
public struct WorkoutActivityProvider: MiniAppActivityProvider {
    public init() {}

    public var miniAppID: MiniAppID { .workout }

    public func recentActivities(in context: ModelContext, limit: Int) -> [ActivityFeedItem] {
        var descriptor = FetchDescriptor<WorkoutSession>(
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit

        let sessions = (try? context.fetch(descriptor)) ?? []
        return sessions.map { session in
            ActivityFeedItem(
                id: session.id,
                kind: .workout,
                title: session.name,
                subtitle: Self.subtitle(for: session),
                timestamp: session.startedAt,
                metadata: [
                    "isActive": session.isActive ? "true" : "false",
                    "totalSets": String(session.totalSets),
                    "exerciseCount": String(session.exercises.count)
                ]
            )
        }
    }

    private static func subtitle(for session: WorkoutSession) -> String {
        let exercises = session.exercises.count
        let sets = session.totalSets
        if session.isActive {
            return "In progress · \(exercises) exercise\(exercises == 1 ? "" : "s")"
        }
        let minutes = Int(session.duration / 60)
        return "\(minutes) min · \(sets) set\(sets == 1 ? "" : "s")"
    }
}
