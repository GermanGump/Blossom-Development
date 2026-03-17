// Core/Components/TagView.swift
import SwiftUI

enum TagStyle {
    case stock
    case tier
    case category
    case subscribed
    case role

    var foregroundColor: Color {
        switch self {
        case .stock: return BlossomTheme.orange
        case .tier: return BlossomTheme.violet
        case .category: return BlossomTheme.primaryText
        case .subscribed: return .white
        case .role: return BlossomTheme.teal
        }
    }

    var backgroundColor: Color {
        switch self {
        case .stock: return BlossomTheme.orange.opacity(0.12)
        case .tier: return BlossomTheme.violet.opacity(0.12)
        case .category: return BlossomTheme.slate.opacity(0.12)
        case .subscribed: return BlossomTheme.teal
        case .role: return BlossomTheme.teal.opacity(0.12)
        }
    }
}

struct TagView: View {
    let text: String
    let style: TagStyle
    var customColor: Color?

    init(_ text: String, style: TagStyle, customColor: Color? = nil) {
        self.text = text
        self.style = style
        self.customColor = customColor
    }

    var body: some View {
        let fg = customColor ?? style.foregroundColor
        let bg = customColor?.opacity(0.12) ?? style.backgroundColor
        Text(text)
            .font(BlossomFont.caption)
            .lineLimit(1)
            .foregroundStyle(fg)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(bg)
            .clipShape(Capsule())
    }
}

#Preview {
    HStack(spacing: 8) {
        TagView("AAPL", style: .stock)
        TagView("Gold Tier", style: .tier)
        TagView("Tech", style: .category)
        TagView("Creator", style: .role)
    }
    .padding()
    .background(BlossomTheme.background)
}
