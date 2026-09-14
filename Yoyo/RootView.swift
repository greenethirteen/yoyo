import SwiftUI

/// App entry point: shows the splash screen briefly, then crossfades to the
/// Home screen inside a navigation stack.
struct RootView: View {
    @State private var showingSplash = true

    var body: some View {
        ZStack {
            if showingSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                NavigationStack { HomeView() }
                    .transition(.opacity)
            }
        }
        .task {
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
