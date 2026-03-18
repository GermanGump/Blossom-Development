import SwiftUI

struct TiersBottomSheet: View {
    let community: Community
    let tiers: [Tier]
    let popularTierIndex: Int
    var onSubscriptionComplete: (() -> Void)? = nil

    @State private var expandedTierID: UUID? = nil
    @State private var tierForPayment: Tier? = nil
    @State private var showChangeTierAlert = false
    @State private var pendingTierChange: PendingTierChange? = nil
    @State private var showCancelRetention = false
    @State private var selectedDetent: PresentationDetent = .medium
    @Environment(\.dismiss) private var dismiss
    @Environment(SubscriptionStore.self) private var subscriptionStore

    private var isManageMode: Bool {
        subscriptionStore.isSubscribed(to: community.id)
    }

    private var currentTierIndex: Int? {
        guard let currentTierID = subscriptionStore.currentTier(for: community.id, in: community) else { return nil }
        return tiers.firstIndex(where: { $0.id == currentTierID })
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Manual header
            HStack {
                Text(isManageMode ? "Your Subscription" : "Choose Your Tier")
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
                        if isManageMode {
                            let isCurrent = subscriptionStore.currentTier(for: community.id, in: community) == tier.id
                            let action: SubscriptionAction? = {
                                guard !isCurrent, let currentIdx = currentTierIndex else { return nil }
                                return index > currentIdx ? .upgrade : .downgrade
                            }()

                            TierCardView(
                                tier: tier,
                                isPopular: index == popularTierIndex,
                                isCurrentPlan: isCurrent,
                                subscriptionAction: action,
                                isExpanded: expandedTierID == tier.id,
                                onTap: {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        expandedTierID = expandedTierID == tier.id ? nil : tier.id
                                    }
                                },
                                onSubscriptionAction: { selectedTier, selectedAction in
                                    pendingTierChange = PendingTierChange(tier: selectedTier, action: selectedAction)
                                    showChangeTierAlert = true
                                }
                            )
                        } else {
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

                    // Cancel button in manage mode
                    if isManageMode {
                        Button("Cancel Subscription") {
                            showCancelRetention = true
                        }
                        .font(BlossomFont.buttonLabel)
                        .foregroundStyle(.red)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    }
                }
                .padding(16)
            }
        }
        .background(BlossomTheme.background)
        .presentationDetents([.medium, .large], selection: $selectedDetent)
        .onChange(of: expandedTierID) {
            if expandedTierID != nil {
                withAnimation { selectedDetent = .large }
            }
        }
        .alert(
            alertTitle,
            isPresented: $showChangeTierAlert,
            presenting: pendingTierChange
        ) { change in
            Button("Confirm") {
                subscriptionStore.changeTier(for: community.id, to: change.tier)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                pendingTierChange = nil
            }
            Button("Cancel", role: .cancel) {
                pendingTierChange = nil
            }
        }
        .sheet(isPresented: $showCancelRetention) {
            CancelRetentionSheet {
                subscriptionStore.cancel(communityID: community.id)
                showCancelRetention = false
                dismiss()
            }
            .presentationDetents([.medium])
        }
        .sheet(item: $tierForPayment) { selectedTier in
            MockPaymentSheetView(
                community: community,
                tier: selectedTier,
                onSuccess: {
                    subscriptionStore.subscribe(to: community, tier: selectedTier)
                    tierForPayment = nil
                    dismiss()
                    onSubscriptionComplete?()
                }
            )
        }
    }

    private var alertTitle: String {
        guard let change = pendingTierChange else { return "" }
        let priceStr = formattedPrice(change.tier.monthlyPrice)
        switch change.action {
        case .upgrade:
            return "Upgrade to \(change.tier.name) for \(priceStr)?"
        case .downgrade:
            return "Downgrade to \(change.tier.name) for \(priceStr)?"
        }
    }

    private func formattedPrice(_ price: Decimal) -> String {
        let decimal = NSDecimalNumber(decimal: price)
        let value = decimal.doubleValue
        if value == 0 {
            return "Free"
        } else if value == Double(Int(value)) {
            return "$\(Int(value))/mo"
        } else {
            return String(format: "$%.2f/mo", value)
        }
    }
}

// MARK: - Pending Tier Change

private struct PendingTierChange: Identifiable {
    let id = UUID()
    let tier: Tier
    let action: SubscriptionAction
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
