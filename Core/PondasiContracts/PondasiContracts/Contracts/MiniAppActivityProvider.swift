//
//  MiniAppActivityProvider.swift
//  PondasiContracts
//
//  Each mini-app implements this protocol to surface its recent activity
//  to the super-app shell. The shell calls each registered provider with the
//  shared ModelContext, merges results, and sorts by timestamp.
//
//  Why @MainActor + sync: SwiftData's ModelContext is bound to a single
//  actor and feed-sized fetches (typically <50 rows) are fast in-process.
//  Async would buy nothing but ceremony.
//

import Foundation
import SwiftData

@MainActor
public protocol MiniAppActivityProvider {
    /// The mini-app this provider belongs to.
    var miniAppID: MiniAppID { get }

    /// Fetch the most-recent N items, ordered however the provider sees fit.
    /// The shell will re-sort the merged collection by timestamp anyway.
    func recentActivities(in context: ModelContext, limit: Int) -> [ActivityFeedItem]
}
