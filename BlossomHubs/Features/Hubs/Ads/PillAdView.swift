// Features/Hubs/Ads/PillAdView.swift
import SwiftUI

struct PillAdView: View {
    @State private var creative = AdCreative.pillCreatives.randomElement()!

    private var adLabel: String {
        creative.isBlossomPro ? "Upgrade" : "Ad"
    }

    var body: some View {
        Link(destination: creative.destinationURL) {
            HStack(spacing: 8) {
                // Brand icon in small circle
                ZStack {
                    Circle()
                        .fill(creative.accentColor.opacity(0.15))
                        .frame(width: 20, height: 20)
                    Image(systemName: creative.iconName)
                        .font(.system(size: 10))
                        .foregroundStyle(creative.accentColor)
                }

                // Headline
                Text(creative.headline)
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.primaryText)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Ad / Upgrade trailing label
                Text(adLabel)
                    .font(.system(size: 10))
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(BlossomTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(BlossomTheme.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 8) {
        PillAdView()
        PillAdView()
        PillAdView()
    }
    .padding()
    .background(BlossomTheme.background)
}
