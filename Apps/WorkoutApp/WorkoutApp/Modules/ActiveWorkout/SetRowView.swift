import SwiftUI

struct SetRowView: View {
    let setNumber: Int
    let set: SetRecord
    let onUpdate: (Double, Int) -> Void
    let onDelete: () -> Void

    @State private var weightText: String
    @State private var repsText: String

    init(setNumber: Int, set: SetRecord, onUpdate: @escaping (Double, Int) -> Void, onDelete: @escaping () -> Void) {
        self.setNumber = setNumber
        self.set = set
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self._weightText = State(initialValue: set.weightKg == 0 ? "" : String(format: "%.4g", set.weightKg))
        self._repsText = State(initialValue: String(set.reps))
    }

    var body: some View {
        HStack(spacing: 12) {
            Text("Set \(setNumber)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 44, alignment: .leading)

            HStack {
                TextField("0", text: $weightText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity)
                Text("kg")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: 100)

            HStack {
                TextField("0", text: $repsText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity)
                Text("reps")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: 100)

            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundStyle(.red.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .onChange(of: weightText) { _, new in commit(weightText: new) }
        .onChange(of: repsText) { _, new in commit(repsText: new) }
    }

    private func commit(weightText: String? = nil, repsText: String? = nil) {
        let kg = Double(weightText ?? self.weightText) ?? set.weightKg
        let reps = Int(repsText ?? self.repsText) ?? set.reps
        onUpdate(kg, reps)
    }
}
