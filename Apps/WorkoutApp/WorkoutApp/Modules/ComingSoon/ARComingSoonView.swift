import SwiftUI

struct ARComingSoonView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 72))
                .foregroundStyle(Color.accentColor)
            Text("AR Rep Counter")
                .font(.title.bold())
            Text("We're working on a feature that uses your camera to automatically count reps using augmented reality — so you never lose track mid-set.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            Label("Coming Soon", systemImage: "clock")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.accentColor.opacity(0.12))
                .clipShape(Capsule())
            Spacer()
        }
        .padding()
        .navigationTitle("AR Rep Counter")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { ARComingSoonView() }
}
