// Features/Hubs/FAQ/FAQEntryRow.swift
import SwiftUI

struct FAQEntryRow: View {
    let entry: FAQEntry
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Question header — always visible
            Button(action: onToggle) {
                HStack(alignment: .top, spacing: 10) {
                    // Status icon
                    Image(systemName: entry.isAnswered ? "checkmark.circle.fill" : "clock")
                        .font(.system(size: 18))
                        .foregroundStyle(entry.isAnswered ? BlossomTheme.teal : BlossomTheme.secondaryText)

                    // Question text
                    Text(entry.question)
                        .font(BlossomFont.subhead)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(BlossomTheme.primaryText)

                    Spacer()

                    // Chevron for answered entries only
                    if entry.isAnswered {
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 14))
                            .foregroundStyle(BlossomTheme.secondaryText)
                    }
                }
            }
            .disabled(!entry.isAnswered)

            // Expanded answer section
            if isExpanded, let answer = entry.answer {
                VStack(alignment: .leading, spacing: 6) {
                    Text(answer)
                        .font(BlossomFont.body)
                        .foregroundStyle(BlossomTheme.primaryText)

                    // Creator attribution
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(BlossomTheme.teal)

                        Text("Answered by \(entry.answeredBy ?? "Creator")")
                            .font(BlossomFont.caption)
                            .foregroundStyle(BlossomTheme.secondaryText)
                    }
                }
                .padding(12)
                .background(BlossomTheme.teal.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.top, 8)
            }

            // Unanswered — show asker name
            if !entry.isAnswered {
                Text("Asked by \(entry.askedBy)")
                    .font(BlossomFont.caption)
                    .foregroundStyle(BlossomTheme.secondaryText)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 12)
    }
}
