//
//  LandingView.swift
//  PondasiApp
//
//  Created by Leo Wirasanto Laia on 03/04/26.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var vm = LandingViewModel()
    @State private var showingRecentActivities = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                    
                    // Latest activity section
                    if let activity = vm.latestActivity {
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
                            
                            activityCard(for: activity)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Tiles of mini apps
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Apps")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        miniAppsGrid
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $showingRecentActivities) {
                RecentActivitiesView(activities: vm.recentActivities)
            }
        }
    }
    
    // MARK: - Header Section
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
    
    // MARK: - Activity Cards
    @ViewBuilder
    private func activityCard(for activity: ActivityType) -> some View {
        switch activity {
        case .journal(let journal):
            journalCard(journal)
        case .creativity(let creativity):
            creativityCard(creativity)
        case .workout(let workout):
            workoutCard(workout)
        }
    }
    
    private func journalCard(_ journal: JournalActivity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: journal.type == .text ? "text.book.closed.fill" : "waveform")
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Journal Entry")
                        .font(.headline)
                    Text(journal.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Label(journal.type == .text ? "Text" : "Voice", systemImage: "")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
            }
            
            Text(journal.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
    
    private func creativityCard(_ creativity: CreativityActivity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "paintbrush.pointed.fill")
                    .font(.title2)
                    .foregroundStyle(.purple)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Creative Project")
                        .font(.headline)
                    Text("Modified \(creativity.dateModified, style: .relative)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            Text(creativity.projectName)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(creativity.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
    
    private func workoutCard(_ workout: WorkoutActivity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.title2)
                    .foregroundStyle(.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.workoutType)
                        .font(.headline)
                    Text(workout.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Progress")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(workout.repetitionsDone)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                        Text("/ \(workout.repetitionsGoal)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: Double(workout.repetitionsDone) / Double(workout.repetitionsGoal),
                    color: .orange
                )
                .frame(width: 60, height: 60)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
    
    // MARK: - Mini Apps Grid
    private var miniAppsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(vm.miniApps) { app in
                MiniAppTile(app: app)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Supporting Views
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
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 6)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Recent Activities View
struct RecentActivitiesView: View {
    @Environment(\.dismiss) private var dismiss
    let activities: [ActivityType]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(activities.enumerated()), id: \.offset) { index, activity in
                        activityCard(for: activity)
                            .padding(.horizontal)
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
    
    // MARK: - Activity Cards
    @ViewBuilder
    private func activityCard(for activity: ActivityType) -> some View {
        switch activity {
        case .journal(let journal):
            journalCard(journal)
        case .creativity(let creativity):
            creativityCard(creativity)
        case .workout(let workout):
            workoutCard(workout)
        }
    }
    
    private func journalCard(_ journal: JournalActivity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: journal.type == .text ? "text.book.closed.fill" : "waveform")
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Journal Entry")
                        .font(.headline)
                    Text(journal.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Label(journal.type == .text ? "Text" : "Voice", systemImage: "")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
            }
            
            Text(journal.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
    
    private func creativityCard(_ creativity: CreativityActivity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "paintbrush.pointed.fill")
                    .font(.title2)
                    .foregroundStyle(.purple)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Creative Project")
                        .font(.headline)
                    Text("Modified \(creativity.dateModified, style: .relative)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            Text(creativity.projectName)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(creativity.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
    
    private func workoutCard(_ workout: WorkoutActivity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.title2)
                    .foregroundStyle(.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.workoutType)
                        .font(.headline)
                    Text(workout.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Progress")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(workout.repetitionsDone)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                        Text("/ \(workout.repetitionsGoal)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: Double(workout.repetitionsDone) / Double(workout.repetitionsGoal),
                    color: .orange
                )
                .frame(width: 60, height: 60)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

#Preview {
    LandingView()
}
