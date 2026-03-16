import SwiftUI

struct HubsView: View {
    let isSelected: Bool

    @AppStorage("hasSeenHubsSplash") private var hasSeenSplash = false
    @State private var showDiscovery = false
    @State private var searchText = ""

    @Environment(CommunityStore.self) private var store

    var body: some View {
        ZStack {
            if !hasSeenSplash && !showDiscovery {
                HubsSplashView(isActive: isSelected) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showDiscovery = true
                    } completion: {
                        hasSeenSplash = true
                    }
                }
                .transition(.opacity)
            } else {
                VStack(spacing: 0) {
                    HubsTopNavBar(searchText: $searchText)
                    HubsDiscoveryView(searchText: searchText)
                        .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .transition(.opacity)
            }

            // Search overlay on top
            if !searchText.isEmpty {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 60)
                    SearchDropdownView(query: searchText, store: store)
                    Spacer()
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .background(BlossomTheme.background)
        .navigationBarHidden(true)
        .navigationDestination(for: HubsRoute.self) { route in
            switch route {
            case .communityPreview(let id):
                CommunityPreviewView(communityID: id)
            case .communityDetail(let id):
                CommunityHubView(communityID: id)
            case .mySubscriptions:
                MySubscriptionsView()
            case .creatorDashboard:
                CreatorDashboardView()
            case .creatorEditCommunity:
                CommunityEditView()
            case .creatorManageTiers:
                TierEditorView()
            case .creatorPermissions:
                PermissionsMatrixView()
            case .creatorPublishContent:
                ComposePostView()
            case .categoryExplore(let category):
                CategoryExploreView(categoryName: category)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HubsView(isSelected: true)
            .environment(CommunityStore())
    }
}
