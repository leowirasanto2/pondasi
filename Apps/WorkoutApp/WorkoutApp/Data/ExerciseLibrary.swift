import Foundation

enum ExerciseLibrary {
    static let all: [Exercise] = [
        // MARK: Chest
        Exercise(name: "Bench Press", muscleGroup: .chest, alternativeNames: ["Flat Bench"]),
        Exercise(name: "Incline Bench Press", muscleGroup: .chest, alternativeNames: ["Incline Bench"]),
        Exercise(name: "Decline Bench Press", muscleGroup: .chest, alternativeNames: ["Decline Bench"]),
        Exercise(name: "Dumbbell Fly", muscleGroup: .chest, alternativeNames: ["Chest Fly", "DB Fly"]),
        Exercise(name: "Cable Fly", muscleGroup: .chest, alternativeNames: ["Cable Crossover"]),
        Exercise(name: "Push-Up", muscleGroup: .chest, alternativeNames: ["Pushup"]),
        Exercise(name: "Dip", muscleGroup: .chest, alternativeNames: ["Chest Dip"]),
        Exercise(name: "Pec Deck", muscleGroup: .chest, alternativeNames: ["Machine Fly"]),

        // MARK: Back
        Exercise(name: "Deadlift", muscleGroup: .back, alternativeNames: ["Conventional Deadlift"]),
        Exercise(name: "Pull-Up", muscleGroup: .back, alternativeNames: ["Pullup", "Chin-Up"]),
        Exercise(name: "Barbell Row", muscleGroup: .back, alternativeNames: ["Bent-Over Row"]),
        Exercise(name: "Dumbbell Row", muscleGroup: .back, alternativeNames: ["Single-Arm Row", "DB Row"]),
        Exercise(name: "Lat Pulldown", muscleGroup: .back, alternativeNames: ["Cable Pulldown"]),
        Exercise(name: "Seated Cable Row", muscleGroup: .back, alternativeNames: ["Cable Row"]),
        Exercise(name: "T-Bar Row", muscleGroup: .back),
        Exercise(name: "Face Pull", muscleGroup: .back),

        // MARK: Shoulders
        Exercise(name: "Overhead Press", muscleGroup: .shoulders, alternativeNames: ["OHP", "Military Press", "Barbell Press"]),
        Exercise(name: "Dumbbell Shoulder Press", muscleGroup: .shoulders, alternativeNames: ["DB Press"]),
        Exercise(name: "Lateral Raise", muscleGroup: .shoulders, alternativeNames: ["Side Raise"]),
        Exercise(name: "Front Raise", muscleGroup: .shoulders),
        Exercise(name: "Rear Delt Fly", muscleGroup: .shoulders, alternativeNames: ["Reverse Fly", "Bent-Over Lateral"]),
        Exercise(name: "Arnold Press", muscleGroup: .shoulders),
        Exercise(name: "Upright Row", muscleGroup: .shoulders),

        // MARK: Biceps
        Exercise(name: "Barbell Curl", muscleGroup: .biceps, alternativeNames: ["BB Curl"]),
        Exercise(name: "Dumbbell Curl", muscleGroup: .biceps, alternativeNames: ["DB Curl", "Alternating Curl"]),
        Exercise(name: "Hammer Curl", muscleGroup: .biceps),
        Exercise(name: "Preacher Curl", muscleGroup: .biceps, alternativeNames: ["Scott Curl"]),
        Exercise(name: "Cable Curl", muscleGroup: .biceps),
        Exercise(name: "Incline Dumbbell Curl", muscleGroup: .biceps),
        Exercise(name: "Concentration Curl", muscleGroup: .biceps),

        // MARK: Triceps
        Exercise(name: "Tricep Pushdown", muscleGroup: .triceps, alternativeNames: ["Cable Pushdown"]),
        Exercise(name: "Skull Crusher", muscleGroup: .triceps, alternativeNames: ["EZ Bar Skull Crusher", "Lying Tricep Extension"]),
        Exercise(name: "Close-Grip Bench Press", muscleGroup: .triceps, alternativeNames: ["CGBP"]),
        Exercise(name: "Overhead Tricep Extension", muscleGroup: .triceps, alternativeNames: ["French Press"]),
        Exercise(name: "Tricep Dip", muscleGroup: .triceps, alternativeNames: ["Bench Dip"]),
        Exercise(name: "Kickback", muscleGroup: .triceps, alternativeNames: ["Tricep Kickback"]),

        // MARK: Legs
        Exercise(name: "Squat", muscleGroup: .legs, alternativeNames: ["Back Squat", "Barbell Squat"]),
        Exercise(name: "Front Squat", muscleGroup: .legs),
        Exercise(name: "Romanian Deadlift", muscleGroup: .legs, alternativeNames: ["RDL"]),
        Exercise(name: "Leg Press", muscleGroup: .legs),
        Exercise(name: "Leg Curl", muscleGroup: .legs, alternativeNames: ["Hamstring Curl", "Lying Leg Curl"]),
        Exercise(name: "Leg Extension", muscleGroup: .legs),
        Exercise(name: "Lunge", muscleGroup: .legs, alternativeNames: ["Walking Lunge", "Forward Lunge"]),
        Exercise(name: "Bulgarian Split Squat", muscleGroup: .legs, alternativeNames: ["Split Squat"]),
        Exercise(name: "Calf Raise", muscleGroup: .legs, alternativeNames: ["Standing Calf Raise"]),
        Exercise(name: "Hip Thrust", muscleGroup: .legs, alternativeNames: ["Barbell Hip Thrust"]),
        Exercise(name: "Sumo Deadlift", muscleGroup: .legs),
        Exercise(name: "Hack Squat", muscleGroup: .legs),
        Exercise(name: "Step-Up", muscleGroup: .legs),

        // MARK: Core
        Exercise(name: "Plank", muscleGroup: .core),
        Exercise(name: "Crunch", muscleGroup: .core, alternativeNames: ["Sit-Up"]),
        Exercise(name: "Hanging Leg Raise", muscleGroup: .core, alternativeNames: ["HLR"]),
        Exercise(name: "Ab Rollout", muscleGroup: .core, alternativeNames: ["Ab Wheel"]),
        Exercise(name: "Cable Crunch", muscleGroup: .core),
        Exercise(name: "Russian Twist", muscleGroup: .core),
        Exercise(name: "Side Plank", muscleGroup: .core),

        // MARK: Full Body
        Exercise(name: "Power Clean", muscleGroup: .fullBody),
        Exercise(name: "Burpee", muscleGroup: .fullBody),
        Exercise(name: "Kettlebell Swing", muscleGroup: .fullBody),
        Exercise(name: "Thruster", muscleGroup: .fullBody),
        Exercise(name: "Clean and Press", muscleGroup: .fullBody),
    ]

    static func exercises(for muscleGroup: MuscleGroup) -> [Exercise] {
        all.filter { $0.muscleGroup == muscleGroup }
    }

    static func search(_ query: String) -> [Exercise] {
        all.filter { $0.matches(query: query) }
    }
}
