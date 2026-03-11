import Foundation

// MARK: - PostType

enum PostType: String, Codable, CaseIterable {
    case text
    case tradeHighlight
    case youtubeLink
}

// MARK: - Creator

struct Creator: Identifiable {
    let id: UUID
    let name: String
    let username: String
    let profileImageName: String
    let isVerified: Bool
    let isAmbassador: Bool
    let bio: String

    init(
        id: UUID = UUID(),
        name: String,
        username: String,
        profileImageName: String,
        isVerified: Bool = true,
        isAmbassador: Bool = true,
        bio: String
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.profileImageName = profileImageName
        self.isVerified = isVerified
        self.isAmbassador = isAmbassador
        self.bio = bio
    }
}

// MARK: - Tier

struct Tier: Identifiable {
    let id: UUID
    let name: String
    let monthlyPrice: Decimal
    let benefits: [String]

    init(
        id: UUID = UUID(),
        name: String,
        monthlyPrice: Decimal,
        benefits: [String]
    ) {
        self.id = id
        self.name = name
        self.monthlyPrice = monthlyPrice
        self.benefits = benefits
    }
}

// MARK: - Post

struct Post: Identifiable {
    let id: UUID
    let authorId: UUID
    let content: String
    let postType: PostType
    let stockTickers: [String]
    let youtubeURL: String?
    let requiredTierIndex: Int
    let publishedAt: Date
    let collection: String?

    init(
        id: UUID = UUID(),
        authorId: UUID,
        content: String,
        postType: PostType = .text,
        stockTickers: [String] = [],
        youtubeURL: String? = nil,
        requiredTierIndex: Int = 0,
        publishedAt: Date,
        collection: String? = nil
    ) {
        self.id = id
        self.authorId = authorId
        self.content = content
        self.postType = postType
        self.stockTickers = stockTickers
        self.youtubeURL = youtubeURL
        self.requiredTierIndex = requiredTierIndex
        self.publishedAt = publishedAt
        self.collection = collection
    }
}

// MARK: - ForumThread

struct ForumThread: Identifiable {
    let id: UUID
    let title: String
    let content: String
    let authorId: UUID
    let requiredTierIndex: Int
    let replyCount: Int
    let likeCount: Int
    let publishedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        authorId: UUID,
        requiredTierIndex: Int = 0,
        replyCount: Int = 0,
        likeCount: Int = 0,
        publishedAt: Date
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.authorId = authorId
        self.requiredTierIndex = requiredTierIndex
        self.replyCount = replyCount
        self.likeCount = likeCount
        self.publishedAt = publishedAt
    }
}

// MARK: - FAQEntry

struct FAQEntry: Identifiable {
    let id: UUID
    let question: String
    let answer: String?
    let isAnswered: Bool
    let askedBy: String
    let answeredBy: String?

    init(
        id: UUID = UUID(),
        question: String,
        answer: String? = nil,
        isAnswered: Bool = false,
        askedBy: String,
        answeredBy: String? = nil
    ) {
        self.id = id
        self.question = question
        self.answer = answer
        self.isAnswered = isAnswered
        self.askedBy = askedBy
        self.answeredBy = answeredBy
    }
}

// MARK: - Community

struct Community: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let logoImageName: String
    let bannerImageName: String?
    let creator: Creator
    let tiers: [Tier]
    let posts: [Post]
    let threads: [ForumThread]
    let faqEntries: [FAQEntry]
    let memberCount: Int
    let category: String

    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        logoImageName: String,
        bannerImageName: String? = nil,
        creator: Creator,
        tiers: [Tier],
        posts: [Post],
        threads: [ForumThread],
        faqEntries: [FAQEntry],
        memberCount: Int,
        category: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.logoImageName = logoImageName
        self.bannerImageName = bannerImageName
        self.creator = creator
        self.tiers = tiers
        self.posts = posts
        self.threads = threads
        self.faqEntries = faqEntries
        self.memberCount = memberCount
        self.category = category
    }
}
