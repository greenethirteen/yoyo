# Yoyo™ — iPad O Level study helper prototype

A minimal SwiftUI iPad prototype for practising O Level past-paper questions.

## What works
- Paper-first study interface designed for iPad.
- Tap a question to open a right-hand mini lesson.
- Select A/B/C/D and check the answer instantly.
- Correct/incorrect feedback and running score.
- Built-in demo Biology question set structured as replaceable data.
- “Original paper” button opens the linked PapaCambridge 5090/11 May/June 2026 paper inside the app.

## Important prototype note
The interactive questions and mini-lessons in this ZIP are original demo content, not a transcription of Cambridge’s copyrighted paper. The linked official paper is opened remotely in a web view. To ship a production version using official past-paper content, obtain permission/licensing and populate `DemoPaper.questions` from your authorised question/mark-scheme source.

## Open in Xcode
1. Unzip `Yoyo.zip`.
2. Open `Yoyo.xcodeproj`.
3. Choose an iPad simulator (iPad Pro 11-inch works well).
4. In **Signing & Capabilities**, select your Apple Development Team if Xcode asks.
5. Run.

Target: iPadOS 17.0+

## Where to add real papers later
`Yoyo/Models.swift` contains the question content. The UI is already data-driven, so adding a full 40-question paper is simply adding records with the stem, options, correct answer, topic and mini lesson.
