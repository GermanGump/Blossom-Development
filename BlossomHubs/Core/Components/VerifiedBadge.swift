// Core/Components/VerifiedBadge.swift
import SwiftUI

struct VerifiedBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.shield.fill")
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.teal)
            Text("Verified")
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.teal)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(BlossomTheme.teal.opacity(0.15))
        .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 16) {
        VerifiedBadge()

        HStack(spacing: 8) {
            Circle()
                .fill(BlossomTheme.teal.opacity(0.3))
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text("Nick Simpson")
                    .font(BlossomFont.headline)
                    .foregroundStyle(BlossomTheme.primaryText)
                VerifiedBadge()
            }
        }
    }
    .padding()
    .background(BlossomTheme.background)
}
