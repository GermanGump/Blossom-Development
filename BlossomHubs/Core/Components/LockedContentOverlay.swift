// Core/Components/LockedContentOverlay.swift
import SwiftUI

struct LockedContentOverlay<Content: View>: View {
    let tierName: String
    let onUpgrade: () -> Void
    let content: () -> Content

    init(
        tierName: String,
        onUpgrade: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.tierName = tierName
        self.onUpgrade = onUpgrade
        self.content = content
    }

    var body: some View {
        ZStack {
            content()
                .blur(radius: 8)
                .opacity(0.6)

            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)

                Text("Upgrade to \(tierName)")
                    .font(BlossomFont.headline)
                    .foregroundStyle(.white)

                Text("\(tierName) members get access")
                    .font(BlossomFont.body)
                    .foregroundStyle(.white.opacity(0.85))

                Button("Upgrade", action: onUpgrade)
                    .buttonStyle(BlossomPrimaryButton())
                    .padding(.horizontal, 32)
            }
            .padding(24)
        }
    }
}

#Preview {
    LockedContentOverlay(tierName: "Gold", onUpgrade: {}) {
        VStack(spacing: 12) {
            ForEach(0..<4) { _ in
                RoundedRectangle(cornerRadius: 8)
                    .fill(BlossomTheme.cardSurface)
                    .frame(height: 80)
            }
        }
        .padding()
        .background(BlossomTheme.background)
    }
}
