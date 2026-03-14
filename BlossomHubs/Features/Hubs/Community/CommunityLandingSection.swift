import SwiftUI

struct CommunityLandingSection: View {
    let community: Community
    let availableSections: [CommunitySection]
    let onSectionSelected: (CommunitySection) -> Void

    @Environment(SubscriptionStore.self) private var subscriptionStore

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Parallax Banner
            CommunityBannerView(community: community)

            // MARK: - Community Logo overlapping banner
            HStack {
                AvatarView(
                    imageName: community.logoImageName,
                    preset: .xlarge,
                    ringColor: .white
                )
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 3)
                        .frame(width: 80, height: 80)
                )
                .offset(y: -40)
                .padding(.leading, 16)
                Spacer()
            }
            .padding(.bottom, -40)

            // MARK: - Community Info
            VStack(alignment: .leading, spacing: 16) {

                Color.clear.frame(height: 12)

                // Community name + tier badge
                HStack(spacing: 8) {
                    Text(community.name)
                        .font(BlossomFont.title)
                        .foregroundStyle(BlossomTheme.primaryText)

                    if let sub = subscriptionStore.session.subscriptions[community.id] {
                        TagView(sub.tierName, style: .tier)
                    }
                }

                // Description
                Text(community.description)
                    .font(BlossomFont.body)
                    .foregroundStyle(BlossomTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                // Member count
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .foregroundStyle(BlossomTheme.teal)
                        .font(.system(size: 15))
                    Text("\(community.memberCount.formatted()) members")
                        .font(BlossomFont.subhead)
                        .foregroundStyle(BlossomTheme.primaryText)
                }
            }
            .padding(.horizontal, 16)

            // MARK: - Link Tree
            VStack(spacing: 0) {
                ForEach(availableSections.filter { $0 != .landing }) { section in
                    CommunityLinkTreeRow(
                        icon: section.icon,
                        title: section.title,
                        count: sectionCount(for: section),
                        action: { onSectionSelected(section) }
                    )

                    if section != availableSections.filter({ $0 != .landing }).last {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 16)
        }
    }

    private func sectionCount(for section: CommunitySection) -> Int? {
        switch section {
        case .landing: return nil
        case .posts: return community.posts.count
        case .discussions: return community.threads.count
        case .faq: return community.faqEntries.count
        case .videos:
            let count = community.posts.filter { $0.postType == .youtubeLink }.count
            return count > 0 ? count : nil
        }
    }
}
