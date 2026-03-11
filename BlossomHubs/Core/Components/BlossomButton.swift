// Core/Components/BlossomButton.swift
import SwiftUI

// MARK: - Primary Button

struct BlossomPrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BlossomFont.buttonLabel)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(BlossomTheme.violet)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

// MARK: - Secondary Button

struct BlossomSecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BlossomFont.buttonLabel)
            .foregroundColor(BlossomTheme.violet)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(BlossomTheme.violet, lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

// MARK: - Ghost Button

struct BlossomGhostButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BlossomFont.buttonLabel)
            .foregroundColor(BlossomTheme.teal)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

#Preview {
    VStack(spacing: 16) {
        Button("Join Hub — $29/mo") {}
            .buttonStyle(BlossomPrimaryButton())

        Button("View Details") {}
            .buttonStyle(BlossomSecondaryButton())

        Button("See all hubs") {}
            .buttonStyle(BlossomGhostButton())
    }
    .padding(24)
    .background(BlossomTheme.background)
}
