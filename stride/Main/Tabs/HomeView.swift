import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var activeUser: ActiveUser

    var body: some View {
        VStack {
            Image(systemName: "figure.run.square.stack").resizable().frame(width: 200, height: 200)
        }.navigationTitle("Home")
            .padding(.bottom, 40)
    }
}
