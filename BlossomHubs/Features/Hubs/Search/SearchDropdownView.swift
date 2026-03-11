import SwiftUI

struct SearchDropdownView: View {
    let query: String
    let store: CommunityStore

    private var filteredCommunities: [Community] {
        guard !query.isEmpty else { return [] }
        let q = query.lowercased()
        return store.communities.filter { community in
            community.name.lowercased().contains(q) ||
            community.creator.name.lowercased().contains(q) ||
            community.creator.username.lowercased().contains(q)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if filteredCommunities.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "No communities found",
                    subtitle: "Try a different search term"
                )
                .frame(height: 160)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredCommunities) { community in
                            NavigationLink(value: HubsRoute.communityPreview(id: community.id.uuidString)) {
                                HStack(spacing: 10) {
                                    AvatarView(
                                        imageName: community.creator.profileImageName,
                                        preset: .small,
                                        showVerifiedBadge: community.creator.isVerified
                                    )

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(community.name)
                                            .font(BlossomFont.subhead)
                                            .foregroundStyle(BlossomTheme.primaryText)

                                        Text(community.creator.name)
                                            .font(BlossomFont.caption)
                                            .foregroundStyle(BlossomTheme.secondaryText)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                        .foregroundStyle(BlossomTheme.secondaryText)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(.plain)

                            if community.id != filteredCommunities.last?.id {
                                Divider()
                                    .padding(.leading, 54)
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
        }
        .background(BlossomTheme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(BlossomTheme.cardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 16)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

#Preview {
    NavigationStack {
        VStack {
            SearchDropdownView(query: "BD", store: CommunityStore())
            Spacer()
        }
        .padding(.top, 60)
    }
    .background(BlossomTheme.background)
    .environment(CommunityStore())
}
