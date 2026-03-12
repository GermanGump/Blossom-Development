import SwiftUI

struct MySubscriptionsView: View {
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @Environment(CommunityStore.self) private var communityStore

    #if DEBUG
    @State private var showResetAlert = false
    #endif

    private var subscriptions: [Subscription] {
        Array(subscriptionStore.session.subscriptions.values)
            .sorted { $0.subscribedAt < $1.subscribedAt }
    }

    private var totalMonthly: Decimal {
        subscriptions.reduce(Decimal.zero) { $0 + $1.monthlyPrice }
    }

    private var formattedTotal: String {
        let decimal = NSDecimalNumber(decimal: totalMonthly)
        let value = decimal.doubleValue
        if value == Double(Int(value)) {
            return "$\(Int(value))/mo"
        } else {
            return String(format: "$%.2f/mo", value)
        }
    }

    private func communityName(for communityID: UUID) -> String {
        communityStore.communities.first(where: { $0.id == communityID })?.name ?? "Unknown Community"
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
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

    var body: some View {
        Group {
            if subscriptions.isEmpty {
                EmptyStateView(
                    icon: "creditcard",
                    title: "No Active Subscriptions",
                    subtitle: "Browse communities to get started!"
                )
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(subscriptions) { subscription in
                            NavigationLink(value: HubsRoute.communityPreview(id: subscription.communityID.uuidString)) {
                                subscriptionCard(subscription)
                            }
                            .buttonStyle(.plain)
                        }

                        // Total summary
                        HStack {
                            Text("Total")
                                .font(BlossomFont.headline)
                                .foregroundStyle(BlossomTheme.primaryText)
                            Spacer()
                            Text(formattedTotal)
                                .font(BlossomFont.headline)
                                .foregroundStyle(BlossomTheme.violet)
                        }
                        .padding(16)
                        .background(BlossomTheme.cardSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(BlossomTheme.cardBorder, lineWidth: 1)
                        )

                        #if DEBUG
                        Button("Reset All Subscriptions") {
                            showResetAlert = true
                        }
                        .font(BlossomFont.buttonLabel)
                        .foregroundStyle(.red)
                        .padding(.top, 16)
                        #endif
                    }
                    .padding(16)
                }
            }
        }
        .background(BlossomTheme.background)
        .navigationTitle("My Subscriptions")
        .navigationBarTitleDisplayMode(.large)
        #if DEBUG
        .alert("Reset All Subscriptions?", isPresented: $showResetAlert) {
            Button("Reset", role: .destructive) {
                subscriptionStore.resetAll()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove all active subscriptions. This action cannot be undone.")
        }
        #endif
    }

    @ViewBuilder
    private func subscriptionCard(_ subscription: Subscription) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(communityName(for: subscription.communityID))
                    .font(BlossomFont.headline)
                    .foregroundStyle(BlossomTheme.primaryText)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(BlossomTheme.secondaryText)
            }

            HStack {
                Text(subscription.tierName)
                    .font(BlossomFont.subhead)
                    .foregroundStyle(BlossomTheme.violet)

                Text(formattedPrice(subscription.monthlyPrice))
                    .font(BlossomFont.subhead)
                    .foregroundStyle(BlossomTheme.secondaryText)
            }

            Text("Subscribed since \(formattedDate(subscription.subscribedAt))")
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.secondaryText)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .blossomCard()
    }
}

#Preview {
    NavigationStack {
        MySubscriptionsView()
            .environment(SubscriptionStore())
            .environment(CommunityStore())
    }
}
