//
//  ActivityFeedItem.swift
//  PondasiContracts
//
//  Cross-cutting feed item produced by each mini-app's MiniAppActivityProvider
//  and consumed by the super-app shell (PondasiApp) for the Latest Activity
//  section and the full Recent Activities view.
//
//  The `id` is the entity ID inside the originating mini-app (e.g. a
//  JournalEntry.id or WorkoutSession.id) and is what the shell uses for
//  deep-linking back to the source.
//

import Foundation

public struct ActivityFeedItem: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let kind: MiniAppID
    public let title: String
    public let subtitle: String?
    public let timestamp: Date
    /// Open-ended payload for kind-specific display data (e.g. workout
    /// reps/goal, journal entry type). Avoids growing this struct's API
    /// surface as new verticals come online.
    public let metadata: [String: String]

    public init(
        id: UUID,
        kind: MiniAppID,
        title: String,
        subtitle: String? = nil,
        timestamp: Date,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.kind = kind
        self.title = title
        self.subtitle = subtitle
        self.timestamp = timestamp
        self.metadata = metadata
    }
}
