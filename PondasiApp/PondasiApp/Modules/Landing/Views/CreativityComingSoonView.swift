//
//  CreativityComingSoonView.swift
//  PondasiApp
//
//  Placeholder shown when the Creativity tile is tapped — CreativityApp
//  isn't wired into the super-app yet, but having a destination keeps the
//  Landing navigation pattern uniform across all three mini-apps.
//

import SwiftUI

struct CreativityComingSoonView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "paintbrush.pointed.fill")
                .font(.system(size: 56))
                .foregroundStyle(.purple)
            Text("Creativity")
                .font(.title.bold())
            Text("Coming soon. The filmmaking vertical is still in design.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Creativity")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { CreativityComingSoonView() }
}
