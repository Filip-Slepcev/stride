import SwiftUI

struct IsPlannedView: View {
    @Binding var isPlanned: Bool
    @Binding var dateRange: ClosedRange<Date>
    @Binding var date: Date

    @State private var showSheet: Bool = false

    var body: some View {
        Button(action: { showSheet = true }, label: {
            HStack {
                Image(systemName: "\(isPlanned ? "pencil" : "record.circle")").resizable().frame(width: 20, height: 20)
                Text("\(isPlanned ? "Plan Workout" : "Record Workout")")
                Spacer()
                Image(systemName: "chevron.down").resizable()
                    .frame(width: 15, height: 10)
            }
        })
        .sheet(isPresented: $showSheet) {
            VStack(alignment: .leading) {
                SheetRectangle()

                Text("Workout Type").font(
                    .system(
                        size: 18,
                        weight: .bold,
                        design: .default
                    )
                ).padding(.top, -20)
                    .padding(.leading, 20)
                Divider()
                VStack(alignment: .leading, spacing: 30) {
                    Button(action: { isPlanned = true
                        dateRange = Date.now ... Date.distantFuture
                        date = Date.now
                    }, label: {
                        HStack {
                            Image(systemName: "pencil").resizable().frame(width: 20, height: 20)
                            Text("Planned Workout")
                            Spacer()
                            SelectedCircle(isSelected: isPlanned)
                        }
                    })
                    Button(action: { isPlanned = false
                        dateRange = Date.distantPast ... Date.now
                        date = Date.now
                    }, label: {
                        HStack {
                            Image(systemName: "record.circle").resizable().frame(width: 20, height: 20)
                            Text("Recorded Workout")
                            Spacer()
                            SelectedCircle(isSelected: !isPlanned)
                        }
                    })
                }.padding([.top, .leading], 20)
            }.presentationDetents([.height(200)])
        }
        .addBorder(OrangeTheme.opacity(0.3), cornerRadius: 5, padding: .all(10))
        .foregroundStyle(.primary)
    }
}
