import SwiftUI

struct BlossomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(AppTab.allCases) { tab in
                        BlossomTabItem(
                            tab: tab,
                            isSelected: selectedTab == tab
                        ) {
                            selectedTab = tab
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(height: 60)
            .background(BlossomTheme.tabBarBackground)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
        }
        .background(BlossomTheme.tabBarBackground)
    }
}

struct BlossomTabItem: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20))
                Text(tab.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? BlossomTheme.tabActive : BlossomTheme.tabInactive)
            .frame(minWidth: 70)
            .padding(.top, 8)
        }
        .buttonStyle(.plain)
    }
}
