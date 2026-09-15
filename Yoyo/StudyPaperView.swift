import SwiftUI
import AVFoundation

struct StudyPaperView: View {
    @State private var selectedSubject: String = DemoPaper.papers[0].subject
    @State private var selectedPaper: Paper = DemoPaper.papers[0]
    @State private var selectedQuestion: BiologyQuestion?
    @State private var answers: [Int: Int] = [:]
    @State private var checked: Set<Int> = []
    @State private var showingExam = false

    private var score: Int {
        selectedPaper.questions.filter { q in
            checked.contains(q.id) && answers[q.id] == q.correctIndex
        }.count
    }

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let sidebarWidth = selectedQuestion == nil
                ? 0
                : max(300, min(totalWidth - 360, totalWidth * 0.5))

            HStack(spacing: 0) {
                paperColumn
                    .frame(width: totalWidth - sidebarWidth)
                    .clipped()

                if let question = selectedQuestion {
                    LessonSidebar(
                        question: question,
                        selectedAnswer: binding(for: question),
                        isChecked: checked.contains(question.id),
                        onCheck: { checked.insert(question.id) },
                        onReset: {
                            answers.removeValue(forKey: question.id)
                            checked.remove(question.id)
                        },
                        onClose: { withAnimation(.easeInOut(duration: 0.2)) { selectedQuestion = nil } }
                    )
                    .frame(width: sidebarWidth)
                    .clipped()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .frame(width: totalWidth)
            .background(Color(uiColor: .systemGroupedBackground))
        }
        .animation(.easeInOut(duration: 0.2), value: selectedQuestion)
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $showingExam) {
            ExamModeView(paper: selectedPaper)
        }
    }

    private var paperColumn: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 18) {
                    PaperHeader(paper: selectedPaper)
                    ForEach(selectedPaper.questions) { question in
                        QuestionBlock(
                            question: question,
                            selectedAnswer: answers[question.id],
                            isChecked: checked.contains(question.id),
                            isSelected: selectedQuestion?.id == question.id
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedQuestion = question
                            }
                        }
                    }
                    Text("End of paper · \(selectedPaper.questions.count) questions")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 22)
                }
                .frame(maxWidth: 760)
                .padding(.horizontal, 28)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.955, green: 0.95, blue: 0.94))
        }
    }

    private var topBar: some View {
        HStack(spacing: 16) {
            HStack(spacing: 11) {
                YoyoLogo(size: 40)
                Text("Yoyo")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundStyle(Brand.ink)
            }

            subjectPicker
            paperPicker

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                Text("\(score)/\(checked.count)")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Brand.ink)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Brand.mint.opacity(0.35), in: Capsule())

            Button {
                showingExam = true
            } label: {
                Label("Exam mode", systemImage: "timer")
            }
            .buttonStyle(.borderedProminent)
            .tint(Brand.coral)
        }
        .padding(.horizontal, 22)
        .frame(height: 66)
        .background(.background)
        .overlay(alignment: .bottom) { Divider() }
    }

    /// Distinct subjects, in the order they first appear in the paper list.
    private var subjects: [String] {
        var seen = Set<String>()
        var result: [String] = []
        for paper in DemoPaper.papers where !seen.contains(paper.subject) {
            seen.insert(paper.subject)
            result.append(paper.subject)
        }
        return result
    }

    /// Papers belonging to the currently selected subject.
    private var papersInSubject: [Paper] {
        DemoPaper.papers.filter { $0.subject == selectedSubject }
    }

    private var subjectPicker: some View {
        Menu {
            ForEach(subjects, id: \.self) { subject in
                Button {
                    selectSubject(subject)
                } label: {
                    if subject == selectedSubject {
                        Label(subject, systemImage: "checkmark")
                    } else {
                        Text(subject)
                    }
                }
            }
        } label: {
            pickerLabel(icon: "books.vertical.fill", text: selectedSubject)
        }
        .menuStyle(.borderlessButton)
        .fixedSize()
    }

    private var paperPicker: some View {
        Menu {
            ForEach(papersInSubject) { paper in
                Button {
                    selectPaper(paper)
                } label: {
                    if paper.id == selectedPaper.id {
                        Label("\(paper.code) · \(paper.session)", systemImage: "checkmark")
                    } else {
                        Text("\(paper.code) · \(paper.session)")
                    }
                }
            }
        } label: {
            pickerLabel(icon: "doc.text.fill", text: "\(selectedPaper.code) · \(selectedPaper.session)")
        }
        .menuStyle(.borderlessButton)
        .fixedSize()
    }

    private func pickerLabel(icon: String, text: String) -> some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.caption2.weight(.bold))
                .foregroundStyle(Brand.coral)
            Text(text)
                .font(.subheadline.weight(.semibold))
            Image(systemName: "chevron.up.chevron.down")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .foregroundStyle(Brand.ink)
        .padding(.horizontal, 13)
        .padding(.vertical, 8)
        .background(Brand.coral.opacity(0.12), in: Capsule())
    }

    private func selectSubject(_ subject: String) {
        guard subject != selectedSubject else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedSubject = subject
            if let first = DemoPaper.papers.first(where: { $0.subject == subject }) {
                selectedPaper = first
            }
            selectedQuestion = nil
            answers = [:]
            checked = []
        }
    }

    private func selectPaper(_ paper: Paper) {
        guard paper.id != selectedPaper.id else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedPaper = paper
            selectedQuestion = nil
            answers = [:]
            checked = []
        }
    }

    private func binding(for question: BiologyQuestion) -> Binding<Int?> {
        Binding<Int?>(
            get: { answers[question.id] },
            set: { value in
                if let value { answers[question.id] = value }
                else { answers.removeValue(forKey: question.id) }
                checked.remove(question.id)
            }
        )
    }
}

