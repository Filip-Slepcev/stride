import SwiftUI

private struct sheetOption: View {
    var color: Color
    var systemName: String
    var title: String

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10).fill(.white).frame(width: 175, height: 100)
            ZStack(alignment: .center) {
                Circle().fill(color).frame(width: 35, height: 35)
                Image(systemName: systemName).resizable().frame(width: 20, height: 20).foregroundColor(.white)

            }.offset(y: 10)
            Text(title).offset(y: 50)
        }
    }
}

private struct WorkoutSheetView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.03).edgesIgnoringSafeArea(.all)
            VStack {
                RoundedRectangle(cornerRadius: 25).fill(.black.opacity(0.1)).frame(
                    width: UIScreen.width / 3,
                    height: 5
                ).padding(.top, 5)
                Spacer()
                HStack {
                    Spacer()
                    sheetOption(color: Color.blue.opacity(0.7), systemName: "pencil", title: "Plan Workout")
                    Spacer()
                    sheetOption(color: Color.red.opacity(0.7), systemName: "record.circle", title: "Record Workout")
                    Spacer()
                }
                Spacer()
            }

        }.presentationDetents([.height(200)])
    }
}

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

struct MainTabView: View {
    @EnvironmentObject private var activeUser: ActiveUser
    @State var showWelcome: Bool
    @State var loadingOpacity: Double = 1
    @State var selectedTab: Int = 0
    @State var showSheet: Bool = false

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .environmentObject(activeUser).tabItem {
                        Image(systemName: "house")
                    }.tag(0)
                Color.clear.tabItem {
                    Image(systemName: "plus.square").resizable().frame(width: 50, height: 50)
                }.tag(1)
                ProfileView()
                    .environmentObject(activeUser).tabItem {
                        Image(systemName: "person")
                    }.tag(2)
            }.onChange(of: selectedTab) { oldState, newState in
                if newState == 1 {
                    selectedTab = oldState
                    showSheet = true
                }
            }.sheet(isPresented: $showSheet) {
                WorkoutSheetView()
            }.onAppear { UITabBar.appearance().unselectedItemTintColor = UIColor(Color.black) }

            if showWelcome {
                WelcomeView(name: activeUser.username ?? "").transition(
                    .opacity
                )
            }

            // Loading cover
            LoadingView(loadingOpacity: loadingOpacity)

        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
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
