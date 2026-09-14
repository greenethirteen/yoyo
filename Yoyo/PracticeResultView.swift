import SwiftUI

/// Shows the marked result of a practice attempt. Multiple-choice papers are
/// marked locally; written papers are graded on-device by the AI examiner.
struct PracticeResultView: View {
    let paper: PracticePaper
    let mcqAnswers: [Int: Int]
    let writtenAnswers: [Int: String]
    let onDone: () -> Void

    var body: some View {
        switch paper {
        case .mcq(let p):
            MCQResultView(paper: p, answers: mcqAnswers, onDone: onDone)
        case .written(let p):
            WrittenResultView(paper: p, answers: writtenAnswers, onDone: onDone)
        }
    }
}

// MARK: - Shared chrome

private struct ResultBar: View {
    let title: String
    let onDone: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.ink)
            Spacer()
            Button(action: onDone) {
                Text("Done")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Brand.coral, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 22)
        .frame(height: 66)
        .background(.background)
        .overlay(alignment: .bottom) { Divider() }
    }
}

// MARK: - Multiple choice results

private struct MCQResultView: View {
    @Environment(GameStore.self) private var game

    let paper: Paper
    let answers: [Int: Int]
    let onDone: () -> Void

    @State private var earned = 0
    @State private var recorded = false

    private var score: Int {
        paper.questions.filter { answers[$0.id] == $0.correctIndex }.count
    }
    private var wrong: Int {
        paper.questions.filter { answers[$0.id] != nil && answers[$0.id] != $0.correctIndex }.count
    }
    private var skipped: Int {
        paper.questions.filter { answers[$0.id] == nil }.count
    }

    var body: some View {
        VStack(spacing: 0) {
            ResultBar(title: "Results", onDone: onDone)
            ScrollView {
                VStack(spacing: 16) {
                    CelebrationView(
                        title: title,
                        subtitle: "You scored \(score) / \(paper.questions.count)",
                        pointsEarned: earned
                    )
                    ForEach(paper.questions) { question in
                        MCQResultRow(question: question, chosen: answers[question.id])
                    }
                }
                .frame(maxWidth: 760)
                .padding(.horizontal, 24)
                .padding(.vertical, 22)
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.955, green: 0.95, blue: 0.94))
        }
        .task {
            guard !recorded else { return }
            recorded = true
            earned = game.recordPractice(subject: paper.subject,
                                         correct: score, wrong: wrong, skipped: skipped)
        }
    }

    private var title: String {
        switch Double(score) / Double(max(paper.questions.count, 1)) {
        case 0.8...: return "Congratulations!"
        case 0.5..<0.8: return "Well done!"
        default: return "Keep going!"
        }
    }
}

private struct MCQResultRow: View {
    let question: BiologyQuestion
    let chosen: Int?

    private var number: Int { question.id % 100 == 0 ? question.id : question.id % 100 }
    private var isCorrect: Bool { chosen == question.correctIndex }
    private let letters = ["A", "B", "C", "D"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Text("\(number)")
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .frame(width: 24, alignment: .trailing)
                Text(question.stem)
                    .font(.system(size: 16, design: .serif))
                    .foregroundStyle(.black)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(isCorrect ? .green : .red)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Your answer: \(chosen.map { "\(letters[$0]) · \(question.options[$0])" } ?? "Not answered")")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(isCorrect ? .green : .red)
                if !isCorrect {
                    Text("Correct answer: \(letters[question.correctIndex]) · \(question.options[question.correctIndex])")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Brand.ink.opacity(0.7))
                }
            }
            .padding(.leading, 36)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.045), radius: 8, y: 3)
    }
}

// MARK: - Written results (AI graded)

private enum WrittenGradeState {
    case grading
    case graded(WrittenMark)
    case failed(String)
}

private struct WrittenResultView: View {
    @Environment(GameStore.self) private var game

    let paper: WrittenPaper
    let answers: [Int: String]
    let onDone: () -> Void

    @State private var grades: [Int: WrittenGradeState] = [:]
    @State private var unavailableMessage: String?
    @State private var isGrading = true
    @State private var earned = 0

