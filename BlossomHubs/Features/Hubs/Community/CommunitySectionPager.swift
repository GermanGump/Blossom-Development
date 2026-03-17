import SwiftUI

struct CommunitySectionPager: View {
    let community: Community
    let availableSections: [CommunitySection]
    let forumViewModel: ForumViewModel
    @Binding var selectedSection: CommunitySection
    @Binding var showForumCompose: Bool

    /// Sections shown in the pager (excludes .landing)
    private var pagerSections: [CommunitySection] {
        availableSections.filter { $0 != .landing }
    }

    var body: some View {
        // Paged TabView — segmented control is in the pinned Section header above
        TabView(selection: $selectedSection) {
            ForEach(pagerSections) { section in
                VStack {
                    sectionPage(for: section)
                    Spacer()
                }
                .tag(section)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        // 2.5x screen height ensures paged TabView pages are tall enough
        // to display all content (posts + ad + spacing) without clipping.
        // VStack + Spacer pushes content to top; excess height is blank.
        .frame(minHeight: UIScreen.main.bounds.height * 2)
    }

    @ViewBuilder
    private func sectionPage(for section: CommunitySection) -> some View {
        switch section {
        case .posts:
            ContentFeedView(community: community)
        case .discussions:
            DiscussionsFeedView(community: community, forumViewModel: forumViewModel, showComposeSheet: $showForumCompose)
        case .faq:
            FAQListView(community: community)
        case .videos:
            ContentFeedView(community: community, filterToVideos: true)
        case .landing:
            EmptyView()
        }
    }
}
