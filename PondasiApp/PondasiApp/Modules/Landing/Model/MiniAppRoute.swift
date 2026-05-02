//
//  MiniAppRoute.swift
//  PondasiApp
//
//  Navigation destinations from the Landing screen into a mini-app, with an
//  optional deep-link entity ID so a tap on an activity card lands directly
//  on the matching detail view.
//

import Foundation
import PondasiContracts

enum MiniAppRoute: Hashable, Identifiable {
    case journal(entryID: UUID?)
    case workout(sessionID: UUID?)
    case creativity

    /// Stable identity for SwiftUI's `fullScreenCover(item:)` and similar
    /// presentation modifiers. Identity is on the *kind* of mini-app, not on
    /// the deep-link payload — opening the same mini-app twice with a
    /// different entity should re-use the cover.
    var id: String {
        switch self {
        case .journal:    return "journal"
        case .workout:    return "workout"
        case .creativity: return "creativity"
        }
    }

    init(item: ActivityFeedItem) {
        switch item.kind {
        case .journal:    self = .journal(entryID: item.id)
        case .workout:    self = .workout(sessionID: item.id)
        case .creativity: self = .creativity
        }
    }

    init(miniApp id: MiniAppID) {
        switch id {
        case .journal:    self = .journal(entryID: nil)
        case .workout:    self = .workout(sessionID: nil)
        case .creativity: self = .creativity
        }
    }
}
