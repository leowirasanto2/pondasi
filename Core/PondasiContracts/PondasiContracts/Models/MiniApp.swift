//
//  MiniApp.swift
//  PondasiContracts
//
//  Created by Leo Wirasanto Laia on 03/04/26.
//
import Foundation
import SwiftUI

public struct MiniApp: Identifiable {
    public let id = UUID()
    public let name: String
    public let icon: String
    public let color: Color
    
    public init(name: String, icon: String, color: Color) {
        self.name = name
        self.icon = icon
        self.color = color
    }
}
