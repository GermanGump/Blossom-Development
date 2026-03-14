import SwiftUI

struct CommunityLinkTreeRow: View {
    let icon: String
    let title: String
    let count: Int?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(BlossomTheme.violet)
                    .frame(width: 28, height: 28)

                Text(title)
                    .font(BlossomFont.body)
                    .foregroundStyle(BlossomTheme.primaryText)

                Spacer()

                if let count {
                    Text("\(count)")
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
    }
}
