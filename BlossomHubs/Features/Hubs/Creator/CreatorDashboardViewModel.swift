import Foundation
import SwiftUI

// MARK: - MonthlyEarningsPoint

struct MonthlyEarningsPoint: Identifiable {
    let id: UUID = UUID()
    let monthLabel: String          // e.g., "Oct", "Nov"
    let monthIndex: Int             // 0-5 for chart x-axis (Int for reliable chartOverlay proxy.value mapping)
    let grossRevenue: Decimal
    var platformFee: Decimal { grossRevenue * Decimal(string: "0.10")! }
    var netRevenue: Decimal { grossRevenue - platformFee }
    let subscriberCount: Int
    let tierSubscriberCounts: [Int: Int] // tier index -> subscriber count for that tier
}

// MARK: - EarningsPeriod

enum EarningsPeriod: String, CaseIterable {
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"

    var monthCount: Int {
        switch self {
        case .oneMonth: return 1
        case .threeMonths: return 3
        case .sixMonths: return 6
        }
    }
}

// MARK: - TierBreakdownItem

struct TierBreakdownItem {
    let tierName: String
    let tierColor: Color
    let revenue: Decimal
    let percentage: Double
}

// MARK: - CreatorDashboardViewModel

@MainActor
@Observable
final class CreatorDashboardViewModel {
    let communityID: UUID
    private let communityStore: CommunityStore
    private let subscriptionStore: SubscriptionStore

    var community: Community? {
        communityStore.communities.first(where: { $0.id == communityID })
    }

    var subscriberCount: Int {
        community?.memberCount ?? 0
    }

    var estimatedRevenue: String {
        guard let community else { return "$0.00" }
        let avgPrice: Decimal = community.tiers.reduce(0) { $0 + $1.monthlyPrice } / max(Decimal(community.tiers.count), 1)
        let total = Decimal(subscriberCount) * avgPrice
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: total as NSDecimalNumber) ?? "$0.00"
    }

    init(communityID: UUID, communityStore: CommunityStore, subscriptionStore: SubscriptionStore) {
        self.communityID = communityID
        self.communityStore = communityStore
        self.subscriptionStore = subscriptionStore
    }
}

// MARK: - Earnings Extension

extension CreatorDashboardViewModel {

    // 6 months of mock earnings data (Oct 2025 – Mar 2026)
    // Tier indices: 0=Observer($0), 1=Investor($19), 2=Pro($49)
    // Gross = Investor*19 + Pro*49 (Observer is free)
    // Math verified: each month's gross = tierSubscriberCounts[1]*19 + tierSubscriberCounts[2]*49
    private var allEarningsData: [MonthlyEarningsPoint] {
        [
            // Oct 2025: Obs=186, Inv=70, Pro=30, total=286
            // gross = 70*19 + 30*49 = 1330 + 1470 = 2800
            MonthlyEarningsPoint(
                monthLabel: "Oct",
                monthIndex: 0,
                grossRevenue: Decimal(2800),
                subscriberCount: 286,
                tierSubscriberCounts: [0: 186, 1: 70, 2: 30]
            ),
            // Nov 2025: Obs=241, Inv=99, Pro=31, total=371
            // gross = 99*19 + 31*49 = 1881 + 1519 = 3400
            MonthlyEarningsPoint(
                monthLabel: "Nov",
                monthIndex: 1,
                grossRevenue: Decimal(3400),
                subscriberCount: 371,
                tierSubscriberCounts: [0: 241, 1: 99, 2: 31]
            ),
            // Dec 2025: Obs=260, Inv=92, Pro=48, total=400
            // gross = 92*19 + 48*49 = 1748 + 2352 = 4100
            MonthlyEarningsPoint(
                monthLabel: "Dec",
                monthIndex: 2,
                grossRevenue: Decimal(4100),
                subscriberCount: 400,
                tierSubscriberCounts: [0: 260, 1: 92, 2: 48]
            ),
            // Jan 2026: Obs=297, Inv=108, Pro=52, total=457
            // gross = 108*19 + 52*49 = 2052 + 2548 = 4600
            MonthlyEarningsPoint(
                monthLabel: "Jan",
                monthIndex: 3,
                grossRevenue: Decimal(4600),
                subscriberCount: 457,
                tierSubscriberCounts: [0: 297, 1: 108, 2: 52]
            ),
            // Feb 2026: Obs=353, Inv=137, Pro=53, total=543
            // gross = 137*19 + 53*49 = 2603 + 2597 = 5200
            MonthlyEarningsPoint(
                monthLabel: "Feb",
                monthIndex: 4,
                grossRevenue: Decimal(5200),
                subscriberCount: 543,
                tierSubscriberCounts: [0: 353, 1: 137, 2: 53]
            ),
            // Mar 2026: Obs=409, Inv=166, Pro=54, total=629
            // gross = 166*19 + 54*49 = 3154 + 2646 = 5800
            MonthlyEarningsPoint(
                monthLabel: "Mar",
                monthIndex: 5,
                grossRevenue: Decimal(5800),
                subscriberCount: 629,
                tierSubscriberCounts: [0: 409, 1: 166, 2: 54]
            )
        ]
    }

