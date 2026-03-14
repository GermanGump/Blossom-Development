import SwiftUI

struct CommunitySectionPager: View {
    let community: Community
    let availableSections: [CommunitySection]
    @Binding var selectedSection: CommunitySection

    /// Sections shown in the pager (excludes .landing)
    private var pagerSections: [CommunitySection] {
        availableSections.filter { $0 != .landing }
    }

    var body: some View {
        // Paged TabView — segmented control is in the pinned Section header above
        TabView(selection: $selectedSection) {
            ForEach(pagerSections) { section in
                sectionPage(for: section)
                    .tag(section)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(minHeight: 400)
    }

    @ViewBuilder
    private func sectionPage(for section: CommunitySection) -> some View {
        switch section {
        case .posts:
            ContentFeedView(community: community)
        case .discussions:
            EmptyStateView(
                icon: "bubble.left.and.bubble.right",
                title: "Discussions",
                subtitle: "Discussions coming in Phase 7"
            )
        case .faq:
            EmptyStateView(
                icon: "questionmark.circle",
                title: "FAQ",
                subtitle: "FAQ coming in Phase 7"
            )
        case .videos:
            ContentFeedView(community: community, filterToVideos: true)
        case .landing:
            EmptyView()
        }
    }
}
