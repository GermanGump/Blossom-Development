import SwiftUI

struct HubsTopNavBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 12) {
            // Left: Nick's avatar with teal ring and bolt badge
            AvatarView(
                image: Image("nick-profile-pic"),
                ringColor: BlossomTheme.teal,
                showBadge: true
            )
            .frame(width: 40, height: 40)

            // Center: search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search", text: $searchText)
                    .font(.subheadline)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)

            Spacer()

            // Right: teal bell with red "9+" badge
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell.fill")
                    .foregroundColor(BlossomTheme.teal)
                    .font(.title3)
                Text("9+")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 3)
                    .background(Color.red)
                    .clipShape(Capsule())
                    .offset(x: 6, y: -6)
            }

            // Right: violet circle with dollar-sign chat bubble
            ZStack {
                Circle()
                    .fill(BlossomTheme.violet)
                    .frame(width: 34, height: 34)
                Image(systemName: "dollarsign.bubble.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
