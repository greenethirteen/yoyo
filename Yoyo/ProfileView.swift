import SwiftUI

/// The player's stats dashboard: level, points, accuracy & win-rate rings, and
/// per-subject performance bars.
struct ProfileView: View {
    @Environment(GameStore.self) private var game

    private var hasData: Bool { game.stats.quizzesPlayed > 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                ringsRow
                subjectPerformance
            }
            .frame(maxWidth: 720)
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity)
        }
        .background(
            LinearGradient(colors: [Brand.cream, Color(red: 0.955, green: 0.95, blue: 0.94)],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .toolbar(.hidden, for: .navigationBar)
    }

    private var headerCard: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Brand.coral, Brand.peach],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                Image(systemName: "face.smiling.inverse")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 84, height: 84)
            .shadow(color: Brand.coral.opacity(0.35), radius: 10, y: 5)

            Text("You")
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.ink)

            HStack(spacing: 10) {
                Label("Level \(game.level)", systemImage: "star.fill")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.coral)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Brand.coral.opacity(0.14), in: Capsule())
                Label("\(game.points)", systemImage: "bolt.fill")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.72, green: 0.5, blue: 0.0))
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Color(red: 1.0, green: 0.95, blue: 0.66), in: Capsule())
                Label("\(game.stats.streakDays)d", systemImage: "flame.fill")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.peach)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Brand.peach.opacity(0.16), in: Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(26)
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 3)
    }

    private var ringsRow: some View {
        HStack(spacing: 16) {
            StatCard(title: "Correct meter") {
                SegmentedRing(segments: [
                    (Double(game.stats.correct), .green),
                    (Double(game.stats.wrong), .red),
                    (Double(game.stats.skipped), Color.gray.opacity(0.5))
                ]) {
                    VStack(spacing: 2) {
                        Text("\(Int((game.accuracy * 100).rounded()))%")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundStyle(Brand.ink)
                        Text("correct")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundStyle(Brand.ink.opacity(0.5))
                    }
                }
                legend
            }
            StatCard(title: "Win rate") {
                SegmentedRing(segments: [
                    (Double(game.stats.wins), Brand.mint),
                    (Double(game.stats.losses), Color.gray.opacity(0.5))
                ]) {
                    VStack(spacing: 2) {
                        Text("\(Int((game.winRate * 100).rounded()))%")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundStyle(Brand.ink)
                        Text("\(game.gamesPlayed) games")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundStyle(Brand.ink.opacity(0.5))
                    }
                }
                HStack(spacing: 12) {
                    legendDot(Brand.mint, "\(game.stats.wins) won")
                    legendDot(Color.gray.opacity(0.5), "\(game.stats.losses) lost")
                }
            }
        }
    }

    private var legend: some View {
        HStack(spacing: 10) {
            legendDot(.green, "\(game.stats.correct)")
            legendDot(.red, "\(game.stats.wrong)")
            legendDot(Color.gray.opacity(0.5), "\(game.stats.skipped)")
        }
    }

    private func legendDot(_ color: Color, _ text: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.6))
        }
    }

    private var subjectPerformance: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Subject performance")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.ink)

            if game.stats.perSubject.isEmpty {
                Text("Play a quiz to start tracking your performance across subjects.")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(Brand.ink.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                ForEach(game.stats.perSubject.sorted(by: { $0.key < $1.key }), id: \.key) { subject, stat in
                    SubjectBar(name: subject, correct: stat.correct, total: stat.total)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(.white, in: RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 3)
    }
}

private struct StatCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.55))
            content
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(.white, in: RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 3)
    }
}

/// A ring split into coloured segments. Falls back to the track when empty.
struct SegmentedRing<Center: View>: View {
    let segments: [(Double, Color)]
    var lineWidth: CGFloat = 14
    @ViewBuilder let center: Center

    private var total: Double { max(segments.reduce(0) { $0 + $1.0 }, 1) }

    private var starts: [Double] {
        var running = 0.0
        return segments.map { segment in
            defer { running += segment.0 }
            return running
        }
    }

    var body: some View {
        ZStack {
            Circle().stroke(Brand.ink.opacity(0.07), lineWidth: lineWidth)
            ForEach(Array(segments.enumerated()), id: \.offset) { index, segment in
                Circle()
                    .trim(from: starts[index] / total, to: (starts[index] + segment.0) / total)
                    .stroke(segment.1, style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
                    .rotationEffect(.degrees(-90))
            }
            center
        }
        .frame(width: 120, height: 120)
    }
}

private struct SubjectBar: View {
    let name: String
    let correct: Int
    let total: Int

    private var fraction: Double { total == 0 ? 0 : Double(correct) / Double(total) }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(name)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.ink)
                Spacer()
                Text("\(correct)/\(total)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Brand.ink.opacity(0.55))
                Text("\(Int((fraction * 100).rounded()))%")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.coral)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Brand.coral.opacity(0.12), in: Capsule())
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Brand.ink.opacity(0.08))
                    Capsule()
                        .fill(LinearGradient(colors: [Brand.mint, Brand.coral],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: max(6, geo.size.width * fraction))
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environment(GameStore())
}
