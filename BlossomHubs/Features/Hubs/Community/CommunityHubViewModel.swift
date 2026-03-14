import Foundation

@MainActor
@Observable
final class CommunityHubViewModel {
    let community: Community
    var selectedSection: CommunitySection = .landing

    var availableSections: [CommunitySection] {
        var sections: [CommunitySection] = [.landing]
        if !community.posts.isEmpty { sections.append(.posts) }
        if !community.threads.isEmpty { sections.append(.discussions) }
        if !community.faqEntries.isEmpty { sections.append(.faq) }
        let hasVideos = community.posts.contains { $0.postType == .youtubeLink }
        if hasVideos { sections.append(.videos) }
        return sections
    }

    init(community: Community) {
        self.community = community
    }
}
