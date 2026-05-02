//
//  LandingView.swift
//  PondasiApp
//
//  Created by Leo Wirasanto Laia on 03/04/26.
//

import SwiftUI
import SwiftData
import PondasiContracts
import JournalApp
import WorkoutApp

struct LandingView: View {
    @StateObject private var vm = LandingViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var presentedRoute: MiniAppRoute?
    @State private var showingRecentActivities = false

    var body: some View {
        // Note: deliberately NOT wrapped in a NavigationStack. Each mini-app
        // entry view (JournalRootView, WorkoutRootView) brings its own
        // NavigationStack for internal navigation. Wrapping again here causes
        // SwiftUI to crash with AnyNavigationPath.comparisonTypeMismatch when
        // the inner stack pushes a typed destination. Mini-apps are presented
        // as fullScreenCover instead of pushed.
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection

                if let activity = vm.latestActivity {
                    latestActivitySection(activity)
                }

                miniAppsSection
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(item: $presentedRoute) { route in
            destinationView(for: route)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showingRecentActivities) {
            RecentActivitiesView(
                activities: vm.feed,
                onSelect: { item in
                    showingRecentActivities = false
                    presentedRoute = MiniAppRoute(item: item)
                }
            )
        }
        .task {
            vm.refresh(context: modelContext)
        }
        .onChange(of: presentedRoute) { _, newValue in
            // Re-aggregate when a mini-app is dismissed (route returns to nil)
            // so Latest Activity reflects any new entries/sessions.
            if newValue == nil {
                vm.refresh(context: modelContext)
            }
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back,")
                .font(.title3)
                .foregroundStyle(.secondary)

            Text(vm.userName)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(Date.now, style: .date)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private func latestActivitySection(_ activity: ActivityFeedItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Latest Activity")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button {
                    showingRecentActivities = true
                } label: {
                    HStack(spacing: 4) {
                        Text("More")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.blue)
                }
            }

            Button {
                presentedRoute = MiniAppRoute(item: activity)
            } label: {
                ActivityCardView(item: activity)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }

    private var miniAppsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Apps")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(vm.miniApps) { app in
                    Button {
                        presentedRoute = MiniAppRoute(miniApp: app.id)
                    } label: {
                        MiniAppTile(app: app)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Navigation destinations

    @ViewBuilder
    private func destinationView(for route: MiniAppRoute) -> some View {
        switch route {
        case .journal(let entryID):
            JournalAppEntry(deepLinkEntryID: entryID)
        case .workout(let sessionID):
            WorkoutAppEntry(deepLinkSessionID: sessionID)
        case .creativity:
            CreativityComingSoonView()
        }
    }
}

// MARK: - Activity Card

/// Renders a single ActivityFeedItem in the same visual language regardless
/// of mini-app, with kind-specific touches (icon, accent color, supporting
/// metadata) driven by `item.kind` and `item.metadata`.
struct ActivityCardView: View {
    let item: ActivityFeedItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundStyle(accentColor)

                VStack(alignment: .leading, spacing: 4) {
                    Text(headerLabel)
                        .font(.headline)
                    Text(item.timestamp, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if let badge = trailingBadge {
                    Text(badge)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(accentColor.opacity(0.1))
                        .foregroundStyle(accentColor)
                        .clipShape(Capsule())
                }
            }

            if !item.title.isEmpty {
                Text(item.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }

            if let subtitle = item.subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }

    // MARK: kind-specific styling

    private var accentColor: Color {
        switch item.kind {
        case .journal:    return .blue
        case .workout:    return .orange
        case .creativity: return .purple
        }
    }

    private var iconName: String {
        switch item.kind {
        case .journal:
            return item.metadata["type"] == "voice" ? "waveform" : "text.book.closed.fill"
        case .workout:
            return "figure.strengthtraining.traditional"
        case .creativity:
            return "paintbrush.pointed.fill"
        }
    }

    private var headerLabel: String {
        switch item.kind {
        case .journal:    return "Journal Entry"
        case .workout:    return "Workout"
        case .creativity: return "Creative Project"
        }
    }

    private var trailingBadge: String? {
        switch item.kind {
        case .journal:
            return item.metadata["type"] == "voice" ? "Voice" : "Text"
        case .workout:
            return item.metadata["isActive"] == "true" ? "Active" : nil
        case .creativity:
            return nil
        }
    }
}

// MARK: - Tile

struct MiniAppTile: View {
    let app: MiniApp

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: app.icon)
                .font(.system(size: 32))
                .foregroundStyle(app.color)

            Text(app.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Recent Activities sheet

struct RecentActivitiesView: View {
    @Environment(\.dismiss) private var dismiss
    let activities: [ActivityFeedItem]
    let onSelect: (ActivityFeedItem) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if activities.isEmpty {
                        ContentUnavailableView(
                            "No Activity Yet",
                            systemImage: "tray",
                            description: Text("Create a journal entry or start a workout to see it here.")
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(activities) { item in
                            Button {
                                onSelect(item)
                            } label: {
                                ActivityCardView(item: item)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Recent Activities")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
        }
    }
}

#Preview {
    LandingView()
        .modelContainer(
            try! ModelContainer(
                for: Schema(JournalAppSchema.models + WorkoutAppSchema.models),
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
        )
}
