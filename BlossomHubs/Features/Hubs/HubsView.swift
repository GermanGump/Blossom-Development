import SwiftUI

struct HubsView: View {
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            HubsTopNavBar(searchText: $searchText)
            Spacer()
            VStack(spacing: 8) {
                Text("Hubs")
                    .font(.title.weight(.semibold))
                    .foregroundColor(BlossomTheme.darkNavy)
                Text("Communities will appear here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
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
