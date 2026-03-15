import SwiftUI

struct ComposePostView: View {
    @Environment(CommunityStore.self) private var communityStore
    @Environment(SubscriptionStore.self) private var subscriptionStore

    @State private var selectedPostType: PostType = .text
    @State private var content: String = ""
    @State private var tickerInput: String = ""
    @State private var youtubeURL: String = ""
    @State private var selectedCollection: String?
    @State private var selectedTierIndex: Int = 0
    @State private var showSuccess: Bool = false

    private var community: Community? {
        guard let creatorID = subscriptionStore.session.creatorCommunityID else { return nil }
        return communityStore.communities.first { $0.id == creatorID }
    }

    private var existingCollections: [String] {
        guard let community else { return [] }
        return Array(Set(community.posts.compactMap(\.collection))).sorted()
    }

    var body: some View {
        Group {
            if let community {
                Form {
                    // Post Type
                    Section("Post Type") {
                        Picker("Type", selection: $selectedPostType) {
                            Text("Text").tag(PostType.text)
                            Text("Trade").tag(PostType.tradeHighlight)
                            Text("YouTube").tag(PostType.youtubeLink)
                        }
                        .pickerStyle(.segmented)
                    }

                    // Content
                    Section("Content") {
                        TextField("Write your post...", text: $content, axis: .vertical)
                            .lineLimit(5...12)
                    }

                    // Conditional fields based on post type
                    if selectedPostType == .tradeHighlight {
                        Section {
                            TextField("$AMD, $TSLA", text: $tickerInput)
                        } header: {
                            Text("Tickers")
                        } footer: {
                            Text("Separate tickers with commas")
                        }
                    }

                    if selectedPostType == .youtubeLink {
                        Section("YouTube Link") {
                            TextField("https://youtube.com/watch?v=...", text: $youtubeURL)
                                .keyboardType(.URL)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                    }

                    // Organization
                    Section("Organization") {
                        Picker("Collection", selection: $selectedCollection) {
                            Text("None").tag(String?.none)
                            ForEach(existingCollections, id: \.self) { name in
                                Text(name).tag(Optional(name))
                            }
                        }

                        Picker("Minimum Tier", selection: $selectedTierIndex) {
                            ForEach(Array(community.tiers.enumerated()), id: \.offset) { index, tier in
                                Text("\(tier.name) — $\(tier.monthlyPrice)/mo")
                                    .tag(index)
                            }
                        }
                    }

                    // Publish
                    Section {
                        Button {
                            publishPost(community: community)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Publish")
                                    .font(BlossomFont.buttonLabel)
                                Spacer()
                            }
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(content.isEmpty ? BlossomTheme.teal.opacity(0.4) : BlossomTheme.teal)
                        )
                        .foregroundStyle(.white)
                        .disabled(content.isEmpty)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(BlossomTheme.background)
                .overlay {
                    if showSuccess {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(BlossomTheme.teal)

                            Text("Post published!")
                                .font(BlossomFont.headline)
                                .foregroundStyle(BlossomTheme.primaryText)
                        }
                        .padding(32)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Publish Content")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func publishPost(community: Community) {
        let parsedTickers = selectedPostType == .tradeHighlight
            ? parseTickers(from: tickerInput)
            : []

        let newPost = Post(
            authorId: community.creator.id,
            content: content,
            postType: selectedPostType,
            stockTickers: parsedTickers,
            youtubeURL: selectedPostType == .youtubeLink ? youtubeURL : nil,
            requiredTierIndex: selectedTierIndex,
            publishedAt: .now,
            collection: selectedCollection
        )

        communityStore.addPost(to: community.id, post: newPost)

        withAnimation {
            showSuccess = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showSuccess = false
            }
            resetForm()
        }
    }

    private func resetForm() {
        content = ""
        tickerInput = ""
        youtubeURL = ""
        selectedCollection = nil
        selectedTierIndex = 0
        selectedPostType = .text
    }

    private func parseTickers(from input: String) -> [String] {
        let pattern = /\$[A-Za-z.]+/
        return input.matches(of: pattern).map { String($0.output) }
    }
}

#Preview {
    NavigationStack {
        ComposePostView()
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
