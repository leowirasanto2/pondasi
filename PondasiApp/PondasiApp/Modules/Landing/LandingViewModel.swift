//
//  LandingViewModel.swift
//  PondasiApp
//
//  Created by Leo Wirasanto Laia on 03/04/26.
//

import Foundation
import Combine
import PondasiContracts

import SwiftUI

// TODO: all dummy data are acceptable for this phase, let's not care about that now.
@MainActor
class LandingViewModel: ObservableObject {
    @Published var userName: String = "Leo"
    @Published var latestActivity: LandingActivityType?
    @Published var recentActivities: [LandingActivityType] = []
    @Published var miniApps: [MiniApp] = []
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        // Mock recent activities
        recentActivities = [
            .journal(JournalActivity(
                date: Date(),
                type: .text,
                summary: "Reflected on today's progress and set goals for tomorrow"
            )),
            .workout(WorkoutActivity(
                date: Date().addingTimeInterval(-86400),
                workoutType: "Chest Day",
                repetitionsDone: 45,
                repetitionsGoal: 50
            )),
            .creativity(CreativityActivity(
                projectName: "Digital Illustration",
                description: "Working on a new character design for my portfolio",
                dateModified: Date().addingTimeInterval(-172800)
            )),
            .journal(JournalActivity(
                date: Date().addingTimeInterval(-259200),
                type: .voice,
                summary: "Voice note about morning meditation and gratitude practice"
            )),
            .workout(WorkoutActivity(
                date: Date().addingTimeInterval(-345600),
                workoutType: "Leg Day",
                repetitionsDone: 60,
                repetitionsGoal: 60
            )),
            .creativity(CreativityActivity(
                projectName: "UI Design System",
                description: "Creating a cohesive design system for personal projects",
                dateModified: Date().addingTimeInterval(-432000)
            ))
        ]
        
        // Set latest activity
        latestActivity = recentActivities.first
        
        // Mock mini apps
        miniApps = [
            MiniApp(name: "Journal", icon: "book.fill", color: .blue),
            MiniApp(name: "Creativity", icon: "paintbrush.fill", color: .purple),
            MiniApp(name: "Workout", icon: "figure.run", color: .orange)
        ]
    }
}
