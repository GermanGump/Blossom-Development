# Architecture Research

**Domain:** SwiftUI multi-tab prototype app — paid community platform with subscriber + creator views
**Researched:** 2026-03-10
**Confidence:** HIGH (SwiftUI navigation, @Observable patterns); MEDIUM (iOS 26 specifics, Liquid Glass design language)

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Presentation Layer                           │
│                                                                       │
│  ┌────────────┐  ┌──────────────┐  ┌────────────┐  ┌─────────────┐  │
│  │ Discovery  │  │  Community   │  │  Creator   │  │  Subscriber │  │
│  │  Feature   │  │  Hub Feature │  │ Dashboard  │  │  Flow Views │  │
│  └─────┬──────┘  └──────┬───────┘  └─────┬──────┘  └──────┬──────┘  │
│        │                │                │                 │          │
├────────┴────────────────┴────────────────┴─────────────────┴─────────┤
│                         Navigation Layer                              │
│                                                                       │
│   CommunitiesTab (NavigationStack + NavigationPath)                   │
│   AppNavigationRouter (@Observable, manages path per feature)         │
│                                                                       │
├───────────────────────────────────────────────────────────────────────┤
│                          Domain Layer                                 │
│                                                                       │
│  ┌──────────────┐  ┌────────────────┐  ┌──────────────────────────┐  │
│  │ UserSession  │  │  PermissionGate │  │  CommunityStore          │  │
│  │ (@Observable)│  │  (tier checks)  │  │  (@Observable)           │  │
│  └──────────────┘  └────────────────┘  └──────────────────────────┘  │
│                                                                       │
├───────────────────────────────────────────────────────────────────────┤
│                          Data Layer                                   │
│                                                                       │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐    │
│  │  MockDataService │  │  MockCreators    │  │  MockCommunities │    │
│  │  (static factory)│  │  (ambassador data│  │  (tiers, posts)  │    │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘    │
└───────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Implementation |
|-----------|----------------|----------------|
| `BlossomCommunitiesApp` | App entry point, environment injection, root TabView | `@main` struct, `.environment()` injection |
| `CommunitiesTabView` | Communities tab root, owns NavigationStack and path | SwiftUI View with `@State var path: NavigationPath` |
| `AppRouter` | Programmatic navigation, route enum, deep link support | `@Observable` class, one per tab |
| `UserSession` | Current user identity, subscriptions held, creator status | `@Observable` class, environment-injected |
| `PermissionGate` | Evaluates tier access for a given community + content section | Pure function / value type, no state |
| `CommunityStore` | All communities, tiers, posts, forums — in-memory truth | `@Observable` class, loaded from MockDataService |
| `MockDataService` | Generates structured seed data — communities, creators, posts | Static struct with factory methods |
| `CreatorDashboardView` | Creator-side community management, earnings, permissions | Feature root view, conditionally shown |
| `SubscriberFlowView` | Subscriber-side: discovery → preview → payment → community | Feature root view driven by navigation path |

## Recommended Project Structure

```
BlossomCommunities/
├── BlossomCommunitiesApp.swift     # @main entry, environment setup
├── AppConstants.swift              # Colors, fonts, spacing from brand guidelines
│
├── Navigation/
│   ├── AppRouter.swift             # @Observable NavigationPath router
│   ├── CommunitiesRoute.swift      # Route enum (Hashable destinations)
│   └── CommunitiesTabView.swift    # Tab root: NavigationStack + .navigationDestination
│
├── Domain/
│   ├── Models/
│   │   ├── Community.swift         # Community, Tier, TierPermission
│   │   ├── Creator.swift           # Creator/Ambassador profile
│   │   ├── Post.swift              # ContentPost, PostType (trade, educational, video)
│   │   ├── Forum.swift             # Forum, Thread, Reply
│   │   ├── FAQ.swift               # FAQQuestion, FAQAnswer
│   │   ├── Subscription.swift      # UserSubscription, tier held
│   │   └── User.swift              # Current user (subscriber or creator identity)
│   ├── UserSession.swift           # @Observable — current user, subscriptions, role
│   ├── CommunityStore.swift        # @Observable — all communities, loaded on init
│   └── PermissionGate.swift        # Pure function: canAccess(section:with tier:)
│
├── Data/
│   ├── MockDataService.swift       # Entry point — loads all mock data
│   ├── MockCommunities.swift       # 4-6 fully detailed mock communities
│   ├── MockCreators.swift          # BD, Brandon, Max, Nick, Moe, CIAT with real photos
│   ├── MockPosts.swift             # Posts per community (trade alerts, videos, edu)
│   ├── MockForums.swift            # Threads and replies per community
│   └── MockSubscriptions.swift     # Pre-loaded subscriptions for demo user
│
├── Features/
│   ├── Splash/
│   │   └── SplashView.swift        # Centered Blossom logo, fades to discovery
│   │
│   ├── Discovery/
│   │   ├── DiscoveryView.swift     # Featured communities grid/list
│   │   ├── CommunityCardView.swift # Card: logo, creator photo, name, description
│   │   └── DiscoveryViewModel.swift # Filters, sorting (thin — mostly passes through store)
│   │
│   ├── CommunityPreview/
│   │   ├── CommunityPreviewView.swift    # Hero, description, tier list — non-subscriber
│   │   ├── TierCardView.swift            # Expandable tier: name, price, benefits
│   │   └── TierDetailView.swift          # Full tier breakdown sheet
│   │
│   ├── Payment/
│   │   ├── PaymentFlowView.swift         # Mocked Stripe UI: card entry, confirm
│   │   ├── PaymentSuccessView.swift      # Confetti + Blossom logo celebration
│   │   └── PaymentViewModel.swift        # State machine: idle → processing → success
│   │
│   ├── CommunityHub/
│   │   ├── CommunityHubView.swift        # Linktree-style landing: logo, banner, nav buttons
│   │   ├── ContentFeedView.swift         # Posts feed with gate checks
│   │   ├── PostCardView.swift            # Individual post: trade, video embed, educational
│   │   ├── ForumListView.swift           # Forums list with tier lock indicators
│   │   ├── ForumThreadView.swift         # Thread + replies + compose reply
│   │   ├── FAQView.swift                 # FAQ list + submit question form
│   │   └── CommunityHubViewModel.swift   # Active community, selected tab, gated state
│   │
│   └── CreatorDashboard/
│       ├── CreatorDashboardView.swift     # Dashboard root: tabs for Setup, Earnings, Permissions
│       ├── CommunitySetupView.swift       # Edit community info, tiers, descriptions
│       ├── TierEditorView.swift           # Create/edit a tier: name, price, permissions
│       ├── EarningsView.swift             # Revenue breakdown, 10% fee model, payout view
│       ├── PermissionsMatrixView.swift    # Grid: forum/section rows × tier columns
│       └── CreatorDashboardViewModel.swift # Editing state, draft community
│
└── Shared/
    ├── Components/
    │   ├── BlossomCard.swift           # Reusable card container (white, border, 12px radius)
    │   ├── TierBadgeView.swift         # Pill badge for tier name display
    │   ├── VerifiedBadge.swift         # Creator verified checkmark
    │   ├── GatedContentOverlay.swift   # Lock overlay for tier-restricted content
    │   ├── YouTubeLinkRow.swift        # Row that opens YouTube app on tap
    │   ├── ConfettiView.swift          # Confetti particle animation layer
    │   └── AvatarView.swift            # Profile photo with optional badge
    ├── Extensions/
    │   ├── Color+Blossom.swift         # Brand palette: .blossomViolet, .blossomOrange, etc.
    │   ├── Font+Blossom.swift          # Inter font helpers: .blossomHeadline, .blossomBody
    │   └── View+BlossomCard.swift      # `.blossomCardStyle()` modifier shorthand
    └── Theme/
        └── BlossomTheme.swift          # Light/dark mode color resolution
```

### Structure Rationale

- **Features/:** One folder per user-facing feature. Each feature owns its views and view model. No cross-feature imports — features communicate through the shared store and router only.
- **Domain/Models/:** Plain Swift structs. No SwiftUI imports. Can be used from Data layer and any feature without coupling.
- **Data/:** Pure mock data generation. No view code. MockDataService is the single entry point — features never import individual Mock* files directly.
- **Shared/Components/:** Reusable UI primitives. Accept data as parameters. No store access, no navigation logic.
- **Navigation/:** Navigation is its own concern, not buried in a feature. Route changes happen in one place.

## Architectural Patterns

### Pattern 1: @Observable Store via Environment

**What:** A small set of `@Observable` classes hold all app state and are injected at the root via `.environment()`. Views read state directly — no `@EnvironmentObject` wrappers.

**When to use:** Any state shared across multiple features (current user, all communities). Passed via `.environment()` in the App struct so every view in the hierarchy can access it.

**Trade-offs:** Simpler than dependency injection frameworks. For a prototype with no real networking, this is exactly the right complexity level. Do not use singletons (`static let shared`) — environment injection is testable and scoped.

```swift
// BlossomCommunitiesApp.swift
@main
struct BlossomCommunitiesApp: App {
    @State private var communityStore = CommunityStore()
    @State private var userSession = UserSession()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(communityStore)
                .environment(userSession)
        }
    }
}

// Any feature view
struct DiscoveryView: View {
    @Environment(CommunityStore.self) private var store
    @Environment(UserSession.self) private var session
    // ...
}
```

### Pattern 2: Type-Safe Routing with NavigationPath + Route Enum

**What:** Each tab owns a `NavigationPath` stored as `@State`. Navigation destinations are typed via a `CommunitiesRoute` enum conforming to `Hashable`. The router class is `@Observable` and wraps the path — views call `router.push(.communityHub(id:))` rather than binding directly to path.

**When to use:** Any multi-screen flow within the Communities tab. Sheet presentations (payment flow, tier detail) are separate `@State` booleans on the presenting view — not pushed onto the nav stack.

**Trade-offs:** More setup than implicit `NavigationLink(destination:)`, but eliminates the "double push on iOS 18" bug and makes navigation logic testable. For this prototype, a single `AppRouter` for the Communities tab is sufficient — no need for per-feature coordinators.

```swift
// CommunitiesRoute.swift
enum CommunitiesRoute: Hashable {
    case communityPreview(communityID: String)
    case communityHub(communityID: String)
    case forum(communityID: String, forumID: String)
    case forumThread(threadID: String)
    case faq(communityID: String)
    case creatorDashboard(communityID: String)
}

// AppRouter.swift
@Observable
final class AppRouter {
    var path = NavigationPath()

    func push(_ route: CommunitiesRoute) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

// CommunitiesTabView.swift
struct CommunitiesTabView: View {
    @State private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            DiscoveryView()
                .navigationDestination(for: CommunitiesRoute.self) { route in
                    switch route {
                    case .communityPreview(let id): CommunityPreviewView(communityID: id)
                    case .communityHub(let id): CommunityHubView(communityID: id)
                    case .forum(let cid, let fid): ForumListView(communityID: cid, forumID: fid)
                    case .forumThread(let id): ForumThreadView(threadID: id)
                    case .faq(let id): FAQView(communityID: id)
                    case .creatorDashboard(let id): CreatorDashboardView(communityID: id)
                    }
                }
        }
        .environment(router)
    }
}
```

### Pattern 3: PermissionGate — Pure Function Access Control

**What:** Tier-based content gating is handled by a pure `PermissionGate` function (or namespace struct with static methods), not by logic scattered across views. Views call `PermissionGate.canAccess(section:userTier:)` and render either the content or a `GatedContentOverlay`.

**When to use:** Any place where a forum, content section, or FAQ requires a minimum tier. Also used in the creator dashboard to preview what each tier can see.

**Trade-offs:** Keeps permission logic in one auditable place. Trivially testable. For this prototype, permissions are evaluated against `UserSession.subscriptionTier(for communityID:)` — a simple tier index comparison.

```swift
// PermissionGate.swift
enum ContentSection {
    case contentFeed, forum(id: String), faqSubmit, tradingAlerts
}

struct PermissionGate {
    static func canAccess(
        _ section: ContentSection,
        in community: Community,
        with userTier: Tier?
    ) -> Bool {
        guard let userTier else { return false }
        let requiredTier = community.minimumTier(for: section)
        return userTier.level >= requiredTier.level
    }
}

// Usage in a view
if PermissionGate.canAccess(.forum(id: forum.id), in: community, with: session.tier(for: community.id)) {
    ForumThreadView(forum: forum)
} else {
    GatedContentOverlay(requiredTier: community.minimumTier(for: .forum(id: forum.id)))
}
```

### Pattern 4: Creator/Subscriber Role Switching via UserSession

**What:** `UserSession` holds both the subscriber view of the world (subscriptions, tiers held) and whether the current user is a creator. The demo switches between subscriber and creator perspective by mutating `userSession.viewingAs`, which drives which root view is shown in certain contexts (e.g., on the Community Hub, a "Creator Dashboard" button appears if the user owns that community).

**When to use:** Wherever the UI needs to fork between subscriber-facing and creator-facing content. Keep the fork at the feature entry point, not scattered throughout subviews.

```swift
// UserSession.swift
@Observable
final class UserSession {
    var currentUser: User
    var subscriptions: [UserSubscription] = []
    var ownedCommunities: Set<String> = []   // community IDs this user created

    func isCreator(of communityID: String) -> Bool {
        ownedCommunities.contains(communityID)
    }

    func tier(for communityID: String) -> Tier? {
        subscriptions.first { $0.communityID == communityID }?.tier
    }
}

// CommunityHubView uses this to show/hide creator dashboard entry
if session.isCreator(of: community.id) {
    Button("Creator Dashboard") {
        router.push(.creatorDashboard(communityID: community.id))
    }
}
```

## Data Flow

### Subscriber Navigation Flow

```
SplashView (appears once on launch)
    ↓ (auto-dismiss after 1.5s)
DiscoveryView
    ↓ user taps community card
    router.push(.communityPreview(id:))
CommunityPreviewView
    ↓ user taps "Subscribe" on a tier
    @State var showPaymentSheet = true  →  PaymentFlowView (sheet)
        ↓ user completes payment
        userSession.subscriptions.append(...)
        PaymentSuccessView (full-screen cover with confetti)
            ↓ "Enter Community" button
            router.push(.communityHub(id:))
CommunityHubView  (linktree landing: Posts | Forums | FAQ tabs)
    ├── ContentFeedView  →  PostCardView (PermissionGate checked per-section)
    ├── ForumListView    →  ForumThreadView (PermissionGate checked per-forum)
    └── FAQView          →  submit question (PermissionGate checked for FAQ submit)
```

### Creator Dashboard Flow

```
CommunityHubView  (creator owns this community)
    ↓ "Creator Dashboard" button
    router.push(.creatorDashboard(id:))
CreatorDashboardView  (tab bar: Setup | Earnings | Permissions)
    ├── CommunitySetupView    →  edit info, save to CommunityStore (in-memory)
    ├── TierEditorView        →  create/edit tiers, update community in store
    ├── EarningsView          →  static revenue charts, 10% fee breakdown
    └── PermissionsMatrixView →  grid of forum/section × tier, toggle access
```

### State Management

```
MockDataService (static, runs once at app start)
    ↓ populates
CommunityStore (@Observable, environment-injected)
    ↓ read by
DiscoveryView, CommunityPreviewView, CommunityHubView, CreatorDashboardView
    ↓ mutations from
CreatorDashboardViewModel (draft edits)
    ↓ confirmed changes written back to
CommunityStore (in-memory — prototype only, no persistence needed)

UserSession (@Observable, environment-injected)
    ↓ read by
PermissionGate (determines access)
PaymentFlowView (writes subscription on success)
All views checking .isCreator(of:)
```

### Key Data Flows

1. **Discovery → Preview → Subscribe:** Purely additive. No mutations until PaymentSuccess appends to `userSession.subscriptions`. CommunityStore is read-only during subscriber flow.
2. **Creator edits tiers/permissions:** `CreatorDashboardViewModel` holds a draft `Community` copy. On save, it replaces the entry in `CommunityStore`. Subscriber views automatically re-render because `CommunityStore` is `@Observable`.
3. **Tier gate evaluation:** Views call `PermissionGate.canAccess(...)` synchronously. No async. No loading state. This keeps the UI instant and demo-friendly.
4. **Forum interaction (create post, reply, like):** Mutations go directly to `CommunityStore`. Because the store is `@Observable`, all views showing that forum update automatically.

## Scaling Considerations

This is a prototype. The architecture is intentionally flat.

| Scale | Architecture Adjustments |
|-------|--------------------------|
| Prototype (demo) | Single CommunityStore, local @Observable, no persistence |
| Production v1 | Replace MockDataService with a Repository protocol. Swap mock impl for real API impl. No other architectural changes needed. |
| Production v2+ | Add SwiftData for offline-first persistence. Split CommunityStore into feature-scoped stores. Add proper auth layer to UserSession. |

The key design decision that makes this prototype production-adjacent: **the data layer is behind a service boundary**. Features never reach into `MockCommunities.swift` directly — they always go through `CommunityStore`. Replacing the mock with a real API is a data-layer swap only.

## Anti-Patterns

### Anti-Pattern 1: Putting Navigation Logic Inside Views

**What people do:** Put `NavigationLink(destination: CommunityHubView(...))` inline in card views, passing fully constructed destination views.

**Why it's wrong:** NavigationLink with a destination closure eagerly constructs the destination view. This causes all destinations to be created simultaneously on first render. On iOS 16+ with NavigationStack, this creates the double-push bug and breaks deep linking entirely.

**Do this instead:** Use `NavigationLink(value: CommunitiesRoute.communityHub(id: id))` (value-based) and declare all `.navigationDestination` in one place at the NavigationStack root.

### Anti-Pattern 2: ObservableObject with @Published for Everything

**What people do:** Use `class CommunityStore: ObservableObject` with `@Published var communities: [Community]` on each property.

**Why it's wrong:** Any change to any `@Published` property triggers re-render of all subscribers. A like on a forum post would re-render the discovery grid. With `@Observable` (iOS 17+), views only re-render when the specific properties they read change — dramatically better for this content-heavy UI.

**Do this instead:** `@Observable final class CommunityStore` — no `@Published` annotations, no `ObservableObject` conformance.

### Anti-Pattern 3: Scattering Permission Checks Across Views

**What people do:** Each view contains its own `if userTier >= requiredTier` comparisons with tier names hardcoded as strings.

**Why it's wrong:** Permission logic becomes inconsistent. Creator changes a tier name → multiple string comparisons silently break. No single place to audit who can see what.

**Do this instead:** All permission evaluation goes through `PermissionGate.canAccess(...)`. Views are gate-aware but not gate-smart — they call the gate and render accordingly.

### Anti-Pattern 4: One Massive Community Model

**What people do:** Create a single `Community` struct with arrays of posts, forums, tiers, FAQs, subscribers all embedded directly.

**Why it's wrong:** Loading the full community graph for the discovery grid (which only needs name, logo, creator) is wasteful. More importantly, mutations to a nested array (e.g., appending a reply) invalidate the entire Community value, causing every view holding a reference to re-render.

**Do this instead:** Keep `Community` as a lightweight identity + metadata model. Posts, forums, and FAQs live in `CommunityStore` keyed by community ID. Views fetch what they need from the store rather than unpacking a deeply nested value.

### Anti-Pattern 5: Sheet-Driven Payment as Navigation Push

**What people do:** Push PaymentFlowView onto the NavigationStack like any other destination.

**Why it's wrong:** Payment is a transactional modal flow, not a browsable destination. Users should not be able to swipe-back through payment steps into the tier selection. The confetti success screen should be a full-screen cover, not a nav destination.

**Do this instead:** Trigger PaymentFlowView as `.sheet(isPresented:)` from CommunityPreviewView. On success, dismiss the sheet and present PaymentSuccessView as `.fullScreenCover(isPresented:)`. On "Enter Community" tap, dismiss the cover and push the community hub route.

## Integration Points

### External Services (Mock Only — Prototype)

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| Stripe (payment) | `PaymentFlowView` is pure SwiftUI UI — no SDK | Card field is a styled TextField, not a real card input |
| YouTube | `UIApplication.shared.open(url)` on link tap | Opens YouTube app. No AVPlayer, no WKWebView |
| Blossom backend | Not integrated — standalone prototype | Session user is hardcoded in MockDataService |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| Feature ↔ Feature | Only through CommunityStore or UserSession via environment | Features never import each other |
| Feature ↔ Navigation | Feature views call `router.push(route)` — router is environment-injected | No direct NavigationLink(destination:) with constructed views |
| Feature ↔ Data | Through CommunityStore only — never directly from Mock* files | Swappable data layer |
| Views ↔ PermissionGate | Static function call — no environment, no injection | Pure logic, no state |
| CreatorDashboard ↔ CommunityStore | ViewModel holds draft copy, commits on save | Avoids live-editing published data |

## Build Order

Build in dependency order — nothing should be imported before it exists.

```
Phase 1 — Foundation (no UI dependencies)
  ├── Domain/Models/*         (Community, Tier, Post, Forum, FAQ, User, Subscription)
  ├── PermissionGate.swift
  ├── Shared/Extensions/*     (Color+Blossom, Font+Blossom)
  └── AppConstants.swift

Phase 2 — Data Layer
  ├── MockCreators.swift
  ├── MockCommunities.swift   (depends on Creator model)
  ├── MockPosts.swift
  ├── MockForums.swift
  ├── MockSubscriptions.swift
  └── MockDataService.swift   (assembles all Mock* data)

Phase 3 — State Layer
  ├── CommunityStore.swift    (depends on MockDataService + all models)
  └── UserSession.swift       (depends on Subscription, User models)

Phase 4 — Navigation
  ├── CommunitiesRoute.swift
  ├── AppRouter.swift
  └── CommunitiesTabView.swift (depends on AppRouter + all feature roots)

Phase 5 — Shared Components
  ├── BlossomCard.swift
  ├── TierBadgeView.swift
  ├── VerifiedBadge.swift
  ├── GatedContentOverlay.swift
  ├── AvatarView.swift
  ├── YouTubeLinkRow.swift
  └── ConfettiView.swift      (depends on nothing — self-contained animation)

Phase 6 — Features (build in subscriber flow order)
  ├── SplashView
  ├── Discovery (DiscoveryView, CommunityCardView)
  ├── CommunityPreview (CommunityPreviewView, TierCardView, TierDetailView)
  ├── Payment (PaymentFlowView, PaymentSuccessView, PaymentViewModel)
  ├── CommunityHub (CommunityHubView, ContentFeedView, ForumListView, ForumThreadView, FAQView)
  └── CreatorDashboard (all creator views — last, depends on community models being stable)
```

## Sources

- [Modern SwiftUI Navigation 2025 — Clean Scalable Routing](https://medium.com/@dinaga119/mastering-navigation-in-swiftui-the-2025-guide-to-clean-scalable-routing-bbcb6dbce929)
- [Apple Developer Documentation — Migrating ObservableObject to @Observable](https://developer.apple.com/documentation/SwiftUI/Migrating-from-the-observable-object-protocol-to-the-observable-macro)
- [NavigationStack in new iOS 18 TabView double-push issue — Apple Forums](https://developer.apple.com/forums/thread/759542)
- [NavigationPath with TabView — tanaschita.com](https://tanaschita.com/swiftui-navigation-path-with-tabview/)
- [SwiftUI Tab and Search APIs in iOS 26](https://medium.com/@himalimarasinghe/swiftui-in-ios-26-whats-new-from-wwdc-2025-be6b4864ce05)
- [WWDC25 iOS 26 SwiftUI Features — exploreswiftui.com](https://exploreswiftui.com/wwdc25)
- [Feature-Based Project Structure for SwiftUI](https://medium.com/@omarbasaleh2/feature-based-project-structure-for-swiftui-218e3583d6f0)
- [@Observable Macro Performance vs ObservableObject — avanderlee.com](https://www.avanderlee.com/swiftui/observable-macro-performance-increase-observableobject/)
- [SwiftUI EnvironmentObject as Dependency Injection — haoluo.io](https://haoluo.io/posts/swiftui-environmentobject)
- [Scalable SwiftUI Navigation Part 2 — NavigationStack and TabView](https://medium.com/@glbus/scalable-swiftui-navigation-part-2-navigationstack-and-tabview-6098bf45d550)

---
*Architecture research for: Blossom Communities — SwiftUI paid community prototype*
*Researched: 2026-03-10*
