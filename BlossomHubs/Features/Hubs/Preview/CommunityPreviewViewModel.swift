import Foundation

@MainActor
@Observable
final class CommunityPreviewViewModel {
    var community: Community
    var showTiers = false

    // Heuristic: second tier (index 1) is "Most Popular" when 2+ tiers exist,
    // otherwise first tier (index 0) gets the badge.
    var popularTierIndex: Int {
        community.tiers.count >= 2 ? 1 : 0
    }

    init(community: Community) {
        self.community = community
    }
}
