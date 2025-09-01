import Foundation

enum TypeOfWorkout: String, CaseIterable, Identifiable, Codable {
    case RUN
    case BIKE
    case SWIM
    var id: String { rawValue }
}

struct WorkoutType {
    var title: String
    var description: String
    var dateSet: Date
    var duration: Float // Seconds
    var distance: Float // kilometers
    var effortLevel: Int
    var typeOfWorkout: TypeOfWorkout
    var isPlanned: Bool

    enum CodingKeys: String, CodingKey {
        case title
        case duration
        case distance
        case description
        case isPlanned = "is_planned"
        case typeOfWorkout = "type"
        case effortLevel = "effort_level"
        case dateSet = "date_set"
    }
}

enum WorkoutModel {
    static func createWorkout(workout: InsertWorkoutType) async {
        await WorkoutService.createWorkout(workout: workout)
    }
}
