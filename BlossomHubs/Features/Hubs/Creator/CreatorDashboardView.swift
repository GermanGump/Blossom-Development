import SwiftUI

struct CreatorDashboardView: View {
    @Environment(CommunityStore.self) private var communityStore
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var viewModel: CreatorDashboardViewModel?

    var body: some View {
        Group {
            if let viewModel, let community = viewModel.community {
                ScrollView {
                    VStack(spacing: 16) {
                        // Creator context header
                        HStack(spacing: 12) {
                            Image(community.creator.profileImageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text(community.name)
                                    .font(BlossomFont.headline)
                                    .foregroundStyle(BlossomTheme.primaryText)
                                Text(community.creator.username)
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(BlossomTheme.secondaryText)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 16)

                        // Stat cards
                        HStack(spacing: 12) {
                            statCard(
                                icon: "person.2.fill",
                                label: "Subscribers",
                                value: "\(viewModel.subscriberCount)"
                            )
                            statCard(
                                icon: "dollarsign.circle.fill",
                                label: "Est. Monthly",
                                value: viewModel.estimatedRevenue
                            )
                        }
                        .padding(.horizontal, 16)

                        // Section links
                        VStack(spacing: 10) {
                            sectionLink(
                                icon: "pencil.circle",
                                title: "Edit Community",
                                subtitle: "Title, description & appearance",
                                route: .creatorEditCommunity
                            )

                            sectionLink(
                                icon: "rectangle.stack",
                                title: "Manage Tiers",
                                subtitle: "\(community.tiers.count) tiers configured",
                                route: .creatorManageTiers
                            )

                            sectionLink(
                                icon: "lock.shield",
                                title: "Permissions",
                                subtitle: "Tier access by section",
                                route: .creatorPermissions
                            )

                            sectionLink(
                                icon: "square.and.pencil",
                                title: "Publish Content",
                                subtitle: "Create posts & trade highlights",
                                route: .creatorPublishContent
                            )

                            // Earnings placeholder
                            HStack(spacing: 12) {
                                Image(systemName: "chart.bar")
                                    .font(.system(size: 20))
                                    .foregroundStyle(BlossomTheme.violet)
                                    .frame(width: 32)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Earnings")
                                        .font(BlossomFont.subhead)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(BlossomTheme.primaryText)
                                    Text("Coming soon")
                                        .font(BlossomFont.caption)
                                        .foregroundStyle(BlossomTheme.secondaryText)
                                }

                                Spacer()
                            }
                            .padding(16)
                            .blossomCard()
                            .opacity(0.5)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 12)
                }
            } else {
                ProgressView()
            }
        }
        .background(BlossomTheme.background)
        .navigationTitle("Creator Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if viewModel == nil,
               let creatorID = subscriptionStore.session.creatorCommunityID {
                viewModel = CreatorDashboardViewModel(
                    communityID: creatorID,
                    communityStore: communityStore,
                    subscriptionStore: subscriptionStore
                )
            }
        }
    }

    private func statCard(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(BlossomTheme.violet)

            Text(value)
                .font(BlossomFont.headline)
                .foregroundStyle(BlossomTheme.primaryText)

            Text(label)
                .font(BlossomFont.caption)
                .foregroundStyle(BlossomTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .blossomCard()
    }

    private func sectionLink(icon: String, title: String, subtitle: String, route: HubsRoute) -> some View {
        NavigationLink(value: route) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(BlossomTheme.violet)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(BlossomFont.subhead)
                        .fontWeight(.semibold)
                        .foregroundStyle(BlossomTheme.primaryText)
                    Text(subtitle)
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
            .padding(16)
            .blossomCard()
        }
    }
}

#Preview {
    NavigationStack {
        CreatorDashboardView()
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
