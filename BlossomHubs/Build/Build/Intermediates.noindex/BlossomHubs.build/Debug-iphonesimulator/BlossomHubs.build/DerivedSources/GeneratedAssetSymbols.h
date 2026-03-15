#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.blossom.hubs-prototype";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "BlossomBackground" asset catalog color resource.
static NSString * const ACColorNameBlossomBackground AC_SWIFT_PRIVATE = @"BlossomBackground";

/// The "BlossomCardBorder" asset catalog color resource.
static NSString * const ACColorNameBlossomCardBorder AC_SWIFT_PRIVATE = @"BlossomCardBorder";

/// The "BlossomCardSurface" asset catalog color resource.
static NSString * const ACColorNameBlossomCardSurface AC_SWIFT_PRIVATE = @"BlossomCardSurface";

/// The "BlossomDarkNavy" asset catalog color resource.
static NSString * const ACColorNameBlossomDarkNavy AC_SWIFT_PRIVATE = @"BlossomDarkNavy";

/// The "BlossomOrange" asset catalog color resource.
static NSString * const ACColorNameBlossomOrange AC_SWIFT_PRIVATE = @"BlossomOrange";

/// The "BlossomPrimaryText" asset catalog color resource.
static NSString * const ACColorNameBlossomPrimaryText AC_SWIFT_PRIVATE = @"BlossomPrimaryText";

/// The "BlossomSecondaryText" asset catalog color resource.
static NSString * const ACColorNameBlossomSecondaryText AC_SWIFT_PRIVATE = @"BlossomSecondaryText";

/// The "BlossomSlate" asset catalog color resource.
static NSString * const ACColorNameBlossomSlate AC_SWIFT_PRIVATE = @"BlossomSlate";

/// The "BlossomTeal" asset catalog color resource.
static NSString * const ACColorNameBlossomTeal AC_SWIFT_PRIVATE = @"BlossomTeal";

/// The "BlossomViolet" asset catalog color resource.
static NSString * const ACColorNameBlossomViolet AC_SWIFT_PRIVATE = @"BlossomViolet";

/// The "bd-profile-pic" asset catalog image resource.
static NSString * const ACImageNameBdProfilePic AC_SWIFT_PRIVATE = @"bd-profile-pic";

/// The "blossom-logo-dark" asset catalog image resource.
static NSString * const ACImageNameBlossomLogoDark AC_SWIFT_PRIVATE = @"blossom-logo-dark";

/// The "blossom-logo-icon" asset catalog image resource.
static NSString * const ACImageNameBlossomLogoIcon AC_SWIFT_PRIVATE = @"blossom-logo-icon";

/// The "blossom-logo-light" asset catalog image resource.
static NSString * const ACImageNameBlossomLogoLight AC_SWIFT_PRIVATE = @"blossom-logo-light";

/// The "blossom-logo-white" asset catalog image resource.
static NSString * const ACImageNameBlossomLogoWhite AC_SWIFT_PRIVATE = @"blossom-logo-white";

/// The "brandon-profile-pic" asset catalog image resource.
static NSString * const ACImageNameBrandonProfilePic AC_SWIFT_PRIVATE = @"brandon-profile-pic";

/// The "canada-tshirt-profile-pic" asset catalog image resource.
static NSString * const ACImageNameCanadaTshirtProfilePic AC_SWIFT_PRIVATE = @"canada-tshirt-profile-pic";

/// The "max-profile-pic" asset catalog image resource.
static NSString * const ACImageNameMaxProfilePic AC_SWIFT_PRIVATE = @"max-profile-pic";

/// The "moe-profile-pic" asset catalog image resource.
static NSString * const ACImageNameMoeProfilePic AC_SWIFT_PRIVATE = @"moe-profile-pic";

/// The "nick-profile-pic" asset catalog image resource.
static NSString * const ACImageNameNickProfilePic AC_SWIFT_PRIVATE = @"nick-profile-pic";

#undef AC_SWIFT_PRIVATE
