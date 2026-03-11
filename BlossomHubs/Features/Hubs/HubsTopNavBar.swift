import SwiftUI

struct HubsTopNavBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 12) {
            // Left: Nick's avatar with teal ring and teal bolt badge at bottom
            AvatarView(
                image: Image("nick-profile-pic"),
                ringColor: BlossomTheme.teal,
                showBadge: true,
                size: 44
            )

            // Center: search bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search", text: $searchText)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)

            // Right: teal bell with red "9+" badge
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell.fill")
                    .foregroundColor(BlossomTheme.teal)
                    .font(.system(size: 22))
                Text("9+")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(Color.red)
                    .clipShape(Capsule())
                    .offset(x: 8, y: -6)
            }

            // Right: violet speech bubble with dollar sign
            Image(systemName: "dollarsign.bubble.fill")
                .foregroundColor(BlossomTheme.violet)
                .font(.system(size: 28))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
