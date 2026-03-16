import SwiftUI

struct TierEditorView: View {
    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var editingTier: Tier?

    private var community: Community? {
        guard let id = subscriptionStore.session.creatorCommunityID else { return nil }
        return store.communities.first(where: { $0.id == id })
    }

    private var communityID: UUID? {
        subscriptionStore.session.creatorCommunityID
    }

    var body: some View {
        Group {
            if let community, let communityID {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(community.tiers) { tier in
                            Button {
                                editingTier = tier
                            } label: {
                                tierCard(tier)
                            }
                            .buttonStyle(.plain)
                        }

                        if community.tiers.count < 4 {
                            Button {
                                let newTier = Tier(
                                    name: "New Tier",
                                    monthlyPrice: 9,
                                    benefits: ["Benefit 1"]
                                )
                                store.updateCommunity(id: communityID) { c in
                                    c.tiers.append(newTier)
                                }
                                editingTier = newTier
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 18))
                                    Text("Add Tier")
                                        .font(BlossomFont.subhead)
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(BlossomTheme.violet)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(BlossomTheme.violet, lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .sheet(item: $editingTier) { tier in
                    TierEditSheet(
                        tier: tier,
                        communityID: communityID,
                        store: store
                    )
                }
            } else {
                Text("No community found")
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
        }
        .background(BlossomTheme.background)
        .navigationTitle("Manage Tiers")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func tierCard(_ tier: Tier) -> some View {
        HStack {
            Circle()
                .fill(tier.color)
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 4) {
                Text(tier.name)
                    .font(BlossomFont.subhead)
                    .fontWeight(.semibold)
                    .foregroundStyle(BlossomTheme.primaryText)

                Text("$\(tier.monthlyPrice as NSDecimalNumber)/mo")
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.secondaryText)
            }

            Spacer()

            Text("\(tier.benefits.count) benefit\(tier.benefits.count == 1 ? "" : "s")")
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.secondaryText)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(BlossomTheme.secondaryText)
        }
        .padding(16)
        .blossomCard()
    }
}

#Preview {
    NavigationStack {
        TierEditorView()
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
