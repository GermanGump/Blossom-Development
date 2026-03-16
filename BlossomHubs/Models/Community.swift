import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0
        }
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - PostType

enum PostType: String, Codable, CaseIterable {
    case text
    case tradeHighlight
    case youtubeLink
}

// MARK: - Creator

struct Creator: Identifiable {
    let id: UUID
    var name: String
    var username: String
    var profileImageName: String
    var isVerified: Bool
    var isAmbassador: Bool
    var bio: String

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

struct Tier: Identifiable, Hashable {
    let id: UUID
    var name: String
    var monthlyPrice: Decimal
    var benefits: [String]
    var colorHex: String

    init(
        id: UUID = UUID(),
        name: String,
        monthlyPrice: Decimal,
        benefits: [String],
        colorHex: String = "7C3AED"
    ) {
        self.id = id
        self.name = name
        self.monthlyPrice = monthlyPrice
        self.benefits = benefits
        self.colorHex = colorHex
    }

    var color: Color {
        Color(hex: colorHex)
    }
}

// MARK: - Post

struct Post: Identifiable {
    let id: UUID
    var authorId: UUID
    var content: String
    var postType: PostType
    var stockTickers: [String]
    var youtubeURL: String?
    var requiredTierIndex: Int
    var publishedAt: Date
    var collection: String?

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
    var title: String
    var content: String
    var authorId: UUID
    var requiredTierIndex: Int
    var replyCount: Int
    var likeCount: Int
    var publishedAt: Date

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

// MARK: - ForumReply

struct ForumReply: Identifiable {
    let id: UUID
    var threadID: UUID
    var authorId: UUID
    var authorName: String
    var authorTierName: String
    var content: String
    var likeCount: Int
    var publishedAt: Date
    var isCreator: Bool
    var isAmbassador: Bool

    init(
        id: UUID = UUID(),
        threadID: UUID,
        authorId: UUID,
        authorName: String,
        authorTierName: String,
        content: String,
        likeCount: Int = 0,
        publishedAt: Date,
        isCreator: Bool = false,
        isAmbassador: Bool = false
    ) {
        self.id = id
        self.threadID = threadID
        self.authorId = authorId
        self.authorName = authorName
        self.authorTierName = authorTierName
        self.content = content
        self.likeCount = likeCount
        self.publishedAt = publishedAt
        self.isCreator = isCreator
        self.isAmbassador = isAmbassador
    }
}

// MARK: - FAQEntry

struct FAQEntry: Identifiable {
    let id: UUID
    var question: String
    var answer: String?
    var isAnswered: Bool
    var askedBy: String
    var answeredBy: String?

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
    var name: String
    var description: String
    var logoImageName: String
    var logoImageData: Data?
    var bannerImageName: String?
    var bannerImageData: Data?
    var creator: Creator
    var tiers: [Tier]
    var posts: [Post]
    var threads: [ForumThread]
    var faqEntries: [FAQEntry]
    var memberCount: Int
    var category: String
    var permissions: [String: Set<Int>]

    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        logoImageName: String,
        logoImageData: Data? = nil,
        bannerImageName: String? = nil,
        bannerImageData: Data? = nil,
        creator: Creator,
        tiers: [Tier],
        posts: [Post],
        threads: [ForumThread],
        faqEntries: [FAQEntry],
        memberCount: Int,
        category: String,
        permissions: [String: Set<Int>] = [:]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.logoImageName = logoImageName
        self.logoImageData = logoImageData
        self.bannerImageName = bannerImageName
        self.bannerImageData = bannerImageData
        self.creator = creator
        self.tiers = tiers
        self.posts = posts
        self.threads = threads
        self.faqEntries = faqEntries
        self.memberCount = memberCount
        self.category = category
        self.permissions = permissions
    }
}
