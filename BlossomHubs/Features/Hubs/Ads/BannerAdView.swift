// Features/Hubs/Ads/BannerAdView.swift
import SwiftUI

struct BannerAdView: View {
    @State private var creative = AdCreative.bannerCreatives.randomElement()!

    var body: some View {
        Link(destination: creative.destinationURL) {
            ZStack(alignment: .topTrailing) {
                HStack(spacing: 12) {
                    // Brand icon with circular background
                    ZStack {
                        Circle()
                            .fill(creative.accentColor.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: creative.iconName)
                            .font(.system(size: 20))
                            .foregroundStyle(creative.accentColor)
                    }

                    // Headline and subtitle
                    VStack(alignment: .leading, spacing: 3) {
                        Text(creative.headline)
                            .font(BlossomFont.subhead)
                            .fontWeight(.semibold)
                            .foregroundStyle(BlossomTheme.primaryText)
                            .lineLimit(1)
                        Text(creative.subtitle)
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Trailing chevron
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(BlossomTheme.secondaryText)
                }
                .padding(14)
                .background(BlossomTheme.cardSurface)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(creative.accentColor.opacity(0.4), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)

                // Sponsored / Upgrade label at top-trailing
                Text(creative.sponsoredLabel)
                    .font(.system(size: 10))
                    .foregroundStyle(creative.isBlossomPro ? BlossomTheme.violet : BlossomTheme.secondaryText)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(BlossomTheme.cardSurface.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    .padding(.top, 6)
                    .padding(.trailing, 10)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        BannerAdView()
        BannerAdView()
    }
    .padding()
    .background(BlossomTheme.background)
}
