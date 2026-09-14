import SwiftUI

/// The app's main shell after the splash: Home, Leaderboard and Profile tabs,
/// each with its own navigation stack.
struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack { LeaderboardView() }
                .tabItem { Label("Ranks", systemImage: "trophy.fill") }

            NavigationStack { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(Brand.coral)
    }
}

#Preview {
    MainTabView()
        .environment(GameStore())
}
