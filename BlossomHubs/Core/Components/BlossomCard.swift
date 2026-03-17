// Core/Components/BlossomCard.swift
import SwiftUI

struct BlossomCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(BlossomTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(BlossomTheme.cardBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

extension View {
    func blossomCard() -> some View {
        modifier(BlossomCard())
    }
}

#Preview {
    VStack(spacing: 16) {
        Text("Hub Card Example")
            .font(BlossomFont.headline)
            .foregroundStyle(BlossomTheme.primaryText)
            .padding(20)
            .blossomCard()

        VStack(alignment: .leading, spacing: 8) {
            Text("Investor Community")
                .font(BlossomFont.headline)
                .foregroundStyle(BlossomTheme.primaryText)
            Text("Premium stock picks and analysis")
                .font(BlossomFont.body)
                .foregroundStyle(BlossomTheme.secondaryText)
        }
        .padding(16)
        .blossomCard()
    }
    .padding()
    .background(BlossomTheme.background)
}
