import SwiftUI

final class FormModel: ObservableObject {
    @Published var workout: InsertWorkoutType = .init()
    @Published var dateRange: ClosedRange<Date> = Date.distantPast ... Date.now

    var isValid: Bool {
        !self.workout.title.isEmpty && !self.workout.description.isEmpty && self.workout.duration >= 0 && self.workout.distance >= 0 && self.workout.effortLevel >= 0
    }

    var buttonDisabled: Bool { !self.isValid }

    func buttonPressed() {
        Task {
            await WorkoutModel.createWorkout(workout: self.workout)
        }
    }
}

struct WorkoutView: View {
    @EnvironmentObject private var activeUser: ActiveUser
    @StateObject private var form: FormModel = .init()
    let isPlanned: Bool

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Color.white.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Date").foregroundColor(Color.gray).bold()
                    DatePicker("", selection: self.$form.workout.dateSet, in: self.form.dateRange, displayedComponents: .date).labelsHidden().padding([.top], -5)

                    Text("Title").foregroundColor(Color.gray).bold()
                    TextField("Workout Title", text: self.$form.workout.title).addBorder(OrangeTheme.opacity(0.3), cornerRadius: 5, padding: .all(10))

                    Text("Description").foregroundColor(Color.gray).bold()
                    TextField(
                        "Description",
                        text: self.$form.workout.description,
                        axis: .vertical
                    ).frame(minHeight: 75, alignment: .top)
                        .multilineTextAlignment(.leading).addBorder(OrangeTheme.opacity(0.3), cornerRadius: 5, padding: .all(10))

                    WorkoutTypeView(typeOfWorkout: self.$form.workout.typeOfWorkout)

                    MetricsView(duration: self.$form.workout.duration, distance: self.$form.workout.distance)

                    EffortView(effortLevel: self.$form.workout.effortLevel, isPlanned: self.$form.workout.isPlanned)

                    IsPlannedView(isPlanned: self.$form.workout.isPlanned, dateRange: self.$form.dateRange, date: self.$form.workout.dateSet)

                    Spacer()
                }
            }
            .padding([.leading, .trailing], 50)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(self.form.workout.isPlanned ? "Plan" : "Record") Your Workout")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: self.form.buttonPressed) { Text("Submit").bold() }.frame(width: 200, height: 40).foregroundColor(.white).background(self.form.buttonDisabled ? .gray.opacity(0.25) : OrangeTheme).cornerRadius(5).disabled(self.form.buttonDisabled)
                }
            }
        }
    }
}

#Preview {
    WorkoutView(isPlanned: false)
}
