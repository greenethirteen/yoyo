import SwiftUI

/// A paper the student can sit as a timed practice exam — either an existing
/// multiple-choice paper or a written short-answer paper.
enum PracticePaper: Identifiable, Hashable {
    case mcq(Paper)
    case written(WrittenPaper)

    var id: String {
        switch self {
        case .mcq(let p): return "mcq-\(p.id)"
        case .written(let p): return "written-\(p.id)"
        }
    }

    var subject: String {
        switch self {
        case .mcq(let p): return p.subject
        case .written(let p): return p.subject
        }
    }

    var code: String {
        switch self {
        case .mcq(let p): return p.code
        case .written(let p): return p.code
        }
    }

    var session: String {
        switch self {
        case .mcq(let p): return p.session
        case .written(let p): return p.session
        }
    }

    var paperTitle: String {
        switch self {
        case .mcq(let p): return p.paperTitle
        case .written(let p): return p.paperTitle
        }
    }

    var duration: String {
        switch self {
        case .mcq(let p): return p.duration
        case .written(let p): return p.duration
        }
    }

    var questionCount: Int {
        switch self {
        case .mcq(let p): return p.questions.count
        case .written(let p): return p.questions.count
        }
    }

    /// Total available marks (MCQ papers are one mark per question).
    var totalMarks: Int {
        switch self {
        case .mcq(let p): return p.questions.count
        case .written(let p): return p.totalMarks
        }
    }

    var isWritten: Bool {
        if case .written = self { return true }
        return false
    }

    var kindLabel: String { isWritten ? "Written · AI graded" : "Multiple choice" }

    /// The countdown length in seconds, parsed from the friendly duration text.
    var durationSeconds: Int {
        let lower = duration.lowercased()
        let value = Int(lower.filter(\.isNumber)) ?? 0
        if lower.contains("hour") { return value * 3600 }
        if lower.contains("min") { return value * 60 }
        return max(value, 60)
    }
}

/// Lists the papers available to sit and starts a timed attempt.
struct PracticeSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var startPaper: PracticePaper?

    private var papers: [PracticePaper] {
        DemoPaper.papers.map(PracticePaper.mcq) + DemoPaper.writtenPapers.map(PracticePaper.written)
    }

    private var gradingUnavailableMessage: String? {
        GradingEngine.unavailableMessage
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 18) {
                    intro
                    if let message = gradingUnavailableMessage {
                        aiBanner(message)
                    }
                    ForEach(papers) { paper in
                        Button {
                            startPaper = paper
                        } label: {
                            PaperOptionCard(paper: paper)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: 720)
                .padding(.horizontal, 28)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.955, green: 0.95, blue: 0.94))
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(item: $startPaper) { paper in
            PracticeExamView(paper: paper)
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

            Text("Practice exam")
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
            Text("Pick a paper to sit")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.ink)
            Text("A timer starts as soon as you begin. Multiple-choice papers are marked instantly; written papers are graded on-device by the AI examiner.")
                .font(.system(size: 15, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.62))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 3)
    }

    private func aiBanner(_ message: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "sparkles")
                .foregroundStyle(Color(red: 0.85, green: 0.6, blue: 0.0))
            Text(message)
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(red: 1.0, green: 0.95, blue: 0.66), in: RoundedRectangle(cornerRadius: 14))
    }
}

private struct PaperOptionCard: View {
    let paper: PracticePaper

    private var tint: Color {
        paper.isWritten ? Brand.peach : Brand.coral
    }

    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [tint, tint.opacity(0.7)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                Image(systemName: paper.isWritten ? "square.and.pencil" : "checklist")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 58, height: 58)

            VStack(alignment: .leading, spacing: 5) {
                Text("\(paper.subject) · \(paper.code)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.ink)
                Text("\(paper.paperTitle) · \(paper.session)")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(Brand.ink.opacity(0.6))
                HStack(spacing: 10) {
                    metaChip(paper.kindLabel)
                    metaChip("\(paper.duration)")
                    metaChip("\(paper.totalMarks) marks")
                }
                .padding(.top, 2)
            }

            Spacer(minLength: 8)

            Image(systemName: "play.circle.fill")
                .font(.system(size: 30))
                .foregroundStyle(tint)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 3)
    }

    private func metaChip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(Brand.ink.opacity(0.7))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Brand.ink.opacity(0.06), in: Capsule())
    }
}

#Preview {
    NavigationStack { PracticeSetupView() }
}
