import Foundation

// MARK: - Subscription

struct Subscription: Codable, Identifiable, Sendable {
    let id: UUID
    let communityID: UUID
    let tierID: UUID
    let tierName: String
    let monthlyPrice: Decimal
    let subscribedAt: Date
    var hasSeenWelcome: Bool

    init(
        id: UUID = UUID(),
        communityID: UUID,
        tierID: UUID,
        tierName: String,
        monthlyPrice: Decimal,
        subscribedAt: Date = .now,
        hasSeenWelcome: Bool = false
    ) {
        self.id = id
        self.communityID = communityID
        self.tierID = tierID
        self.tierName = tierName
        self.monthlyPrice = monthlyPrice
        self.subscribedAt = subscribedAt
        self.hasSeenWelcome = hasSeenWelcome
    }
}

// MARK: - UserSession

struct UserSession: Codable, Sendable {
    let id: UUID
    let name: String
    let username: String
    let profileImageName: String
    var subscriptions: [UUID: Subscription]
    var creatorCommunityID: UUID?

    init(
        id: UUID = UUID(),
        name: String,
        username: String,
        profileImageName: String,
        subscriptions: [UUID: Subscription] = [:],
        creatorCommunityID: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.profileImageName = profileImageName
        self.subscriptions = subscriptions
        self.creatorCommunityID = creatorCommunityID
    }

    enum CodingKeys: String, CodingKey {
        case id, name, username, profileImageName, subscriptions, creatorCommunityID
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        profileImageName = try container.decode(String.self, forKey: .profileImageName)
        subscriptions = try container.decode([UUID: Subscription].self, forKey: .subscriptions)
        creatorCommunityID = try container.decodeIfPresent(UUID.self, forKey: .creatorCommunityID)
    }
}