// MARK: - Brand & styling

/// Playful brand palette used across the app.
enum Brand {
    static let coral = Color(red: 1.00, green: 0.42, blue: 0.38)
    static let peach = Color(red: 1.00, green: 0.62, blue: 0.36)
    static let mint = Color(red: 0.55, green: 0.86, blue: 0.68)
    static let cream = Color(red: 0.995, green: 0.98, blue: 0.95)
    static let ink = Color(red: 0.16, green: 0.15, blue: 0.20)
}

extension Font {
    /// Built-in iOS handwriting face, for the "note" feel.
    static func hand(_ size: CGFloat) -> Font { .custom("Noteworthy-Bold", size: size) }
}

/// Colour + illustration for a topic, so the sidebar feels alive and specific.
struct TopicStyle {
    let color: Color
    let symbol: String

    private static let palette: [Color] = [
        Color(red: 1.00, green: 0.42, blue: 0.38), // coral
        Color(red: 0.98, green: 0.63, blue: 0.25), // amber
        Color(red: 0.22, green: 0.70, blue: 0.66), // teal
        Color(red: 0.32, green: 0.74, blue: 0.44), // green
        Color(red: 0.30, green: 0.63, blue: 0.94), // blue
        Color(red: 0.59, green: 0.46, blue: 0.98), // purple
        Color(red: 0.95, green: 0.49, blue: 0.68), // pink
        Color(red: 0.36, green: 0.50, blue: 0.98)  // indigo
    ]

