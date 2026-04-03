import Foundation

struct Exercise: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let muscleGroup: MuscleGroup
    let alternativeNames: [String]

    init(name: String, muscleGroup: MuscleGroup, alternativeNames: [String] = []) {
        self.id = UUID()
        self.name = name
        self.muscleGroup = muscleGroup
        self.alternativeNames = alternativeNames
    }

    func matches(query: String) -> Bool {
        guard !query.isEmpty else { return true }
        let q = query.lowercased()
        return name.lowercased().contains(q)
            || alternativeNames.contains { $0.lowercased().contains(q) }
    }
}
