import PhotosUI
import SwiftUI

struct CommunityEditView: View {
    @Environment(CommunityStore.self) private var store
    @Environment(SubscriptionStore.self) private var subscriptionStore

    // Draft state — only committed on Save
    @State private var draftName: String = ""
    @State private var draftDescription: String = ""
    @State private var draftCategory: String = ""
    @State private var draftLogoData: Data?
    @State private var draftBannerData: Data?
    @State private var hasLogoChange = false
    @State private var hasBannerChange = false

    @State private var logoPickerItem: PhotosPickerItem?
    @State private var bannerPickerItem: PhotosPickerItem?
    @State private var didLoad = false
    @State private var showSavedConfirmation = false

    private var community: Community? {
        guard let id = subscriptionStore.session.creatorCommunityID else { return nil }
        return store.communities.first(where: { $0.id == id })
    }

    private var communityID: UUID? {
        subscriptionStore.session.creatorCommunityID
    }

    private var hasChanges: Bool {
        guard let community else { return false }
        return draftName != community.name
            || draftDescription != community.description
            || draftCategory != community.category
            || hasLogoChange
            || hasBannerChange
    }

    var body: some View {
        Group {
            if let community, let communityID {
                Form {
                    Section("Community Hub Name") {
                        TextField("Enter hub name", text: $draftName)
                            .font(BlossomFont.body)
                            .textInputAutocapitalization(.words)
                    }

                    Section("Hub Description") {
                        TextField("Describe your hub", text: $draftDescription, axis: .vertical)
                            .font(BlossomFont.body)
                            .lineLimit(3...6)
                    }

                    Section {
                        HStack(spacing: 16) {
                            logoPreview(community)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(BlossomTheme.teal, lineWidth: 2)
                                )

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Current Logo")
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(BlossomTheme.secondaryText)

                                PhotosPicker(selection: $logoPickerItem, matching: .images) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "arrow.up.circle.fill")
                                            .font(.system(size: 16))
                                        Text("Upload New Logo")
                                            .font(BlossomFont.caption)
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundStyle(BlossomTheme.violet)
                                }
                            }

                            Spacer()
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Text("Logo")
                    } footer: {
                        Text("Recommended: 400 x 400 px (square, 1:1 ratio)")
                            .font(BlossomFont.caption)
                    }

                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            bannerPreview(community)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            PhotosPicker(selection: $bannerPickerItem, matching: .images) {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.system(size: 16))
                                    Text("Upload New Banner")
                                        .font(BlossomFont.caption)
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(BlossomTheme.violet)
                            }
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Text("Banner")
                    } footer: {
                        Text("Recommended: 1200 x 400 px (landscape, 3:1 ratio)")
                            .font(BlossomFont.caption)
                    }

                    Section("Category") {
                        TextField("Category", text: $draftCategory)
                            .font(BlossomFont.body)
                    }

                    Section {
                        Button {
                            saveChanges(communityID: communityID)
                        } label: {
                            HStack {
                                Spacer()
                                if showSavedConfirmation {
                                    HStack(spacing: 6) {
                                        Image(systemName: "checkmark.circle.fill")
                                        Text("Saved!")
                                    }
                                    .font(BlossomFont.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                } else {
                                    Text("Save Changes")
                                        .font(BlossomFont.body)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(hasChanges ? BlossomTheme.teal : BlossomTheme.teal.opacity(0.4))
                        .disabled(!hasChanges)
                    }
                }
                .contentMargins(.bottom, 100)
                .onAppear {
                    guard !didLoad else { return }
                    draftName = community.name
                    draftDescription = community.description
                    draftCategory = community.category
                    draftLogoData = community.logoImageData
                    draftBannerData = community.bannerImageData
                    didLoad = true
                }
                .onChange(of: logoPickerItem) { _, newItem in
                    Task {
                        guard let newItem,
                              let data = try? await newItem.loadTransferable(type: Data.self) else { return }
                        draftLogoData = data
                        hasLogoChange = true
                        logoPickerItem = nil
                    }
                }
                .onChange(of: bannerPickerItem) { _, newItem in
                    Task {
                        guard let newItem,
                              let data = try? await newItem.loadTransferable(type: Data.self) else { return }
                        draftBannerData = data
                        hasBannerChange = true
                        bannerPickerItem = nil
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

    private func saveChanges(communityID: UUID) {
        store.updateCommunity(id: communityID) { c in
            c.name = draftName
            c.description = draftDescription
            c.category = draftCategory
            if hasLogoChange {
                c.logoImageData = draftLogoData
            }
            if hasBannerChange {
                c.bannerImageData = draftBannerData
            }
        }
        hasLogoChange = false
        hasBannerChange = false
        showSavedConfirmation = true
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            showSavedConfirmation = false
        }
    }

    private func logoPreview(_ community: Community) -> Image {
        if hasLogoChange, let data = draftLogoData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        if let data = community.logoImageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return Image(community.logoImageName)
    }

    private func bannerPreview(_ community: Community) -> Image {
        if hasBannerChange, let data = draftBannerData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        if let data = community.bannerImageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        if let bannerName = community.bannerImageName {
            return Image(bannerName)
        }
        return Image(systemName: "photo")
    }
}

#Preview {
    NavigationStack {
        CommunityEditView()
            .environment(CommunityStore())
            .environment(SubscriptionStore())
    }
}
