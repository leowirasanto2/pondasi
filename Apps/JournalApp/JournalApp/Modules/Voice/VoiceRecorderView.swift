import SwiftUI

struct VoiceRecorderView: View {
    @State private var isRecording = false

    var body: some View {
        Button {
            isRecording.toggle()
        } label: {
            Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .font(.title2)
                .foregroundStyle(isRecording ? Color.red : Color.accentColor)
        }
        .accessibilityIdentifier("btn_voice_record")
    }
}

#Preview {
    VoiceRecorderView()
        .padding()
}
