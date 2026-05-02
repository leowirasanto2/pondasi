//
//  LandingViewModel.swift
//  PondasiApp
//
//  Aggregates ActivityFeedItems from each registered MiniAppActivityProvider
//  and exposes the merged + sorted list to LandingView.
//

import Foundation
import Combine
import SwiftUI
import SwiftData
import PondasiContracts
import JournalApp
import WorkoutApp

@MainActor
final class LandingViewModel: ObservableObject {
    @Published var userName: String = "Leo"
    @Published var feed: [ActivityFeedItem] = []
    @Published var miniApps: [MiniApp] = [
        MiniApp(id: .journal,    name: "Journal",    icon: "book.fill",       color: .blue),
        MiniApp(id: .creativity, name: "Creativity", icon: "paintbrush.fill", color: .purple),
        MiniApp(id: .workout,    name: "Workout",    icon: "figure.run",      color: .orange)
    ]

    /// Per-provider fetch limit before merging. The shell trims the merged
    /// list when displaying. 20 per vertical is plenty for a feed.
    private let perProviderLimit = 20

    private let providers: [MiniAppActivityProvider] = [
        JournalActivityProvider(),
        WorkoutActivityProvider()
        // CreativityActivityProvider() — wire up when CreativityApp ships
    ]

    /// The single most recent activity across all mini-apps, used for the
    /// "Latest Activity" card on the landing screen. Returns nil when the
    /// feed is empty (e.g. fresh install).
    var latestActivity: ActivityFeedItem? { feed.first }

    /// Refresh from the shared ModelContext. Call from LandingView's `.task`
    /// or `.onAppear` so we pick up changes when returning from a mini-app.
    func refresh(context: ModelContext) {
        let merged = providers.flatMap { provider in
            provider.recentActivities(in: context, limit: perProviderLimit)
        }
        feed = merged.sorted { $0.timestamp > $1.timestamp }
    }
}
