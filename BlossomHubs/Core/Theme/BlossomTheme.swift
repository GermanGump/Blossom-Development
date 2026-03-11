// Core/Theme/BlossomTheme.swift
import SwiftUI

enum BlossomTheme {
    // Brand accents — identical in light and dark mode
    static let teal = Color("BlossomTeal")
    static let violet = Color("BlossomViolet")
    static let orange = Color("BlossomOrange")

    // Legacy convenience aliases (preserved for existing callers)
    static let darkNavy = Color("BlossomDarkNavy")
    static let slate = Color("BlossomSlate")

    // Semantic tokens — automatically adapt between light and dark via colorsets
    static let background = Color("BlossomBackground")
    static let cardSurface = Color("BlossomCardSurface")
    static let cardBorder = Color("BlossomCardBorder")
    static let primaryText = Color("BlossomPrimaryText")
    static let secondaryText = Color("BlossomSecondaryText")

    // Tab bar (systemBackground auto-adapts — correct for both modes)
    static let tabActive = teal
    static let tabInactive = Color(UIColor.systemGray3)
    static let tabBarBackground = Color(UIColor.systemBackground)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
