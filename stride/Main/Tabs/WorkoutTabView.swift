// import SwiftUI
//
//
// struct WorkoutTabView: View {
//    @State private var contentHeight: CGFloat = 0
//    @State private var showsSheet = false
//    @State private var fontSize: CGFloat = 50
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Button {
//                showsSheet = true
//            } label: {
//                Image(systemName: "plus.square")
//            }
//            .buttonStyle(.bordered)
//
//        }
//        .padding()
//        .sheet(isPresented: $showsSheet) {
//            VStack {
//                Text("As you can see this sheet is dynamically sized to fit this content.")
//                    .fixedSize(horizontal: false, vertical: true)
//                    .padding()
//                    .font(.system(size: fontSize))
//
//            }
//            .onGeometryChange(for: CGSize.self) { proxy in
//                proxy.size
//            } action: {
//                self.contentHeight = $0.height
//            }
//            .presentationDetents([.height(contentHeight)])
//
//        }
//    }
// }
//
// #Preview {
//    WorkoutTabView()
// }
