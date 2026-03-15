import Foundation

@MainActor
@Observable
final class CreatorDashboardViewModel {
    let communityID: UUID
    private let communityStore: CommunityStore
    private let subscriptionStore: SubscriptionStore

    var community: Community? {
        communityStore.communities.first(where: { $0.id == communityID })
    }

    var subscriberCount: Int {
        community?.memberCount ?? 0
    }

    var estimatedRevenue: Decimal {
        guard let community else { return 0 }
        let avgPrice: Decimal = community.tiers.reduce(0) { $0 + $1.monthlyPrice } / max(Decimal(community.tiers.count), 1)
        return Decimal(subscriberCount) * avgPrice
    }

    init(communityID: UUID, communityStore: CommunityStore, subscriptionStore: SubscriptionStore) {
        self.communityID = communityID
        self.communityStore = communityStore
        self.subscriptionStore = subscriptionStore
    }
}
