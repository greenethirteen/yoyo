import SwiftUI

/// Minimalist landing page: the ways to study.
struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                header
                cards
                subjectsStrip
            }
            .frame(maxWidth: 720)
            .padding(.horizontal, 28)
            .padding(.top, 24)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity)
        }
        .background(
            LinearGradient(
                colors: [Brand.cream, Color(red: 0.955, green: 0.95, blue: 0.94)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Yoyo")
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundStyle(Brand.ink)
                Text("Ready to revise?")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.ink.opacity(0.6))
            }
            Spacer()
            BobbingYoyo()
        }
    }

    private var cards: some View {
        VStack(spacing: 16) {
            NavigationLink {
                StudyPaperView()
            } label: {
                HomeCard(
                    title: "Study papers",
                    subtitle: "Work through past papers with an instant mini lesson for every question.",
                    systemImage: "book.fill",
                    tint: Brand.coral
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                PracticeSetupView()
            } label: {
                HomeCard(
                    title: "Practice exam",
                    subtitle: "Sit a timed paper — multiple choice and written answers.",
                    systemImage: "timer",
                    tint: Brand.mint
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var subjectsStrip: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SUBJECTS")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .tracking(1.4)
                .foregroundStyle(Brand.ink.opacity(0.45))
            HStack(spacing: 12) {
                SubjectChip(name: "Biology", symbol: "leaf.fill",
                            color: Color(red: 0.32, green: 0.74, blue: 0.44))
                SubjectChip(name: "Chemistry", symbol: "atom",
                            color: Color(red: 0.30, green: 0.63, blue: 0.94))
            }
        }
    }
}

/// A small yoyo that gently drops and rises on its string while spinning.
struct BobbingYoyo: View {
    @State private var dropped = false
    var size: CGFloat = 48

    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .fill(Brand.ink.opacity(0.3))
                .frame(width: 5, height: 5)
            Capsule()
                .fill(Brand.ink.opacity(0.22))
                .frame(width: 2, height: dropped ? 34 : 10)
            YoyoLogo(size: size)
                .rotationEffect(.degrees(dropped ? 200 : 0))
        }
        .frame(height: size + 46, alignment: .top)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                dropped = true
            }
        }
    }
}

private struct HomeCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let tint: Color

    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [tint, tint.opacity(0.7)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                Image(systemName: systemImage)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 64, height: 64)
            .shadow(color: tint.opacity(0.35), radius: 8, y: 4)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.ink)
                Text(subtitle)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundStyle(Brand.ink.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundStyle(Brand.ink.opacity(0.3))
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }
}

private struct SubjectChip: View {
    let name: String
    let symbol: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(color)
            Text(name)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Brand.ink)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(color.opacity(0.12), in: Capsule())
    }
}

#Preview {
    NavigationStack { HomeView() }
}
