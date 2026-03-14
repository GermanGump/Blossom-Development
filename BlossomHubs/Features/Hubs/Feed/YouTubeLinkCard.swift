// Features/Hubs/Feed/YouTubeLinkCard.swift
import SwiftUI

struct YouTubeLinkCard: View {
    let community: Community
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            PostAuthorRow(community: community, post: post)

            Text(post.content)
                .font(BlossomFont.body)
                .foregroundStyle(BlossomTheme.primaryText)

            Button {
                openYouTube()
            } label: {
                VStack(alignment: .leading, spacing: 0) {
                    thumbnailPlaceholder

                    VStack(alignment: .leading, spacing: 4) {
                        Text(videoTitle)
                            .font(BlossomFont.subhead)
                            .foregroundStyle(BlossomTheme.primaryText)
                            .lineLimit(2)

                        HStack(spacing: 6) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.red)
                            Text("Tap to watch on YouTube")
                                .font(BlossomFont.caption)
                                .foregroundStyle(BlossomTheme.secondaryText)
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(BlossomTheme.cardSurface)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(BlossomTheme.cardBorder, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .blossomCard()
    }

    private var thumbnailPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 180)

            Circle()
                .fill(Color.red)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "play.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.white)
                        .offset(x: 2)
                )
        }
    }

    private var videoTitle: String {
        if let url = post.youtubeURL {
            // Use post content as the video title, fallback to URL
            return post.content.isEmpty ? url : String(post.content.prefix(80))
        }
        return post.content
    }

    private func openYouTube() {
        guard let urlString = post.youtubeURL,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
