import SwiftUI

struct CommunityBannerView: View {
    let community: Community

    var body: some View {
        Color.clear
            .frame(height: 240)
            .overlay(alignment: .center) {
                if let bannerName = community.bannerImageName {
                    Image(bannerName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .visualEffect { content, proxy in
                            let offsetY = proxy.frame(in: .scrollView).minY
                            return content.offset(y: offsetY > 0 ? -offsetY * 0.4 : 0)
                        }
                } else {
                    LinearGradient(
                        colors: Self.gradientColors(for: community.category),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .visualEffect { content, proxy in
                        let offsetY = proxy.frame(in: .scrollView).minY
                        return content.offset(y: offsetY > 0 ? -offsetY * 0.4 : 0)
                    }
                }
            }
            .clipped()
    }

    static func gradientColors(for category: String) -> [Color] {
        switch category {
        case "Dividend Investing": return [BlossomTheme.teal, BlossomTheme.violet]
        case "Swing Trading": return [BlossomTheme.orange, BlossomTheme.violet]
        case "Options Trading": return [BlossomTheme.violet, BlossomTheme.teal]
        case "Growth Investing": return [BlossomTheme.teal, BlossomTheme.orange]
        case "Value Investing": return [BlossomTheme.violet, BlossomTheme.orange]
        case "Canadian Markets": return [BlossomTheme.orange, BlossomTheme.teal]
        default: return [BlossomTheme.violet, BlossomTheme.teal]
        }
    }
}
