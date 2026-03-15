// Features/Hubs/FAQ/FAQViewModel.swift
import Foundation

@MainActor
@Observable
final class FAQViewModel {
    let community: Community
    var entries: [FAQEntry]
    let faqRequiredTierIndex: Int

    init(community: Community, faqRequiredTierIndex: Int = 1) {
        self.community = community
        self.entries = community.faqEntries
        self.faqRequiredTierIndex = faqRequiredTierIndex
    }

    /// Answered entries first, then unanswered, preserving original order within each group.
    var sortedEntries: [FAQEntry] {
        let answered = entries.filter { $0.isAnswered }
        let unanswered = entries.filter { !$0.isAnswered }
        return answered + unanswered
    }

    func canAskQuestion(userTierIndex: Int?) -> Bool {
        guard let index = userTierIndex else { return false }
        return index >= faqRequiredTierIndex
    }

    var requiredTierName: String {
        guard faqRequiredTierIndex < community.tiers.count else {
            return "Premium"
        }
        return community.tiers[faqRequiredTierIndex].name
    }

    func submitQuestion(text: String, askedBy: String) {
        let entry = FAQEntry(
            question: text,
            answer: nil,
            isAnswered: false,
            askedBy: askedBy,
            answeredBy: nil
        )
        entries.append(entry)
    }
}
