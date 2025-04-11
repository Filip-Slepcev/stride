import SwiftUI

struct AppView: View {
    @StateObject private var activeUser = ActiveUser()
    @State private var isLoading: Bool = true

    var body: some View {
        ZStack {
            Group {
                if activeUser.loggedIn {
                    MainTabView()
                        .environmentObject(activeUser)
                        .transition(.move(edge: .trailing))
                } else {
                    if !isLoading { AuthView()
                        .transition(.move(edge: .leading))
                    }
                }
            }
            .animation(.easeInOut, value: activeUser.loggedIn)
        }
        .task {
            for await state in supabase.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(
                    state.event
                ) {
                    if state.session != nil {
                        await activeUser.initProfile(
                            userId: state.session!.user.id
                        )
                    }
                }
            }
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

@main
struct striveApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
