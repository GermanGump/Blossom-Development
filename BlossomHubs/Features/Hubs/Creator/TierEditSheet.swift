import SwiftUI

struct TierEditSheet: View {
    let tier: Tier
    let communityID: UUID
    let store: CommunityStore

    @State private var name: String
    @State private var priceText: String
    @State private var benefits: [String]
    @Environment(\.dismiss) private var dismiss

    init(tier: Tier, communityID: UUID, store: CommunityStore) {
        self.tier = tier
        self.communityID = communityID
        self.store = store
        _name = State(initialValue: tier.name)
        _priceText = State(initialValue: "\(tier.monthlyPrice)")
        _benefits = State(initialValue: tier.benefits)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Tier Details") {
                    TextField("Tier Name", text: $name)
                        .font(BlossomFont.body)

                    HStack {
                        Text("$")
                            .font(BlossomFont.body)
                            .foregroundStyle(BlossomTheme.secondaryText)
                        TextField("Monthly Price", text: $priceText)
                            .font(BlossomFont.body)
                            .keyboardType(.decimalPad)
                        Text("/mo")
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                    }
                }

                Section("Benefits") {
                    ForEach(benefits.indices, id: \.self) { index in
                        HStack {
                            TextField("Benefit", text: $benefits[index])
                                .font(BlossomFont.body)

                            Button {
                                benefits.remove(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Button {
                        benefits.append("")
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(BlossomTheme.violet)
                            Text("Add Benefit")
                                .font(BlossomFont.body)
                                .foregroundStyle(BlossomTheme.violet)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Edit Tier")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func save() {
        let price = Decimal(string: priceText) ?? tier.monthlyPrice
        let filteredBenefits = benefits.filter { !$0.isEmpty }
        store.updateCommunity(id: communityID) { community in
            if let index = community.tiers.firstIndex(where: { $0.id == tier.id }) {
                community.tiers[index].name = name
                community.tiers[index].monthlyPrice = price
                community.tiers[index].benefits = filteredBenefits
            }
        }
    }
}
