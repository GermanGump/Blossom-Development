import SwiftUI

struct CategoryExploreView: View {
    let categoryName: String

    @Environment(CommunityStore.self) private var store
    @State private var cardsVisible = false
    @State private var adCadence: Int = Int.random(in: 6...8)

    private var realCommunities: [Community] {
        store.communities
            .filter { CategoryMapping.displayName(for: $0.category) == categoryName }
            .sorted { $0.memberCount > $1.memberCount }
    }

    private var mockCommunities: [Community] {
        CategoryMockData.communities(for: categoryName)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Real communities first
                ForEach(Array(realCommunities.enumerated()), id: \.element.id) { index, community in
                    let totalIndex = index
                    CommunityCardView(community: community)
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                        .animation(
                            .easeOut(duration: 0.35).delay(Double(index) * 0.06),
                            value: cardsVisible
                        )
                    if (totalIndex + 1).isMultiple(of: adCadence) {
                        PillAdView()
                    }
                }

                if !realCommunities.isEmpty && !mockCommunities.isEmpty {
                    HStack {
                        Rectangle()
                            .fill(BlossomTheme.cardBorder)
                            .frame(height: 1)
                        Text("More Communities")
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                        Rectangle()
                            .fill(BlossomTheme.cardBorder)
                            .frame(height: 1)
                    }
                    .padding(.vertical, 4)
                }

                // Mock communities
                ForEach(Array(mockCommunities.enumerated()), id: \.element.id) { index, community in
                    let totalIndex = realCommunities.count + index
                    mockCommunityCard(community)
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                        .animation(
                            .easeOut(duration: 0.35)
                                .delay(Double(totalIndex) * 0.06),
                            value: cardsVisible
                        )
                    if (totalIndex + 1).isMultiple(of: adCadence) {
                        PillAdView()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(BlossomTheme.background)
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard !cardsVisible else { return }
            cardsVisible = true
        }
    }

    private func mockCommunityCard(_ community: Community) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Placeholder avatar with initials
            ZStack {
                Circle()
                    .fill(Color.fromHex(community.tiers.first?.colorHex ?? "7C3AED").opacity(0.2))
                    .frame(width: 48, height: 48)
                Text(initials(from: community.creator.name))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.fromHex(community.tiers.first?.colorHex ?? "7C3AED"))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(community.name)
                    .font(BlossomFont.subhead)
                    .fontWeight(.semibold)
                    .foregroundStyle(BlossomTheme.primaryText)

                Text(community.creator.name)
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.secondaryText)

                Text(community.description)
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.secondaryText)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    HStack(spacing: 3) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(BlossomTheme.secondaryText)
                        Text("\(community.memberCount)")
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                    }

                    TagView(community.category, style: .category)

                    Spacer()

                    if let minPrice = community.tiers.map(\.monthlyPrice).filter({ $0 > 0 }).min() {
                        Text("From $\(minPrice)/mo")
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.violet)
                    }
                }
            }
        }
        .padding(14)
        .blossomCard()
    }

    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
        }
        return String(name.prefix(2)).uppercased()
    }
}

#Preview {
    NavigationStack {
        CategoryExploreView(categoryName: "Trading Hubs")
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
