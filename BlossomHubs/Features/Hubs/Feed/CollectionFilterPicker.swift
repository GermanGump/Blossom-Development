// Features/Hubs/Feed/CollectionFilterPicker.swift
import SwiftUI

struct CollectionFilterPicker: View {
    let collections: [String]
    @Binding var selectedCollection: String?

    private var label: String {
        if let selected = selectedCollection {
            return "Filter: \(selected)"
        }
        return "Filter: All Posts"
    }

    var body: some View {
        HStack {
            Menu {
                Button {
                    selectedCollection = nil
                } label: {
                    if selectedCollection == nil {
                        Label("All Posts", systemImage: "checkmark")
                    } else {
                        Text("All Posts")
                    }
                }

                Divider()

                ForEach(collections, id: \.self) { collection in
                    Button {
                        selectedCollection = collection
                    } label: {
                        if selectedCollection == collection {
                            Label(collection, systemImage: "checkmark")
                        } else {
                            Text(collection)
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(label)
                        .font(BlossomFont.subhead)
                        .foregroundStyle(BlossomTheme.primaryText)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundStyle(BlossomTheme.secondaryText)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
