import SwiftUI

struct AppView: View {
    @StateObject private var activeUser = ActiveUser()

    var body: some View {
        Group {
            if activeUser.loggedIn {
                HomeView()
                    .environmentObject(activeUser)
            } else {
                AuthView()
            }
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