    func chartData(for period: EarningsPeriod) -> [MonthlyEarningsPoint] {
        let count = period.monthCount
        return Array(allEarningsData.suffix(count))
    }

    func tierBreakdown(for period: EarningsPeriod) -> [TierBreakdownItem] {
        let data = chartData(for: period)
        guard let tiers = community?.tiers, !tiers.isEmpty else { return [] }

        // Accumulate revenue per tier index across the selected period
        var tierRevenue: [Int: Decimal] = [:]
        for point in data {
            for (tierIndex, count) in point.tierSubscriberCounts {
                guard tierIndex < tiers.count else { continue }
                let price = tiers[tierIndex].monthlyPrice
                let rev = Decimal(count) * price
                tierRevenue[tierIndex, default: 0] += rev
            }
        }

        let totalRevenue = tierRevenue.values.reduce(0, +)
        guard totalRevenue > 0 else { return [] }

        var items: [TierBreakdownItem] = []
        for (index, revenue) in tierRevenue {
            guard index < tiers.count else { continue }
            let tier = tiers[index]
            let percentage = NSDecimalNumber(decimal: revenue / totalRevenue).doubleValue
            items.append(TierBreakdownItem(
                tierName: tier.name,
                tierColor: tier.color,
                revenue: revenue,
                percentage: percentage
            ))
        }

        return items.sorted { $0.revenue > $1.revenue }
    }

    func periodLabel(for period: EarningsPeriod) -> String {
        let data = chartData(for: period)
        guard let first = data.first, let last = data.last else { return "" }
        switch period {
        case .oneMonth:
            return "\(last.monthLabel) 2026"
        case .threeMonths:
            let firstYear = first.monthIndex <= 2 ? "2025" : "2026"
            let lastYear = "2026"
            return "\(first.monthLabel) \(firstYear) – \(last.monthLabel) \(lastYear)"
        case .sixMonths:
            return "\(first.monthLabel) 2025 – \(last.monthLabel) 2026"
        }
    }

    func totalGross(for period: EarningsPeriod) -> Decimal {
        chartData(for: period).reduce(0) { $0 + $1.grossRevenue }
    }

    func totalFee(for period: EarningsPeriod) -> Decimal {
        chartData(for: period).reduce(0) { $0 + $1.platformFee }
    }

    func totalNet(for period: EarningsPeriod) -> Decimal {
        chartData(for: period).reduce(0) { $0 + $1.netRevenue }
    }

    func totalSubscribers(for period: EarningsPeriod) -> Int {
        chartData(for: period).last?.subscriberCount ?? 0
    }

    func formatted(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: amount as NSDecimalNumber) ?? "$0.00"
    }
}
