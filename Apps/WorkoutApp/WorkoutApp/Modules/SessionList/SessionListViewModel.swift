import SwiftUI
import SwiftData
import Combine

@MainActor
final class SessionListViewModel: ObservableObject {
    @Published var sessions: [WorkoutSession] = []
    @Published var activeSession: WorkoutSession?
    @Published var showNewSessionSheet = false
    @Published var newSessionName = ""

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchSessions()
    }

    func fetchSessions() {
        let descriptor = FetchDescriptor<WorkoutSession>(
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        sessions = (try? modelContext.fetch(descriptor)) ?? []
        activeSession = sessions.first { $0.isActive }
    }

    func startNewSession() {
        guard !newSessionName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let session = WorkoutSession(name: newSessionName.trimmingCharacters(in: .whitespaces))
        modelContext.insert(session)
        try? modelContext.save()
        newSessionName = ""
        showNewSessionSheet = false
        fetchSessions()
    }

    func finishSession(_ session: WorkoutSession) {
        session.finishedAt = Date()
        try? modelContext.save()
        fetchSessions()
    }

    func deleteSession(_ session: WorkoutSession) {
        modelContext.delete(session)
        try? modelContext.save()
        fetchSessions()
    }
}
