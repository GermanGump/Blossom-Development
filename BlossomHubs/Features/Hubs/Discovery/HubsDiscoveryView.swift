import SwiftUI

struct HubsDiscoveryView: View {
    let searchText: String

    @Environment(CommunityStore.self) private var store
    @State private var viewModel: HubsDiscoveryViewModel?
    @State private var cardsVisible = false

    var body: some View {
        Group {
            if let vm = viewModel {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if let hero = vm.heroCommunity {
                            CommunityHeroCardView(community: hero)
                                .opacity(cardsVisible ? 1 : 0)
                                .offset(y: cardsVisible ? 0 : 20)
                                .animation(.easeOut(duration: 0.35).delay(0), value: cardsVisible)
                        }

                        ForEach(Array(vm.listCommunities.enumerated()), id: \.element.id) { index, community in
                            CommunityCardView(community: community)
                                .opacity(cardsVisible ? 1 : 0)
                                .offset(y: cardsVisible ? 0 : 20)
                                .animation(
                                    .easeOut(duration: 0.35).delay(Double(index + 1) * 0.08),
                                    value: cardsVisible
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: searchText) { _, newValue in
                    vm.searchText = newValue
                }
                .task {
                    guard !cardsVisible else { return }
                    cardsVisible = true
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = HubsDiscoveryViewModel(store: store)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HubsDiscoveryView(searchText: "")
            .environment(CommunityStore())
    }
    .background(BlossomTheme.background)
}
