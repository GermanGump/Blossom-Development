// Features/Hubs/Forums/ForumThreadDetailView.swift
import SwiftUI

struct ForumThreadDetailView: View {
    let community: Community
    let thread: ForumThread
    let viewModel: ForumViewModel

    @State private var replyText = ""
    @Environment(SubscriptionStore.self) private var subscriptionStore

    /// Resolve the user's tier index within this community's tiers array.
    private var userTierIndex: Int? {
        guard let tierID = subscriptionStore.currentTier(for: community.id) else {
            return nil
        }
        return community.tiers.firstIndex { $0.id == tierID }
    }

    private var userTierName: String {
        guard let idx = userTierIndex, idx < community.tiers.count else { return "Member" }
        return community.tiers[idx].name
    }

    private var isCreatorThread: Bool {
        thread.authorId == community.creator.id
    }

    private var threadReplies: [ForumReply] {
        viewModel.replies[thread.id] ?? []
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Original post
                    originalPostSection

                    Divider()

                    // Replies header
                    Text("Replies (\(threadReplies.count))")
                        .font(BlossomFont.headline)
                        .foregroundColor(BlossomTheme.primaryText)
                        .padding(.horizontal, 16)

                    // Replies list
                    LazyVStack(spacing: 4) {
                        ForEach(threadReplies) { reply in
                            let profileImg = (reply.isCreator || reply.isAmbassador)
                                ? community.creator.profileImageName
                                : "person.circle"

                            ForumReplyRow(
                                reply: reply,
                                profileImage: profileImg,
                                isLiked: viewModel.likedReplyIDs.contains(reply.id),
                                onLike: { viewModel.toggleReplyLike(replyID: reply.id) }
                            )
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.vertical, 16)
            }

            // Reply input bar
            replyInputBar
        }
        .navigationTitle(thread.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Original Post

    @ViewBuilder
    private var originalPostSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Author row
            HStack(spacing: 8) {
                AvatarView(
                    image: Image(systemName: isCreatorThread ? community.creator.profileImageName : "person.circle"),
                    showVerifiedBadge: isCreatorThread,
                    size: AvatarSize.medium.rawValue
                )

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(isCreatorThread ? community.creator.name : "Member")
                            .font(BlossomFont.subhead)
                            .foregroundColor(BlossomTheme.primaryText)

                        TagView(viewModel.tierName(for: thread.requiredTierIndex), style: .tier)

                        if isCreatorThread {
                            TagView("Creator", style: .role)
                        }
                    }

                    Text(thread.publishedAt, format: .relative(presentation: .named))
                        .font(BlossomFont.caption)
                        .foregroundColor(BlossomTheme.secondaryText)
                }

                Spacer()
            }

            // Thread title
            Text(thread.title)
                .font(BlossomFont.headline)
                .foregroundColor(BlossomTheme.primaryText)

            // Thread content
            Text(thread.content)
                .font(BlossomFont.body)
                .foregroundColor(BlossomTheme.primaryText)

            // Like button row
            Button(action: { viewModel.toggleThreadLike(threadID: thread.id) }) {
                HStack(spacing: 4) {
                    let isLiked = viewModel.likedThreadIDs.contains(thread.id)
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundColor(isLiked ? .red : BlossomTheme.secondaryText)
                    Text("\(thread.likeCount + (viewModel.likedThreadIDs.contains(thread.id) ? 1 : 0))")
                        .font(BlossomFont.caption)
                        .foregroundColor(BlossomTheme.secondaryText)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Reply Input Bar

    @ViewBuilder
    private var replyInputBar: some View {
        Divider()
        HStack(spacing: 10) {
            TextField("Write a reply...", text: $replyText)
                .font(BlossomFont.body)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(BlossomTheme.cardSurface)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Button(action: sendReply) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(replyText.isEmpty ? BlossomTheme.secondaryText : BlossomTheme.violet)
            }
            .disabled(replyText.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(BlossomTheme.background)
    }

    private func sendReply() {
        guard !replyText.isEmpty else { return }
        viewModel.addReply(
            threadID: thread.id,
            authorName: subscriptionStore.session.name,
            authorTierName: userTierName,
            content: replyText
        )
        replyText = ""
    }
}
