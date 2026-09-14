import SwiftUI

/// Brief launch screen: the yoyo mark spins in and the wordmark fades up.
struct SplashView: View {
    @State private var appeared = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Brand.cream, Brand.coral.opacity(0.20)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                YoyoLogo(size: 104)
                    .scaleEffect(appeared ? 1 : 0.55)
                    .rotationEffect(.degrees(appeared ? 0 : -140))

                Text("Yoyo")
                    .font(.system(size: 46, weight: .heavy, design: .rounded))
                    .foregroundStyle(Brand.ink)
                    .opacity(appeared ? 1 : 0)

                Text("Master every past paper")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.ink.opacity(0.55))
                    .opacity(appeared ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                appeared = true
            }
        }
    }
}

#Preview {
    SplashView()
}
