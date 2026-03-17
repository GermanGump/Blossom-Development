// Features/Hubs/Ads/AdCreative.swift
import SwiftUI

struct AdCreative {
    let brandName: String
    let headline: String
    let subtitle: String
    let brandColor: Color
    let iconName: String
    let destinationURL: URL
    let isBlossomPro: Bool

    var sponsoredLabel: String {
        isBlossomPro ? "Upgrade" : "Sponsored"
    }

    var accentColor: Color {
        isBlossomPro ? BlossomTheme.violet : brandColor
    }

    // MARK: - Banner creatives (one per advertiser, full-width format)

    static let bannerCreatives: [AdCreative] = [
        AdCreative(
            brandName: "BMO ETFs",
            headline: "Build a diversified portfolio",
            subtitle: "Commission-free ETF investing with BMO",
            brandColor: Color(hex: "009A44"),
            iconName: "building.columns.fill",
            destinationURL: URL(string: "https://www.bmo.com/etfs")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "Wealthsimple",
            headline: "Invest without the fees",
            subtitle: "Canada's most trusted investing platform",
            brandColor: Color(hex: "292929"),
            iconName: "chart.line.uptrend.xyaxis",
            destinationURL: URL(string: "https://www.wealthsimple.com")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "Questrade",
            headline: "Trade stocks for $4.95 flat",
            subtitle: "Canada's lowest commissions on stock trades",
            brandColor: Color(hex: "00A651"),
            iconName: "dollarsign.arrow.circlepath",
            destinationURL: URL(string: "https://www.questrade.com")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "EQ Bank",
            headline: "High-interest savings account",
            subtitle: "Earn more with EQ Bank — up to 4% interest",
            brandColor: Color(hex: "2B59C3"),
            iconName: "banknote.fill",
            destinationURL: URL(string: "https://www.eqbank.ca")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "Blossom PRO",
            headline: "Level up your investing",
            subtitle: "Access premium communities and exclusive insights",
            brandColor: BlossomTheme.violet,
            iconName: "crown.fill",
            destinationURL: URL(string: "https://www.blossom.ca")!,
            isBlossomPro: true
        ),
    ]

    // MARK: - Inline card creatives (feed-integrated format, different copy variants)

    static let inlineCreatives: [AdCreative] = [
        AdCreative(
            brandName: "BMO ETFs",
            headline: "Low-cost ETFs for every investor",
            subtitle: "Start with as little as $25. No trading fees.",
            brandColor: Color(hex: "009A44"),
            iconName: "building.columns.fill",
            destinationURL: URL(string: "https://www.bmo.com/etfs")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "Wealthsimple",
            headline: "Automate your portfolio",
            subtitle: "Set it, forget it, and watch your money grow",
            brandColor: Color(hex: "292929"),
            iconName: "chart.line.uptrend.xyaxis",
            destinationURL: URL(string: "https://www.wealthsimple.com")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "Questrade",
            headline: "Switch and save on trades",
            subtitle: "Active traders love Questrade's flat-rate commissions",
            brandColor: Color(hex: "00A651"),
            iconName: "dollarsign.arrow.circlepath",
            destinationURL: URL(string: "https://www.questrade.com")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "EQ Bank",
            headline: "Your money works harder here",
            subtitle: "No monthly fees. High interest. Always.",
            brandColor: Color(hex: "2B59C3"),
            iconName: "banknote.fill",
            destinationURL: URL(string: "https://www.eqbank.ca")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "Blossom PRO",
            headline: "Unlock premium communities",
            subtitle: "Get deeper insights from Canada's top investors",
            brandColor: BlossomTheme.violet,
            iconName: "crown.fill",
            destinationURL: URL(string: "https://www.blossom.ca")!,
            isBlossomPro: true
        ),
    ]

    // MARK: - Pill creatives (compact single-line format)

    static let pillCreatives: [AdCreative] = [
        AdCreative(
            brandName: "BMO ETFs",
            headline: "Commission-free ETF investing",
            subtitle: "Build wealth with BMO",
            brandColor: Color(hex: "009A44"),
            iconName: "building.columns.fill",
            destinationURL: URL(string: "https://www.bmo.com/etfs")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "Wealthsimple",
            headline: "Trade free. Invest smart.",
            subtitle: "Wealthsimple — Canada's top platform",
            brandColor: Color(hex: "292929"),
            iconName: "chart.line.uptrend.xyaxis",
            destinationURL: URL(string: "https://www.wealthsimple.com")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "Questrade",
            headline: "Low commissions on every trade",
            subtitle: "Try Questrade today",
            brandColor: Color(hex: "00A651"),
            iconName: "dollarsign.arrow.circlepath",
            destinationURL: URL(string: "https://www.questrade.com")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "EQ Bank",
            headline: "Earn more with EQ Bank",
            subtitle: "High-interest savings, no fees",
            brandColor: Color(hex: "2B59C3"),
            iconName: "banknote.fill",
            destinationURL: URL(string: "https://www.eqbank.ca")!,
            isBlossomPro: false
        ),
        AdCreative(
            brandName: "Blossom PRO",
            headline: "Upgrade to Blossom PRO",
            subtitle: "Premium investing communities",
            brandColor: BlossomTheme.violet,
            iconName: "crown.fill",
            destinationURL: URL(string: "https://www.blossom.ca")!,
            isBlossomPro: true
        ),
    ]
}
