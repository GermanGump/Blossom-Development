import Foundation

// MARK: - Subscription

struct Subscription: Codable, Identifiable, Sendable {
    let id: UUID
    let communityID: UUID
    let tierID: UUID
    let tierName: String
    let monthlyPrice: Decimal
    let subscribedAt: Date

    init(
        id: UUID = UUID(),
        communityID: UUID,
        tierID: UUID,
        tierName: String,
        monthlyPrice: Decimal,
        subscribedAt: Date = .now
    ) {
        self.id = id
        self.communityID = communityID
        self.tierID = tierID
        self.tierName = tierName
        self.monthlyPrice = monthlyPrice
        self.subscribedAt = subscribedAt
    }
}

// MARK: - UserSession

struct UserSession: Codable, Sendable {
    let name: String
    let username: String
    let profileImageName: String
    var subscriptions: [UUID: Subscription]
}
