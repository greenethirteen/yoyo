import SwiftUI

/// A simulated opponent for a 1v1 battle (no backend — everything on-device).
struct BotOpponent: Hashable {
    let name: String
    let accuracy: Double
    let symbol: String
    let color: Color
}

enum BattleDifficulty: String, CaseIterable, Identifiable {
    case easy = "Rookie"
    case medium = "Contender"
    case hard = "Champion"

    var id: String { rawValue }

    var accuracy: Double {
        switch self {
        case .easy: return 0.45
        case .medium: return 0.65
        case .hard: return 0.85
        }
    }

    var subtitle: String {
        switch self {
        case .easy: return "Answers about half correctly"
        case .medium: return "A solid, steady opponent"
        case .hard: return "Rarely gets one wrong"
        }
    }
}

/// Everything a battle needs, passed to the full-screen runner.
struct BattleConfig: Identifiable {
    let id = UUID()
    let paper: Paper
    let bot: BotOpponent
}

/// Choose a paper and difficulty, then find a match.
struct BattleSetupView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPaperID: Int = DemoPaper.papers.first?.id ?? 0
    @State private var difficulty: BattleDifficulty = .medium
    @State private var config: BattleConfig?

    private var mcqPapers: [Paper] { DemoPaper.papers }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 18) {
                    intro
                    paperSection
                    difficultySection
                    startButton
                }
                .frame(maxWidth: 720)
                .padding(.horizontal, 28)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.955, green: 0.95, blue: 0.94))
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(item: $config) { config in
            BattleView(paper: config.paper, bot: config.bot)
        }
    }

    private var topBar: some View {
        HStack(spacing: 16) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Brand.ink)
                    .frame(width: 38, height: 38)
                    .background(Brand.coral.opacity(0.12), in: Circle())
            }
            .buttonStyle(.plain)
            Text("1v1 Battle")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.ink)
            Spacer()
        }
        .padding(.horizontal, 22)
        .frame(height: 66)
        .background(.background)
        .overlay(alignment: .bottom) { Divider() }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quiz duel")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.ink)
            Text("Answer faster and more accurately than your opponent. Most correct answers wins the match — and the points.")
                .font(.system(size: 15, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.62))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 3)
    }

    private var paperSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TOPIC")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .tracking(1.4)
                .foregroundStyle(Brand.ink.opacity(0.45))
            ForEach(mcqPapers) { paper in
                Button {
                    selectedPaperID = paper.id
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: selectedPaperID == paper.id ? "largecircle.fill.circle" : "circle")
                            .foregroundStyle(selectedPaperID == paper.id ? Brand.coral : Brand.ink.opacity(0.3))
                        Text("\(paper.subject) · \(paper.code)")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Brand.ink)
                        Spacer()
                        Text(paper.session)
                            .font(.system(size: 13, design: .rounded))
                            .foregroundStyle(Brand.ink.opacity(0.5))
                    }
                    .padding(16)
                    .background(.white, in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var difficultySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("OPPONENT")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .tracking(1.4)
                .foregroundStyle(Brand.ink.opacity(0.45))
            HStack(spacing: 12) {
                ForEach(BattleDifficulty.allCases) { level in
                    Button {
                        difficulty = level
                    } label: {
                        VStack(spacing: 4) {
                            Text(level.rawValue)
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                            Text(level.subtitle)
                                .font(.system(size: 11, design: .rounded))
                                .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(difficulty == level ? .white : Brand.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(difficulty == level ? Brand.coral : Color.white,
                                    in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var startButton: some View {
        Button {
            config = BattleConfig(paper: selectedPaper, bot: makeBot())
        } label: {
            Label("Find match", systemImage: "bolt.horizontal.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(Brand.peach, in: RoundedRectangle(cornerRadius: 16))
        .padding(.top, 4)
    }

    private var selectedPaper: Paper {
        mcqPapers.first { $0.id == selectedPaperID } ?? mcqPapers[0]
    }

    private func makeBot() -> BotOpponent {
        let roster: [(String, String, Color)] = [
            ("Suresh", "bird.fill", Color(red: 0.30, green: 0.63, blue: 0.94)),
            ("Aisha", "hare.fill", Color(red: 0.22, green: 0.70, blue: 0.66)),
            ("Kwame", "pawprint.fill", Color(red: 0.32, green: 0.74, blue: 0.44)),
            ("Lena", "fish.fill", Color(red: 0.95, green: 0.49, blue: 0.68)),
            ("Omar", "tortoise.fill", Color(red: 0.98, green: 0.63, blue: 0.25))
        ]
        let pick = roster.randomElement() ?? roster[0]
        return BotOpponent(name: pick.0, accuracy: difficulty.accuracy, symbol: pick.1, color: pick.2)
    }
}

#Preview {
    NavigationStack { BattleSetupView() }
}
