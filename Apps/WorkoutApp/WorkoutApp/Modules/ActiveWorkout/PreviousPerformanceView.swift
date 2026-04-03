import SwiftUI

struct PreviousPerformanceView: View {
    let entry: ExerciseEntry

    var body: some View {
        let sets = entry.orderedSets
        if sets.isEmpty { EmptyView() } else {
            VStack(alignment: .leading, spacing: 4) {
                Label("Last time", systemImage: "clock.arrow.circlepath")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    ForEach(Array(sets.enumerated()), id: \.offset) { _, set in
                        Text("\(set.displayWeight) × \(set.reps)")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.accentColor.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}
