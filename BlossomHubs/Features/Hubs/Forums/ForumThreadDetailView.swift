// Features/Hubs/Forums/ForumThreadDetailView.swift
import SwiftUI

struct ForumThreadDetailView: View {
    let community: Community
    let thread: ForumThread
    let viewModel: ForumViewModel

    @State private var replyText = ""
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @Environment(\.dismiss) private var dismiss

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

    private var isLiked: Bool {
        viewModel.likedThreadIDs.contains(thread.id)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Original post
                    originalPostSection

                    // Engagement stats bar
                    engagementBar
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)

                    Divider()
                        .padding(.horizontal, 16)

                    // Sort label
                    HStack {
                        Text("Most Recent")
                            .font(BlossomFont.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(BlossomTheme.primaryText)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(BlossomTheme.primaryText)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)

                    // Replies list
                    LazyVStack(spacing: 0) {
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

                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                }
            }

            // Reply input bar
            replyInputBar
        }
        .navigationTitle(thread.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(BlossomFont.subhead)
                    }
                    .foregroundStyle(BlossomTheme.violet)
                }
            }
        }
    }

    // MARK: - Original Post

    @ViewBuilder
    private var originalPostSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Author row
            HStack(spacing: 10) {
                AvatarView(
                    imageName: isCreatorThread ? community.creator.profileImageName : "person.circle",
                    preset: .medium,
                    showVerifiedBadge: isCreatorThread
                )

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(isCreatorThread ? community.creator.name : "Member")
                            .font(BlossomFont.subhead)
                            .fontWeight(.semibold)
                            .foregroundColor(BlossomTheme.primaryText)

                        if isCreatorThread {
                            TagView("Creator", style: .role)
                        }

                        TagView(viewModel.tierName(for: thread.requiredTierIndex), style: .tier, customColor: viewModel.tierColor(for: thread.requiredTierIndex))
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
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    // MARK: - Engagement Stats Bar

    @ViewBuilder
    private var engagementBar: some View {
        HStack(spacing: 20) {
            // Likes
            Button(action: { viewModel.toggleThreadLike(threadID: thread.id) }) {
                HStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundColor(isLiked ? .red : BlossomTheme.secondaryText)
                    Text("\(thread.likeCount + (isLiked ? 1 : 0))")
                        .font(BlossomFont.caption)
                        .foregroundColor(BlossomTheme.secondaryText)
                }
            }
            .buttonStyle(.plain)

            // Comments
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                    .font(.system(size: 15))
                    .foregroundColor(BlossomTheme.secondaryText)
                Text("\(threadReplies.count)")
                    .font(BlossomFont.caption)
                    .foregroundColor(BlossomTheme.secondaryText)
            }

            // Share
            HStack(spacing: 4) {
                Image(systemName: "arrowshape.turn.up.right")
                    .font(.system(size: 15))
                    .foregroundColor(BlossomTheme.secondaryText)
                Text("0")
                    .font(BlossomFont.caption)
                    .foregroundColor(BlossomTheme.secondaryText)
            }

            Spacer()

            // Bookmark
            Image(systemName: "bookmark")
                .font(.system(size: 15))
                .foregroundColor(BlossomTheme.secondaryText)
        }
    }

    // MARK: - Reply Input Bar

    @ViewBuilder
    private var replyInputBar: some View {
        Divider()
        HStack(spacing: 10) {
            AvatarView(
                imageName: subscriptionStore.session.profileImageName,
                preset: .small,
                showVerifiedBadge: false
            )

            TextField("Add Comment", text: $replyText)
                .font(BlossomFont.body)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(BlossomTheme.cardSurface)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Button(action: sendReply) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(replyText.isEmpty ? BlossomTheme.secondaryText : BlossomTheme.teal)
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
