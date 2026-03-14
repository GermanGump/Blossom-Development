import SwiftUI

struct CommunityHubView: View {
    let communityID: String

    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: CommunityHubViewModel?

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
        .onAppear {
            if viewModel == nil,
               let community = store.communities.first(where: { $0.id.uuidString == communityID }) {
                viewModel = CommunityHubViewModel(community: community)
            }
        }
    }

    @ViewBuilder
    private func hubContent(viewModel: CommunityHubViewModel) -> some View {
        ScrollView {
            CommunityLandingSection(
                community: viewModel.community,
                availableSections: viewModel.availableSections,
                onSectionSelected: { section in
                    viewModel.selectedSection = section
                }
            )
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
