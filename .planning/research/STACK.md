# Stack Research

**Domain:** SwiftUI iOS prototype — paid community platform (Patreon-style)
**Researched:** 2026-03-10
**Confidence:** HIGH (Apple-first stack; all core decisions backed by official WWDC25 and Apple documentation)

---

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| SwiftUI | iOS 26 / Xcode 26 | Entire UI layer | Apple's declarative UI framework is the only choice for a pure-SwiftUI prototype; UIKit integration would add unnecessary complexity and fight against the project constraint |
| Swift | 6.2 | Language | Ships with Xcode 26; approachable concurrency (main-actor-by-default option) eliminates most concurrency boilerplate in a prototype that has no async data work |
| Xcode | 26.x | IDE, simulator, asset management | Required to target iOS 26 APIs; Xcode 26 becomes mandatory for App Store submissions in April 2026 |
| Swift Observation (`@Observable`) | iOS 17+ / included in Swift 5.9+ | State management for view models | Replaces ObservableObject/ObservedObject entirely; only observable properties read during body evaluation trigger rerenders — far more efficient than ObservableObject's coarse-grained invalidation |
| TabView + Tab role API | iOS 26 | 6-tab bottom navigation | iOS 26 introduces `tabBarMinimizeBehavior`, floating Liquid Glass tab bar, and `tabViewBottomAccessory` — adopt these so the Communities tab feels native to iOS 26 |
| NavigationStack | iOS 16+ | In-tab push navigation | Type-safe value-driven navigation; community detail, tier detail, forum thread, and creator dashboard all push onto a stack inside each tab |

### Supporting Apple Frameworks

| Framework | Version | Purpose | When to Use |
|-----------|---------|---------|-------------|
| Foundation | iOS 26 | Data models, date formatting, URL opening | Always — all model types, `URL(string:)` + `UIApplication.shared.open` for YouTube deep links |
| UIKit (surface-level only) | iOS 26 | YouTube URL open, haptic feedback | `UIApplication.shared.open` for YouTube links; `UIImpactFeedbackGenerator` for subscription confirmation tap — do not use UIKit for any views |
| SwiftUI Animations | iOS 17+ | Confetti, transitions, scroll effects | `PhaseAnimator` for multi-step confetti celebration; `matchedGeometryEffect` for tier card expansion; `scrollTransition` for feed card entrance animations |
| SF Symbols | 6.x | Icons throughout the app | Use symbol variants with `.imageScale`, `.symbolEffect` (iOS 17+) for interactive states like like-button fill; no icon library needed |
| SwiftUI Color + Asset Catalog | iOS 26 | Brand color palette, dark/light mode | Define all six Blossom brand colors as named Color assets in the Asset Catalog with light/dark variants — automatic color scheme adaptation with zero code |

### No Third-Party Dependencies

This project has an explicit constraint: Apple frameworks only unless justified. All required capabilities are achievable natively:

| Requirement | Native Solution | Third-Party (Rejected) |
|-------------|----------------|------------------------|
| Confetti animation | Custom `PhaseAnimator` with `Canvas` or positioned views | ConfettiSwiftUI — unnecessary dependency for a prototype |
| Charts / earnings view | SwiftUI `Charts` framework (iOS 16+) | Charts.js, etc. — wrong platform |
| Navigation | `NavigationStack` + `TabView` | TCA, The Composable Architecture — overkill for a prototype |
| State management | `@Observable` + `@State` + `@Environment` | Redux-style libs — not justified |
| Networking | None — all data is local | Alamofire, etc. — explicitly out of scope |

---

## Architecture Patterns

### State Management Strategy

Use `@Observable` for all model objects (communities, tiers, posts, users). The pattern for this prototype:

```
AppState (@Observable, @State in root App struct)
  └── CommunitiesViewModel (@Observable)
  └── CreatorDashboardViewModel (@Observable)
  └── CurrentUserSession (@Observable) — tracks which tier user is subscribed to
```

Pass models via `.environment()` at the root so any nested view can read them without prop drilling. Use `@Bindable` only where two-way binding to an `@Observable` object's property is needed (e.g., form fields in creator setup flow).

**Do not use:** `ObservableObject`, `@Published`, `@StateObject`, `@ObservedObject`, `@EnvironmentObject` — these are the pre-iOS 17 pattern and are superseded by `@Observable`.

