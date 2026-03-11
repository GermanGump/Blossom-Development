// Features/TabBar/TabItem.swift
import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home = "Home"
    case hubs = "Hubs"
    case markets = "Markets"
    case learn = "Learn"
    case portfolio = "Portfolio"
    case insights = "Insights"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home:      "house.fill"
        case .hubs:      "person.3.fill"
        case .markets:   "globe"
        case .learn:     "book.fill"
        case .portfolio: "arrow.triangle.2.circlepath"
        case .insights:  "bolt.fill"
        }
    }
}
