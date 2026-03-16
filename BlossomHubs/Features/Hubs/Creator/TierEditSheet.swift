import SwiftUI

struct TierEditSheet: View {
    let tier: Tier
    let communityID: UUID
    let store: CommunityStore

    @State private var name: String
    @State private var priceText: String
    @State private var benefits: [String]
    @State private var colorHex: String
    @State private var selectedColor: Color
    @Environment(\.dismiss) private var dismiss

    private static let presetColors: [(name: String, hex: String)] = [
        ("Violet", "7C3AED"),
        ("Teal", "14B8A6"),
        ("Blue", "3B82F6"),
        ("Orange", "F97316"),
        ("Rose", "F43F5E"),
        ("Emerald", "10B981"),
        ("Amber", "F59E0B"),
        ("Indigo", "6366F1"),
    ]

    init(tier: Tier, communityID: UUID, store: CommunityStore) {
        self.tier = tier
        self.communityID = communityID
        self.store = store
        _name = State(initialValue: tier.name)
        _priceText = State(initialValue: "\(tier.monthlyPrice)")
        _benefits = State(initialValue: tier.benefits)
        _colorHex = State(initialValue: tier.colorHex)
        _selectedColor = State(initialValue: Color.fromHex( tier.colorHex))
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

                Section {
                    // Preview tag
                    HStack {
                        Text("Preview:")
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                        TagView(name.isEmpty ? "Tier" : name, style: .tier, customColor: Color.fromHex( colorHex))
                        Spacer()
                    }
                    .padding(.vertical, 2)

                    // Preset color swatches
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Self.presetColors, id: \.hex) { preset in
                                Button {
                                    colorHex = preset.hex
                                    selectedColor = Color.fromHex( preset.hex)
                                } label: {
                                    Circle()
                                        .fill(Color.fromHex( preset.hex))
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Circle()
                                                .stroke(colorHex == preset.hex ? BlossomTheme.primaryText : Color.clear, lineWidth: 2.5)
                                        )
                                        .overlay(
                                            colorHex == preset.hex
                                                ? Image(systemName: "checkmark")
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundStyle(.white)
                                                : nil
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    // Custom HEX input
                    HStack(spacing: 8) {
                        Text("#")
                            .font(BlossomFont.body)
                            .foregroundStyle(BlossomTheme.secondaryText)
                        TextField("HEX Code", text: $colorHex)
                            .font(.system(.body, design: .monospaced))
                            .textInputAutocapitalization(.characters)
                            .onChange(of: colorHex) { _, newValue in
                                let cleaned = newValue.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
                                if cleaned.count == 6 {
                                    selectedColor = Color.fromHex( cleaned)
                                }
                            }

                        Circle()
                            .fill(Color.fromHex( colorHex))
                            .frame(width: 24, height: 24)
                            .overlay(Circle().stroke(BlossomTheme.cardBorder, lineWidth: 1))
                    }
                } header: {
                    Text("Tier Color")
                } footer: {
                    Text("This color appears on the tier tag in discussions and FAQ")
                        .font(BlossomFont.caption)
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

                Section {
                    Button(role: .destructive) {
                        deleteTier()
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Tier")
                                .font(BlossomFont.body)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
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

    private func deleteTier() {
        store.updateCommunity(id: communityID) { community in
            community.tiers.removeAll(where: { $0.id == tier.id })
        }
    }

    private func save() {
        let price = Decimal(string: priceText) ?? tier.monthlyPrice
        let filteredBenefits = benefits.filter { !$0.isEmpty }
        let cleanedHex = colorHex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let finalHex = cleanedHex.count == 6 ? cleanedHex : tier.colorHex
        store.updateCommunity(id: communityID) { community in
            if let index = community.tiers.firstIndex(where: { $0.id == tier.id }) {
                community.tiers[index].name = name
                community.tiers[index].monthlyPrice = price
                community.tiers[index].benefits = filteredBenefits
                community.tiers[index].colorHex = finalHex
            }
        }
    }
}
