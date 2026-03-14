import SwiftUI

struct WelcomeOverlayView: View {
    let communityName: String
    let tierName: String
    let onExplore: () -> Void

    @State private var shakePhase = false

    var body: some View {
        ZStack {
            // Dimmed background — tapping also dismisses
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onExplore()
                }

            // Welcome card
            VStack(spacing: 20) {
                Text("Welcome to \(communityName)!")
                    .font(BlossomFont.title)
                    .foregroundStyle(BlossomTheme.primaryText)
                    .multilineTextAlignment(.center)

                TagView(tierName, style: .tier)

                Button("Explore") {
                    onExplore()
                }
                .buttonStyle(BlossomPrimaryButton())
            }
            .padding(32)
            .background(BlossomTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(BlossomTheme.cardBorder, lineWidth: 1)
            )
            .padding(.horizontal, 40)
            .rotationEffect(.degrees(shakePhase ? 2 : -2))
            .onAppear {
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(500))
                    withAnimation(.easeInOut(duration: 0.08).repeatCount(5, autoreverses: true)) {
                        shakePhase.toggle()
                    }
                }
            }
        }
    }
}
