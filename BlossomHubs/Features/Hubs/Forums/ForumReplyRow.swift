// Features/Hubs/Forums/ForumReplyRow.swift
import SwiftUI

struct ForumReplyRow: View {
    let reply: ForumReply
    let profileImage: String
    let isLiked: Bool
    let onLike: () -> Void
    var isNested: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AvatarView(
                imageName: profileImage,
                preset: .small,
                showVerifiedBadge: reply.isCreator || reply.isAmbassador
            )

            VStack(alignment: .leading, spacing: 6) {
                // Author row
                HStack(spacing: 4) {
                    Text(reply.authorName)
                        .font(BlossomFont.subhead)
                        .fontWeight(.semibold)
                        .foregroundStyle(BlossomTheme.primaryText)

                    if reply.isCreator || reply.isAmbassador {
                        TagView(reply.isCreator ? "Creator" : "Ambassador", style: .role)
                    } else {
                        TagView(reply.authorTierName, style: .tier)
                    }

                    Text("·")
                        .foregroundStyle(BlossomTheme.secondaryText)

                    Text(reply.publishedAt, format: .relative(presentation: .named))
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)

                    Spacer()
                }

                // Reply content
                Text(reply.content)
                    .font(BlossomFont.body)
                    .foregroundStyle(BlossomTheme.primaryText)

                // Action row
                HStack(spacing: 16) {
                    Text("Reply")
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)

                    Spacer()

                    Button(action: onLike) {
                        HStack(spacing: 4) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 13))
                                .foregroundStyle(isLiked ? .red : BlossomTheme.secondaryText)
                            Text("\(reply.likeCount + (isLiked ? 1 : 0))")
                                .font(BlossomFont.caption)
                                .foregroundStyle(BlossomTheme.secondaryText)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, isNested ? 0 : 16)
        .padding(.leading, isNested ? 44 : 0)
        .background(
            (reply.isCreator || reply.isAmbassador)
                ? BlossomTheme.teal.opacity(0.08)
                : Color.clear
        )
    }
}
