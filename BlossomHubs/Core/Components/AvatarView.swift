import SwiftUI

enum AvatarSize: CGFloat {
    case small  = 28
    case medium = 40
    case large  = 56
    case xlarge = 80
}

struct AvatarView: View {
    let image: Image
    var ringColor: Color = BlossomTheme.teal
    var showBadge: Bool = false
    var showVerifiedBadge: Bool = false
    var size: CGFloat = 40

    // Convenience init using AvatarSize preset
    init(imageName: String, preset: AvatarSize, ringColor: Color = BlossomTheme.teal, showBadge: Bool = false, showVerifiedBadge: Bool = false) {
        self.image = Image(imageName)
        self.ringColor = ringColor
        self.showBadge = showBadge
        self.showVerifiedBadge = showVerifiedBadge
        self.size = preset.rawValue
    }

    // Backward-compatible init using Image and CGFloat size
    init(image: Image, ringColor: Color = BlossomTheme.teal, showBadge: Bool = false, showVerifiedBadge: Bool = false, size: CGFloat = 40) {
        self.image = image
        self.ringColor = ringColor
        self.showBadge = showBadge
        self.showVerifiedBadge = showVerifiedBadge
        self.size = size
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            image
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(ringColor, lineWidth: 2.5))

            if showBadge {
                Image(systemName: "bolt.fill")
                    .font(.system(size: size * 0.2, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: size * 0.3, height: size * 0.3)
                    .background(BlossomTheme.teal)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 1.5))
                    .offset(y: 4)
            }

            if showVerifiedBadge {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: size * 0.22, weight: .bold))
                    .foregroundStyle(BlossomTheme.teal)
                    .frame(width: size * 0.35, height: size * 0.35)
                    .background(.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(BlossomTheme.teal.opacity(0.3), lineWidth: 1))
                    .offset(x: size * 0.28, y: 0)
            }
        }
        .frame(width: size + (showVerifiedBadge ? size * 0.15 : 0), height: size + (showBadge ? 4 : 0))
    }
}

#Preview {
    HStack(spacing: 20) {
        // Bolt badge variant (ambassador highlight)
        AvatarView(
            image: Image(systemName: "person.circle.fill"),
            ringColor: BlossomTheme.teal,
            showBadge: true,
            size: 56
        )

        // Verified badge variant (creator profile)
        AvatarView(
            image: Image(systemName: "person.circle.fill"),
            ringColor: BlossomTheme.teal,
            showVerifiedBadge: true,
            size: 56
        )

        // Both badges
        AvatarView(
            image: Image(systemName: "person.circle.fill"),
            ringColor: BlossomTheme.teal,
            showBadge: true,
            showVerifiedBadge: true,
            size: 56
        )

        // Plain avatar using AvatarSize preset
        AvatarView(
            imageName: "person.circle.fill",
            preset: .large
        )
    }
    .padding()
    .background(BlossomTheme.background)
}
