import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var vm: ActiveWorkoutViewModel
    @Binding var navigationPath: [WorkoutDestination]
    @State private var showFinishAlert = false

    init(session: WorkoutSession, navigationPath: Binding<[WorkoutDestination]>, modelContext: ModelContext) {
        self._vm = StateObject(wrappedValue: ActiveWorkoutViewModel(session: session, modelContext: modelContext))
        self._navigationPath = navigationPath
    }

    var body: some View {
        List {
            if vm.session.orderedExercises.isEmpty {
                ContentUnavailableView(
                    "No exercises yet",
                    systemImage: "dumbbell",
                    description: Text("Tap + to add an exercise")
                )
                .listRowBackground(Color.clear)
            }

            ForEach(vm.session.orderedExercises) { entry in
                ExerciseRowView(
                    entry: entry,
                    lastPerformance: vm.lastPerformances[entry.exerciseName],
                    navigationPath: $navigationPath,
                    onAddSet: { vm.addSet(to: entry) },
                    onRemoveSet: { vm.removeSet($0) },
                    onUpdateSet: { set, kg, reps in vm.updateSet(set, weightKg: kg, reps: reps) },
                    onRemoveExercise: { vm.removeExercise(entry) }
                )
            }
        }
        .navigationTitle(vm.session.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    vm.showExercisePicker = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            if vm.session.isActive {
                ToolbarItem(placement: .secondaryAction) {
                    Button("Finish Workout", role: .destructive) {
                        showFinishAlert = true
                    }
                }
            }
        }
        .sheet(isPresented: $vm.showExercisePicker) {
            ExerciseLibraryView(
                isPickerMode: true,
                onSelect: { exercise in
                    vm.addExercise(exercise)
                    vm.showExercisePicker = false
                }
            )
        }
        .alert("Finish Workout?", isPresented: $showFinishAlert) {
            Button("Finish", role: .destructive) { vm.finishWorkout() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will mark the workout as completed.")
        }
    }
}