### Navigation Pattern

Each tab wraps a `NavigationStack` with a `@State` path array:

```swift
@State private var communityPath: [CommunityRoute] = []

NavigationStack(path: $communityPath) {
    CommunityDiscoveryView()
        .navigationDestination(for: CommunityRoute.self) { route in
            switch route {
            case .detail(let community): CommunityDetailView(community: community)
            case .tier(let tier): TierDetailView(tier: tier)
            case .forum(let forum): ForumView(forum: forum)
            // ...
            }
        }
}
```

Use an `enum` for each tab's route type. This enables deep-link style programmatic navigation (useful for demo flows) and keeps navigation state serializable.

### Mock Data Pattern

All data lives in a `MockData` namespace with static properties:

```swift
enum MockData {
    static let communities: [Community] = [ /* ... */ ]
    static let currentUser: User = User(...)
}
```

Expose preview-friendly initializers on all view models:

```swift
extension CommunitiesViewModel {
    static var preview: CommunitiesViewModel {
        let vm = CommunitiesViewModel()
        vm.communities = MockData.communities
        return vm
    }
}
```

Place all mock data files in Xcode's `Preview Content` group — Xcode strips them from release builds automatically. Use `#Preview` macro (iOS 17+ syntax) for all previews.

### Brand Compliance Pattern

Define a `BlossomTheme` namespace with `Color` and `Font` extensions:

```swift
extension Color {
    static let blossomViolet = Color("BlossomViolet")   // #7361F7
    static let blossomOrange = Color("BlossomOrange")   // #FF7833
    static let blossomTeal   = Color("BlossomTeal")     // #35C7B2
    static let darkNavy      = Color("DarkNavy")        // #1E222A
    static let slate         = Color("Slate")            // #565E76
}

extension Font {
    static func inter(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Inter-\(weight.interFamilyName)", size: size)
    }
}
```

Define a `BlossomButtonStyle` conforming to `ButtonStyle` for the 8px radius primary buttons. Create a `CardModifier` (ViewModifier) for the card pattern: white/system-background fill, 12px radius, `#E2E4E9` stroke or light shadow. Apply modifiers via `.modifier(CardModifier())` or a `.blossomCard()` View extension.

---

## Font Management

**Inter font — registration process (HIGH confidence):**

1. Download Inter font files (Inter-Regular.ttf, Inter-Medium.ttf, Inter-SemiBold.ttf, Inter-Bold.ttf) from rsms.me/inter
2. Add to Xcode project, checking "Add to target" for the app target
3. Register in `Info.plist` under `UIAppFonts` (array of filenames)
4. Reference as `.custom("Inter-Regular", size: 16)` — the PostScript name, not the filename

Use the `relativeTo:` parameter for Dynamic Type scaling:
```swift
.custom("Inter-Regular", size: 16, relativeTo: .body)
```

**Important:** If the font name string is wrong, SwiftUI silently falls back to system font with no error. Verify with `UIFont.familyNames` in a debug build.

---

## Animation Stack

### Confetti Celebration (subscription success)

Build natively using `PhaseAnimator` + positioned `Circle`/`Rectangle` views or `Canvas`:

- Define 40–60 confetti pieces with random initial positions above the frame, random colors from the Blossom palette, random rotation axes
- Phase 1: pieces at top, opacity 0
- Phase 2: pieces fall with `.spring` animation, opacity 1, rotation applied
- Phase 3: pieces fade out below frame, opacity 0
- Overlay on top of a "You're in!" confirmation sheet showing the Blossom logo
- Add `UIImpactFeedbackGenerator(.medium)` on trigger for haptic confirmation

### Feed Card Entrance

`.scrollTransition(.animated)` on each `PostCardView` in the community feed:

```swift
PostCardView(post: post)
    .scrollTransition(.animated) { view, phase in
        view.opacity(phase.isIdentity ? 1 : 0.6)
            .scaleEffect(phase.isIdentity ? 1 : 0.95)
    }
```

### Tier Card Expansion

`matchedGeometryEffect` between the collapsed tier row and the expanded tier detail sheet — creates the impression of the card growing into a full view.

### Navigation Transitions

