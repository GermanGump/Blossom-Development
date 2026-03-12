import SwiftUI
import UIKit

struct ConfettiCelebrationView: View {
    let communityName: String
    let onContinue: () -> Void

    @State private var showButton = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image("blossom-logo-light")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)

                Text("Welcome to \(communityName)!")
                    .font(BlossomFont.title)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                if showButton {
                    Button("Enter Community") {
                        onContinue()
                    }
                    .buttonStyle(BlossomPrimaryButton())
                    .padding(.horizontal, 40)
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }

                Spacer()
            }

            ConfettiCanvasView()
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .onAppear {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        .sensoryFeedback(.impact, trigger: showButton)
        .task {
            try? await Task.sleep(for: .milliseconds(800))
            withAnimation(.easeOut(duration: 0.4)) {
                showButton = true
            }
        }
    }
}

// MARK: - Confetti Canvas

private struct ConfettiCanvasView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var startTime: Date? = nil

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                guard let start = startTime else { return }
                let elapsed = timeline.date.timeIntervalSince(start)
                let centerX = size.width / 2
                let centerY = size.height / 2
                let gravity: Double = 800

                for particle in particles {
                    let t = elapsed
                    let x = centerX + particle.x + particle.velocityX * t
                    let y = centerY + particle.y + particle.velocityY * t + 0.5 * gravity * t * t
                    let opacity = max(0, 1.0 - elapsed * 0.4)

                    guard opacity > 0 else { continue }
                    guard x > -20 && x < size.width + 20 && y < size.height + 50 else { continue }

                    let rotation = particle.rotation + particle.rotationSpeed * t

                    context.opacity = opacity
                    context.translateBy(x: x, y: y)
                    context.rotate(by: .radians(rotation))

                    let path: Path
                    switch particle.shape {
                    case .circle:
                        path = Path(ellipseIn: CGRect(x: -4, y: -4, width: 8, height: 8))
                    case .rectangle:
                        path = Path(CGRect(x: -5, y: -3, width: 10, height: 6))
                    case .strip:
                        path = Path(CGRect(x: -2, y: -6, width: 4, height: 12))
                    }

                    context.fill(path, with: .color(particle.color))

                    context.rotate(by: .radians(-rotation))
                    context.translateBy(x: -x, y: -y)
                    context.opacity = 1
                }
            }
        }
        .onAppear {
            spawnParticles()
            startTime = Date()
        }
    }

    private func spawnParticles() {
        let colors: [Color] = [BlossomTheme.violet, BlossomTheme.orange, BlossomTheme.teal]
        let shapes: [ConfettiShape] = [.circle, .rectangle, .strip]

        particles = (0..<100).map { _ in
            let angle = Double.random(in: 0...(2 * .pi))
            let speed = Double.random(in: 200...600)
            let vx = cos(angle) * speed
            let vy = sin(angle) * speed - 300 // bias upward

            return ConfettiParticle(
                x: 0,
                y: 0,
                velocityX: vx,
                velocityY: vy,
                rotation: Double.random(in: 0...(2 * .pi)),
                rotationSpeed: Double.random(in: -8...8),
                color: colors.randomElement()!,
                shape: shapes.randomElement()!
            )
        }
    }
}

// MARK: - Particle Model

private enum ConfettiShape: Sendable {
    case circle, rectangle, strip
}

private struct ConfettiParticle: Identifiable, Sendable {
    let id = UUID()
    let x: Double
    let y: Double
    let velocityX: Double
    let velocityY: Double
    let rotation: Double
    let rotationSpeed: Double
    let color: Color
    let shape: ConfettiShape
}
