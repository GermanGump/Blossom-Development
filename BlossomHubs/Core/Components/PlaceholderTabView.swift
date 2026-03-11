import SwiftUI

struct PlaceholderTabView: View {
    let tab: AppTab

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: tab.icon)
                .font(.system(size: 56, weight: .regular))
                .foregroundColor(BlossomTheme.teal)
            Text(tab.rawValue)
                .font(.title.weight(.semibold))
                .foregroundColor(BlossomTheme.darkNavy)
            Text("Coming soon")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    PlaceholderTabView(tab: .markets)
}
