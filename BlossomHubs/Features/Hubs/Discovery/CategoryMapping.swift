import SwiftUI

enum CategoryMapping {
    /// Maps raw community category to display section name
    static func displayName(for rawCategory: String) -> String {
        switch rawCategory {
        case "Dividend Investing": return "Dividend Hubs"
        case "Passive Investing": return "Value Investing Hubs"
        case "Swing Trading", "Options & Swing Trading", "Momentum Trading": return "Trading Hubs"
        case "Canadian Personal Finance", "Canadian Investing": return "Canadian Investing Hubs"
        default: return rawCategory
        }
    }

    /// SF Symbol icon for each display category
    static func icon(for displayName: String) -> String {
        switch displayName {
        case "Dividend Hubs": return "chart.bar.fill"
        case "Value Investing Hubs": return "building.columns.fill"
        case "Trading Hubs": return "bolt.fill"
        case "Canadian Investing Hubs": return "leaf.fill"
        default: return "star.fill"
        }
    }

    /// Ordered list of display categories
    static let displayOrder = [
        "Dividend Hubs",
        "Value Investing Hubs",
        "Trading Hubs",
        "Canadian Investing Hubs",
    ]
}
