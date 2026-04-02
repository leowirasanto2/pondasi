//
//  LandingViewModel.swift
//  PondasiApp
//
//  Created by Leo Wirasanto Laia on 03/04/26.
//

import Foundation
internal import Combine

// MARK: - Activity Models
enum ActivityType {
    case journal(JournalActivity)
    case creativity(CreativityActivity)
    case workout(WorkoutActivity)
}

struct JournalActivity {
    let date: Date
    let type: JournalType
    let summary: String
    
    enum JournalType {
        case text
        case voice
    }
}

struct CreativityActivity {
    let projectName: String
    let description: String
    let dateModified: Date
}

struct WorkoutActivity {
    let date: Date
    let workoutType: String // e.g., "Chest Day", "Leg Day", "Back Day"
    let repetitionsDone: Int
    let repetitionsGoal: Int
}

struct MiniApp: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

import SwiftUI

@MainActor
class LandingViewModel: ObservableObject {
    @Published var userName: String = "Leo"
    @Published var latestActivity: ActivityType?
    @Published var recentActivities: [ActivityType] = []
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
            MiniApp(name: "Workout", icon: "figure.run", color: .orange),
            MiniApp(name: "Meditation", icon: "heart.fill", color: .pink),
            MiniApp(name: "Learning", icon: "graduationcap.fill", color: .green),
            MiniApp(name: "Goals", icon: "target", color: .red)
        ]
    }
}
