import SwiftUI

struct CommunityHubView: View {
    let communityID: String

    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: CommunityHubViewModel?
    @State private var showWelcome = false

    var body: some View {
        Group {
            if let viewModel {
                hubContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(BlossomTheme.background)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text(viewModel?.community.name ?? "Community")
                            .font(BlossomFont.subhead)
                    }
                    .foregroundStyle(BlossomTheme.violet)
                }
            }
        }
        .overlay {
            if showWelcome, let vm = viewModel,
               let sub = subscriptionStore.session.subscriptions[vm.community.id] {
                WelcomeOverlayView(
                    communityName: vm.community.name,
                    tierName: sub.tierName,
                    onExplore: {
                        withAnimation {
                            showWelcome = false
                        }
                        subscriptionStore.markWelcomeSeen(for: vm.community.id)
                    }
                )
            }
        }
        .onAppear {
            if viewModel == nil,
               let community = store.communities.first(where: { $0.id.uuidString == communityID }) {
                viewModel = CommunityHubViewModel(community: community)

                // Show welcome overlay on first visit after subscribing
                if let sub = subscriptionStore.session.subscriptions[community.id],
                   !sub.hasSeenWelcome {
                    Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(300))
                        showWelcome = true
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func hubContent(viewModel: CommunityHubViewModel) -> some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                // Landing content (not inside the pinned Section)
                CommunityLandingSection(
                    community: viewModel.community,
                    availableSections: viewModel.availableSections,
                    onSectionSelected: { section in
                        viewModel.selectedSection = section
                    }
                )

                // Pager section with sticky segmented control header
                Section {
                    CommunitySectionPager(
                        community: viewModel.community,
                        availableSections: viewModel.availableSections,
                        selectedSection: Binding(
                            get: { viewModel.selectedSection },
                            set: { viewModel.selectedSection = $0 }
                        )
                    )
                } header: {
                    if viewModel.availableSections.contains(where: { $0 != .landing }) {
                        Picker("Section", selection: Binding(
                            get: { viewModel.selectedSection },
                            set: { viewModel.selectedSection = $0 }
                        )) {
                            ForEach(viewModel.availableSections.filter { $0 != .landing }) { section in
                                Text(section.title).tag(section)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(BlossomTheme.background)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CommunityHubView(communityID: CommunityStore().communities.first!.id.uuidString)
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
