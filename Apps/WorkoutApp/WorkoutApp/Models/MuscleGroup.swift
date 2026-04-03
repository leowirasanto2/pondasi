import Foundation

enum MuscleGroup: String, CaseIterable, Codable, Sendable {
    case chest
    case back
    case shoulders
    case biceps
    case triceps
    case legs
    case core
    case fullBody

    var displayName: String {
        switch self {
        case .fullBody: return "Full Body"
        default: return rawValue.capitalized
        }
    }

    var systemImage: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.rowing"
        case .shoulders: return "figure.arms.open"
        case .biceps: return "figure.flexibility"
        case .triceps: return "figure.cooldown"
        case .legs: return "figure.run"
        case .core: return "figure.core.training"
        case .fullBody: return "figure.mixed.cardio"
        }
    }
}