    static func forTopic(_ topic: String) -> TopicStyle {
        let t = topic.lowercased()
        let symbol: String
        switch true {
        case t.contains("cell"): symbol = "circle.grid.2x2.fill"
        case t.contains("photo") || t.contains("plant") || t.contains("leaf"): symbol = "leaf.fill"
        case t.contains("respir"): symbol = "lungs.fill"
        case t.contains("gas exchange"): symbol = "wind"
        case t.contains("transport in humans") || t.contains("circulat") || t.contains("blood"): symbol = "heart.fill"
        case t.contains("movement") || t.contains("osmos") || t.contains("water"): symbol = "drop.fill"
        case t.contains("nutri") || t.contains("digest"): symbol = "fork.knife"
        case t.contains("enzyme"): symbol = "bolt.fill"
        case t.contains("coordination") || t.contains("response") || t.contains("eye"): symbol = "eye.fill"
        case t.contains("excret") || t.contains("kidney"): symbol = "drop.triangle.fill"
        case t.contains("hormone"): symbol = "bolt.heart.fill"
        case t.contains("immun") || t.contains("disease"): symbol = "shield.lefthalf.filled"
        case t.contains("inherit") || t.contains("variation") || t.contains("selection") || t.contains("genetic"): symbol = "person.2.fill"
        case t.contains("ecolog") || t.contains("decompos") || t.contains("impact") || t.contains("environment"): symbol = "globe.europe.africa.fill"
        case t.contains("atom"): symbol = "atom"
        case t.contains("bond"): symbol = "link"
        case t.contains("acid") || t.contains("base"): symbol = "testtube.2"
        case t.contains("periodic"): symbol = "tablecells.fill"
        case t.contains("stoichi") || t.contains("mass"): symbol = "scalemass.fill"
        case t.contains("rate"): symbol = "timer"
        case t.contains("electro"): symbol = "bolt.batteryblock.fill"
        case t.contains("organic"): symbol = "hexagon.fill"
        default: symbol = "sparkles"
        }

        // Deterministic colour so a topic keeps the same hue across launches.
        let sum = topic.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return TopicStyle(color: palette[sum % palette.count], symbol: symbol)
    }
}

/// Minimal, bold yoyo mark: a gradient disc with a centre hole.
struct YoyoLogo: View {
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [Brand.coral, Brand.peach],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
            Circle()
                .fill(.white)
                .frame(width: size * 0.26, height: size * 0.26)
        }
        .frame(width: size, height: size)
        .shadow(color: Brand.coral.opacity(0.35), radius: size * 0.14, y: size * 0.07)
    }
}

// MARK: - Paper column

private struct PaperHeader: View {
    let paper: Paper

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CAMBRIDGE O LEVEL")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .tracking(1.4)
                        .foregroundStyle(Brand.coral)
                    Text(paper.subject)
                        .font(.system(size: 32, weight: .bold, design: .serif))
                    Text("\(paper.code) · \(paper.paperTitle)")
                        .font(.system(size: 15, weight: .medium))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text(paper.duration)
                        .font(.headline)
                    Text(paper.marks)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()
            Text("Tap any question to open Yoyo. Choose an answer in the lesson panel and check it instantly.")
                .font(.system(size: 15, design: .serif))
                .foregroundStyle(.secondary)
        }
        .padding(30)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }
}

private struct QuestionBlock: View {
    let question: BiologyQuestion
    let selectedAnswer: Int?
    let isChecked: Bool
    let isSelected: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            Text("\(displayNumber)")
                .font(.system(size: 17, weight: .bold, design: .serif))
                .frame(width: 30, alignment: .trailing)

            VStack(alignment: .leading, spacing: 14) {
                Text(question.stem)
                    .font(.system(size: 17, design: .serif))
                    .foregroundStyle(.black)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 9) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                        HStack(alignment: .top, spacing: 10) {
                            Text(["A", "B", "C", "D"][index])
                                .font(.system(size: 15, weight: .semibold, design: .serif))
                                .frame(width: 18, alignment: .leading)
                            Text(option)
                                .font(.system(size: 15, design: .serif))
                            Spacer(minLength: 8)
                            if selectedAnswer == index {
                                Image(systemName: isChecked ? (index == question.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill") : "circle.inset.filled")
                                    .foregroundStyle(isChecked ? (index == question.correctIndex ? .green : .red) : Brand.coral)
                            }
                        }
                    }
                }
            }
            Spacer()

            Image(systemName: "sparkles")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isSelected ? .white : Brand.coral)
                .padding(9)
                .background(isSelected ? Brand.coral : Brand.coral.opacity(0.12), in: Circle())
        }
        .padding(26)
        .background(.white)
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isSelected ? Brand.coral : .clear, lineWidth: 2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .shadow(color: .black.opacity(0.045), radius: 10, y: 3)
    }

    // Questions use globally-unique ids; show a friendly 1-based number per paper.
    private var displayNumber: Int { question.id % 100 == 0 ? question.id : question.id % 100 }
}

