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
                    .foregroundColor(BlossomTheme.secondaryText)
                TextField("Search", text: $searchText)
                    .font(BlossomFont.subhead)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(BlossomTheme.cardSurface)
            .cornerRadius(10)

            // Right: teal bell with red "9+" badge
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell.fill")
                    .foregroundColor(BlossomTheme.teal)
                    .font(.system(size: 22))
                Text("9+")
                    .font(BlossomFont.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(Color.red)
                    .clipShape(Capsule())
                    .offset(x: 8, y: -6)
            }

            // Right: violet speech bubble with dollar sign -> My Subscriptions
            NavigationLink(value: HubsRoute.mySubscriptions) {
                Image(systemName: "dollarsign.bubble.fill")
                    .foregroundColor(BlossomTheme.violet)
                    .font(.system(size: 28))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
