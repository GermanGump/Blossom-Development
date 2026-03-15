// Features/Hubs/Forums/ForumComposeSheet.swift
import SwiftUI

struct ForumComposeSheet: View {
    let viewModel: ForumViewModel
    let userTierName: String

    @State private var title = ""
    @State private var content = ""
    @Environment(\.dismiss) private var dismiss

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
                            authorTierName: userTierName
                        )
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}
