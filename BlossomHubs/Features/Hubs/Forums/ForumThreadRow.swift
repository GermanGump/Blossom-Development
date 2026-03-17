// Features/Hubs/Forums/ForumThreadRow.swift
import SwiftUI

struct ForumThreadRow: View {
    let thread: ForumThread
    let authorName: String
    let authorProfileImage: String
    let isCreator: Bool
    let isAmbassador: Bool
    let tierName: String
    var tierColor: Color? = nil
    let isLiked: Bool
    let onLike: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                AvatarView(
                    imageName: authorProfileImage,
                    preset: .small,
                    showVerifiedBadge: isCreator || isAmbassador
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(thread.title)
                        .font(BlossomFont.subhead)
                        .foregroundStyle(BlossomTheme.primaryText)
                        .lineLimit(2)

                    HStack(spacing: 6) {
                        Text(authorName)
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)

                        TagView(tierName, style: .tier, customColor: tierColor)

                        if isCreator {
                            TagView("Creator", style: .role)
                        } else if isAmbassador {
                            TagView("Ambassador", style: .role)
                        }

                        Spacer()

                        Text(thread.publishedAt, format: .relative(presentation: .named))
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                    }
                }

                VStack(spacing: 8) {
                    HStack(spacing: 3) {
                        Image(systemName: "bubble.right")
                            .font(.system(size: 12))
                            .foregroundStyle(BlossomTheme.secondaryText)
                        Text("\(thread.replyCount)")
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                    }

                    Button(action: onLike) {
                        HStack(spacing: 3) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 12))
                                .foregroundStyle(isLiked ? .red : BlossomTheme.secondaryText)
                            Text("\(thread.likeCount + (isLiked ? 1 : 0))")
                                .font(BlossomFont.caption)
                                .foregroundStyle(BlossomTheme.secondaryText)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                (isCreator || isAmbassador)
                    ? BlossomTheme.teal.opacity(0.08)
                    : Color.clear
            )

            Divider()
                .padding(.leading, 54)
        }
    }
}
