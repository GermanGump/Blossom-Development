// Features/Hubs/FAQ/FAQListView.swift
import SwiftUI

struct FAQListView: View {
    let community: Community

    @State private var viewModel: FAQViewModel?
    @Environment(SubscriptionStore.self) private var subscriptionStore
    @State private var expandedEntryID: UUID?
    @State private var questionText = ""
    @State private var showUpgradeSheet = false

    /// Resolve the user's tier index within this community's tiers array.
    private var userTierIndex: Int? {
        guard let tierID = subscriptionStore.currentTier(for: community.id) else {
            return nil
        }
        return community.tiers.firstIndex { $0.id == tierID }
    }

    /// Heuristic: second tier is "Most Popular" when 2+ tiers exist.
    private var popularTierIndex: Int {
        community.tiers.count >= 2 ? 1 : 0
    }

    var body: some View {
        if let viewModel {
            let hasPermission = viewModel.canAskQuestion(userTierIndex: userTierIndex)

            // CRITICAL: No ScrollView here -- participates in outer CommunityHubView scroll
            VStack(alignment: .leading, spacing: 0) {
                // Inline Ask field at top
                HStack(spacing: 8) {
                    TextField("Ask a question...", text: $questionText)
                        .font(BlossomFont.body)
                        .disabled(!hasPermission)

                    Button {
                        viewModel.submitQuestion(text: questionText, askedBy: "You")
                        questionText = ""
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(BlossomTheme.violet)
                    }
                    .disabled(questionText.isEmpty || !hasPermission)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                // Upgrade prompt when no permission
                if !hasPermission {
                    Button {
                        showUpgradeSheet = true
                    } label: {
                        Text("Upgrade to \(viewModel.requiredTierName) to ask questions")
                            .font(BlossomFont.caption)
                            .foregroundStyle(.orange)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }

                Divider()

                // FAQ entries
                ForEach(viewModel.sortedEntries) { entry in
                    FAQEntryRow(
                        entry: entry,
                        isExpanded: expandedEntryID == entry.id,
                        onToggle: {
                            withAnimation {
                                expandedEntryID = expandedEntryID == entry.id ? nil : entry.id
                            }
                        }
                    )
                    .padding(.horizontal, 16)

                    Divider()
                }

                Spacer()
            }
            .sheet(isPresented: $showUpgradeSheet) {
                TiersBottomSheet(
                    community: community,
                    tiers: community.tiers,
                    popularTierIndex: popularTierIndex
                )
            }
        } else {
            ProgressView()
                .frame(maxWidth: .infinity, minHeight: 200)
                .onAppear {
                    viewModel = FAQViewModel(community: community)
                }
        }
    }
}
