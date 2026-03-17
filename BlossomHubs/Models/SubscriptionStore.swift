import Foundation

@MainActor
@Observable
final class SubscriptionStore {
    var session: UserSession

    private static let storageKey = "blossom_user_session"

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let saved = try? JSONDecoder().decode(UserSession.self, from: data) {
            self.session = saved
        } else {
            self.session = UserSession(
                id: UUID(),
                name: "Nick",
                username: "@nick",
                profileImageName: "nick-profile-pic",
                subscriptions: [:],
                creatorCommunityID: CommunityStore.wealthmaticaID
            )
        }
        // Ensure Nick always has creator community ID (handles sessions persisted before this field existed)
        if session.creatorCommunityID == nil {
            session.creatorCommunityID = CommunityStore.wealthmaticaID
            persist()
        }
    }

    func subscribe(to community: Community, tier: Tier) {
        let sub = Subscription(
            communityID: community.id,
            tierID: tier.id,
            tierName: tier.name,
            monthlyPrice: tier.monthlyPrice
        )
        session.subscriptions[community.id] = sub
        persist()
    }

    func changeTier(for communityID: UUID, to tier: Tier) {
        guard let existing = session.subscriptions[communityID] else { return }
        session.subscriptions[communityID] = Subscription(
            communityID: communityID,
            tierID: tier.id,
            tierName: tier.name,
            monthlyPrice: tier.monthlyPrice,
            subscribedAt: existing.subscribedAt
        )
        persist()
    }

    func cancel(communityID: UUID) {
        session.subscriptions.removeValue(forKey: communityID)
        persist()
    }

    func isSubscribed(to communityID: UUID) -> Bool {
        // Creator always has access to their own community
        if session.creatorCommunityID == communityID { return true }
        return session.subscriptions[communityID] != nil
    }

    func currentTier(for communityID: UUID, in community: Community? = nil) -> UUID? {
        // Creator gets the highest tier on their own community
        if session.creatorCommunityID == communityID,
           let topTier = community?.tiers.last {
            return topTier.id
        }
        return session.subscriptions[communityID]?.tierID
    }

    func markWelcomeSeen(for communityID: UUID) {
        session.subscriptions[communityID]?.hasSeenWelcome = true
        persist()
    }

    #if DEBUG
    func resetAll() {
        session.subscriptions = [:]
        persist()
    }
    #endif

    private func persist() {
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }
}
