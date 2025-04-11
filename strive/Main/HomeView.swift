import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userSettings: ActiveUser
    @State var showAnimation1: Bool = false
    @State var showAnimation2: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, \(userSettings.fullName ?? "User")").opacity(
                    showAnimation1 ? 1 : 0
                )
                .font(.system(size: 40))
                .padding(.vertical, 40)
                Text("Welcome to the app!").opacity(showAnimation2 ? 1 : 0)
                    .font(.system(size: 40))

            }
            .padding(.bottom, 40)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        AvatarIconView(avatarImage: userSettings.avatarImage)
                    }
                }
            }
            .padding()
        }.onAppear(perform: {
            withAnimation(.smooth(duration: 4)) {
                showAnimation1.toggle()
            }
            withAnimation(.smooth(duration: 4).delay(1)) {
                showAnimation2.toggle()
            }
        })
    }
}
