import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var activeUser: ActiveUser
    @State private var showTabs: Bool = false
    @State private var showWelcome: Bool = false

    var body: some View {
        ZStack {
            if showWelcome {
                VStack(spacing: 20) {
                    Text("Welcome Back")
                        .font(.system(size: 40))
                        .transition(.opacity)
                        .bold()
                    Text(activeUser.fullName ?? "User")
                        .font(.system(size: 40))
                        .transition(.opacity)
                        .bold()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeOut(duration: 4)) {
                            showWelcome = false
                            showTabs = true
                        }
                    }
                }
            }

            if showTabs {
                TabView {
                    Tab("Home", systemImage: "house") {
                        HomeView()
                            .environmentObject(activeUser)
                    }
                    Tab("Record Workout", systemImage: "plus.square") {}
                    Tab("Profile", systemImage: "person") {
                        ProfileView()
                            .environmentObject(activeUser)
                    }
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 2)) {
                showWelcome = true
            }
        }
        .animation(.easeInOut, value: showTabs)
    }
}
