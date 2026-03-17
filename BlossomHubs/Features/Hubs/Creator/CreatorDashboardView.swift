import SwiftUI
import Charts

struct CreatorDashboardView: View {
    @Environment(CommunityStore.self) private var communityStore
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var viewModel: CreatorDashboardViewModel?
    @State private var selectedPeriod: EarningsPeriod = .sixMonths
    @State private var selectedMonth: String?

    var body: some View {
        Group {
            if let viewModel, let community = viewModel.community {
                ScrollView {
                    VStack(spacing: 16) {
                        // Creator context header
                        HStack(spacing: 12) {
                            Image(community.creator.profileImageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text(community.name)
                                    .font(BlossomFont.headline)
                                    .foregroundStyle(BlossomTheme.primaryText)
                                Text(community.creator.username)
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(BlossomTheme.secondaryText)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 16)

                        // Stat cards
                        HStack(spacing: 12) {
                            statCard(
                                icon: "person.2.fill",
                                label: "Subscribers",
                                value: "\(viewModel.subscriberCount)"
                            )
                            statCard(
                                icon: "dollarsign.circle.fill",
                                label: "Est. Monthly",
                                value: viewModel.estimatedRevenue
                            )
                        }
                        .padding(.horizontal, 16)

                        // Earnings section (replaces placeholder, positioned between stats and section links)
                        earningsSection(viewModel: viewModel)
                            .padding(.horizontal, 16)

                        // Section links
                        VStack(spacing: 10) {
                            sectionLink(
                                icon: "pencil.circle",
                                title: "Edit Community",
                                subtitle: "Title, description & appearance",
                                route: .creatorEditCommunity
                            )

                            sectionLink(
                                icon: "rectangle.stack",
                                title: "Manage Tiers",
                                subtitle: "\(community.tiers.count) tiers configured",
                                route: .creatorManageTiers
                            )

                            sectionLink(
                                icon: "lock.shield",
                                title: "Permissions",
                                subtitle: "Tier access by section",
                                route: .creatorPermissions
                            )

                            sectionLink(
                                icon: "square.and.pencil",
                                title: "Publish Content",
                                subtitle: "Create posts & trade highlights",
                                route: .creatorPublishContent
                            )
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 12)
                    .padding(.bottom, 100)
                }
            } else {
                ProgressView()
            }
        }
        .background(BlossomTheme.background)
        .navigationTitle("Creator Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if viewModel == nil,
               let creatorID = subscriptionStore.session.creatorCommunityID {
                viewModel = CreatorDashboardViewModel(
                    communityID: creatorID,
                    communityStore: communityStore,
                    subscriptionStore: subscriptionStore
                )
            }
        }
    }

    // MARK: - Earnings Section

    @ViewBuilder
    private func earningsSection(viewModel: CreatorDashboardViewModel) -> some View {
        let chartPoints = viewModel.chartData(for: selectedPeriod)
        let breakdown = viewModel.tierBreakdown(for: selectedPeriod)
        let subsCount = viewModel.totalSubscribers(for: selectedPeriod)
        let gross = viewModel.totalGross(for: selectedPeriod)
        let fee = viewModel.totalFee(for: selectedPeriod)
        let net = viewModel.totalNet(for: selectedPeriod)

        VStack(spacing: 12) {
            // Header row: title + period label
            HStack {
                Text("Earnings")
                    .font(BlossomFont.subhead)
                    .fontWeight(.semibold)
                    .foregroundStyle(BlossomTheme.primaryText)
                Spacer()
                Text(viewModel.periodLabel(for: selectedPeriod))
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.secondaryText)
            }

            // Subscriber count row
            HStack {
                Text("Members")
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.secondaryText)
                Spacer()
                Text(formatCount(subsCount))
                    .font(BlossomFont.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(BlossomTheme.primaryText)
            }

            // Segmented period picker
            Picker("Period", selection: $selectedPeriod) {
                ForEach(EarningsPeriod.allCases, id: \.self) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedPeriod) { selectedMonth = nil }
            .sensoryFeedback(.impact(flexibility: .soft), trigger: selectedPeriod)

            // Bar chart — net revenue per month
            Chart(chartPoints) { point in
                BarMark(
                    x: .value("Month", point.monthLabel),
                    y: .value("Net Revenue", NSDecimalNumber(decimal: point.netRevenue).doubleValue),
                    width: .ratio(0.55)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [BlossomTheme.violet.opacity(0.5), BlossomTheme.violet],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .opacity(selectedMonth == nil || selectedMonth == point.monthLabel ? 1.0 : 0.4)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture { location in
                            let relativeX = location.x - geo[proxy.plotAreaFrame].origin.x
                            if let month: String = proxy.value(atX: relativeX) {
                                selectedMonth = (selectedMonth == month) ? nil : month
                            }
                        }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let label = value.as(String.self) {
                            Text(label)
                                .font(BlossomFont.caption)
                                .foregroundStyle(BlossomTheme.secondaryText)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let val = value.as(Double.self) {
                            Text(formatAxisValue(val))
                                .font(.system(size: 10))
                                .foregroundStyle(BlossomTheme.secondaryText)
                        }
                    }
                }
            }
            .frame(height: 180)
            .animation(.easeInOut(duration: 0.3), value: selectedPeriod)
            .sensoryFeedback(.selection, trigger: selectedMonth)

            // Selected month callout
            if let selLabel = selectedMonth,
               let point = chartPoints.first(where: { $0.monthLabel == selLabel }) {
                HStack(spacing: 10) {
                    Image("blossom-logo-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    VStack(alignment: .leading, spacing: 1) {
                        Text("Certified Blossom Payout:")
                            .font(BlossomFont.caption)
                            .foregroundStyle(.white.opacity(0.8))
                        HStack(spacing: 4) {
                            Text(point.monthLabel)
                                .font(BlossomFont.caption)
                                .foregroundStyle(.white.opacity(0.7))
                            Text(viewModel.formatted(point.netRevenue))
                                .font(BlossomFont.subhead)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(
                    LinearGradient(
                        colors: [BlossomTheme.violet, BlossomTheme.violet.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.scale(scale: 0.8, anchor: .top).combined(with: .opacity))
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: selectedMonth)
            }

            Divider()

            // Revenue breakdown rows
            revenueRow(label: "Gross Revenue", amount: gross, isDeduction: false)
                .contentTransition(.numericText())
            revenueRow(label: "Blossom Fee (10%)", amount: fee, isDeduction: true)
                .contentTransition(.numericText())
            Divider()
            revenueRow(label: "Net Payout", amount: net, isDeduction: false, bold: true)
                .contentTransition(.numericText())

            // Per-tier breakdown
            if !breakdown.isEmpty {
                VStack(spacing: 8) {
                    ForEach(Array(breakdown.enumerated()), id: \.offset) { _, item in
                        VStack(spacing: 4) {
                            HStack {
                                Circle()
                                    .fill(item.tierColor)
                                    .frame(width: 8, height: 8)
                                Text(item.tierName)
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(BlossomTheme.primaryText)
                                Spacer()
                                Text(String(format: "%.0f%%", item.percentage * 100))
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(BlossomTheme.secondaryText)
                            }
                            // NOTE: GeometryReader intentional — containerRelativeFrame() cannot
                            // express arbitrary percentage-based width fill for progress bar
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(item.tierColor.opacity(0.2))
                                    .overlay(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(item.tierColor)
                                            .frame(width: geo.size.width * item.percentage)
                                    }
                            }
                            .frame(height: 6)
                        }
                    }
                }
            }
        }
        .padding(16)
        .blossomCard()
    }

    // MARK: - Revenue Row

    private func revenueRow(label: String, amount: Decimal, isDeduction: Bool, bold: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.secondaryText)
            Spacer()
            Text(formatAmount(amount))
                .font(BlossomFont.subhead)
                .fontWeight(bold ? .semibold : .regular)
                .foregroundStyle(isDeduction ? BlossomTheme.orange : BlossomTheme.primaryText)
        }
    }

    // MARK: - Formatting Helpers

    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "CAD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: amount as NSDecimalNumber) ?? "$0.00"
    }

    private func formatAxisValue(_ value: Double) -> String {
        if value == 0 { return "$0" }
        if value >= 1000 {
            let k = value / 1000
            return k.truncatingRemainder(dividingBy: 1) == 0
                ? "$\(Int(k))K"
                : String(format: "$%.1fK", k)
        }
        return "$\(Int(value))"
    }

    private func formatCount(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: count)) ?? "\(count)"
    }

    // MARK: - Stat Card

    private func statCard(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(BlossomTheme.violet)

            Text(value)
                .font(BlossomFont.headline)
                .foregroundStyle(BlossomTheme.primaryText)

            Text(label)
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .blossomCard()
    }

    // MARK: - Section Link

    private func sectionLink(icon: String, title: String, subtitle: String, route: HubsRoute) -> some View {
        NavigationLink(value: route) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(BlossomTheme.violet)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(BlossomFont.subhead)
                        .fontWeight(.semibold)
                        .foregroundStyle(BlossomTheme.primaryText)
                    Text(subtitle)
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
            .padding(16)
            .blossomCard()
        }
    }
}

#Preview {
    NavigationStack {
        CreatorDashboardView()
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
