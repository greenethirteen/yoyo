import SwiftUI
import Observation

/// Per-subject tally used for the profile performance bars.
struct SubjectStat: Codable, Hashable {
    var correct: Int = 0
    var total: Int = 0
}

/// The persisted snapshot of the player's progress.
struct PlayerStats: Codable {
    var points: Int = 0
    var correct: Int = 0
    var wrong: Int = 0
    var skipped: Int = 0
    var quizzesPlayed: Int = 0
    var wins: Int = 0
    var losses: Int = 0
    var streakDays: Int = 0
    /// Day (yyyy-MM-dd) the player last completed a quiz.
    var lastPlayedDay: String = ""
    var perSubject: [String: SubjectStat] = [:]
}

/// Central point values so scoring is tuned in one place.
enum Points {
    static let perCorrectMCQ = 10
    static let perWrittenMark = 12
    static let paperCompletion = 20
    static let battleWin = 60
    static let battleDraw = 25
    static let battleLoss = 10
    static let perLevel = 500
}

/// A row on the leaderboard — the player plus simulated peers.
struct LeaderboardEntry: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let points: Int
    let isPlayer: Bool
    let symbol: String
    let color: Color
}

/// Single source of truth for gamification. Loaded from and saved to
/// `UserDefaults`; injected into the environment by `RootView`.
@Observable
final class GameStore {
    private(set) var stats: PlayerStats

    private let defaultsKey = "yoyo.player.stats.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: "yoyo.player.stats.v1"),
           let decoded = try? JSONDecoder().decode(PlayerStats.self, from: data) {
            stats = decoded
        } else {
            stats = PlayerStats()
        }
    }

    // MARK: - Derived values

    var points: Int { stats.points }
    var level: Int { stats.points / Points.perLevel + 1 }
    var pointsIntoLevel: Int { stats.points % Points.perLevel }
    var levelProgress: Double { Double(pointsIntoLevel) / Double(Points.perLevel) }

    var gamesPlayed: Int { stats.wins + stats.losses }
    var winRate: Double { gamesPlayed == 0 ? 0 : Double(stats.wins) / Double(gamesPlayed) }

    var accuracy: Double {
        let answered = stats.correct + stats.wrong
        return answered == 0 ? 0 : Double(stats.correct) / Double(answered)
    }

    // MARK: - Streak

    /// Call on app open: clears a streak that has already lapsed.
    func refreshStreak() {
        guard !stats.lastPlayedDay.isEmpty else { return }
        if stats.lastPlayedDay != Self.dayString(0) && stats.lastPlayedDay != Self.dayString(-1) {
            stats.streakDays = 0
            save()
        }
    }

    private func registerActivity() {
        let today = Self.dayString(0)
        guard stats.lastPlayedDay != today else { return }
        if stats.lastPlayedDay == Self.dayString(-1) {
            stats.streakDays += 1
        } else {
            stats.streakDays = 1
        }
        stats.lastPlayedDay = today
    }

    // MARK: - Recording results

    /// Records a completed practice paper and returns the points earned.
    @discardableResult
    func recordPractice(subject: String,
                        correct: Int, wrong: Int, skipped: Int,
                        writtenMarks: Int = 0, writtenTotal: Int = 0) -> Int {
        registerActivity()
        stats.correct += correct
        stats.wrong += wrong
        stats.skipped += skipped
        stats.quizzesPlayed += 1

        let earned = correct * Points.perCorrectMCQ
            + writtenMarks * Points.perWrittenMark
            + Points.paperCompletion
        stats.points += earned

        var subjectStat = stats.perSubject[subject] ?? SubjectStat()
        subjectStat.correct += correct + writtenMarks
        subjectStat.total += correct + wrong + skipped + writtenTotal
        stats.perSubject[subject] = subjectStat

        save()
        return earned
    }

    /// Records a 1v1 battle result and returns the points earned.
    @discardableResult
    func recordBattle(subject: String,
                      playerCorrect: Int, opponentCorrect: Int,
                      questionCount: Int) -> Int {
        registerActivity()
        stats.correct += playerCorrect
        stats.wrong += max(0, questionCount - playerCorrect)
        stats.quizzesPlayed += 1

        var earned = playerCorrect * Points.perCorrectMCQ
        if playerCorrect > opponentCorrect {
            stats.wins += 1
            earned += Points.battleWin
        } else if playerCorrect == opponentCorrect {
            earned += Points.battleDraw
        } else {
            stats.losses += 1
            earned += Points.battleLoss
        }
        stats.points += earned

        var subjectStat = stats.perSubject[subject] ?? SubjectStat()
        subjectStat.correct += playerCorrect
        subjectStat.total += questionCount
        stats.perSubject[subject] = subjectStat

        save()
        return earned
    }

    // MARK: - Leaderboard

    func leaderboard() -> [LeaderboardEntry] {
        var entries = Self.peers
        entries.append(
            LeaderboardEntry(name: "You", points: stats.points, isPlayer: true,
                             symbol: "face.smiling.inverse", color: Brand.coral)
        )
        return entries.sorted { $0.points > $1.points }
    }

    /// Simulated competitors so the leaderboard feels alive with no backend.
    private static let peers: [LeaderboardEntry] = [
        .init(name: "Aisha K.", points: 320, isPlayer: false, symbol: "hare.fill",
              color: Color(red: 0.22, green: 0.70, blue: 0.66)),
        .init(name: "Bilal R.", points: 540, isPlayer: false, symbol: "tortoise.fill",
              color: Color(red: 0.98, green: 0.63, blue: 0.25)),
        .init(name: "Chen W.", points: 780, isPlayer: false, symbol: "bird.fill",
              color: Color(red: 0.59, green: 0.46, blue: 0.98)),
        .init(name: "Dana M.", points: 1120, isPlayer: false, symbol: "ant.fill",
              color: Color(red: 0.30, green: 0.63, blue: 0.94)),
        .init(name: "Ella P.", points: 1580, isPlayer: false, symbol: "fish.fill",
              color: Color(red: 0.95, green: 0.49, blue: 0.68)),
        .init(name: "Farid S.", points: 2140, isPlayer: false, symbol: "pawprint.fill",
              color: Color(red: 0.32, green: 0.74, blue: 0.44)),
        .init(name: "Grace T.", points: 2760, isPlayer: false, symbol: "leaf.fill",
              color: Color(red: 0.36, green: 0.50, blue: 0.98))
    ]

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    // MARK: - Day helpers

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    /// A yyyy-MM-dd string for today plus `offset` days.
    private static func dayString(_ offset: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date()
        return dayFormatter.string(from: date)
    }
}