// MARK: - Lesson sidebar

private struct LessonSidebar: View {
    let question: BiologyQuestion
    @Binding var selectedAnswer: Int?
    let isChecked: Bool
    let onCheck: () -> Void
    let onReset: () -> Void
    let onClose: () -> Void

    /// Remembered across questions and launches.
    @AppStorage("lessonLevel") private var levelRaw: Int = LessonLevel.simple.rawValue
    @State private var speech = SpeechController()
    @State private var isSpeaking = false

    private var style: TopicStyle { TopicStyle.forTopic(question.topic) }
    private var level: LessonLevel { LessonLevel(rawValue: levelRaw) ?? .detailed }

    // The saved notes baked into each question.
    private var lessonTitle: String { question.lessonTitle }
    private var lessonBody: String { question.body(for: level) }
    private var lessonTip: String { question.tip }
    private var selectedAnswerIsCorrect: Bool {
        isChecked && selectedAnswer == question.correctIndex
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    levelPicker
                    lessonCard
                    tipNote
                    answerPicker

                    if isChecked, let selectedAnswer {
                        ResultCard(
                            correct: selectedAnswer == question.correctIndex,
                            correctLetter: ["A", "B", "C", "D"][question.correctIndex],
                            accent: style.color
                        )
                    }
                }
                .padding(22)
            }

            footer
        }
        .background(
            LinearGradient(
                colors: [style.color.opacity(0.18), Brand.cream],
                startPoint: .top, endPoint: .bottom
            )
        )
        .overlay(alignment: .leading) { Divider() }
        .onAppear { speech.onChange = { speaking in isSpeaking = speaking } }
        .onChange(of: question) { _, _ in stopSpeaking() }
        .onChange(of: levelRaw) { _, _ in stopSpeaking() }
        .onDisappear { stopSpeaking() }
    }

    /// Segmented control that chooses how much detail the explanation shows.
    private var levelPicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("EXPLAIN IT")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .tracking(1.2)
                .foregroundStyle(Brand.ink.opacity(0.45))
            Picker("Explanation level", selection: Binding(
                get: { level },
                set: { levelRaw = $0.rawValue }
            )) {
                ForEach(LessonLevel.allCases) { lvl in
                    Text(lvl.label).tag(lvl)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private func toggleSpeech() {
        let text = "\(question.lessonTitle). \(question.body(for: level))"
        speech.toggle(text)
        isSpeaking = speech.isSpeaking
    }

    private func stopSpeaking() {
        speech.stop()
        isSpeaking = false
    }

    private var header: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [style.color, style.color.opacity(0.7)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                Image(systemName: style.symbol)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 60, height: 60)
            .shadow(color: style.color.opacity(0.35), radius: 8, y: 4)

            VStack(alignment: .leading, spacing: 2) {
                Text("QUESTION \(question.id % 100 == 0 ? question.id : question.id % 100)")
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(style.color)
                Text(question.topic)
                    .font(.hand(24))
                    .foregroundStyle(Brand.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
            if selectedAnswerIsCorrect {
                Label("Correct", systemImage: "checkmark.circle.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color.green.opacity(0.12), in: Capsule())
            }
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Brand.ink)
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.plain)
            .background(.white.opacity(0.7), in: Circle())
        }
        .padding(22)
    }

    private var lessonCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text("mini lesson")
                    .font(.hand(17))
                    .foregroundStyle(style.color)
                Image(systemName: "sparkles")
                    .font(.footnote)
                    .foregroundStyle(style.color)
                Spacer(minLength: 8)
                Button(action: toggleSpeech) {
                    Image(systemName: isSpeaking ? "stop.circle.fill" : "speaker.wave.2.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(style.color, in: Circle())
                        .shadow(color: style.color.opacity(0.35), radius: 5, y: 2)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isSpeaking ? "Stop reading" : "Read aloud")
            }
            Text(lessonTitle)
                .font(.hand(27))
                .foregroundStyle(Brand.ink)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)
            Text(lessonBody)
                .font(.system(size: 16, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.78))
                .lineSpacing(5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3)
                .fill(style.color)
                .frame(width: 5)
                .padding(.vertical, 14)
                .padding(.leading, 6)
        }
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }

    private var tipNote: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundStyle(Color(red: 0.85, green: 0.6, blue: 0.0))
            Text(lessonTip)
                .font(.hand(18))
                .foregroundStyle(Brand.ink.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(red: 1.0, green: 0.95, blue: 0.66), in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
        .rotationEffect(.degrees(-1.4))
    }

    private var answerPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your answer")
                .font(.headline)
                .foregroundStyle(Brand.ink)
            ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                Button {
                    selectedAnswer = index
                } label: {
                    HStack(spacing: 12) {
                        Text(["A", "B", "C", "D"][index])
                            .font(.headline)
                            .frame(width: 34, height: 34)
                            .background(selectedAnswer == index ? style.color : Color.white,
                                        in: Circle())
                            .foregroundStyle(selectedAnswer == index ? .white : Brand.ink)
                            .overlay {
                                if selectedAnswer != index {
                                    Circle().stroke(style.color.opacity(0.3), lineWidth: 1)
                                }
                            }
                        Text(option)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Brand.ink)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(12)
                    .background(selectedAnswer == index ? style.color.opacity(0.14) : Color.white.opacity(0.7),
                                in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .disabled(isChecked)
            }
        }
    }

    private var footer: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 12) {
                if isChecked {
                    Button(action: onReset) {
                        Label("Try again", systemImage: "arrow.counterclockwise")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(style.color)
                    .background(.white, in: RoundedRectangle(cornerRadius: 14))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(style.color.opacity(0.35), lineWidth: 1)
                    }
                } else {
                    Button(action: onCheck) {
                        Text("Check answer")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.white)
                    .background(selectedAnswer == nil ? AnyShapeStyle(Color.gray) : AnyShapeStyle(style.color))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(selectedAnswer == nil)
                }
            }
            .padding(18)
        }
    }
}

