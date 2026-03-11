import SwiftUI

struct CommunityCardView: View {
    let community: Community

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
            HStack(alignment: .top, spacing: 12) {
                AvatarView(
                    imageName: community.creator.profileImageName,
                    preset: .medium,
                    showVerifiedBadge: community.creator.isVerified
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text(community.name)
                        .font(BlossomFont.subhead)
                        .fontWeight(.semibold)
                        .foregroundStyle(BlossomTheme.primaryText)

                    Text(community.creator.name)
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)

                    Text(community.description)
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                        .lineLimit(2)

                    HStack(spacing: 8) {
                        HStack(spacing: 3) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 10))
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
            }
            .padding(14)
            .blossomCard()
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 12) {
            ForEach(CommunityStore.makeMockData().prefix(3)) { community in
                CommunityCardView(community: community)
            }
        }
        .padding()
    }
    .background(BlossomTheme.background)
    .environment(CommunityStore())
}
