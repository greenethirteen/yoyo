import SwiftUI

/// The 1v1 battle runner: a VS room, a timed multiple-choice duel against a
/// simulated opponent, then the standings and points.
struct BattleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(GameStore.self) private var game

    let paper: Paper
    let bot: BotOpponent

    private enum Phase { case room, question, reveal, results }

    private let questionTime = 15

    @State private var phase: Phase = .room
    @State private var qIndex = 0
    @State private var playerChoice: Int?
    @State private var botChoice: Int?
    @State private var botCommitted = false
    @State private var botDelay = 5
    @State private var botWillBeCorrect = true
    @State private var timeLeft = 15
    @State private var scored = false
    @State private var playerCorrect = 0
    @State private var botCorrect = 0
    @State private var earnedPoints = 0
    @State private var didRecord = false

    private var questions: [BiologyQuestion] { Array(paper.questions.prefix(8)) }
    private var current: BiologyQuestion { questions[min(qIndex, questions.count - 1)] }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Brand.cream, Brand.peach.opacity(0.18)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            switch phase {
            case .room: roomView
            case .question, .reveal: duelView
            case .results: resultsView
            }
        }
        .task(id: phase == .room) {
            guard phase == .room else { return }
            try? await Task.sleep(for: .seconds(1.8))
            if phase == .room { startQuestion(reset: true) }
        }
    }

    // MARK: - Room

    private var roomView: some View {
        VStack(spacing: 28) {
            closeButton
            Spacer()
            Text("Quiz Room")
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.ink)
            Text(paper.subject + " · " + paper.code)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.6))

            HStack(spacing: 30) {
                fighter(symbol: "face.smiling.inverse", color: Brand.coral, name: "You")
                Text("VS")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .background(Brand.peach, in: Circle())
                    .shadow(color: Brand.peach.opacity(0.4), radius: 8, y: 4)
                fighter(symbol: bot.symbol, color: bot.color, name: bot.name)
            }
            .padding(.vertical, 10)

            ProgressView()
            Text("Finding your opponent…")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.6))
            Spacer()
        }
        .padding(24)
    }

    private func fighter(symbol: String, color: Color, name: String) -> some View {
        VStack(spacing: 10) {
            BattleAvatar(symbol: symbol, color: color, size: 84)
            Text(name)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.ink)
        }
    }

    // MARK: - Duel

    private var duelView: some View {
        VStack(spacing: 18) {
            duelBar
            scoreboard
            ScrollView {
                VStack(spacing: 16) {
                    questionCard
                    if phase == .reveal { nextButton }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 20)
            }
        }
        .task(id: qIndex) { await runTimer() }
        .task(id: revealKey) { await autoAdvance() }
    }

    private var duelBar: some View {
        HStack {
            closeButton
            Spacer()
            Text("Question \(qIndex + 1)/\(questions.count)")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.ink)
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "timer")
                Text("\(timeLeft)s")
            }
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(timeLeft <= 5 ? .red : Brand.ink)
            .frame(width: 74)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var scoreboard: some View {
        HStack(spacing: 14) {
            playerScoreChip(symbol: "face.smiling.inverse", color: Brand.coral,
                            name: "You", score: playerCorrect, committed: playerChoice != nil)
            Text("VS")
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(Brand.peach, in: Circle())
            playerScoreChip(symbol: bot.symbol, color: bot.color,
                            name: bot.name, score: botCorrect, committed: botCommitted)
        }
        .padding(.horizontal, 20)
    }

    private func playerScoreChip(symbol: String, color: Color, name: String, score: Int, committed: Bool) -> some View {
        HStack(spacing: 10) {
            BattleAvatar(symbol: symbol, color: color, size: 38)
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.ink)
                    .lineLimit(1)
                Text(committed ? "Answered" : "Thinking…")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(committed ? .green : Brand.ink.opacity(0.45))
            }
            Spacer()
            Text("\(score)")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(color)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(.white, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
    }

    private var questionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(current.stem)
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .foregroundStyle(.black)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(Array(current.options.enumerated()), id: \.offset) { index, option in
                Button {
                    if phase == .question && playerChoice == nil { playerChoice = index }
                } label: {
                    HStack(spacing: 12) {
                        Text(["A", "B", "C", "D"][index])
                            .font(.subheadline.weight(.bold))
                            .frame(width: 30, height: 30)
                            .background(letterBackground(index), in: Circle())
                            .foregroundStyle(letterForeground(index))
                        Text(option)
                            .font(.system(size: 16, design: .serif))
                            .foregroundStyle(Brand.ink)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 8)
                        if phase == .reveal, index == current.correctIndex {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                        } else if phase == .reveal, index == playerChoice {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                        }
                    }
                    .padding(12)
                    .background(rowBackground(index), in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(phase == .reveal || playerChoice != nil)
            }

            if phase == .reveal {
                Text("\(bot.name) answered \(botChoice == current.correctIndex ? "correctly" : "incorrectly").")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.ink.opacity(0.6))
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
    }

    private var nextButton: some View {
        Button {
            advance()
        } label: {
            Text(qIndex + 1 < questions.count ? "Next question" : "See result")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(Brand.coral, in: RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Results

    private var resultsView: some View {
        let won = playerCorrect > botCorrect
        let draw = playerCorrect == botCorrect
        return ScrollView {
            VStack(spacing: 18) {
                CelebrationView(
                    title: won ? "Victory!" : (draw ? "It's a draw!" : "Good game"),
                    subtitle: won ? "You beat \(bot.name)!" : (draw ? "Neck and neck with \(bot.name)." : "\(bot.name) edged it this time."),
                    pointsEarned: earnedPoints,
                    symbol: won ? "trophy.fill" : (draw ? "equal.circle.fill" : "flag.checkered"),
                    tint: won ? Brand.coral : Brand.peach
                )
                standingsCard
                actionButtons
            }
            .frame(maxWidth: 640)
            .padding(.horizontal, 24)
            .padding(.top, 30)
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity)
        }
        .task {
            guard !didRecord else { return }
            didRecord = true
            earnedPoints = game.recordBattle(
                subject: paper.subject,
                playerCorrect: playerCorrect,
                opponentCorrect: botCorrect,
                questionCount: questions.count
            )
        }
    }

    private var standingsCard: some View {
        VStack(spacing: 14) {
            standingRow(symbol: "face.smiling.inverse", color: Brand.coral, name: "You", score: playerCorrect)
            Divider()
            standingRow(symbol: bot.symbol, color: bot.color, name: bot.name, score: botCorrect)
        }
        .padding(20)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
    }

    private func standingRow(symbol: String, color: Color, name: String, score: Int) -> some View {
        HStack(spacing: 14) {
            BattleAvatar(symbol: symbol, color: color, size: 44)
            Text(name)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.ink)
            Spacer()
            Text("\(score) / \(questions.count)")
                .font(.system(size: 17, weight: .heavy, design: .rounded))
                .foregroundStyle(color)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Brand.ink)
            .background(.white, in: RoundedRectangle(cornerRadius: 14))
            .overlay { RoundedRectangle(cornerRadius: 14).stroke(Brand.ink.opacity(0.15), lineWidth: 1) }

            Button {
                playAgain()
            } label: {
                Label("Play again", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .background(Brand.coral, in: RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Shared

    private var closeButton: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Brand.ink)
                    .frame(width: 38, height: 38)
                    .background(Brand.ink.opacity(0.06), in: Circle())
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }

    // MARK: - Option styling

    private func letterBackground(_ index: Int) -> Color {
        if phase == .reveal, index == current.correctIndex { return .green }
        if phase == .reveal, index == playerChoice { return .red }
        if playerChoice == index { return Brand.coral }
        return Brand.coral.opacity(0.12)
    }

    private func letterForeground(_ index: Int) -> Color {
        if phase == .reveal, index == current.correctIndex || index == playerChoice { return .white }
        if playerChoice == index { return .white }
        return Brand.ink
    }

    private func rowBackground(_ index: Int) -> Color {
        if phase == .reveal, index == current.correctIndex { return Color.green.opacity(0.12) }
        if phase == .reveal, index == playerChoice { return Color.red.opacity(0.10) }
        if playerChoice == index { return Brand.coral.opacity(0.12) }
        return Color.black.opacity(0.02)
    }

    // MARK: - Flow

    private var revealKey: String { "\(qIndex)-\(phase == .reveal)" }

    private func startQuestion(reset: Bool) {
        if reset { qIndex = 0 }
        playerChoice = nil
        botChoice = nil
        botCommitted = false
        scored = false
        timeLeft = questionTime
        botDelay = Int.random(in: 2...12)
        botWillBeCorrect = Double.random(in: 0...1) < bot.accuracy
        phase = .question
    }

    private func runTimer() async {
        guard phase == .question else { return }
        while timeLeft > 0 {
            try? await Task.sleep(for: .seconds(1))
            if phase != .question { return }
            timeLeft -= 1
            if questionTime - timeLeft >= botDelay { botCommitted = true }
            if playerChoice != nil && botCommitted { break }
        }
        if phase == .question { reveal() }
    }

    private func reveal() {
        guard !scored else { return }
        scored = true
        botCommitted = true
        if botWillBeCorrect {
            botChoice = current.correctIndex
            botCorrect += 1
        } else {
            botChoice = current.options.indices.first { $0 != current.correctIndex }
        }
        if playerChoice == current.correctIndex { playerCorrect += 1 }
        withAnimation { phase = .reveal }
    }

    private func autoAdvance() async {
        guard phase == .reveal else { return }
        try? await Task.sleep(for: .seconds(2.4))
        if phase == .reveal { advance() }
    }

    private func advance() {
        if qIndex + 1 < questions.count {
            qIndex += 1
            startQuestion(reset: false)
        } else {
            withAnimation { phase = .results }
        }
    }

    private func playAgain() {
        playerCorrect = 0
        botCorrect = 0
        earnedPoints = 0
        didRecord = false
        phase = .room
    }
}

/// A circular avatar built from a Brand colour + SF Symbol (battle-local).
private struct BattleAvatar: View {
    let symbol: String
    let color: Color
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [color, color.opacity(0.7)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
            Image(systemName: symbol)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }
}