    private var awarded: Int {
        paper.questions.reduce(0) { sum, q in
            if case .graded(let r) = grades[q.id] { return sum + r.marksAwarded }
            return sum
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ResultBar(title: "Results", onDone: onDone)
            ScrollView {
                VStack(spacing: 16) {
                    headerSection
                    ForEach(paper.questions) { question in
                        WrittenResultCard(
                            question: question,
                            answer: answers[question.id] ?? "",
                            state: grades[question.id],
                            selfMark: unavailableMessage != nil
                        )
                    }
                }
                .frame(maxWidth: 760)
                .padding(.horizontal, 24)
                .padding(.vertical, 22)
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.955, green: 0.95, blue: 0.94))
        }
        .task { await gradeAll() }
    }

    @ViewBuilder
    private var headerSection: some View {
        if let unavailableMessage {
            selfMarkBanner(unavailableMessage)
        } else if isGrading {
            gradingHeader
        } else {
            CelebrationView(
                title: awarded >= paper.totalMarks ? "Full marks!" : "Paper marked!",
                subtitle: "The AI examiner scored you \(awarded) / \(paper.totalMarks)",
                pointsEarned: earned
            )
        }
    }

    private var gradingHeader: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Marking your answers…")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(.white, in: RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 3)
    }

    private func selfMarkBanner(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Self-mark this paper", systemImage: "sparkles")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.ink)
            Text("\(message) Compare each answer with the model answer below.")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(red: 1.0, green: 0.95, blue: 0.66), in: RoundedRectangle(cornerRadius: 20))
    }

    private func gradeAll() async {
        if let message = GradingEngine.unavailableMessage {
            unavailableMessage = message
            isGrading = false
            // Award completion points even when self-marking.
            earned = game.recordPractice(subject: paper.subject,
                                         correct: 0, wrong: 0, skipped: 0,
                                         writtenMarks: 0, writtenTotal: paper.totalMarks)
            return
        }
        for question in paper.questions {
            grades[question.id] = .grading
        }
        for question in paper.questions {
            do {
                let result = try await GradingEngine.grade(
                    question: question,
                    answer: answers[question.id] ?? ""
                )
                grades[question.id] = .graded(result)
            } catch {
                grades[question.id] = .failed(error.localizedDescription)
            }
        }
        isGrading = false
        earned = game.recordPractice(subject: paper.subject,
                                     correct: 0, wrong: 0, skipped: 0,
                                     writtenMarks: awarded, writtenTotal: paper.totalMarks)
    }
}

private struct WrittenResultCard: View {
    let question: WrittenQuestion
    let answer: String
    let state: WrittenGradeState?
    let selfMark: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Text("\(question.number)")
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .frame(width: 24, alignment: .trailing)
                Text(question.stem)
                    .font(.system(size: 16, design: .serif))
                    .foregroundStyle(.black)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                marksBadge
            }

            answerBlock("Your answer", answer.isEmpty ? "Not answered" : answer,
                        muted: answer.isEmpty)

            if !selfMark, case .graded(let result) = state {
                feedbackBlock(result.feedback)
            }
            if case .failed(let message) = state {
                Text(message)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.orange)
            }

            answerBlock("Model answer", question.exemplar, muted: false, accent: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.045), radius: 8, y: 3)
    }

    @ViewBuilder
    private var marksBadge: some View {
        switch (selfMark, state) {
        case (false, .graded(let result)):
            Text("\(result.marksAwarded) / \(question.marks)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(result.marksAwarded == question.marks ? Color.green : Brand.coral, in: Capsule())
        case (false, .grading):
            ProgressView().controlSize(.small)
        default:
            Text("[\(question.marks)]")
                .font(.system(size: 15, weight: .bold, design: .serif))
                .foregroundStyle(Brand.ink.opacity(0.5))
        }
    }

    private func answerBlock(_ label: String, _ text: String, muted: Bool, accent: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .tracking(1.0)
                .foregroundStyle(accent ? Brand.mint.opacity(0.9) : Brand.ink.opacity(0.4))
            Text(text)
                .font(.system(size: 15, design: .rounded))
                .foregroundStyle(muted ? Brand.ink.opacity(0.4) : Brand.ink.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background((accent ? Brand.mint.opacity(0.12) : Color.black.opacity(0.03)),
                    in: RoundedRectangle(cornerRadius: 12))
    }

    private func feedbackBlock(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "sparkles")
                .foregroundStyle(Brand.coral)
            Text(text)
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Brand.coral.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }
}
