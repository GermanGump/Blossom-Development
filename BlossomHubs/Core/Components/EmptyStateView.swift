// Core/Components/EmptyStateView.swift
import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    var ctaText: String? = nil
    var ctaAction: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(BlossomTheme.secondaryText)

            Text(title)
                .font(BlossomFont.headline)
                .foregroundStyle(BlossomTheme.primaryText)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(BlossomFont.body)
                .foregroundStyle(BlossomTheme.secondaryText)
                .multilineTextAlignment(.center)

            if let ctaText, let ctaAction {
                Button(ctaText, action: ctaAction)
                    .buttonStyle(BlossomPrimaryButton())
                    .padding(.top, 8)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    VStack {
        EmptyStateView(
            icon: "person.3.fill",
            title: "No Hubs Yet",
            subtitle: "Join a hub to get premium insights from expert investors.",
            ctaText: "Explore Hubs",
            ctaAction: {}
        )

        EmptyStateView(
            icon: "magnifyingglass",
            title: "No Results",
            subtitle: "Try searching with different keywords."
        )
    }
    .background(BlossomTheme.background)
}
