//
//  MiniAppID.swift
//  PondasiContracts
//
//  Stable identifier for each mini-app. Used for tile routing, activity
//  classification, and deep-linking from the super-app shell.
//

import Foundation

public enum MiniAppID: String, Sendable, Hashable, Codable, CaseIterable {
    case journal
    case workout
    case creativity
}
