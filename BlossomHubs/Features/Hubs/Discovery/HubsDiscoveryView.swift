import SwiftUI

struct HubsDiscoveryView: View {
    let searchText: String

    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var cardsVisible = false

    private var subscribedCommunities: [Community] {
        let creatorID = subscriptionStore.session.creatorCommunityID
        return store.communities.filter { community in
            subscriptionStore.currentTier(for: community.id, in: community) != nil
                && community.id != creatorID
        }
    }

    private var creatorCommunity: Community? {
        guard let id = subscriptionStore.session.creatorCommunityID else { return nil }
        return store.communities.first { $0.id == id }
    }

    private var heroCommunity: Community? {
        store.communities.first { $0.creator.username == "@bdinvesting" }
    }

    /// Group non-hero, non-subscribed, non-creator communities by display category,
    /// merging raw categories that share the same display name (e.g. Trading Hubs).
    private var categorizedCommunities: [(category: String, communities: [Community])] {
        let creatorID = subscriptionStore.session.creatorCommunityID
        let heroID = heroCommunity?.id
        let subscribedIDs = Set(subscribedCommunities.map(\.id))

        let eligible = store.communities.filter { community in
            community.id != heroID
                && community.id != creatorID
                && !subscribedIDs.contains(community.id)
        }

        // Group by display name (merges raw categories like Swing/Options/Momentum → Trading Hubs)
        let grouped = Dictionary(grouping: eligible) { community in
            CategoryMapping.displayName(for: community.category)
        }

        return CategoryMapping.displayOrder.compactMap { displayName in
            guard let communities = grouped[displayName], !communities.isEmpty else { return nil }
            let sorted = communities.sorted { $0.memberCount > $1.memberCount }
            return (category: displayName, communities: sorted)
        }
    }

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 22) {
                // Header
                HStack(spacing: 10) {
                    Image(colorScheme == .dark ? "blossom-logo-dark" : "blossom-logo-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Verified Blossom Communities")
                            .font(BlossomFont.subhead)
                            .fontWeight(.semibold)
                            .foregroundStyle(BlossomTheme.primaryText)
                        Text("Join, learn, invest.")
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                    }

                    Spacer()
                }
                .padding(.bottom, 4)

                // Creator entry point
                if subscriptionStore.session.creatorCommunityID != nil {
                    NavigationLink(value: HubsRoute.creatorDashboard) {
                        HStack(spacing: 12) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(BlossomTheme.violet)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Manage my Hub")
                                    .font(BlossomFont.subhead)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(BlossomTheme.primaryText)
                                Text("Edit community, tiers & content")
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(BlossomTheme.secondaryText)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(BlossomTheme.secondaryText)
                        }
                        .padding(16)
                        .background(BlossomTheme.cardSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                // My Community — creator's own hub quick access
                if let myCommunity = creatorCommunity {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Community")
                            .font(BlossomFont.subhead)
                            .fontWeight(.semibold)
                            .foregroundStyle(BlossomTheme.primaryText)

                        CommunityCardView(
                            community: myCommunity,
                            route: .communityDetail(id: myCommunity.id.uuidString)
                        )
                    }
                }

                // My Hubs — subscribed communities
                if !subscribedCommunities.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Hubs")
                            .font(BlossomFont.subhead)
                            .fontWeight(.semibold)
                            .foregroundStyle(BlossomTheme.primaryText)

                        ForEach(subscribedCommunities) { community in
                            CommunityCardView(
                                community: community,
                                route: .communityDetail(id: community.id.uuidString)
                            )
                        }
                    }
                    .padding(.bottom, 8)
                }

                // Banner ad — appears above Featured Hub regardless of subscription state
                BannerAdView()

                // Featured Hub
                if let hero = heroCommunity {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Featured Hub")
                            .font(BlossomFont.subhead)
                            .fontWeight(.semibold)
                            .foregroundStyle(BlossomTheme.primaryText)

                        CommunityHeroCardView(community: hero)
                            .opacity(cardsVisible ? 1 : 0)
                            .offset(y: cardsVisible ? 0 : 20)
                            .animation(.easeOut(duration: 0.35).delay(0), value: cardsVisible)
                    }
                    .padding(.bottom, 4)
                }

                // Category sections
                ForEach(Array(categorizedCommunities.enumerated()), id: \.element.category) { sectionIndex, group in
                    VStack(alignment: .leading, spacing: 8) {
                        // Section header
                        HStack(spacing: 6) {
                            Image(systemName: CategoryMapping.icon(for: group.category))
                                .font(.system(size: 14))
                                .foregroundStyle(BlossomTheme.violet)
                            Text(group.category)
                                .font(BlossomFont.subhead)
                                .fontWeight(.semibold)
                                .foregroundStyle(BlossomTheme.primaryText)
                        }
                        .padding(.top, 4)

                        // Community cards
                        ForEach(Array(group.communities.enumerated()), id: \.element.id) { cardIndex, community in
                            CommunityCardView(community: community)
                                .opacity(cardsVisible ? 1 : 0)
                                .offset(y: cardsVisible ? 0 : 20)
                                .animation(
                                    .easeOut(duration: 0.35)
                                        .delay(Double(sectionIndex * 2 + cardIndex + 1) * 0.08),
                                    value: cardsVisible
                                )
                        }

                        // Explore more link
                        NavigationLink(value: HubsRoute.categoryExplore(category: group.category)) {
                            HStack(spacing: 6) {
                                Text("Explore more")
                                    .font(BlossomFont.caption)
                                    .fontWeight(.medium)
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 11, weight: .semibold))
                            }
                            .foregroundStyle(BlossomTheme.violet)
                            .padding(.top, 2)
                            .padding(.bottom, 4)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .padding(.bottom, 100)
        }
        .task {
            guard !cardsVisible else { return }
            cardsVisible = true
        }
    }
}

#Preview {
    NavigationStack {
        HubsDiscoveryView(searchText: "")
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
    .background(BlossomTheme.background)
}
