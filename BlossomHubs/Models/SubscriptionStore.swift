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
                subscriptions: [:]
            )
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
        session.subscriptions[communityID] != nil
    }

    func currentTier(for communityID: UUID) -> UUID? {
        session.subscriptions[communityID]?.tierID
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
