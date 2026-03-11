import Foundation

@MainActor
@Observable
final class HubsDiscoveryViewModel {
    private let store: CommunityStore
    var searchText: String = ""

    init(store: CommunityStore) {
        self.store = store
    }

    var heroCommunity: Community? {
        store.communities.first { $0.creator.username == "@bdinvesting" }
    }

    var listCommunities: [Community] {
        let heroID = heroCommunity?.id
        return store.communities
            .filter { $0.id != heroID }
            .sorted { $0.memberCount > $1.memberCount }
    }

    var filteredCommunities: [Community] {
        guard !searchText.isEmpty else { return store.communities }
        let query = searchText.lowercased()
        return store.communities.filter { community in
            community.name.lowercased().contains(query) ||
            community.creator.name.lowercased().contains(query) ||
            community.creator.username.lowercased().contains(query)
        }
    }
}
