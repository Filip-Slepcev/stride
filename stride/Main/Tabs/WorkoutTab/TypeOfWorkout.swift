import SwiftUI

struct WorkoutTypeView: View {
    @Binding var typeOfWorkout: TypeOfWorkout

    @State private var showSheet: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Workout Type").foregroundColor(Color.gray).bold()
            Button(
                action: {
                    showSheet = true
                },
                label: {
                    HStack {
                        Image(systemName: typeOfWorkout == TypeOfWorkout.BIKE ? "bicycle" : typeOfWorkout == TypeOfWorkout.RUN ? "figure.run" : "figure.pool.swim").resizable()
                            .frame(width: 25, height: 25)
                        Text("\(typeOfWorkout)").padding(.bottom, -2)
                        Spacer()
                        Image(systemName: "chevron.down").resizable()
                            .frame(width: 15, height: 10)
                    }
                }
            ).foregroundStyle(.primary)
                .sheet(isPresented: $showSheet) {
                    VStack(alignment: .leading) {
                        SheetRectangle()
                        Picker(selection: $typeOfWorkout, label: Text("Picker")) {
                            ForEach(TypeOfWorkout.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.wheel)
                    }.presentationDetents([.height(200)])
                }.addBorder(OrangeTheme.opacity(0.3), cornerRadius: 5, padding: .all(10))
        }
    }
}