Use `.navigationTransition(.zoom(sourceID:in:))` available in iOS 18+ for community card → detail zoom. If targeting iOS 26 minimum, this is available. For iOS 16 minimum fallback, use default push.

---

## Dark Mode / Color Scheme

Use named Color assets in Asset Catalog with "Any Appearance" and "Dark" slots — not hard-coded hex values in Swift. SwiftUI reads `@Environment(\.colorScheme)` automatically; named assets switch without a single line of code.

For the splash/intro screen (white background, Blossom logo): force light mode with `.preferredColorScheme(.light)` on that specific view only. The rest of the app respects system preference.

---

## YouTube Link Opening

No framework needed. Deep link into the YouTube app:

```swift
func openYouTube(videoID: String) {
    let appURL = URL(string: "youtube://\(videoID)")!
    let webURL = URL(string: "https://youtube.com/watch?v=\(videoID)")!
    if UIApplication.shared.canOpenURL(appURL) {
        UIApplication.shared.open(appURL)
    } else {
        UIApplication.shared.open(webURL)  // fallback to Safari
    }
}
```

Add `youtube` to `LSApplicationQueriesSchemes` in Info.plist for `canOpenURL` to work.

---

## iOS Version Targeting

| Decision | Recommendation | Rationale |
|----------|---------------|-----------|
| Minimum deployment target | iOS 26.0 | Project explicitly targets iOS 26; enables all new TabView APIs, `tabBarMinimizeBehavior`, Liquid Glass materials, `@Animatable` macro, `.navigationTransition(.zoom)` |
| Swift concurrency mode | Swift 6 strict concurrency | Swift 6.2 ships with Xcode 26; for a mock-data prototype with no async work, strict concurrency adds zero friction |
| SwiftUI previews | `#Preview` macro | Modern syntax, replaces `PreviewProvider`; available from iOS 17, standard as of Xcode 15+ |
| Asset catalog | xcassets (Xcode default) | Named colors, app icon, image assets all managed here; avoids any image-loading library |

**Note on iOS 26 adoption:** As of late 2025, iOS 26 has ~9% device market share. This is irrelevant for a prototype/demo running in Xcode Simulator — adoption rate only matters for production App Store releases.

---

## Alternatives Considered

| Category | Recommended | Alternative | When to Use Alternative |
|----------|-------------|-------------|------------------------|
| State management | `@Observable` | `ObservableObject` / `@Published` | Never for new iOS 17+ projects; only relevant when supporting iOS 15 |
| Navigation | `NavigationStack` | `NavigationView` | Never; `NavigationView` is deprecated in iOS 16+ |
| Navigation state | Enum-based path array | String/AnyHashable path | Only if you need cross-module routing without shared types |
| Tab structure | `TabView` with `Tab` API | Custom tab bar | Only if design requires non-standard tab bar behavior Apple's API can't accommodate |
| Charts (earnings) | SwiftUI Charts (Apple) | Third-party charting lib | If you need chart types Apple doesn't support (unlikely for a simple bar/line chart) |
| Animation | Native `PhaseAnimator` | `ConfettiSwiftUI` package | If confetti needs production-level particle physics and native implementation is insufficient |
| Persistence | None (in-memory mock data) | SwiftData / UserDefaults | If prototype needs state persistence between app launches (not required) |

---

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| UIKit views (`UIViewController`, `UITableView`, etc.) | Fights the SwiftUI constraint; forces representable wrappers that complicate previews | SwiftUI equivalents (`List`, `ScrollView + LazyVStack`) |
| `ObservableObject` + `@Published` | Superseded by `@Observable`; coarser invalidation, more boilerplate | `@Observable` macro |
| `NavigationView` | Deprecated iOS 16; removed behavioral guarantees | `NavigationStack` |
| Third-party navigation (TCA, Coordinator pattern libs) | Massive overhead for a prototype; adds dependency, learning curve | Enum-based `NavigationStack` path |
| `WKWebView` for YouTube | Opens a web view within the app; breaks out-of-app experience and requires sandboxing config | URL deep link to YouTube app |
| Hard-coded hex `Color(hex:)` extensions | Bypasses Asset Catalog; breaks automatic dark mode adaptation | Named Color assets in xcassets |
| `GeometryReader` for layout where avoidable | Breaks lazy loading in lists, causes layout performance issues | Use `.frame`, `.padding`, `.containerRelativeFrame` (iOS 17+) instead |
| SwiftData for mock data | Adds schema migration complexity for zero benefit in a prototype | Static `MockData` enum with in-memory structs |

