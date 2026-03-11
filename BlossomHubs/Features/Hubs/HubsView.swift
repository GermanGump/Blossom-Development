import SwiftUI

struct HubsView: View {
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            HubsTopNavBar(searchText: $searchText)
            Spacer()
            VStack(spacing: 8) {
                Text("Hubs")
                    .font(BlossomFont.title)
                    .foregroundColor(BlossomTheme.primaryText)
                Text("Communities will appear here")
                    .font(BlossomFont.subhead)
                    .foregroundColor(BlossomTheme.secondaryText)
            }
            Spacer()
        }
        .background(BlossomTheme.background)
        .navigationBarHidden(true)
        .navigationDestination(for: HubsRoute.self) { _ in
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        HubsView()
    }
}
