// Core/Components/TagView.swift
import SwiftUI

enum TagStyle {
    case stock
    case tier
    case category
    case subscribed

    var foregroundColor: Color {
        switch self {
        case .stock: return BlossomTheme.orange
        case .tier: return BlossomTheme.violet
        case .category: return BlossomTheme.primaryText
        case .subscribed: return .white
        }
    }

    var backgroundColor: Color {
        switch self {
        case .stock: return BlossomTheme.orange.opacity(0.12)
        case .tier: return BlossomTheme.violet.opacity(0.12)
        case .category: return BlossomTheme.slate.opacity(0.12)
        case .subscribed: return BlossomTheme.teal
        }
    }
}

struct TagView: View {
    let text: String
    let style: TagStyle

    init(_ text: String, style: TagStyle) {
        self.text = text
        self.style = style
    }

    var body: some View {
        Text(text)
            .font(BlossomFont.caption)
            .foregroundColor(style.foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(style.backgroundColor)
            .clipShape(Capsule())
    }
}

#Preview {
    HStack(spacing: 8) {
        TagView("AAPL", style: .stock)
        TagView("Gold Tier", style: .tier)
        TagView("Tech", style: .category)
    }
    .padding()
    .background(BlossomTheme.background)
}
