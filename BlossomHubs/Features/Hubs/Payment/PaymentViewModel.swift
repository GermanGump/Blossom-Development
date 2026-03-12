import Foundation

enum PaymentState: Equatable, Sendable {
    case idle
    case processing
    case success
}

@MainActor
@Observable
final class PaymentViewModel {
    var state: PaymentState = .idle
    let community: Community
    let tier: Tier

    init(community: Community, tier: Tier) {
        self.community = community
        self.tier = tier
    }

    func submitPayment() async {
        state = .processing
        try? await Task.sleep(for: .seconds(Double.random(in: 1.0...2.0)))
        state = .success
    }

    var isProcessing: Bool { state == .processing }
}
