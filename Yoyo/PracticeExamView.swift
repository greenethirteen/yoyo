import SwiftUI

/// A timed attempt at a practice paper. Runs a countdown, collects answers,
/// then hands off to the results screen for marking.
struct PracticeExamView: View {
    @Environment(\.dismiss) private var dismiss

    let paper: PracticePaper

    private enum Phase { case answering, results }

    @State private var phase: Phase = .answering
    @State private var remaining: Int
    @State private var mcqAnswers: [Int: Int] = [:]
    @State private var writtenAnswers: [Int: String] = [:]
    @State private var showQuitConfirm = false

    init(paper: PracticePaper) {
        self.paper = paper
        _remaining = State(initialValue: paper.durationSeconds)
    }

    var body: some View {
        Group {
            if phase == .results {
                PracticeResultView(
                    paper: paper,
                    mcqAnswers: mcqAnswers,
                    writtenAnswers: writtenAnswers,
                    onDone: { dismiss() }
                )
            } else {
                answeringView
            }
        }
        .task(id: phase == .answering) {
            guard phase == .answering else { return }
            while remaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                if phase != .answering { return }
                remaining -= 1
            }
            if phase == .answering {
                withAnimation { phase = .results }
            }
        }
    }

    private var answeringView: some View {
        VStack(spacing: 0) {
            examBar
            ScrollView {
                VStack(spacing: 18) {
                    questionViews
                    submitButton
                }
                .frame(maxWidth: 760)
                .padding(.horizontal, 24)
                .padding(.vertical, 22)
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.955, green: 0.95, blue: 0.94))
        }
        .alert("Leave the exam?", isPresented: $showQuitConfirm) {
            Button("Keep going", role: .cancel) {}
            Button("Leave", role: .destructive) { dismiss() }
        } message: {
            Text("Your progress on this attempt will be lost.")
        }
    }

    private var examBar: some View {
        HStack(spacing: 16) {
            Button {
                showQuitConfirm = true
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Brand.ink)
                    .frame(width: 38, height: 38)
                    .background(Brand.ink.opacity(0.06), in: Circle())
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 1) {
                Text("\(paper.subject) · \(paper.code)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.ink)
                Text(paper.paperTitle)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(Brand.ink.opacity(0.55))
            }

            Spacer()

            timerPill
        }
        .padding(.horizontal, 20)
        .frame(height: 66)
        .background(.background)
        .overlay(alignment: .bottom) { Divider() }
    }

    private var timerPill: some View {
        let urgent = remaining <= 300
        return HStack(spacing: 7) {
            Image(systemName: "timer")
            Text(timeString)
                .monospacedDigit()
        }
        .font(.system(size: 16, weight: .bold, design: .rounded))
        .foregroundStyle(urgent ? .red : Brand.ink)
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background((urgent ? Color.red : Brand.mint).opacity(0.18), in: Capsule())
    }

    private var timeString: String {
        let minutes = remaining / 60
        let seconds = remaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    @ViewBuilder
    private var questionViews: some View {
        switch paper {
        case .mcq(let p):
            ForEach(p.questions) { question in
                PracticeMCQCard(
                    question: question,
                    selected: mcqAnswers[question.id],
                    onSelect: { mcqAnswers[question.id] = $0 }
                )
            }
        case .written(let p):
            ForEach(p.questions) { question in
                PracticeWrittenCard(
                    question: question,
                    text: Binding(
                        get: { writtenAnswers[question.id] ?? "" },
                        set: { writtenAnswers[question.id] = $0 }
                    )
                )
            }
        }
    }

    private var submitButton: some View {
        Button {
            withAnimation { phase = .results }
        } label: {
            Text("Submit paper")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(Brand.coral, in: RoundedRectangle(cornerRadius: 16))
        .padding(.top, 6)
    }
}

// MARK: - Question cards

private struct PracticeMCQCard: View {
    let question: BiologyQuestion
    let selected: Int?
    let onSelect: (Int) -> Void

    private var number: Int { question.id % 100 == 0 ? question.id : question.id % 100 }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Text("\(number)")
                    .font(.system(size: 17, weight: .bold, design: .serif))
                    .frame(width: 26, alignment: .trailing)
                Text(question.stem)
                    .font(.system(size: 17, design: .serif))
                    .foregroundStyle(.black)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(spacing: 9) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    Button {
                        onSelect(index)
                    } label: {
                        HStack(spacing: 12) {
                            Text(["A", "B", "C", "D"][index])
                                .font(.subheadline.weight(.bold))
                                .frame(width: 32, height: 32)
                                .background(selected == index ? Brand.coral : Color.white, in: Circle())
                                .foregroundStyle(selected == index ? .white : Brand.ink)
                                .overlay {
                                    if selected != index {
                                        Circle().stroke(Brand.coral.opacity(0.3), lineWidth: 1)
                                    }
                                }
                            Text(option)
                                .font(.system(size: 15, design: .serif))
                                .foregroundStyle(Brand.ink)
                                .multilineTextAlignment(.leading)
                            Spacer(minLength: 8)
                        }
                        .padding(11)
                        .background(selected == index ? Brand.coral.opacity(0.12) : Color.black.opacity(0.02),
                                    in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.045), radius: 8, y: 3)
    }
}

private struct PracticeWrittenCard: View {
    let question: WrittenQuestion
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Text("\(question.number)")
                    .font(.system(size: 17, weight: .bold, design: .serif))
                    .frame(width: 26, alignment: .trailing)
                Text(question.stem)
                    .font(.system(size: 17, design: .serif))
                    .foregroundStyle(.black)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                Text("[\(question.marks)]")
                    .font(.system(size: 15, weight: .bold, design: .serif))
                    .foregroundStyle(Brand.ink.opacity(0.5))
            }

            TextEditor(text: $text)
                .font(.system(size: 16, design: .rounded))
                .foregroundStyle(Brand.ink)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 120)
                .padding(10)
                .background(Color.black.opacity(0.03), in: RoundedRectangle(cornerRadius: 12))
                .overlay(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Write your answer here…")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundStyle(Brand.ink.opacity(0.35))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 18)
                            .allowsHitTesting(false)
                    }
                }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.045), radius: 8, y: 3)
    }
}
