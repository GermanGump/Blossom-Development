// Core/Components/SectionHeader.swift
import SwiftUI

struct SectionHeader: View {
    let title: String
    var actionText: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(BlossomFont.headline)
                .foregroundStyle(BlossomTheme.primaryText)

            Spacer()

            if let actionText, let action {
                Button(action: action) {
                    Text(actionText)
                        .font(BlossomFont.subhead)
                        .foregroundStyle(BlossomTheme.teal)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 16) {
        SectionHeader(title: "Trending Hubs")

        SectionHeader(title: "Your Hubs", actionText: "See all") {
            // action
        }
    }
    .padding(.vertical)
    .background(BlossomTheme.background)
}
