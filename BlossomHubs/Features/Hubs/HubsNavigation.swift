import Foundation

enum HubsRoute: Hashable {
    case communityDetail(id: String)
    case communityPreview(id: String)
    case mySubscriptions
    case creatorDashboard
    case creatorEditCommunity
    case creatorManageTiers
    case creatorPermissions
    case creatorPublishContent
}
