import SwiftUI

struct PermissionsMatrixView: View {
    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore

    private let permissionSections = ["Posts", "Discussions", "FAQ Submit", "Videos"]

    private var community: Community? {
        guard let id = subscriptionStore.session.creatorCommunityID else { return nil }
        return store.communities.first(where: { $0.id == id })
    }

    private var communityID: UUID? {
        subscriptionStore.session.creatorCommunityID
    }

    var body: some View {
        Group {
            if let community, let communityID {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Control which tiers can access each section")
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                            .padding(.horizontal, 16)

                        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 16) {
                            // Header row
                            GridRow {
                                Text("")
                                    .gridColumnAlignment(.leading)

                                ForEach(Array(community.tiers.enumerated()), id: \.element.id) { _, tier in
                                    Text(tier.name)
                                        .font(BlossomFont.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(BlossomTheme.primaryText)
                                        .frame(minWidth: 60)
                                        .multilineTextAlignment(.center)
                                }
                            }

                            Divider()

                            // Section rows
                            ForEach(permissionSections, id: \.self) { section in
                                GridRow {
                                    Text(section)
                                        .font(BlossomFont.subhead)
                                        .foregroundStyle(BlossomTheme.primaryText)
                                        .frame(minWidth: 80, alignment: .leading)

                                    ForEach(Array(community.tiers.enumerated()), id: \.element.id) { tierIndex, _ in
                                        Toggle(
                                            section,
                                            isOn: permissionBinding(
                                                section: section,
                                                tierIndex: tierIndex,
                                                communityID: communityID
                                            )
                                        )
                                        .labelsHidden()
                                        .toggleStyle(.switch)
                                        .tint(BlossomTheme.teal)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .blossomCard()
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 12)
                }
            } else {
                Text("No community found")
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
        }
        .background(BlossomTheme.background)
        .navigationTitle("Permissions")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func permissionBinding(section: String, tierIndex: Int, communityID: UUID) -> Binding<Bool> {
        Binding(
            get: { community?.permissions[section]?.contains(tierIndex) ?? false },
            set: { enabled in
                store.updateCommunity(id: communityID) { community in
                    if enabled {
                        community.permissions[section, default: []].insert(tierIndex)
                    } else {
                        community.permissions[section, default: []].remove(tierIndex)
                    }
                }
            }
        )
    }
}

#Preview {
    NavigationStack {
        PermissionsMatrixView()
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
