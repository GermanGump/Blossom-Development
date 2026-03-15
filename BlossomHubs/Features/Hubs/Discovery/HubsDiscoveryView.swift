import SwiftUI

struct HubsDiscoveryView: View {
    let searchText: String

    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var cardsVisible = false

    private var subscribedCommunities: [Community] {
        store.communities.filter { community in
            subscriptionStore.currentTier(for: community.id) != nil
        }
    }

    private var heroCommunity: Community? {
        store.communities.first { $0.creator.username == "@bdinvesting" }
    }

    private var listCommunities: [Community] {
        let heroID = heroCommunity?.id
        let subscribedIDs = Set(subscribedCommunities.map(\.id))
        return store.communities
            .filter { $0.id != heroID && !subscribedIDs.contains($0.id) }
            .sorted { $0.memberCount > $1.memberCount }
    }

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
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

                if let hero = heroCommunity {
                    CommunityHeroCardView(community: hero)
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                        .animation(.easeOut(duration: 0.35).delay(0), value: cardsVisible)
                }

                ForEach(Array(listCommunities.enumerated()), id: \.element.id) { index, community in
                    CommunityCardView(community: community)
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                        .animation(
                            .easeOut(duration: 0.35).delay(Double(index + 1) * 0.08),
                            value: cardsVisible
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
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
