import Foundation

enum HubsRoute: Hashable {
    case communityDetail(id: String)
    case communityPreview(id: String)
    case mySubscriptions
}
