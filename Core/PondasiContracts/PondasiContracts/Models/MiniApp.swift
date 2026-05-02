//
//  MiniApp.swift
//  PondasiContracts
//
//  Created by Leo Wirasanto Laia on 03/04/26.
//
import Foundation
import SwiftUI

public struct MiniApp: Identifiable, Hashable {
    public let id: MiniAppID
    public let name: String
    public let icon: String
    public let color: Color

    public init(id: MiniAppID, name: String, icon: String, color: Color) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
    }
}
