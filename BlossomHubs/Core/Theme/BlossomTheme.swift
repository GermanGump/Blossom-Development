// Core/Theme/BlossomTheme.swift
import SwiftUI

enum BlossomTheme {
    static let teal = Color(hex: "#35C7B2")
    static let violet = Color(hex: "#7361F7")
    static let orange = Color(hex: "#FF7833")
    static let darkNavy = Color(hex: "#1E222A")
    static let slate = Color(hex: "#565E76")

    // Tab bar specific
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
