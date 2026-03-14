// Features/Hubs/Feed/PostAuthorRow.swift
import SwiftUI

struct PostAuthorRow: View {
    let community: Community
    let post: Post

    var body: some View {
        HStack(spacing: 10) {
            AvatarView(
                imageName: community.creator.profileImageName,
                preset: .small,
                showVerifiedBadge: community.creator.isVerified
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(community.creator.name)
                    .font(BlossomFont.subhead)
                    .foregroundStyle(BlossomTheme.primaryText)
                Text(post.publishedAt.formatted(.relative(presentation: .named)))
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.secondaryText)
            }

            Spacer()
        }
    }
}
