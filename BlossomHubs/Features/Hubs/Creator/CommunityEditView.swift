import SwiftUI

struct CommunityEditView: View {
    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore

    private var community: Community? {
        guard let id = subscriptionStore.session.creatorCommunityID else { return nil }
        return store.communities.first(where: { $0.id == id })
    }

    private var communityID: UUID? {
        subscriptionStore.session.creatorCommunityID
    }

    private static let logoOptions = [
        "nick-profile-pic",
        "bd-profile-pic",
        "brandon-profile-pic",
        "max-profile-pic",
        "moe-profile-pic",
        "canada-tshirt-profile-pic"
    ]

    var body: some View {
        Group {
            if let community, let communityID {
                Form {
                    Section("Details") {
                        TextField("Community Name", text: Binding(
                            get: { community.name },
                            set: { newValue in
                                store.updateCommunity(id: communityID) { c in
                                    c.name = newValue
                                }
                            }
                        ))
                        .font(BlossomFont.body)

                        TextField("Description", text: Binding(
                            get: { community.description },
                            set: { newValue in
                                store.updateCommunity(id: communityID) { c in
                                    c.description = newValue
                                }
                            }
                        ), axis: .vertical)
                        .font(BlossomFont.body)
                        .lineLimit(3...6)
                    }

                    Section("Appearance") {
                        Picker("Logo", selection: Binding(
                            get: { community.logoImageName },
                            set: { newValue in
                                store.updateCommunity(id: communityID) { c in
                                    c.logoImageName = newValue
                                }
                            }
                        )) {
                            ForEach(Self.logoOptions, id: \.self) { name in
                                HStack {
                                    Image(name)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 28, height: 28)
                                        .clipShape(Circle())
                                    Text(name.replacingOccurrences(of: "-profile-pic", with: "").capitalized)
                                }
                                .tag(name)
                            }
                        }
                        .font(BlossomFont.body)
                    }

                    Section("Category") {
                        TextField("Category", text: Binding(
                            get: { community.category },
                            set: { newValue in
                                store.updateCommunity(id: communityID) { c in
                                    c.category = newValue
                                }
                            }
                        ))
                        .font(BlossomFont.body)
                    }
                }
            } else {
                Text("No community found")
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
        }
        .navigationTitle("Edit Community")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CommunityEditView()
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
