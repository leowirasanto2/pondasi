import Foundation
import SwiftData
import Combine

@MainActor
final class EntryListViewModel: ObservableObject {

    /// Returns sections: "This Week" (flat) then one section per day for older entries.
    func sections(from entries: [JournalEntry]) -> [(title: String, entries: [JournalEntry])] {
        let calendar = Calendar.current
        let thisWeek = entries
            .filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear) }
            .sorted { $0.date > $1.date }
        let older = entries
            .filter { !calendar.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear) }
            .sorted { $0.date > $1.date }

        var result: [(title: String, entries: [JournalEntry])] = []

        if !thisWeek.isEmpty {
            result.append(("This Week", thisWeek))
        }

        // Group older entries by day label
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none

        var grouped: [(key: String, date: Date, entries: [JournalEntry])] = []
        for entry in older {
            let label = formatter.string(from: entry.date)
            if let idx = grouped.firstIndex(where: { $0.key == label }) {
                grouped[idx].entries.append(entry)
            } else {
                grouped.append((label, entry.date, [entry]))
            }
        }

        for group in grouped {
            result.append((group.key, group.entries))
        }

        return result
    }

    func delete(_ entry: JournalEntry, context: ModelContext) {
        context.delete(entry)
    }
}
