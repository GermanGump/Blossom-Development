import SwiftUI

struct CommunityHeroCardView: View {
    let community: Community
    @Environment(SubscriptionStore.self) private var subscriptionStore

    private var startingPrice: Decimal? {
        community.tiers
            .map(\.monthlyPrice)
            .filter { $0 > 0 }
            .min()
    }

    private var startingPriceText: String {
        guard let price = startingPrice else { return "" }
        return "From $\(price)/mo"
    }

    var body: some View {
        NavigationLink(value: HubsRoute.communityPreview(id: community.id.uuidString)) {
            PhaseAnimator([false, true]) { isGlowing in
                VStack(alignment: .leading, spacing: 12) {
                    // Popular badge
                    HStack {
                        TagView("Popular", style: .category)
                        Spacer()
                    }

                    // Creator row
                    HStack(spacing: 12) {
                        AvatarView(
                            imageName: community.creator.profileImageName,
                            preset: .large,
                            showVerifiedBadge: community.creator.isVerified
                        )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(community.name)
                                .font(BlossomFont.headline)
                                .foregroundStyle(BlossomTheme.primaryText)

                            HStack(spacing: 4) {
                                Text(community.creator.name)
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(BlossomTheme.secondaryText)
                                VerifiedBadge()
                            }
                        }

                        Spacer()
                    }

                    // Description
                    Text(community.description)
                        .font(BlossomFont.body)
                        .foregroundStyle(BlossomTheme.secondaryText)
                        .lineLimit(2)

                    // Bottom info row
                    HStack(spacing: 10) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(BlossomTheme.secondaryText)
                            Text("\(community.memberCount)")
                                .font(BlossomFont.caption)
                                .foregroundStyle(BlossomTheme.secondaryText)
                        }

                        TagView(community.category, style: .category)

                        Spacer()

                        if !startingPriceText.isEmpty {
                            Text(startingPriceText)
                                .font(BlossomFont.caption)
                                .foregroundStyle(BlossomTheme.violet)
                        }
                    }
                }
                .padding(16)
                .blossomCard()
                .overlay(alignment: .topTrailing) {
                    if subscriptionStore.isSubscribed(to: community.id) {
                        TagView("Subscribed", style: .subscribed)
                            .padding(8)
                    }
                }
                .shadow(
                    color: BlossomTheme.violet.opacity(isGlowing ? 0.6 : 0.15),
                    radius: isGlowing ? 20 : 8,
                    x: 0,
                    y: 0
                )
            } animation: { _ in
                .easeInOut(duration: 1.4)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CommunityHeroCardView(community: CommunityStore.makeMockData()[1])
            .padding()
    }
    .background(BlossomTheme.background)
    .environment(CommunityStore())
    .environment(SubscriptionStore())
}
