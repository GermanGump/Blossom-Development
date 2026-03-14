// Features/Hubs/Feed/TextPostCard.swift
import SwiftUI

struct TextPostCard: View {
    let community: Community
    let post: Post

    @State private var isExpanded = false
    @State private var isTruncated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            PostAuthorRow(community: community, post: post)

            Text(post.content)
                .font(BlossomFont.body)
                .foregroundStyle(BlossomTheme.primaryText)
                .lineLimit(isExpanded ? nil : 4)
                .background(
                    ViewThatFits(in: .vertical) {
                        Text(post.content)
                            .font(BlossomFont.body)
                            .hidden()
                        Color.clear
                            .onAppear { isTruncated = true }
                    }
                    .hidden()
                )

            if isTruncated {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Text(isExpanded ? "Show less" : "Read more")
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.violet)
                }
            }
        }
        .padding(16)
        .blossomCard()
    }
}
