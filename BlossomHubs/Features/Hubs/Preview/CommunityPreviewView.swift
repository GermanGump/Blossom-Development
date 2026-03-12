import SwiftUI

struct CommunityPreviewView: View {
    let communityID: String

    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: CommunityPreviewViewModel?
    @State private var showTiers = false

    var body: some View {
        Group {
            if let viewModel {
                contentView(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(BlossomTheme.background)
            }
        }
        .onAppear {
            if viewModel == nil,
               let community = store.communities.first(where: { $0.id.uuidString == communityID }) {
                viewModel = CommunityPreviewViewModel(community: community)
            }
        }
    }

    @ViewBuilder
    private func contentView(viewModel: CommunityPreviewViewModel) -> some View {
        let community = viewModel.community

        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: - Parallax Banner
                Color.clear
                    .frame(height: 240)
                    .overlay(alignment: .center) {
                        if let bannerName = community.bannerImageName {
                            Image(bannerName)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, proxy in
                                    let offsetY = proxy.frame(in: .scrollView).minY
                                    return content.offset(y: offsetY > 0 ? -offsetY * 0.4 : 0)
                                }
                        } else {
                            LinearGradient(
                                colors: [BlossomTheme.violet, BlossomTheme.teal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .visualEffect { content, proxy in
                                let offsetY = proxy.frame(in: .scrollView).minY
                                return content.offset(y: offsetY > 0 ? -offsetY * 0.4 : 0)
                            }
                        }
                    }
                    .clipped()

                // MARK: - Creator Avatar overlapping banner
                HStack {
                    AvatarView(
                        imageName: community.creator.profileImageName,
                        preset: .xlarge,
                        ringColor: .white,
                        showVerifiedBadge: community.creator.isVerified
                    )
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 3)
                            .frame(width: 80, height: 80)
                    )
                    .offset(y: -40)
                    .padding(.leading, 16)
                    Spacer()
                }
                .padding(.bottom, -40)

                // MARK: - Content Section
                VStack(alignment: .leading, spacing: 24) {

                    // Spacer for avatar overlap
                    Color.clear.frame(height: 12)

                    // Value proposition tagline
                    VStack(alignment: .leading, spacing: 8) {
                        Text(community.name)
                            .font(BlossomFont.title)
                            .foregroundStyle(BlossomTheme.primaryText)

                        TagView(community.category, style: .category)
                    }

                    // Creator bio section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 10) {
                            AvatarView(
                                imageName: community.creator.profileImageName,
                                preset: .medium
                            )
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 6) {
                                    Text(community.creator.name)
                                        .font(BlossomFont.headline)
                                        .foregroundStyle(BlossomTheme.primaryText)
                                    if community.creator.isVerified {
                                        VerifiedBadge()
                                    }
                                }
                                Text(community.creator.username)
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(BlossomTheme.secondaryText)
                            }
                        }

                        Text(community.creator.bio)
                            .font(BlossomFont.body)
                            .foregroundStyle(BlossomTheme.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Full description
                    Text(community.description)
                        .font(BlossomFont.body)
                        .foregroundStyle(BlossomTheme.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    // Social proof section
                    SocialProofSection(community: community)

                    // Bottom padding so content isn't hidden behind CTA
                    Color.clear.frame(height: 80)
                }
                .padding(.horizontal, 16)
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
                        Text("Communities")
                            .font(BlossomFont.subhead)
                    }
                    .foregroundStyle(BlossomTheme.violet)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Divider()
                Button(subscriptionStore.isSubscribed(to: UUID(uuidString: communityID) ?? UUID())
                       ? "Your Subscription" : "View Tiers") {
                    showTiers = true
                }
                .buttonStyle(BlossomPrimaryButton())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(BlossomTheme.background)
        }
        .sheet(isPresented: $showTiers) {
            TiersBottomSheet(
                community: community,
                tiers: community.tiers,
                popularTierIndex: viewModel.popularTierIndex,
                onSubscriptionComplete: {
                    showTiers = false
                    Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(300))
                        dismiss()
                    }
                }
            )
            .presentationDetents([.fraction(0.55), .large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Social Proof Section

private struct SocialProofSection: View {
    let community: Community

    // Hardcoded testimonials per community name (fallback for any community)
    private var testimonial: (quote: String, author: String) {
        switch community.name {
        case "Wealthmatica":
            return (
                "Nick's weekly commentary completely changed how I think about dividend investing. Worth every penny.",
                "Sarah M."
            )
        case "BD Investing":
            return (
                "The swing trade alerts alone have paid for my subscription ten times over. BD is the real deal.",
                "James K."
            )
        case "Brandon's Alpha":
            return (
                "Brandon's options strategies are next level. I've learned more here than from any paid course.",
                "Tyler R."
            )
        case "Max Markets":
            return (
                "Max breaks down complex macro trends in a way that actually makes sense. Game-changing content.",
                "Priya L."
            )
        case "Moe's Watchlist":
            return (
                "Moe's watchlist picks have been consistently outperforming the market. Incredible community.",
                "Derek F."
            )
        case "Canadian Investor":
            return (
                "Finally a community focused on Canadian stocks and ETFs. The TSX coverage is unmatched.",
                "Amanda C."
            )
        default:
            return (
                "This community has completely transformed my investing approach. Highly recommended.",
                "Alex P."
            )
        }
    }

    // Placeholder avatar colors for member row
    private let avatarColors: [Color] = [
        Color(red: 0.4, green: 0.6, blue: 0.9),
        Color(red: 0.6, green: 0.85, blue: 0.7),
        Color(red: 0.95, green: 0.65, blue: 0.4),
        Color(red: 0.75, green: 0.5, blue: 0.9),
        Color(red: 0.5, green: 0.8, blue: 0.85)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Member count
            HStack(spacing: 6) {
                Image(systemName: "person.2.fill")
                    .foregroundStyle(BlossomTheme.teal)
                    .font(.system(size: 15))
                Text("\(community.memberCount.formatted()) members")
                    .font(BlossomFont.subhead)
                    .foregroundStyle(BlossomTheme.primaryText)
            }

            // Member avatar row (overlapping circles)
            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(avatarColors[index])
                        .frame(width: 32, height: 32)
                        .overlay(Circle().stroke(BlossomTheme.background, lineWidth: 2))
                        .overlay(alignment: .center) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                        }
                        .offset(x: CGFloat(index) * -8)
                }
                Text("+\(max(0, community.memberCount - 5)) more")
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.secondaryText)
                    .offset(x: -8 * 4 + 4)
            }

            // Testimonial quote card
            HStack(spacing: 0) {
                Rectangle()
                    .fill(BlossomTheme.violet)
                    .frame(width: 3)
                    .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text("\"\(testimonial.quote)\"")
                        .font(BlossomFont.body)
                        .foregroundStyle(BlossomTheme.primaryText)
                        .italic()
                        .fixedSize(horizontal: false, vertical: true)

                    Text("— \(testimonial.author)")
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                }
                .padding(.leading, 12)
                .padding(.vertical, 10)
            }
            .padding(12)
            .background(BlossomTheme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(BlossomTheme.cardBorder, lineWidth: 1)
            )
        }
        .padding(16)
        .background(BlossomTheme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(BlossomTheme.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        CommunityPreviewView(communityID: CommunityStore().communities.first!.id.uuidString)
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
