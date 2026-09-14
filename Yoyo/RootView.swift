import SwiftUI

/// App entry point: shows the splash screen briefly, then crossfades to the
/// main tab shell. Owns the shared `GameStore`.
struct RootView: View {
    @State private var showingSplash = true
    @State private var game = GameStore()

    var body: some View {
        ZStack {
            if showingSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .environment(game)
        .task {
            game.refreshStreak()
            try? await Task.sleep(for: .seconds(1.8))
            withAnimation(.easeInOut(duration: 0.55)) {
                showingSplash = false
            }
        }
    }
}

#Preview {
    RootView()
}
