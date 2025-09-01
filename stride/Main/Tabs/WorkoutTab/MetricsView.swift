import SwiftUI

struct MetricsView: View {
    @Binding var duration: Float
    @Binding var distance: Float

    @State private var pace: String = "0:00"
    @State private var speed: String = "0:00"

    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0

    @State private var durationFormat: String = "00:00:00"
    @State private var showSheet: Bool = false

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                VStack {
                    Text("Distance (km)").foregroundColor(Color.gray).bold()
                    TextField("Distance (km)", value: $distance, format: .number,).onSubmit {
                        if duration > 0 {
                            calcPace()
                        }
                    }.frame(width: 100).addBorder(OrangeTheme.opacity(0.3), cornerRadius: 5, padding: .all(10)).multilineTextAlignment(.center).bold()
                }
                VStack {
                    Text("Duration").foregroundColor(Color.gray).bold()
                    Button(action: { showSheet = true },
                           label: {
                               Text(durationFormat).frame(width: 100).addBorder(OrangeTheme.opacity(0.3), cornerRadius: 5, padding: .all(10)).bold().foregroundColor(.black)
                           }).sheet(isPresented: $showSheet, onDismiss: didDismiss) {
                        VStack {
                            Spacer()
                            SheetRectangle()
                            HStack(spacing: 0) {
                                HStack {
                                    Picker(selection: $hours, label: Text("Picker")) {
                                        ForEach(0 ..< 100) { index in
                                            Text("\(index)").tag(index)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .padding(.trailing, -20)
                                    .clipped()
                                    .padding(.trailing, -4)

                                    Text("hour").font(.system(size: 22)).padding(.leading, -40)
                                }
                                HStack {
                                    Picker(selection: $minutes, label: Text("Picker")) {
                                        ForEach(0 ..< 60) { index in
                                            Text("\(index)").tag(index)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .padding(.horizontal, -20)
                                    .clipped()
                                    .padding(.horizontal, -8)

                                    Text("min").font(.system(size: 22)).padding(.leading, -50)
                                }
                                HStack {
                                    Picker(selection: $seconds, label: Text("Picker")) {
                                        ForEach(0 ..< 60) { index in
                                            Text("\(index)").tag(index)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .padding(.leading, -20)
                                    .clipped()

                                    Text("sec").font(.system(size: 22)).padding(.leading, -50)
                                }
                            }.frame(height: 125).padding(.bottom, 30)
                        }.presentationDetents([.height(200)])
                    }
                }
            }
            HStack(alignment: .center) {
                Spacer()
                VStack {
                    Text("Avg Pace").foregroundColor(Color.gray).bold()
                    Text("\(pace) / km").bold().frame(width: 100).addBorder(Color.gray.opacity(0), cornerRadius: 5, padding: .all(10))
                }
                VStack {
                    Text("Avg Speed").foregroundColor(Color.gray).bold()
                    Text("\(speed) km/h").bold().frame(width: 100).addBorder(Color.gray.opacity(0), cornerRadius: 5, padding: .all(10))
                }
                Spacer()
            }
        }
    }

    func didDismiss() {
        durationFormat = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        duration = Float(hours * 3600 + minutes * 60 + seconds)
        if distance > 0 {
            calcPace()
        }
    }

    func calcPace() {
        let kmPace = (duration / 60) / distance
        pace = String(format: "%.0f:%02.0f", kmPace, (kmPace - kmPace.rounded(.down)) * 60)
        speed = String(format: "%.0f:%02.0f", distance / (duration / 3600))
    }
}
