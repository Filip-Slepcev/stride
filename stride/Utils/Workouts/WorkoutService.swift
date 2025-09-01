import Foundation

struct InsertWorkoutType: Encodable {
    var title: String
    var duration: Float // seconds
    var distance: Float // kilometers
    var description: String
    var isPlanned: Bool
    var typeOfWorkout: TypeOfWorkout
    var effortLevel: Float
    var dateSet: Date

    init() {
        self.title = ""
        self.duration = 0
        self.distance = 0
        self.description = ""
        self.isPlanned = false
        self.typeOfWorkout = .RUN
        self.effortLevel = 0
        self.dateSet = Date.now
    }

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

enum WorkoutService {
    static func createWorkout(workout: InsertWorkoutType) async {
        do {
            try await supabase.from("workouts").insert(workout).execute()
        } catch {
            dump("\(error)")
        }
    }
}
