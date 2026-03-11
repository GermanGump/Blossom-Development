import SwiftUI

struct AvatarView: View {
    let image: Image
    var ringColor: Color = BlossomTheme.teal
    var showBadge: Bool = false
    var size: CGFloat = 40

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            image
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(ringColor, lineWidth: 2))

            if showBadge {
                Image(systemName: "bolt.fill")
                    .font(.system(size: size * 0.25, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: size * 0.32, height: size * 0.32)
                    .background(BlossomTheme.violet)
                    .clipShape(Circle())
                    .offset(x: -2, y: 2)
            }
        }
    }
}

#Preview {
    AvatarView(
        image: Image(systemName: "person.circle.fill"),
        ringColor: BlossomTheme.teal,
        showBadge: true,
        size: 40
    )
    .padding()
}
