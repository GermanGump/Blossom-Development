// Features/Hubs/Forums/ForumComposeSheet.swift
import SwiftUI

struct ForumComposeSheet: View {
    let viewModel: ForumViewModel
    let userTierIndex: Int

    @State private var title = ""
    @State private var content = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(SubscriptionStore.self) private var subscriptionStore

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Thread title", text: $title)
                        .font(BlossomFont.subhead)

                    TextField("What's on your mind?", text: $content, axis: .vertical)
                        .font(BlossomFont.body)
                        .lineLimit(3...8)
                }
            }
            .navigationTitle("New Thread")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        viewModel.addThread(
                            title: title,
                            content: content,
                            authorTierIndex: userTierIndex,
                            authorId: subscriptionStore.session.id
                        )
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}
