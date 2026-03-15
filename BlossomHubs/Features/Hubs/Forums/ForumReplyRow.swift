// Features/Hubs/Forums/ForumReplyRow.swift
import SwiftUI

struct ForumReplyRow: View {
    let reply: ForumReply
    let profileImage: String
    let isLiked: Bool
    let onLike: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Author row
            HStack(spacing: 6) {
                AvatarView(
                    image: Image(systemName: profileImage),
                    showVerifiedBadge: reply.isCreator || reply.isAmbassador,
                    size: AvatarSize.small.rawValue
                )

                Text(reply.authorName)
                    .font(BlossomFont.subhead)
                    .foregroundColor(BlossomTheme.primaryText)

                TagView(reply.authorTierName, style: .tier)

                if reply.isCreator {
                    TagView("Creator", style: .role)
                } else if reply.isAmbassador {
                    TagView("Ambassador", style: .role)
                }

                Spacer()

                Text(reply.publishedAt, format: .relative(presentation: .named))
                    .font(BlossomFont.caption)
                    .foregroundColor(BlossomTheme.secondaryText)
            }

            // Reply content
            Text(reply.content)
                .font(BlossomFont.body)
                .foregroundColor(BlossomTheme.primaryText)

            // Like button
            Button(action: onLike) {
                HStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 14))
                        .foregroundColor(isLiked ? .red : BlossomTheme.secondaryText)
                    Text("\(reply.likeCount + (isLiked ? 1 : 0))")
                        .font(BlossomFont.caption)
                        .foregroundColor(BlossomTheme.secondaryText)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(
            (reply.isCreator || reply.isAmbassador)
                ? BlossomTheme.teal.opacity(0.08)
                : Color.clear
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