---

## Version Compatibility

| Component | Requires | Notes |
|-----------|----------|-------|
| `@Observable` macro | iOS 17+ / Swift 5.9+ | Ships with Xcode 15+; standard as of iOS 26 |
| `NavigationStack` | iOS 16+ | Stable, no compatibility issues |
| `PhaseAnimator` | iOS 17+ | Stable |
| `scrollTransition` | iOS 17+ | Stable |
| `matchedGeometryEffect` | iOS 14+ | Stable |
| `TabView` Tab role API / `tabBarMinimizeBehavior` | iOS 26 | New in iOS 26; simulator only if device < iOS 26 |
| SwiftUI Charts | iOS 16+ | Sufficient for earnings bar chart |
| `#Preview` macro | iOS 17+ / Xcode 15+ | Replaces `PreviewProvider` |
| `.navigationTransition(.zoom)` | iOS 18+ | Available on iOS 26 simulator; use with confidence |
| `.symbolEffect` | iOS 17+ | For animated SF Symbols (like buttons) |
| `containerRelativeFrame` | iOS 17+ | Preferred over `GeometryReader` for proportional sizing |

---

## Project Setup Checklist

When creating the Xcode project:

1. New project → App template → SwiftUI interface, Swift language
2. Minimum deployment target: iOS 26.0
3. Enable Swift 6 language mode in Build Settings → Swift Language Version
4. Add Inter font files to project, register in Info.plist under `UIAppFonts`
5. Add `LSApplicationQueriesSchemes` to Info.plist with `youtube` entry
6. Create named Color assets in Assets.xcassets for all six Blossom brand colors (with dark mode variants)
7. Add profile photos (BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt) to Assets.xcassets as Image Sets
8. Add Blossom logo variants (light, dark, icon square) to Assets.xcassets
9. Create `MockData/` group in project navigator for all static data (mark folder as "Preview Content" development asset)
10. Create `Theme/` group for `Color+Blossom.swift`, `Font+Blossom.swift`, `ButtonStyle+Blossom.swift`, `ViewModifier+Card.swift`

---

## Sources

- Hacking with Swift — "What's new in SwiftUI for iOS 26": https://www.hackingwithswift.com/articles/278/whats-new-in-swiftui-for-ios-26 — confirmed tab minimize and accessory APIs (HIGH confidence)
- Swift.org — Swift 6.2 Release: https://www.swift.org/blog/swift-6.2-released/ — concurrency changes confirmed (HIGH confidence)
- Donny Wals — "Exploring tab bars on iOS 26 with Liquid Glass": https://www.donnywals.com/exploring-tab-bars-on-ios-26-with-liquid-glass/ — TabView API patterns (HIGH confidence)
- Apple Developer — "Migrating from ObservableObject to Observable": https://developer.apple.com/documentation/SwiftUI/Migrating-from-the-observable-object-protocol-to-the-observable-macro (HIGH confidence)
- Apple Developer — scrollTransition API: https://developer.apple.com/documentation/swiftui/view/scrolltransition(_:axis:transition:) (HIGH confidence)
- Medium — iOS 26 SDK Requirements: https://ravi6997.medium.com/ios-26-sdk-requirements-what-developers-need-to-know-for-april-2026-16dec793c44d — Xcode 26 mandatory April 2026 (MEDIUM confidence, trade press)
- Apple Developer WWDC25 — "Build a SwiftUI app with the new design": https://developer.apple.com/videos/play/wwdc2025/323/ — Liquid Glass design system (HIGH confidence)
- Sarunw — Custom fonts in SwiftUI: https://sarunw.com/posts/swiftui-custom-font/ — Inter font registration process (HIGH confidence)
- AppCoda — PhaseAnimator: https://www.appcoda.com/learnswiftui/swiftui-phaseanimator.html — confetti animation approach (MEDIUM confidence, tutorial)

---

*Stack research for: Blossom Communities — SwiftUI iOS 26 paid community prototype*
*Researched: 2026-03-10*
