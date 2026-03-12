import SwiftUI

struct TiersBottomSheet: View {
    let community: Community
    let tiers: [Tier]
    let popularTierIndex: Int

    @State private var expandedTierID: UUID? = nil
    @State private var tierForPayment: Tier? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(SubscriptionStore.self) private var subscriptionStore

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Manual header
            HStack {
                Text("Choose Your Tier")
                    .font(BlossomFont.title)
                    .foregroundStyle(BlossomTheme.primaryText)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(BlossomTheme.secondaryText)
                        .frame(width: 32, height: 32)
                        .background(BlossomTheme.cardSurface)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 12)

            Divider()

            // MARK: - Tier cards
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(Array(tiers.enumerated()), id: \.element.id) { index, tier in
                        TierCardView(
                            tier: tier,
                            isPopular: index == popularTierIndex,
                            isExpanded: expandedTierID == tier.id,
                            onTap: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    expandedTierID = expandedTierID == tier.id ? nil : tier.id
                                }
                            },
                            onSubscribe: { selectedTier in
                                tierForPayment = selectedTier
                            }
                        )
                    }
                }
                .padding(16)
            }
        }
        .background(BlossomTheme.background)
        .sheet(item: $tierForPayment) { selectedTier in
            MockPaymentSheetView(
                community: community,
                tier: selectedTier,
                onSuccess: {
                    subscriptionStore.subscribe(to: community, tier: selectedTier)
                    tierForPayment = nil
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    let tiers = [
        Tier(
            name: "Observer",
            monthlyPrice: 0,
            benefits: [
                "Access to free market commentary",
                "Monthly newsletter digest",
                "Community forum (read only)"
            ]
        ),
        Tier(
            name: "Investor",
            monthlyPrice: 19,
            benefits: [
                "Weekly market commentary",
                "Stock watchlist access",
                "Community forum (full access)",
                "Monthly portfolio snapshot"
            ]
        ),
        Tier(
            name: "Pro",
            monthlyPrice: 49,
            benefits: [
                "Real-time trade alerts",
                "Monthly portfolio review call",
                "Direct message access",
                "All Investor tier benefits",
                "Exclusive deep-dive research reports"
            ]
        )
    ]

    let community = Community(
        name: "Preview Community",
        description: "A preview community",
        logoImageName: "logo",
        creator: Creator(name: "Test", username: "@test", profileImageName: "test", bio: "Test bio"),
        tiers: tiers,
        posts: [],
        threads: [],
        faqEntries: [],
        memberCount: 100,
        category: "Investing"
    )

    TiersBottomSheet(community: community, tiers: tiers, popularTierIndex: 1)
        .environment(SubscriptionStore())
}
