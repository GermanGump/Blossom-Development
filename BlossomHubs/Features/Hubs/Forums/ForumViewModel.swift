// Features/Hubs/Forums/ForumViewModel.swift
import Foundation
import SwiftUI

@MainActor
@Observable
final class ForumViewModel {
    let community: Community
    var threads: [ForumThread]
    var likedThreadIDs: Set<UUID> = []
    var likedReplyIDs: Set<UUID> = []
    var replies: [UUID: [ForumReply]] = [:]

    init(community: Community) {
        self.community = community
        self.threads = community.threads.sorted { $0.publishedAt > $1.publishedAt }
        generateMockReplies()
    }

    func canAccessThread(_ thread: ForumThread, userTierIndex: Int?) -> Bool {
        guard let index = userTierIndex else { return false }
        return thread.requiredTierIndex <= index
    }

    func tierName(for requiredIndex: Int) -> String {
        guard requiredIndex < community.tiers.count else { return "Premium" }
        return community.tiers[requiredIndex].name
    }

    func tierColor(for requiredIndex: Int) -> Color? {
        guard requiredIndex < community.tiers.count else { return nil }
        return community.tiers[requiredIndex].color
    }

    func toggleThreadLike(threadID: UUID) {
        if likedThreadIDs.contains(threadID) {
            likedThreadIDs.remove(threadID)
        } else {
            likedThreadIDs.insert(threadID)
        }
    }

    func toggleReplyLike(replyID: UUID) {
        if likedReplyIDs.contains(replyID) {
            likedReplyIDs.remove(replyID)
        } else {
            likedReplyIDs.insert(replyID)
        }
    }

    func addThread(title: String, content: String, authorTierIndex: Int, authorId: UUID) {
        let thread = ForumThread(
            title: title,
            content: content,
            authorId: authorId,
            requiredTierIndex: authorTierIndex,
            publishedAt: Date()
        )
        threads.insert(thread, at: 0)
    }

    func addReply(threadID: UUID, authorName: String, authorTierName: String, content: String) {
        let reply = ForumReply(
            threadID: threadID,
            authorId: UUID(),
            authorName: authorName,
            authorTierName: authorTierName,
            content: content,
            publishedAt: Date()
        )
        replies[threadID, default: []].append(reply)

        // Replace the thread with an updated replyCount
        if let idx = threads.firstIndex(where: { $0.id == threadID }) {
            let old = threads[idx]
            threads[idx] = ForumThread(
                id: old.id,
                title: old.title,
                content: old.content,
                authorId: old.authorId,
                requiredTierIndex: old.requiredTierIndex,
                replyCount: old.replyCount + 1,
                likeCount: old.likeCount,
                publishedAt: old.publishedAt
            )
        }
    }

    // MARK: - Mock Data Generation

    private func generateMockReplies() {
        let memberNames = ["TraderMike", "InvestorJane", "CryptoCarl", "MarketMaven", "AlphaSeeker"]
        let creatorName = community.creator.name
        let creatorId = community.creator.id

        for thread in threads {
            var threadReplies: [ForumReply] = []
            let replyCount = Int.random(in: 3...5)

            for i in 0..<replyCount {
                let isCreatorReply = (i == 0) // First reply is always from creator
                let name = isCreatorReply ? creatorName : memberNames[i % memberNames.count]
                let authorId = isCreatorReply ? creatorId : UUID()
                let tierIndex = min(Int.random(in: 0...community.tiers.count - 1), community.tiers.count - 1)
                let tierName = community.tiers[tierIndex].name

                let replyContents = [
                    "Great analysis! This aligns with what I've been seeing in the market lately.",
                    "Thanks for sharing this insight. I adjusted my position accordingly.",
                    "Interesting perspective. Have you considered the macro implications?",
                    "This is exactly the kind of content I subscribed for. Keep it coming!",
                    "I ran the numbers and your thesis checks out. Solid setup here."
                ]

                let reply = ForumReply(
                    threadID: thread.id,
                    authorId: authorId,
                    authorName: name,
                    authorTierName: tierName,
                    content: replyContents[i % replyContents.count],
                    likeCount: Int.random(in: 0...15),
                    publishedAt: thread.publishedAt.addingTimeInterval(Double(i + 1) * 3600),
                    isCreator: isCreatorReply,
                    isAmbassador: isCreatorReply && community.creator.isAmbassador
                )
                threadReplies.append(reply)
            }

            replies[thread.id] = threadReplies
        }
    }
}
