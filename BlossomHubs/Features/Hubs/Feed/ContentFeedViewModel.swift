// Features/Hubs/Feed/ContentFeedViewModel.swift
import Foundation

@MainActor
@Observable
final class ContentFeedViewModel {
    let community: Community
    var selectedCollection: String? = nil
    let filterToVideos: Bool

    var collections: [String] {
        let names = Set(community.posts.compactMap { $0.collection })
        return names.sorted()
    }

    var filteredPosts: [Post] {
        var posts = community.posts.sorted { $0.publishedAt > $1.publishedAt }

        if filterToVideos {
            posts = posts.filter { $0.postType == .youtubeLink }
        }

        if let collection = selectedCollection {
            posts = posts.filter { $0.collection == collection }
        }

        return posts
    }

    func canAccess(post: Post, userTierIndex: Int?) -> Bool {
        guard let userIndex = userTierIndex else { return false }
        return post.requiredTierIndex <= userIndex
    }

    func tierName(for requiredIndex: Int) -> String {
        guard requiredIndex < community.tiers.count else { return "Premium" }
        return community.tiers[requiredIndex].name
    }

    init(community: Community, filterToVideos: Bool = false) {
        self.community = community
        self.filterToVideos = filterToVideos
    }
}
