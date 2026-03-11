import SwiftUI

struct BlossomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(UIColor.separator))
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
            .padding(.top, 8)
            .padding(.bottom, 2)
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
                    .font(.system(size: 22, weight: .medium))
                Text(tab.rawValue)
                    .font(BlossomFont.caption)
            }
            .foregroundColor(isSelected ? BlossomTheme.tabActive : BlossomTheme.tabInactive)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
