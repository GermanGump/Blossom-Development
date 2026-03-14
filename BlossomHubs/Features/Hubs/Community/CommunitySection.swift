import Foundation

enum CommunitySection: String, CaseIterable, Identifiable {
    case landing = "Home"
    case posts = "Posts"
    case discussions = "Discussions"
    case faq = "FAQ"
    case videos = "Videos"

    var id: String { rawValue }
    var title: String { rawValue }

    var icon: String {
        switch self {
        case .landing: return "house.fill"
        case .posts: return "doc.text.fill"
        case .discussions: return "bubble.left.and.bubble.right.fill"
        case .faq: return "questionmark.circle.fill"
        case .videos: return "play.rectangle.fill"
        }
    }
}
