import SwiftUI

/// A podium of the top three plus a full rankings list. The player is ranked
/// among simulated peers (no backend) and their row is highlighted.
struct LeaderboardView: View {
    @Environment(GameStore.self) private var game

    var body: some View {
        let entries = game.leaderboard()
        ScrollView {
            VStack(spacing: 24) {
                Text("Leaderboard")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundStyle(Brand.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Podium(entries: Array(entries.prefix(3)))

                VStack(spacing: 10) {
                    ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                        RankRow(rank: index + 1, entry: entry)
                    }
                }
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
}

private struct Podium: View {
    let entries: [LeaderboardEntry]

    var body: some View {
        HStack(alignment: .bottom, spacing: 14) {
            if entries.count > 1 { column(entries[1], rank: 2, height: 96) }
            if !entries.isEmpty { column(entries[0], rank: 1, height: 128) }
            if entries.count > 2 { column(entries[2], rank: 3, height: 72) }
        }
        .frame(maxWidth: .infinity)
    }

    private func column(_ entry: LeaderboardEntry, rank: Int, height: CGFloat) -> some View {
        VStack(spacing: 8) {
            if rank == 1 {
                Image(systemName: "crown.fill")
                    .font(.title3)
                    .foregroundStyle(Color(red: 0.95, green: 0.75, blue: 0.1))
            }
            AvatarCircle(entry: entry, size: rank == 1 ? 66 : 54)
            Text(entry.name)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Brand.ink)
                .lineLimit(1)
            Text("\(entry.points)")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.6))
                .padding(.horizontal, 10).padding(.vertical, 3)
                .background(Brand.ink.opacity(0.06), in: Capsule())

            RoundedRectangle(cornerRadius: 12)
                .fill(entry.isPlayer ? Brand.coral.opacity(0.9) : Brand.mint.opacity(0.55))
                .frame(height: height)
                .overlay(
                    Text("\(rank)")
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                )
        }
        .frame(maxWidth: .infinity)
    }
}

private struct RankRow: View {
    let rank: Int
    let entry: LeaderboardEntry

    var body: some View {
        HStack(spacing: 14) {
            Text("\(rank)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.5))
                .frame(width: 26)
            AvatarCircle(entry: entry, size: 40)
            Text(entry.name)
                .font(.system(size: 16, weight: entry.isPlayer ? .heavy : .medium, design: .rounded))
                .foregroundStyle(Brand.ink)
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "bolt.fill")
                Text("\(entry.points)")
            }
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.72, green: 0.5, blue: 0.0))
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(Color(red: 1.0, green: 0.95, blue: 0.66), in: Capsule())
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(entry.isPlayer ? Brand.coral.opacity(0.10) : Color.white,
                    in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            if entry.isPlayer {
                RoundedRectangle(cornerRadius: 16).stroke(Brand.coral.opacity(0.5), lineWidth: 1.5)
            }
        }
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}

/// A circular avatar built from a Brand colour + SF Symbol.
struct AvatarCircle: View {
    let entry: LeaderboardEntry
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [entry.color, entry.color.opacity(0.7)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
            Image(systemName: entry.symbol)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    NavigationStack { LeaderboardView() }
        .environment(GameStore())
}
