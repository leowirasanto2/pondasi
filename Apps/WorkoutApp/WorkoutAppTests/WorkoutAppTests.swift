import Testing
import SwiftData
@testable import WorkoutApp

// MARK: - Helpers

private func makeContainer() throws -> ModelContainer {
    try ModelContainer(
        for: Schema(WorkoutAppSchema.models),
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
}

// MARK: - WorkoutSession Model Tests

struct WorkoutSessionTests {

    @Test func isActiveWhenNoFinishedAt() throws {
        let session = WorkoutSession(name: "Push Day")
        #expect(session.isActive == true)
    }

    @Test func isNotActiveAfterFinish() throws {
        let session = WorkoutSession(name: "Push Day")
        session.finishedAt = Date()
        #expect(session.isActive == false)
    }

    @Test func orderedExercisesIsSorted() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let session = WorkoutSession(name: "Chest")
        context.insert(session)

        let e1 = ExerciseEntry(exerciseName: "Bench Press", muscleGroup: "chest", order: 1)
        let e0 = ExerciseEntry(exerciseName: "Incline Press", muscleGroup: "chest", order: 0)
        context.insert(e1)
        context.insert(e0)
        session.exercises.append(e1)
        session.exercises.append(e0)

        let ordered = session.orderedExercises
        #expect(ordered.first?.order == 0)
        #expect(ordered.last?.order == 1)
    }

    @Test func totalSetsCountsAllSets() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let session = WorkoutSession(name: "Back")
        context.insert(session)

        let entry = ExerciseEntry(exerciseName: "Deadlift", muscleGroup: "back", order: 0)
        context.insert(entry)
        session.exercises.append(entry)

        let s1 = SetRecord(order: 0, weightKg: 100, reps: 5)
        let s2 = SetRecord(order: 1, weightKg: 110, reps: 3)
        context.insert(s1)
        context.insert(s2)
        entry.sets.append(s1)
        entry.sets.append(s2)

        #expect(session.totalSets == 2)
    }
}

// MARK: - ExerciseLibrary Tests

struct ExerciseLibraryTests {

    @Test func allExercisesHaveNames() {
        #expect(ExerciseLibrary.all.allSatisfy { !$0.name.isEmpty })
    }

    @Test func exerciseNamesAreUnique() {
        let names = ExerciseLibrary.all.map { $0.name }
        #expect(Set(names).count == names.count)
    }

    @Test func searchReturnsMatchingExercises() {
        let results = ExerciseLibrary.search("bench")
        #expect(!results.isEmpty)
        #expect(results.allSatisfy { $0.matches(query: "bench") })
    }

    @Test func emptySearchReturnsAll() {
        let results = ExerciseLibrary.search("")
        #expect(results.count == ExerciseLibrary.all.count)
    }

    @Test func filterByMuscleGroup() {
        let chestExercises = ExerciseLibrary.exercises(for: .chest)
        #expect(chestExercises.allSatisfy { $0.muscleGroup == .chest })
    }
}

// MARK: - SessionListViewModel Tests

struct SessionListViewModelTests {

    @Test func startNewSessionAppearsInList() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let vm = SessionListViewModel(modelContext: context)

        vm.newSessionName = "Leg Day"
        vm.startNewSession()

        #expect(vm.sessions.count == 1)
        #expect(vm.sessions.first?.name == "Leg Day")
    }

    @Test func startNewSessionSetsActiveSession() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let vm = SessionListViewModel(modelContext: context)

        vm.newSessionName = "Pull Day"
        vm.startNewSession()

        #expect(vm.activeSession != nil)
        #expect(vm.activeSession?.isActive == true)
    }

    @Test func finishSessionClearsActiveSession() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let vm = SessionListViewModel(modelContext: context)

        vm.newSessionName = "Push Day"
        vm.startNewSession()

        let session = try #require(vm.activeSession)
        vm.finishSession(session)

        #expect(vm.activeSession == nil)
        #expect(vm.sessions.first?.isActive == false)
    }

    @Test func deleteSessionRemovesFromList() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let vm = SessionListViewModel(modelContext: context)

        vm.newSessionName = "Chest Day"
        vm.startNewSession()
        let session = try #require(vm.sessions.first)
        vm.deleteSession(session)

        #expect(vm.sessions.isEmpty)
    }

    @Test func blankNameDoesNotCreateSession() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let vm = SessionListViewModel(modelContext: context)

        vm.newSessionName = "   "
        vm.startNewSession()

        #expect(vm.sessions.isEmpty)
    }
}

