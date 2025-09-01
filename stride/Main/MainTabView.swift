import SwiftUI

private struct LoadingView: View {
    var loadingOpacity: Double
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .opacity(loadingOpacity)
            .ignoresSafeArea()
    }
}

private struct WelcomeView: View {
    var name: String

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Welcome Back")
                    .font(.system(size: 40))
                    .transition(.opacity)
                    .bold()
                Text(name)
                    .font(.system(size: 40))
                    .transition(.opacity)
                    .bold()
            }
        }
    }
}

private struct sheetOption: View {
    var color: Color
    var systemName: String
    var title: String

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10).fill(.white).frame(
                width: 175,
                height: 100
            )
            ZStack(alignment: .center) {
                Circle().fill(color).frame(width: 35, height: 35)
                Image(systemName: systemName).resizable().frame(
                    width: 20,
                    height: 20
                ).foregroundColor(.white)

            }.offset(y: 10)
            Text(title).offset(y: 50).foregroundStyle(.black)
        }
    }
}

private struct WorkoutSheetView: View {
    @SwiftUI.Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var activeUser: ActiveUser

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.05).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()

                        NavigationLink(destination: WorkoutView(isPlanned: true).environmentObject(activeUser)) {
                            sheetOption(
                                color: Color.blue.opacity(0.9),
                                systemName: "pencil",
                                title: "Plan Workout"
                            ).environmentObject(activeUser)
                        }

                        Spacer()

                        NavigationLink(destination: WorkoutView(isPlanned: false).environmentObject(activeUser)) {
                            sheetOption(
                                color: Color.red.opacity(0.9),
                                systemName: "record.circle",
                                title: "Record Workout"
                            )
                        }

                        Spacer()
                    }
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left").resizable().frame(width: 10, height: 20).fontWeight(.semibold).padding(.leading, -5)
                        Text("Back")
                    }
                }
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject private var activeUser: ActiveUser

    @State var showWelcome: Bool
    @State private var loadingOpacity: Double = 1

    @State private var selectedTab: Int = 0
    @State private var showSheet: Bool = false

    var body: some View {
        ZStack {
            TabView {
                Tab("Home", systemImage: "house") {
                    HomeView()
                        .environmentObject(activeUser)
                }
                Tab("", systemImage: "plus.square") {
                    WorkoutSheetView().environmentObject(activeUser)
                }
                Tab("Profile", systemImage: "person") {
                    ProfileView()
                        .environmentObject(activeUser)
                }
            }

            // Welcome Back Cover
            if showWelcome {
                WelcomeView(name: activeUser.username ?? "").transition(
                    .opacity
                )
            }

            // Loading Cover
            LoadingView(loadingOpacity: loadingOpacity)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeIn(duration: 0.1)) {
                    loadingOpacity = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 3)) {
                    showWelcome = false
                }
            }
        }
    }
}

#Preview {
    var activeUser = ActiveUser()
    MainTabView(showWelcome: false).environmentObject(activeUser)
}
