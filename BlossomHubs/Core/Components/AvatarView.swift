import SwiftUI

struct AvatarView: View {
    let image: Image
    var ringColor: Color = BlossomTheme.teal
    var showBadge: Bool = false
    var size: CGFloat = 40

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
                    .foregroundColor(.white)
                    .frame(width: size * 0.3, height: size * 0.3)
                    .background(BlossomTheme.teal)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 1.5))
                    .offset(y: 4)
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
