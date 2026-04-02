//
//  LandingActivityType.swift
//  PondasiApp
//
//  Created by Leo Wirasanto Laia on 03/04/26.
//

import Foundation

enum LandingActivityType: Identifiable {
    var id: Int {
        switch self {
        case .journal: return 1
        case .creativity: return 2
        case .workout: return 3
        }
    }
    
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
