import SwiftUI

struct HubsView: View {
    @AppStorage("hasSeenHubsSplash") private var hasSeenSplash = false
    @State private var showDiscovery = false
    @State private var searchText = ""

    @Environment(CommunityStore.self) private var store

    var body: some View {
        ZStack {
            if !hasSeenSplash && !showDiscovery {
                HubsSplashView {
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
                }
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
            case .communityPreview:
                EmptyView() // Plan 03-02
            case .communityDetail:
                EmptyView() // Phase 5
            }
        }
    }
}

#Preview {
    NavigationStack {
        HubsView()
            .environment(CommunityStore())
    }
}
