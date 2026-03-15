// Features/Hubs/Forums/DiscussionsFeedView.swift
import SwiftUI

struct DiscussionsFeedView: View {
    let community: Community

    @State private var viewModel: ForumViewModel?
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var showComposeSheet = false
    @State private var showTierSheet = false

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
        if let viewModel {
            // CRITICAL: No ScrollView here -- participates in outer CommunityHubView ScrollView
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 12)

                ForEach(viewModel.threads) { thread in
                    let isCreator = thread.authorId == community.creator.id
                    let isAmbassador = isCreator && community.creator.isAmbassador
                    let authorName = isCreator ? community.creator.name : "Member"
                    let authorImage = isCreator ? community.creator.profileImageName : "person.circle"
                    let threadTierName = viewModel.tierName(for: thread.requiredTierIndex)
                    let canAccess = viewModel.canAccessThread(thread, userTierIndex: userTierIndex)
                    let isLiked = viewModel.likedThreadIDs.contains(thread.id)

                    if canAccess {
                        NavigationLink(value: thread.id) {
                            ForumThreadRow(
                                thread: thread,
                                authorName: authorName,
                                authorProfileImage: authorImage,
                                isCreator: isCreator,
                                isAmbassador: isAmbassador,
                                tierName: threadTierName,
                                isLiked: isLiked,
                                onLike: { viewModel.toggleThreadLike(threadID: thread.id) }
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
            .overlay(alignment: .bottomTrailing) {
                if userTierIndex != nil {
                    Button(action: { showComposeSheet = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(BlossomTheme.violet)
                            .clipShape(Circle())
                            .shadow(color: BlossomTheme.violet.opacity(0.4), radius: 8, y: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(for: UUID.self) { threadID in
                if let thread = viewModel.threads.first(where: { $0.id == threadID }) {
                    ForumThreadDetailView(
                        community: community,
                        thread: thread,
                        viewModel: viewModel
                    )
                }
            }
            .sheet(isPresented: $showComposeSheet) {
                ForumComposeSheet(
                    viewModel: viewModel,
                    userTierName: userTierIndex.map { community.tiers[$0].name } ?? ""
                )
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
                    viewModel = ForumViewModel(community: community)
                }
        }
    }
}
