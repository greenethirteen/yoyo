import Foundation
import FoundationModels

/// A plain, availability-free mark the UI can hold regardless of OS version.
struct WrittenMark: Hashable {
    let marksAwarded: Int
    let feedback: String
}

enum GradingError: LocalizedError {
    case unavailable(String)

    var errorDescription: String? {
        switch self {
        case .unavailable(let message): return message
        }
    }
}

/// Facade the UI talks to. It hides the iOS 26-only FoundationModels APIs
/// behind availability checks so the rest of the app builds on any target.
enum GradingEngine {
    /// A human-readable reason grading can't run, or `nil` when it's ready.
    static var unavailableMessage: String? {
        if #available(iOS 26.0, *) {
            return GradingService.shared.unavailableMessage
        } else {
            return "Automatic grading needs iOS 26 with Apple Intelligence. Self-mark using the model answers below."
        }
    }

    /// Marks a single written answer, on-device.
    static func grade(question: WrittenQuestion, answer: String) async throws -> WrittenMark {
        if #available(iOS 26.0, *) {
            return try await GradingService.shared.grade(question: question, answer: answer)
        } else {
            throw GradingError.unavailable(unavailableMessage ?? "Automatic grading is unavailable.")
        }
    }
}

/// The structured result the on-device model returns for one written answer.
@available(iOS 26.0, *)
@Generable
struct GradeResult {
    @Guide(description: "Whole number of marks awarded, from 0 up to the maximum for this question")
    let marksAwarded: Int
    @Guide(description: "One or two short, encouraging sentences saying what earned marks and what was missing")
    let feedback: String
}

/// Grades written short-answer questions on-device with Apple's FoundationModels.
///
/// No network, no API key — everything runs locally. When Apple Intelligence
/// isn't available the caller falls back to showing the model answer for
/// self-marking.
@available(iOS 26.0, *)
actor GradingService {
    static let shared = GradingService()

    /// A human-readable reason grading is unavailable, or `nil` when it's ready.
    nonisolated var unavailableMessage: String? {
        switch SystemLanguageModel.default.availability {
        case .available:
            return nil
        case .unavailable(.deviceNotEligible):
            return "This device doesn't support Apple Intelligence, so answers can't be graded automatically."
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Turn on Apple Intelligence in Settings to have written answers graded automatically."
        case .unavailable(.modelNotReady):
            return "The on-device model is still downloading. Try again in a little while."
        case .unavailable:
            return "Automatic grading is unavailable on this device right now."
        }
    }

    /// Marks a single written answer against its mark scheme.
    func grade(question: WrittenQuestion, answer: String) async throws -> WrittenMark {
        guard SystemLanguageModel.default.isAvailable else {
            throw GradingError.unavailable(unavailableMessage ?? "Automatic grading is unavailable.")
        }

        let trimmed = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return WrittenMark(marksAwarded: 0, feedback: "No answer was written for this question.")
        }

        let instructions = Instructions("""
        You are a Cambridge O Level Biology examiner. Mark the student's answer strictly against the \
        mark scheme provided. Award one mark for each distinct mark-scheme point the student clearly \
        makes, up to the maximum. Do not award marks for correct ideas that are not in the mark scheme, \
        and never award more than the maximum. Keep feedback brief and encouraging, naming what earned \
        marks and what was missing.
        """)

        let session = LanguageModelSession(instructions: instructions)

        let markSchemeText = question.markScheme
            .map { "- \($0)" }
            .joined(separator: "\n")

        let prompt = """
        Question (\(question.marks) marks): \(question.stem)

        Mark scheme (maximum \(question.marks) marks):
        \(markSchemeText)

        Student's answer:
        \(trimmed)

        Award marksAwarded as a whole number between 0 and \(question.marks).
        """

        let response = try await session.respond(to: prompt, generating: GradeResult.self)
        let content = response.content

        // Clamp defensively so a stray value can never exceed the paper's marks.
        let clamped = min(max(content.marksAwarded, 0), question.marks)
        return WrittenMark(marksAwarded: clamped, feedback: content.feedback)
    }
}
