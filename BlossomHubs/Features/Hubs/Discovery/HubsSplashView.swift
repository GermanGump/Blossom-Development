import SwiftUI

struct HubsSplashView: View {
    let isActive: Bool
    let onComplete: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0
    @State private var hasStarted = false

    var body: some View {
        ZStack {
            BlossomTheme.background
                .ignoresSafeArea()

            Image(colorScheme == .dark ? "blossom-logo-dark" : "blossom-logo-light")
                .resizable()
                .scaledToFit()
                .frame(width: 140)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onChange(of: isActive) { _, active in
            if active && !hasStarted {
                startAnimation()
            }
        }
        .onAppear {
            if isActive && !hasStarted {
                startAnimation()
            }
        }
    }

    private func startAnimation() {
        hasStarted = true
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            scale = 1.0
            opacity = 1.0
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeIn(duration: 0.3)) {
                    opacity = 0
                } completion: {
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    HubsSplashView(isActive: true, onComplete: {})
}
