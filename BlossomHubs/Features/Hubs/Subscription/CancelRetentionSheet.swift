import SwiftUI

struct CancelRetentionSheet: View {
    let onConfirmCancel: () -> Void

    @State private var selectedReason: String? = nil
    @Environment(\.dismiss) private var dismiss

    private let reasons = [
        "Too expensive",
        "Not enough content",
        "Found a better alternative",
        "Just taking a break",
        "Other"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Header
            Text("Why are you leaving?")
                .font(BlossomFont.title)
                .foregroundStyle(BlossomTheme.primaryText)

            Text("We'd love to know so we can improve.")
                .font(BlossomFont.body)
                .foregroundStyle(BlossomTheme.secondaryText)

            // Reason list
            VStack(spacing: 0) {
                ForEach(reasons, id: \.self) { reason in
                    Button {
                        selectedReason = reason
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: selectedReason == reason ? "circle.inset.filled" : "circle")
                                .font(.system(size: 20))
                                .foregroundStyle(selectedReason == reason ? BlossomTheme.violet : BlossomTheme.secondaryText)

                            Text(reason)
                                .font(BlossomFont.body)
                                .foregroundStyle(BlossomTheme.primaryText)

                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if reason != reasons.last {
                        Divider()
                    }
                }
            }

            Spacer()

            // Action buttons
            VStack(spacing: 12) {
                Button("Cancel Subscription") {
                    onConfirmCancel()
                }
                .font(BlossomFont.buttonLabel)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(selectedReason != nil ? Color.red : Color.red.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .disabled(selectedReason == nil)

                Button("Never mind, keep subscription") {
                    dismiss()
                }
                .buttonStyle(BlossomSecondaryButton())
            }
        }
        .padding(20)
        .background(BlossomTheme.background)
    }
}

#Preview {
    CancelRetentionSheet(onConfirmCancel: {})
        .presentationDetents([.medium])
}