private struct ResultCard: View {
    let correct: Bool
    let correctLetter: String
    let accent: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title3)
                .foregroundStyle(correct ? .green : .red)
            VStack(alignment: .leading, spacing: 4) {
                Text(correct ? "Correct" : "Not quite")
                    .font(.hand(20))
                    .foregroundStyle(Brand.ink)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                Text(correct ? "Nice. You’ve got this one." : "The correct answer is \(correctLetter). Review the mini lesson, then try the idea again on another question.")
                    .font(.subheadline)
                    .foregroundStyle(Brand.ink.opacity(0.75))
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background((correct ? Color.green : Color.red).opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Read-aloud

/// Wraps `AVSpeechSynthesizer` so an explanation can be read aloud using the
/// device's built-in offline voice. No network or AI needed.
final class SpeechController: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    /// Called when speaking starts or stops, so a view can update its icon.
    var onChange: ((Bool) -> Void)?

    /// Chosen once: the most natural-sounding English voice installed.
    private lazy var voice: AVSpeechSynthesisVoice? = Self.preferredVoice()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    var isSpeaking: Bool { synthesizer.isSpeaking }

    /// Starts reading `text`, or stops if already speaking.
    func toggle(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            onChange?(false)
            return
        }
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        try? AVAudioSession.sharedInstance().setActive(true)

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = 0.46          // a little slower, easier to follow
        synthesizer.speak(utterance)
        onChange?(true)
    }

    /// Picks the best-quality English voice available on the device, preferring
    /// downloaded premium/enhanced voices over the robotic compact default.
    private static func preferredVoice() -> AVSpeechSynthesisVoice? {
        let english = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix("en") }

        func rank(_ v: AVSpeechSynthesisVoice) -> Int {
            var r = 0
            switch v.quality {
            case .premium: r += 300
            case .enhanced: r += 200
            default: r += 0
            }
            switch v.language {
            case "en-GB": r += 30
            case "en-AU", "en-IE": r += 18
            case "en-US": r += 15
            default: r += 0
            }
            // Skip the old novelty / eloquence voices, which sound robotic.
            let name = v.name.lowercased()
            if name.contains("eloquence") || name.contains("novelty") { r -= 500 }
            return r
        }

        return english.max { rank($0) < rank($1) }
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        onChange?(false)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onChange?(false)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        onChange?(false)
    }
}

