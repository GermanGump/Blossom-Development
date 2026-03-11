import SwiftUI

struct TierCardView: View {
    let tier: Tier
    var isPopular: Bool = false
    let isExpanded: Bool
    let onTap: () -> Void

    private var formattedPrice: String {
        let decimal = NSDecimalNumber(decimal: tier.monthlyPrice)
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
        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Header row (always visible)
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(tier.name)
                        .font(BlossomFont.headline)
                        .foregroundStyle(BlossomTheme.primaryText)
                    Text(formattedPrice)
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                }

                Spacer()

                if isPopular {
                    TagView("Most Popular", style: .tier)
                }

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
            .padding(16)

            // MARK: - Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()

                    ForEach(tier.benefits, id: \.self) { benefit in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(BlossomTheme.teal)
                                .font(.system(size: 16))
                            Text(benefit)
                                .font(BlossomFont.body)
                                .foregroundStyle(BlossomTheme.primaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Button("Subscribe") {
                        // Phase 4 wires this
                    }
                    .buttonStyle(BlossomPrimaryButton())
                    .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .blossomCard()
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isExpanded)
    }
}

#Preview {
    let sampleTier = Tier(
        name: "Investor",
        monthlyPrice: 29.99,
        benefits: [
            "Weekly market commentary",
            "Stock watchlist access",
            "Community forum (full access)",
            "Monthly portfolio snapshot"
        ]
    )

    VStack(spacing: 12) {
        TierCardView(
            tier: sampleTier,
            isPopular: true,
            isExpanded: true,
            onTap: {}
        )

        TierCardView(
            tier: Tier(name: "Observer", monthlyPrice: 0, benefits: ["Free market commentary"]),
            isPopular: false,
            isExpanded: false,
            onTap: {}
        )
    }
    .padding()
    .background(BlossomTheme.background)
}
