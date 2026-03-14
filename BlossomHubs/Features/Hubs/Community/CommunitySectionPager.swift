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
            EmptyStateView(
                icon: "doc.text",
                title: "Posts",
                subtitle: "Posts coming in Phase 6"
            )
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
            EmptyStateView(
                icon: "play.rectangle",
                title: "Videos",
                subtitle: "Videos coming in Phase 6"
            )
        case .landing:
            EmptyView()
        }
    }
}
