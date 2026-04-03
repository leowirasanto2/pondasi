import SwiftUI
import SwiftData
import Combine

/// Public entry point consumed by PondasiApp.
public struct WorkoutAppEntry: View {
    public init() {}

    public var body: some View {
        WorkoutRootView()
    }
}

/// All SwiftData model types WorkoutApp persists.
/// PondasiApp must include these in its shared ModelContainer schema.
public enum WorkoutAppSchema {
    public static var models: [any PersistentModel.Type] {
        [WorkoutSession.self, ExerciseEntry.self, SetRecord.self]
    }
}
