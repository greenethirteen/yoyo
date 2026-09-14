import SwiftUI

/// A lively results header shared by practice and battle results: a trophy in a
/// gradient disc, a headline, and the points earned.
struct CelebrationView: View {
    let title: String
    let subtitle: String
    let pointsEarned: Int
    var symbol: String = "trophy.fill"
    var tint: Color = Brand.coral

    @State private var pop = false

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [tint, tint.opacity(0.65)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 96, height: 96)
                Image(systemName: symbol)
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.white)
            }
            .scaleEffect(pop ? 1 : 0.5)
            .shadow(color: tint.opacity(0.4), radius: 14, y: 8)

            Text(title)
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.ink)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(subtitle)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.6))
                .multilineTextAlignment(.center)

            HStack(spacing: 7) {
                Image(systemName: "bolt.fill")
                Text("+\(pointsEarned) points")
            }
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.72, green: 0.5, blue: 0.0))
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(Color(red: 1.0, green: 0.95, blue: 0.66), in: Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .background(
            LinearGradient(colors: [tint.opacity(0.16), .white], startPoint: .top, endPoint: .bottom),
            in: RoundedRectangle(cornerRadius: 24)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 3)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) { pop = true }
        }
    }
}

#Preview {
    CelebrationView(title: "Congratulations!", subtitle: "You scored 8 / 10", pointsEarned: 100)
        .padding()
}
