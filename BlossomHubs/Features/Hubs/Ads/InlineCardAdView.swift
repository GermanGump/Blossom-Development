// Features/Hubs/Ads/InlineCardAdView.swift
import SwiftUI

struct InlineCardAdView: View {
    @State private var creative = AdCreative.inlineCreatives.randomElement()!

    private var ctaLabel: String {
        creative.isBlossomPro ? "Upgrade Now" : "Learn More"
    }

    var body: some View {
        Link(destination: creative.destinationURL) {
            HStack(spacing: 0) {
                // Left accent stripe — visual differentiator from organic post cards
                UnevenRoundedRectangle(
                    topLeadingRadius: 12,
                    bottomLeadingRadius: 12,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0,
                    style: .continuous
                )
                .fill(creative.accentColor)
                .frame(width: 3)

                // Card content
                VStack(alignment: .leading, spacing: 8) {
                    // Top row: brand info + Sponsored label
                    HStack(alignment: .top) {
                        HStack(spacing: 6) {
                            Image(systemName: creative.iconName)
                                .font(.system(size: 13))
                                .foregroundStyle(creative.accentColor)
                            Text(creative.brandName)
                                .font(BlossomFont.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(BlossomTheme.secondaryText)
                        }
                        Spacer()
                        Text(creative.sponsoredLabel)
                            .font(.system(size: 10))
                            .foregroundStyle(creative.isBlossomPro ? BlossomTheme.violet : BlossomTheme.secondaryText)
                    }

                    // Headline
                    Text(creative.headline)
                        .font(BlossomFont.subhead)
                        .fontWeight(.semibold)
                        .foregroundStyle(BlossomTheme.primaryText)
                        .lineLimit(2)

                    // Subtitle
                    Text(creative.subtitle)
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                        .lineLimit(2)

                    // CTA label
                    Text(ctaLabel)
                        .font(BlossomFont.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(creative.accentColor)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(BlossomTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(BlossomTheme.cardBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        InlineCardAdView()
        InlineCardAdView()
    }
    .padding()
    .background(BlossomTheme.background)
}
