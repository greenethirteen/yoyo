import SwiftUI

@main
struct YoyoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

/// App entry point: shows the splash screen briefly, then crossfades to the
/// question paper.
struct RootView: View {
    @State private var showingSplash = true

    var body: some View {
        ZStack {
            if showingSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                StudyPaperView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1.9))
            withAnimation(.easeInOut(duration: 0.5)) {
                showingSplash = false
            }
        }
    }
}

/// Minimal launch screen: the yoyo mark drops on its string and spins, then the
/// wordmark and slogan fade up.
struct SplashView: View {
    @State private var dropped = false
    @State private var appeared = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Brand.cream, Brand.coral.opacity(0.16)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                // Yoyo on a string: the string extends as the disc drops and spins.
                VStack(spacing: 0) {
                    Circle()
                        .fill(Brand.ink.opacity(0.3))
                        .frame(width: 5, height: 5)
                    Capsule()
                        .fill(Brand.ink.opacity(0.2))
                        .frame(width: 2, height: dropped ? 48 : 8)
                    YoyoLogo(size: 96)
                        .rotationEffect(.degrees(dropped ? 720 : 0))
                }

                VStack(spacing: 8) {
                    Text("Yoyo")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundStyle(Brand.ink)
                    Text("Learning through repetition")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Brand.ink.opacity(0.5))
                }
                .opacity(appeared ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1)) { dropped = true }
            withAnimation(.easeIn(duration: 0.6).delay(0.35)) { appeared = true }
        }
    }
}
