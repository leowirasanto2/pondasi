//
//  PondasiAppApp.swift
//  PondasiApp
//
//  Created by Leo Wirasanto Laia on 02/04/26.
//

import SwiftUI
import SwiftData
import JournalApp
import WorkoutApp

@main
struct PondasiAppApp: App {
    /// Shared ModelContainer that aggregates the @Model types contributed by
    /// each mini-app. Each vertical exposes its own schema via
    /// `<MiniApp>Schema.models`, and we merge them here so SwiftData has a
    /// single source of truth across the super app.
    var sharedModelContainer: ModelContainer = {
        let allModels: [any PersistentModel.Type] =
            JournalAppSchema.models +
            WorkoutAppSchema.models

        let schema = Schema(allModels)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LandingView()
        }
        .modelContainer(sharedModelContainer)
    }
}
