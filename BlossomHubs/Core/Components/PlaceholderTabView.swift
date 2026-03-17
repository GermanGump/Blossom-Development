import SwiftUI

struct PlaceholderTabView: View {
    let tab: AppTab

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: tab.icon)
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(BlossomTheme.teal)
            Text(tab.rawValue)
                .font(BlossomFont.title)
                .foregroundStyle(BlossomTheme.primaryText)
            Text("Coming soon")
                .font(BlossomFont.subhead)
                .foregroundStyle(BlossomTheme.secondaryText)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlossomTheme.background)
    }
}

#Preview {
    PlaceholderTabView(tab: .markets)
}
