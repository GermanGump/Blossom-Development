import Foundation
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "AccentColor" asset catalog color resource.
    static let accent = DeveloperToolsSupport.ColorResource(name: "AccentColor", bundle: resourceBundle)

    /// The "BlossomBackground" asset catalog color resource.
    static let blossomBackground = DeveloperToolsSupport.ColorResource(name: "BlossomBackground", bundle: resourceBundle)

    /// The "BlossomCardBorder" asset catalog color resource.
    static let blossomCardBorder = DeveloperToolsSupport.ColorResource(name: "BlossomCardBorder", bundle: resourceBundle)

    /// The "BlossomCardSurface" asset catalog color resource.
    static let blossomCardSurface = DeveloperToolsSupport.ColorResource(name: "BlossomCardSurface", bundle: resourceBundle)

    /// The "BlossomDarkNavy" asset catalog color resource.
    static let blossomDarkNavy = DeveloperToolsSupport.ColorResource(name: "BlossomDarkNavy", bundle: resourceBundle)

    /// The "BlossomOrange" asset catalog color resource.
    static let blossomOrange = DeveloperToolsSupport.ColorResource(name: "BlossomOrange", bundle: resourceBundle)

    /// The "BlossomPrimaryText" asset catalog color resource.
    static let blossomPrimaryText = DeveloperToolsSupport.ColorResource(name: "BlossomPrimaryText", bundle: resourceBundle)

    /// The "BlossomSecondaryText" asset catalog color resource.
    static let blossomSecondaryText = DeveloperToolsSupport.ColorResource(name: "BlossomSecondaryText", bundle: resourceBundle)

    /// The "BlossomSlate" asset catalog color resource.
    static let blossomSlate = DeveloperToolsSupport.ColorResource(name: "BlossomSlate", bundle: resourceBundle)

    /// The "BlossomTeal" asset catalog color resource.
    static let blossomTeal = DeveloperToolsSupport.ColorResource(name: "BlossomTeal", bundle: resourceBundle)

    /// The "BlossomViolet" asset catalog color resource.
    static let blossomViolet = DeveloperToolsSupport.ColorResource(name: "BlossomViolet", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "bd-profile-pic" asset catalog image resource.
    static let bdProfilePic = DeveloperToolsSupport.ImageResource(name: "bd-profile-pic", bundle: resourceBundle)

    /// The "blossom-logo-dark" asset catalog image resource.
    static let blossomLogoDark = DeveloperToolsSupport.ImageResource(name: "blossom-logo-dark", bundle: resourceBundle)

    /// The "blossom-logo-icon" asset catalog image resource.
    static let blossomLogoIcon = DeveloperToolsSupport.ImageResource(name: "blossom-logo-icon", bundle: resourceBundle)

    /// The "blossom-logo-light" asset catalog image resource.
    static let blossomLogoLight = DeveloperToolsSupport.ImageResource(name: "blossom-logo-light", bundle: resourceBundle)

    /// The "blossom-logo-white" asset catalog image resource.
    static let blossomLogoWhite = DeveloperToolsSupport.ImageResource(name: "blossom-logo-white", bundle: resourceBundle)

    /// The "brandon-profile-pic" asset catalog image resource.
    static let brandonProfilePic = DeveloperToolsSupport.ImageResource(name: "brandon-profile-pic", bundle: resourceBundle)

    /// The "canada-tshirt-profile-pic" asset catalog image resource.
    static let canadaTshirtProfilePic = DeveloperToolsSupport.ImageResource(name: "canada-tshirt-profile-pic", bundle: resourceBundle)

    /// The "max-profile-pic" asset catalog image resource.
    static let maxProfilePic = DeveloperToolsSupport.ImageResource(name: "max-profile-pic", bundle: resourceBundle)

    /// The "moe-profile-pic" asset catalog image resource.
    static let moeProfilePic = DeveloperToolsSupport.ImageResource(name: "moe-profile-pic", bundle: resourceBundle)

    /// The "nick-profile-pic" asset catalog image resource.
    static let nickProfilePic = DeveloperToolsSupport.ImageResource(name: "nick-profile-pic", bundle: resourceBundle)

}

