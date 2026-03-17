// Features/Hubs/Feed/ContentFeedView.swift
import SwiftUI

struct ContentFeedView: View {
    let community: Community
    var filterToVideos: Bool = false

    @State private var viewModel: ContentFeedViewModel?
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var showTierSheet = false
    @State private var adInsertionIndex: Int = Int.random(in: 3...5)

    /// Resolve the user's tier index within this community's tiers array.
    /// Returns nil if not subscribed (all posts locked).
    private var userTierIndex: Int? {
        guard let tierID = subscriptionStore.currentTier(for: community.id, in: community) else {
            return nil
        }
        return community.tiers.firstIndex { $0.id == tierID }
    }

    /// Heuristic: second tier is "Most Popular" when 2+ tiers exist.
    private var popularTierIndex: Int {
        community.tiers.count >= 2 ? 1 : 0
    }

    var body: some View {
        if let viewModel {
            // CRITICAL: No ScrollView here — participates in outer CommunityHubView ScrollView
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 12)

                if !filterToVideos {
                    CollectionFilterPicker(
                        collections: viewModel.collections,
                        selectedCollection: Binding(
                            get: { viewModel.selectedCollection },
                            set: { viewModel.selectedCollection = $0 }
                        )
                    )
                }

                LazyVStack(spacing: 16) {
                    ForEach(Array(viewModel.filteredPosts.enumerated()), id: \.element.id) { index, post in
                        if index == adInsertionIndex {
                            InlineCardAdView()
                        }

                        let isLocked = !viewModel.canAccess(
                            post: post,
                            userTierIndex: userTierIndex
                        )
                        let requiredTierName = viewModel.tierName(
                            for: post.requiredTierIndex
                        )

                        PostCardView(
                            community: community,
                            post: post,
                            isLocked: isLocked,
                            requiredTierName: requiredTierName,
                            onUpgrade: { showTierSheet = true }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .sheet(isPresented: $showTierSheet) {
                TiersBottomSheet(
                    community: community,
                    tiers: community.tiers,
                    popularTierIndex: popularTierIndex
                )
            }
        } else {
            ProgressView()
                .frame(maxWidth: .infinity, minHeight: 200)
                .onAppear {
                    viewModel = ContentFeedViewModel(
                        community: community,
                        filterToVideos: filterToVideos
                    )
                }
        }
    }
}
