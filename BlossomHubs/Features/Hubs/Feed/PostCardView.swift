// Features/Hubs/Feed/PostCardView.swift
import SwiftUI

struct PostCardView: View {
    let community: Community
    let post: Post
    let isLocked: Bool
    let requiredTierName: String
    let onUpgrade: () -> Void

    var body: some View {
        if isLocked {
            lockedCard
        } else {
            unlockedCard
        }
    }

    @ViewBuilder
    private var unlockedCard: some View {
        switch post.postType {
        case .text:
            TextPostCard(community: community, post: post)
        case .tradeHighlight:
            TradeHighlightCard(community: community, post: post)
        case .youtubeLink:
            YouTubeLinkCard(community: community, post: post)
        }
    }

    private var lockedCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            PostAuthorRow(community: community, post: post)

            postTypeIndicator

            if post.postType == .tradeHighlight && !post.stockTickers.isEmpty {
                HStack(spacing: 6) {
                    ForEach(post.stockTickers, id: \.self) { ticker in
                        TagView(ticker, style: .stock)
                    }
                }
            }

            LockedContentOverlay(
                tierName: requiredTierName,
                onUpgrade: onUpgrade
            ) {
                Text(post.content)
                    .font(BlossomFont.body)
                    .foregroundStyle(BlossomTheme.primaryText)
                    .lineLimit(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            }
        }
        .padding(16)
        .blossomCard()
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    @ViewBuilder
    private var postTypeIndicator: some View {
        switch post.postType {
        case .text:
            EmptyView()
        case .tradeHighlight:
            HStack(spacing: 4) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 12))
                Text("Trade Highlight")
                    .font(BlossomFont.caption)
            }
            .foregroundStyle(BlossomTheme.orange)
        case .youtubeLink:
            HStack(spacing: 4) {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 12))
                Text("Video")
                    .font(BlossomFont.caption)
            }
            .foregroundStyle(.red)
        }
    }
}
