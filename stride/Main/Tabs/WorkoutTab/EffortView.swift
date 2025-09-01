import SwiftUI

struct EffortView: View {
    @Binding var effortLevel: Float
    @Binding var isPlanned: Bool

    @State private var showSheet: Bool = false

    var body: some View {
        if !isPlanned {
            Text("Effort").foregroundColor(Color.gray).bold()
            Button(
                action: { showSheet = true },
                label: {
                    HStack {
                        Image(systemName: "dial.medium").resizable()
                            .frame(width: 25, height: 25)
                        Text("\(effortLevel, specifier: "%.0f")").padding(.bottom, -2)
                        Spacer()
                        Image(systemName: "chevron.down").resizable()
                            .frame(width: 15, height: 10)
                    }
                }
            ).foregroundStyle(.primary)
                .sheet(isPresented: $showSheet) {
                    VStack(alignment: .leading) {
                        SheetRectangle()
                        Group {
                            Text("Preceived Effort Level").font(
                                .system(
                                    size: 18,
                                    weight: .bold,
                                    design: .default
                                )
                            )
                            if !isPlanned {
                                Text("\(effortLevel, specifier: "%.0f")")
                            }
                        }.padding(.leading, 20)
                        Divider()
                        VStack(alignment: .center) {
                            Slider(
                                value: $effortLevel,
                                in: 0 ... 10,
                                step: 1,
                                label: {}
                            ).accentColor(.orange).frame(
                                width: UIScreen.width * 0.90,
                                alignment: .center
                            )
                            HStack {
                                Text("Easy").padding(.leading, 25)
                                Spacer()
                                Text("Moderate")
                                Spacer()
                                Text("Hard").padding(.trailing, 25)
                            }
                        }

                    }.presentationDetents([.height(200)])
                }.addBorder(OrangeTheme.opacity(0.3), cornerRadius: 5, padding: .all(10))
        }
    }
}
