import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    PlaceholderTabView(tab: .home)
                }
                .tag(AppTab.home)
                .toolbar(.hidden, for: .tabBar)

                NavigationStack {
                    HubsView(isSelected: selectedTab == .hubs)
                }
                .tag(AppTab.hubs)
                .toolbar(.hidden, for: .tabBar)

                NavigationStack {
                    PlaceholderTabView(tab: .markets)
                }
                .tag(AppTab.markets)
                .toolbar(.hidden, for: .tabBar)

                NavigationStack {
                    PlaceholderTabView(tab: .learn)
                }
                .tag(AppTab.learn)
                .toolbar(.hidden, for: .tabBar)

                NavigationStack {
                    PlaceholderTabView(tab: .portfolio)
                }
                .tag(AppTab.portfolio)
                .toolbar(.hidden, for: .tabBar)

                NavigationStack {
                    PlaceholderTabView(tab: .insights)
                }
                .tag(AppTab.insights)
                .toolbar(.hidden, for: .tabBar)
            }
            .ignoresSafeArea(edges: .bottom)

            BlossomTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
