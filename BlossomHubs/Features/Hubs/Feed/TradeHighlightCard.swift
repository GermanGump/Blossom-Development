// Features/Hubs/Feed/TradeHighlightCard.swift
import SwiftUI

struct TradeHighlightCard: View {
    let community: Community
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            PostAuthorRow(community: community, post: post)

            Text(post.content)
                .font(BlossomFont.body)
                .foregroundStyle(BlossomTheme.primaryText)

            if !post.stockTickers.isEmpty {
                tickerMetricsRow
            }
        }
        .padding(16)
        .blossomCard()
    }

    private var tickerMetricsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(post.stockTickers, id: \.self) { ticker in
                    let data = TickerPriceLookup.lookup(ticker)
                    HStack(spacing: 6) {
                        TagView(ticker, style: .stock)

                        Text(data.price)
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.primaryText)

                        Text(data.change)
                            .font(BlossomFont.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(data.isPositive ? .green : .red)
                    }
                }
            }
        }
    }
}
