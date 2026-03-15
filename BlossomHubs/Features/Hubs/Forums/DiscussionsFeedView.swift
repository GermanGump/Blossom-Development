// Features/Hubs/Forums/DiscussionsFeedView.swift
import SwiftUI

struct DiscussionsFeedView: View {
    let community: Community
    let forumViewModel: ForumViewModel
    @Binding var showComposeSheet: Bool

    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var showTierSheet = false
    @State private var selectedThread: ForumThread?

    /// Resolve the user's tier index within this community's tiers array.
    private var userTierIndex: Int? {
        guard let tierID = subscriptionStore.currentTier(for: community.id) else {
            return nil
        }
        return community.tiers.firstIndex { $0.id == tierID }
    }

    /// Heuristic: second tier is "Most Popular" when 2+ tiers exist.
    private var popularTierIndex: Int {
        community.tiers.count >= 2 ? 1 : 0
    }

    var body: some View {
        // CRITICAL: No ScrollView here -- participates in outer CommunityHubView ScrollView
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 12)

            ForEach(forumViewModel.threads) { thread in
                let isCreator = thread.authorId == community.creator.id
                let isAmbassador = isCreator && community.creator.isAmbassador
                let isCurrentUser = thread.authorId == subscriptionStore.session.id
                let authorName = isCreator ? community.creator.name : (isCurrentUser ? subscriptionStore.session.name : "Member")
                let authorImage = isCreator ? community.creator.profileImageName : (isCurrentUser ? subscriptionStore.session.profileImageName : "person.circle")
                let threadTierName = forumViewModel.tierName(for: thread.requiredTierIndex)
                let canAccess = forumViewModel.canAccessThread(thread, userTierIndex: userTierIndex)
                let isLiked = forumViewModel.likedThreadIDs.contains(thread.id)

                if canAccess {
                    Button {
                        selectedThread = thread
                    } label: {
                        ForumThreadRow(
                            thread: thread,
                            authorName: authorName,
                            authorProfileImage: authorImage,
                            isCreator: isCreator,
                            isAmbassador: isAmbassador,
                            tierName: threadTierName,
                            isLiked: isLiked,
                            onLike: { forumViewModel.toggleThreadLike(threadID: thread.id) }
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    LockedContentOverlay(
                        tierName: threadTierName,
                        onUpgrade: { showTierSheet = true }
                    ) {
                        ForumThreadRow(
                            thread: thread,
                            authorName: authorName,
                            authorProfileImage: authorImage,
                            isCreator: isCreator,
                            isAmbassador: isAmbassador,
                            tierName: threadTierName,
                            isLiked: false,
                            onLike: {}
                        )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .fullScreenCover(item: $selectedThread) { thread in
            NavigationStack {
                ForumThreadDetailView(
                    community: community,
                    thread: thread,
                    viewModel: forumViewModel
                )
            }
        }
        .sheet(isPresented: $showComposeSheet) {
            ForumComposeSheet(
                viewModel: forumViewModel,
                userTierIndex: userTierIndex ?? 0
            )
        }
        .sheet(isPresented: $showTierSheet) {
            TiersBottomSheet(
                community: community,
                tiers: community.tiers,
                popularTierIndex: popularTierIndex
            )
        }
    }
}