// MARK: - ActiveWorkoutViewModel Tests

struct ActiveWorkoutViewModelTests {

    private func makeSession(in context: ModelContext) -> WorkoutSession {
        let session = WorkoutSession(name: "Test")
        context.insert(session)
        return session
    }

    @Test func addExerciseAppearsInSession() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let session = makeSession(in: context)
        let vm = ActiveWorkoutViewModel(session: session, modelContext: context)

        let exercise = Exercise(name: "Squat", muscleGroup: .legs)
        vm.addExercise(exercise)

        #expect(session.exercises.count == 1)
        #expect(session.exercises.first?.exerciseName == "Squat")
    }

    @Test func addSetIncreasesSetCount() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let session = makeSession(in: context)
        let vm = ActiveWorkoutViewModel(session: session, modelContext: context)

        vm.addExercise(Exercise(name: "Bench Press", muscleGroup: .chest))
        let entry = try #require(session.exercises.first)
        vm.addSet(to: entry)
        vm.addSet(to: entry)

        #expect(entry.sets.count == 2)
    }

    @Test func lastPerformanceExcludesCurrentSession() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        // Create a finished past session with Bench Press
        let pastSession = WorkoutSession(name: "Chest")
        pastSession.finishedAt = Date().addingTimeInterval(-86400)
        context.insert(pastSession)
        let pastEntry = ExerciseEntry(exerciseName: "Bench Press", muscleGroup: "chest", order: 0)
        context.insert(pastEntry)
        pastSession.exercises.append(pastEntry)
        let pastSet = SetRecord(order: 0, weightKg: 80, reps: 8)
        context.insert(pastSet)
        pastEntry.sets.append(pastSet)
        try context.save()

        // Create new active session
        let currentSession = makeSession(in: context)
        let vm = ActiveWorkoutViewModel(session: currentSession, modelContext: context)
        vm.addExercise(Exercise(name: "Bench Press", muscleGroup: .chest))

        vm.fetchLastPerformance(for: "Bench Press")
        let last = vm.lastPerformances["Bench Press"]

        #expect(last != nil)
        #expect(last?.session?.id == pastSession.id)
    }

    @Test func finishWorkoutSetsFinishedAt() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let session = makeSession(in: context)
        let vm = ActiveWorkoutViewModel(session: session, modelContext: context)

        vm.finishWorkout()

        #expect(session.finishedAt != nil)
        #expect(session.isActive == false)
    }
}

// MARK: - ExerciseLibraryViewModel Tests

struct ExerciseLibraryViewModelTests {

    @Test @MainActor func filterByMuscleGroupShowsOnlyThatGroup() {
        let vm = ExerciseLibraryViewModel()
        vm.selectedMuscleGroup = .chest
        #expect(vm.filteredExercises.allSatisfy { $0.muscleGroup == .chest })
    }

    @Test @MainActor func searchFiltersCorrectly() {
        let vm = ExerciseLibraryViewModel()
        vm.searchText = "squat"
        #expect(!vm.filteredExercises.isEmpty)
        #expect(vm.filteredExercises.allSatisfy { $0.matches(query: "squat") })
    }

    @Test @MainActor func noFilterReturnsAll() {
        let vm = ExerciseLibraryViewModel()
        #expect(vm.filteredExercises.count == ExerciseLibrary.all.count)
    }
}
