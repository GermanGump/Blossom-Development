// Features/Hubs/Feed/TickerPriceLookup.swift
import Foundation

enum TickerPriceLookup {
    struct TickerData {
        let price: String
        let change: String
        let isPositive: Bool
    }

    private static let data: [String: TickerData] = [
        "$AAPL": TickerData(price: "$182.50", change: "+2.3%", isPositive: true),
        "$NVDA": TickerData(price: "$875.40", change: "+4.1%", isPositive: true),
        "$MSFT": TickerData(price: "$415.60", change: "+1.5%", isPositive: true),
        "$TSLA": TickerData(price: "$248.90", change: "-1.8%", isPositive: false),
        "$AMD": TickerData(price: "$164.30", change: "+3.2%", isPositive: true),
        "$RY.TO": TickerData(price: "$145.20", change: "+1.1%", isPositive: true),
        "$SHOP.TO": TickerData(price: "$98.75", change: "-0.8%", isPositive: false),
        "$CNQ.TO": TickerData(price: "$78.30", change: "-1.2%", isPositive: false),
        "$FTS.TO": TickerData(price: "$58.90", change: "+0.6%", isPositive: true),
        "$SOUN": TickerData(price: "$7.45", change: "+12.6%", isPositive: true),
        "$IONQ": TickerData(price: "$14.20", change: "+8.3%", isPositive: true),
    ]

    static func lookup(_ ticker: String) -> TickerData {
        data[ticker] ?? TickerData(price: "--", change: "--", isPositive: true)
    }
}