// MARK: - Exam mode

/// A timed exam sitting for a multiple-choice paper. One question at a time,
/// with an instant mark after each answer and a grade at the end.
struct ExamModeView: View {
    let paper: Paper
    @Environment(\.dismiss) private var dismiss

    @State private var index = 0
    @State private var selected: Int?
    @State private var locked = false
    @State private var score = 0
    @State private var remaining: Int
    @State private var finished = false
    @State private var awardedFlash = false

    init(paper: Paper) {
        self.paper = paper
        // Roughly one minute per question.
        _remaining = State(initialValue: max(60, paper.questions.count * 60))
    }

    private var total: Int { paper.questions.count }
    private var current: BiologyQuestion { paper.questions[index] }
    private let letters = ["A", "B", "C", "D"]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Brand.cream, Color(red: 0.955, green: 0.95, blue: 0.94)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            if finished {
                resultsView
            } else {
                examView
            }
        }
        .task { await runTimer() }
    }

    // MARK: Timer

    private func runTimer() async {
        while remaining > 0 && !finished {
            try? await Task.sleep(for: .seconds(1))
            if finished { break }
            remaining -= 1
        }
        if remaining <= 0 {
            withAnimation(.easeInOut) { finished = true }
        }
    }

    private var timeText: String {
        String(format: "%d:%02d", remaining / 60, remaining % 60)
    }

    // MARK: Exam screen

    private var examView: some View {
        VStack(spacing: 0) {
            examBar
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Question \(index + 1) of \(total)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(Brand.ink.opacity(0.5))

                    Text(current.stem)
                        .font(.system(size: 22, design: .serif))
                        .foregroundStyle(.black)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(spacing: 12) {
                        ForEach(Array(current.options.enumerated()), id: \.offset) { i, option in
                            optionRow(i, option)
                        }
                    }

                    if locked {
                        HStack {
                            if awardedFlash {
                                Label("+1 mark", systemImage: "checkmark.seal.fill")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundStyle(.green)
                            } else {
                                Label("No mark", systemImage: "xmark.seal.fill")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundStyle(.red)
                            }
                            Spacer()
                            Button(action: next) {
                                Text(index + 1 < total ? "Next" : "Finish")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 26)
                                    .padding(.vertical, 13)
                                    .background(Brand.coral, in: Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(maxWidth: 720)
                .padding(.horizontal, 28)
                .padding(.vertical, 26)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var examBar: some View {
        HStack(spacing: 16) {
            Button {
                dismiss()
            } label: {
                Label("Quit", systemImage: "xmark")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Brand.ink)
            }
            .buttonStyle(.plain)

            Spacer()

            HStack(spacing: 7) {
                Image(systemName: "clock.fill")
                Text(timeText).monospacedDigit()
            }
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundStyle(remaining <= 30 ? .red : Brand.ink)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background((remaining <= 30 ? Color.red : Brand.coral).opacity(0.12), in: Capsule())

            Spacer()

            HStack(spacing: 7) {
                Image(systemName: "star.fill")
                Text("\(score)")
            }
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.82, green: 0.6, blue: 0.0))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(red: 1.0, green: 0.95, blue: 0.66), in: Capsule())
        }
        .padding(.horizontal, 22)
        .frame(height: 66)
        .background(.white)
        .overlay(alignment: .bottom) {
            ProgressView(value: Double(index) + (locked ? 1 : 0), total: Double(total))
                .tint(Brand.coral)
        }
    }

    private func optionRow(_ i: Int, _ option: String) -> some View {
        let isCorrect = i == current.correctIndex
        let isChosen = selected == i
        let showRight = locked && isCorrect
        let showWrong = locked && isChosen && !isCorrect

        let background: Color = showRight ? .green.opacity(0.16)
            : showWrong ? .red.opacity(0.14)
            : isChosen ? Brand.coral.opacity(0.14)
            : .white
        let border: Color = showRight ? .green : showWrong ? .red : .clear

        return Button {
            choose(i)
        } label: {
            HStack(spacing: 14) {
                Text(letters[i])
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .frame(width: 30, height: 30)
                    .background(isChosen ? Brand.coral : Brand.coral.opacity(0.12), in: Circle())
                    .foregroundStyle(isChosen ? .white : Brand.ink)
                Text(option)
                    .font(.system(size: 17, design: .serif))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                if showRight {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                } else if showWrong {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14).stroke(border, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
        .disabled(locked)
    }

    private func choose(_ i: Int) {
        guard !locked else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            selected = i
            locked = true
            awardedFlash = (i == current.correctIndex)
            if awardedFlash { score += 1 }
        }
    }

    private func next() {
        withAnimation(.easeInOut(duration: 0.2)) {
            if index + 1 < total {
                index += 1
                selected = nil
                locked = false
                awardedFlash = false
            } else {
                finished = true
            }
        }
    }

    // MARK: Results screen

    private var percentage: Int {
        total == 0 ? 0 : Int((Double(score) / Double(total) * 100).rounded())
    }

    private var grade: String {
        switch percentage {
        case 90...: return "A*"
        case 80..<90: return "A"
        case 70..<80: return "B"
        case 60..<70: return "C"
        case 50..<60: return "D"
        case 40..<50: return "E"
        default: return "U"
        }
    }

    private var gradeColor: Color {
        switch percentage {
        case 70...: return .green
        case 50..<70: return Brand.peach
        default: return Brand.coral
        }
    }

    private var resultsView: some View {
        VStack(spacing: 24) {
            Text(paper.subject)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .tracking(1.2)
                .foregroundStyle(Brand.ink.opacity(0.5))

            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [gradeColor, gradeColor.opacity(0.65)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 150, height: 150)
                    .shadow(color: gradeColor.opacity(0.4), radius: 16, y: 8)
                VStack(spacing: 0) {
                    Text("GRADE")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.85))
                    Text(grade)
                        .font(.system(size: 58, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                }
            }

            VStack(spacing: 6) {
                Text("\(score) / \(total) correct")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.ink)
                Text("\(percentage)%")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.ink.opacity(0.6))
            }

            Text(remaining <= 0 ? "Time's up — here's how you did." : resultMessage)
                .font(.system(size: 16, design: .rounded))
                .foregroundStyle(Brand.ink.opacity(0.7))
                .multilineTextAlignment(.center)

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(Brand.coral, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: 460)
        .padding(36)
        .background(.white, in: RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.08), radius: 20, y: 8)
        .padding(28)
    }

    private var resultMessage: String {
        switch percentage {
        case 80...: return "Excellent work — you've really mastered this paper."
        case 60..<80: return "Good effort. Review the ones you missed and go again."
        case 40..<60: return "You're getting there. Study mode can help fill the gaps."
        default: return "Keep practising — try study mode to learn each question."
        }
    }
}
