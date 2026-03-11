# Project Research Summary

**Project:** Blossom Communities — Paid Subscription Community Platform
**Domain:** SwiftUI iOS 26 native prototype, Patreon-style community platform for investing/finance creators
**Researched:** 2026-03-10
**Confidence:** HIGH

## Executive Summary

Blossom Communities is a paid subscription community platform targeted at investing/finance creators, built as a SwiftUI-only iOS 26 prototype using zero third-party dependencies. The research validates a clear, proven architecture: a feature-folder SwiftUI project using `@Observable` state management, `NavigationStack` with typed route enums per tab, and a layered mock data service behind a protocol boundary. All required capabilities — confetti animation, charts, navigation, tier-gating — are achievable with Apple's native frameworks. The technology decisions are Apple-first by project constraint, and research confirms this is the correct choice for a prototype targeting iOS 26 APIs (Liquid Glass tab bar, `tabBarMinimizeBehavior`, `.navigationTransition(.zoom)`).

The feature set maps clearly onto a proven market structure: Patreon, Circle, and Whop define the table stakes (tiered memberships, content feed, creator earnings, forums), while Blossom has genuine differentiators in its FAQ zone (structured async Q&A — no competitor has this), anti-Discord positioning (curated async content, not real-time chat), confetti subscription celebration, and the unique ability to layer community monetization on top of existing Blossom ambassador trust and verified profiles. Real-time chat, unlimited tiers, and in-line video players are explicit anti-features — well-reasoned exclusions, not oversights.

The dominant risk is foundational rather than feature-level: navigation architecture, the design token layer (Inter font, brand colors, dark mode adaptive colors), the mock data service boundary, and Swift 6 `@MainActor` conventions must all be established before any feature screens are built. Research identifies 10 pitfalls — half of which are irreversible without painful refactoring if not addressed in the first phase. A prototype that gets the foundation wrong will fail at the stakeholder demo regardless of how many features are built.

---

## Key Findings

### Recommended Stack

The stack is entirely Apple-native: SwiftUI on iOS 26 with Xcode 26, Swift 6.2, `@Observable` for all state, `NavigationStack` + enum-based routing for navigation, `TabView` with the iOS 26 `Tab` role API and `tabBarMinimizeBehavior` for the six-tab structure, and SwiftUI `Charts` for the creator earnings view. No third-party packages are needed or permitted. The Inter custom font requires explicit `UIAppFonts` registration in Info.plist and PostScript name usage in `.custom()` calls — SwiftUI silently falls back to system font on any registration error.

**Core technologies:**
- **SwiftUI / iOS 26:** Entire UI layer — only viable choice given pure-SwiftUI constraint; iOS 26 APIs (Liquid Glass tab bar, `.navigationTransition(.zoom)`) are direct project requirements
- **Swift 6.2 + `@Observable` macro:** State management — replaces ObservableObject entirely; fine-grained view invalidation prevents full-tree rerenders in a content-heavy app; `@MainActor` annotation on all view models eliminates Swift 6 concurrency errors in a synchronous mock context
- **`NavigationStack` + typed route enum:** Per-tab navigation — eliminates double-push iOS 18 bug, enables programmatic navigation for demo flows, keeps all `.navigationDestination` registrations in one place
- **`PhaseAnimator` + `Canvas`:** Confetti animation — native implementation; third-party packages are explicitly prohibited
- **SwiftUI `Charts`:** Creator earnings view — ships with iOS 16+, no additional dependency
- **Static `MockData` behind `CommunityStore` protocol:** Data layer — all features access data through the store, not raw mock arrays; makes subscription state transitions demonstrable and the data layer swappable for a real API in production

### Expected Features

The subscriber journey defines the demo critical path. Creator-side features are secondary in depth for the pitch.

**Must have (table stakes) — all in prototype v1:**
- Community discovery screen with featured communities — the browseable tab entry point
- Creator public page with logo, banner, bio, and tiered benefit listings — the conversion page before subscription
- Tiered subscription model (1–4 tiers, 3 is the sweet spot per Patreon data; middle tier gets most conversions via decoy effect)
- Mocked Stripe payment flow — validates the monetization mechanic for stakeholders
- Community landing page (authenticated) — proves the post-subscription experience
- Content feed with text posts, trade highlights, and embedded YouTube links
- Tier-gated content with locked-preview upgrade prompts
- Discussion forums with tier-based access (create, reply, like threads)
- FAQ zone for structured async subscriber Q&A — no direct competitor offers this
- Creator dashboard (community setup, tier editor, permissions matrix) — shallow but present
- Creator earnings view showing gross revenue, 10% Blossom fee, and net payout
- Light and dark mode — Blossom brand compliance requirement

**Should have (competitive differentiators):**
- Confetti subscription celebration — delight moment at payment success; no competitor does this
- Verified creator badge — investing-context credibility signal already in Blossom's design language
- Anti-Discord positioning (no real-time chat; structured async model is the product philosophy)
- Platform fee transparency in creator earnings (10% shown explicitly, not buried)
- Existing Blossom ambassador integration (real profile photos for BD, Brandon, Max, Nick, Moe, CIAT)

**Defer to v2+:**
- Investing-native post types (trade cards with stock ticker tags) — high value but requires stable backend schema
- Real payment processing (StoreKit 2 or Stripe) — mocked for prototype; production requires before App Store launch
- Push notifications — requires APNs backend; out of scope for local prototype
- Subscription management (upgrade/downgrade/cancel in-app) — required before App Store submission, not for prototype pitch
- Creator analytics dashboard — defer until creators are live and requesting it
- Community search — defer until content volume justifies the feature
- Blossom PRO + Communities bundle — defer until both products have standalone traction

### Architecture Approach

The architecture is a four-layer SwiftUI system: Presentation (feature views), Navigation (per-tab `AppRouter` with `NavigationPath`), Domain (`@Observable` stores and `PermissionGate`), and Data (mock services behind protocol). The key structural decisions are: (1) one `NavigationStack` per tab with independent path state to prevent cross-tab navigation bleed; (2) all permission evaluation flows through a single `PermissionGate` pure function — views are gate-aware but not gate-smart; (3) `CommunityStore` is the single in-memory truth for all communities, tiers, posts, and forums; (4) payment is presented as a `.sheet`, not a nav push, so the back-swipe gesture does not exist mid-transaction; (5) `UserSession` holds both subscriber state (subscriptions held) and creator identity, driving which UI variant each screen renders.

**Major components:**
1. `CommunityStore` (`@Observable`) — single in-memory truth for all communities, tiers, posts, forums, loaded from `MockDataService` at app start
2. `UserSession` (`@Observable`) — current user identity, subscriptions, owned community IDs; drives `PermissionGate` evaluation and creator/subscriber UI forking
3. `AppRouter` (`@Observable`) — wraps `NavigationPath` per tab; feature views call `router.push(route)` rather than constructing `NavigationLink(destination:)` inline
4. `PermissionGate` (pure function) — evaluates tier access for any content section in one auditable location
5. `MockDataService` (static factory) — all mock data behind a service boundary; `CommunityStore` reads from it, features never import `Mock*` files directly

### Critical Pitfalls

The top pitfalls from research, ordered by irreversibility if not addressed early:

1. **Shared navigation state across tabs** — wrapping `TabView` in a single `NavigationStack` causes cross-tab bleed, broken back buttons, and tab icon double-tap failures. Each tab must own its own `NavigationStack` and independent `NavigationPath`. Must be locked in before any feature screens are built; retrofitting across 15+ screens is high cost.

2. **Inter font silent fallback** — SwiftUI falls back to SF Pro with zero error or warning if `UIAppFonts` is missing from Info.plist, font files are not in Copy Bundle Resources, or the `.custom()` call uses the filename instead of the PostScript name. Verify with `UIFont.familyNames` debug print immediately after setup; create a `BlossomFont` wrapper that centralizes all `.custom()` calls.

3. **Brand color drift via inline hex values** — after 10+ screens, `Color(hex: "#7361F7")` appears 40 times with subtle typos. Create `Color+Blossom.swift` design tokens and Asset Catalog named colors with Light/Dark variants before writing a single view. This also prevents dark mode breakage: `Color.white` for card backgrounds turns invisible in dark mode; use `Color(.systemBackground)` or adaptive color sets.

4. **Tier permission logic scattered across views** — `if tierLevel >= 2` inline in 10+ view files becomes inconsistent and breaks when tier definitions change. All gating flows through `PermissionGate.canAccess(section:userTier:)` established in Phase 1, before any locked content screens are built.

5. **Swift 6 strict concurrency errors in mock layer** — `@Observable` classes that touch UI state without `@MainActor` produce compile-time data race errors in Swift 6.2. Mark all view models and `@Observable` service classes `@MainActor` from the start; use synchronous mock data returns (no `async/await`) to avoid actor isolation complexity entirely.

---

## Implications for Roadmap

The architecture's build-order section and pitfall-to-phase mapping converge on the same sequencing. Foundation must be locked before features; subscriber journey before creator tools; payment and confetti before community hub. Six phases are suggested.

### Phase 1: Foundation and Design System
**Rationale:** Half of all identified pitfalls (navigation architecture, Inter font, brand colors, dark mode, mock data service layer, Swift 6 concurrency conventions) are irreversible if deferred. Every subsequent phase depends on these being correct. This is the highest-leverage phase — not glamorous but load-bearing.
**Delivers:** Xcode project configured, all brand colors as Asset Catalog tokens, Inter font verified, per-tab `NavigationStack` structure, `CommunityStore`/`UserSession` environment injection, `MockDataService` with all seed data, `@MainActor @Observable` convention established, shared components (`BlossomCard`, `TierBadgeView`, `GatedContentOverlay`, `AvatarView`, `ConfettiView`).
**Addresses:** App scaffold, navigation container, design tokens, shared component library
**Avoids:** Pitfalls 1 (shared nav state), 3 (brand color drift), 4 (custom font), 5 (dark mode breakage), 7 (mock data blob), 10 (Swift 6 concurrency errors)

### Phase 2: Discovery and Community Preview
**Rationale:** The subscriber funnel entry point. Without a browseable discovery screen and a convincing community preview page, there is nothing to demo. This phase establishes the "before subscribe" side of the product and is the first thing stakeholders will see.
**Delivers:** Splash/intro screen, `DiscoveryView` with community cards, `CommunityPreviewView` with tier cards and benefits list, `TierDetailView` (sheet), verified creator badge, community hero section.
**Uses:** `NavigationStack` routing (Phase 1), `CommunityStore` (Phase 1), brand tokens (Phase 1)
**Implements:** Discovery feature, CommunityPreview feature, Splash feature from architecture
**Avoids:** Pitfall 2 (iOS 26 Liquid Glass tab bar insets — test scroll behavior with real content), Pitfall 8 (scope creep — subscriber flow first, creator tools after)

### Phase 3: Payment Flow and Subscription Celebration
**Rationale:** The payment flow is the critical path blocker for all subscriber-side features. Until it exists and produces a subscribed `UserSession` state, nothing downstream (community hub, tier gating, forum access) can be built or demoed. The confetti celebration is also the single most memorable moment in the stakeholder demo — it deserves careful implementation.
**Delivers:** Mocked Stripe payment sheet, payment state machine (idle → processing → success), `PaymentSuccessView` with confetti, `UserSession.subscriptions.append()` on success, subscription state reflected in UI (tier badge, locked content unlocking).
**Uses:** `PaymentFlowView` as `.sheet` (not nav push — per architecture anti-pattern 5), `ConfettiView` component (Phase 1), `UserSession` (Phase 1)
**Avoids:** Pitfall 9 (confetti lifecycle — reset flag after 3s, cap at 150 particles, full teardown between triggers), anti-pattern 5 (payment as nav push)

### Phase 4: Community Hub and Tier-Gated Content
**Rationale:** The "after subscribe" experience. This is the product — what subscribers actually get for their money. Tier gating, the `PermissionGate`, forum threads, and the FAQ zone all live here. The largest feature phase in terms of screen count.
**Delivers:** `CommunityHubView` (Linktree-style landing with Posts / Forums / FAQ tabs), `ContentFeedView` with post cards (text, trade highlights, YouTube links), `GatedContentOverlay` with tier upgrade prompts, `ForumListView` and `ForumThreadView` with reply and like, `FAQView` with question submission and confirmation state, `PermissionGate` established (if not already done in Phase 1).
**Uses:** All Phase 1 foundation, `PermissionGate`, subscribed `UserSession` state from Phase 3
**Implements:** CommunityHub feature (all sub-components), tier gating, FAQ zone
**Avoids:** Pitfall 6 (scattered permission logic — all gate checks go through `PermissionGate`), UX pitfall on lock icons (show "Available to [Tier Name] members" not just a padlock)

### Phase 5: Creator Dashboard
**Rationale:** Creator tools are deliberately secondary to the subscriber journey for the demo pitch. Building them after the full subscriber flow is complete ensures the core experience is polished before complexity is added. Creator dashboard is scoped to two primary screens — earnings and community setup — per the anti-scope-creep recommendation.
**Delivers:** `CreatorDashboardView` (accessible via "Creator Dashboard" button for community owners), `EarningsView` (revenue bar chart, gross → 10% fee → net payout), `CommunitySetupView` (edit community info, tiers), `TierEditorView`, `PermissionsMatrixView` (grid of content sections × tier access levels). Creator entry point gated by `UserSession.isCreator(of:)`.
**Uses:** `CreatorDashboardViewModel` with draft copy pattern (edits committed to `CommunityStore` on save), SwiftUI `Charts` for earnings
**Avoids:** Pitfall 8 (scope creep — cap creator dashboard at these four screens; all others are "Coming soon" stubs), UX pitfall (demo always starts subscriber-side, creator view is appendix)

### Phase 6: Polish, Dark Mode Audit, and Demo Readiness
**Rationale:** The "looks done but isn't" checklist from PITFALLS.md is real. Individual features that pass visual inspection often have dark mode gaps, font rendering issues, or permission state inconsistencies that are only caught end-to-end. This phase is the pre-demo hardening pass.
**Delivers:** Full dark mode verification across every screen in the subscriber demo flow, Inter font rendering verification against brand reference, end-to-end subscriber demo run (discovery → preview → subscribe → confetti → community hub → forum → FAQ), tier permission consistency check across all three content types (feed posts, forums, FAQ), YouTube tap verification, creator earnings math correctness, all six ambassador profile images loading, animation polish (confetti timing, scroll transitions, tier card expansion).
**Avoids:** All "Looks Done But Isn't" checklist items from PITFALLS.md

### Phase Ordering Rationale

- Foundation before features is non-negotiable: five of ten pitfalls are irreversible if deferred past Phase 1.
- Subscriber flow phases (2→3→4) follow the actual user journey dependency graph from FEATURES.md: Discovery requires Preview; Preview requires Payment; Payment unlocks Community Hub; Community Hub requires Tier Gating.
- Creator Dashboard (Phase 5) after the full subscriber experience ensures the demo-critical path is polished before secondary complexity is added — directly addressing scope creep Pitfall 8.
- Polish phase (Phase 6) is explicitly last but budgeted as a real phase, not an afterthought — the "Looks Done But Isn't" checklist demonstrates this phase has genuine work.

### Research Flags

Phases with implementation details that may benefit from deeper research during planning:

- **Phase 3 (Payment Flow):** Confetti animation implementation using `PhaseAnimator` + `Canvas` is documented but at MEDIUM confidence (tutorial source). The lifecycle management pattern (reset flag, teardown between triggers) should be prototyped early and verified.
- **Phase 4 (Community Hub):** iOS 26 `scrollTransition` behavior with the Liquid Glass tab bar floating above content — safe area inset handling at the bottom of scroll views may need testing iteration.

Phases with standard, well-documented patterns that can proceed without additional research:

- **Phase 1 (Foundation):** `@Observable` pattern, `NavigationStack` routing, Asset Catalog named colors, Inter font registration — all HIGH confidence with official Apple documentation.
- **Phase 2 (Discovery/Preview):** Standard SwiftUI view composition with brand components — established patterns.
- **Phase 5 (Creator Dashboard):** SwiftUI `Charts` bar chart for earnings is well-documented; draft/commit pattern for `CommunityStore` edits is standard.

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Apple-first stack backed by official WWDC25 documentation, Swift.org release notes, and high-confidence community sources (Hacking with Swift, Donny Wals). No third-party dependencies to evaluate. iOS 26 market adoption rate irrelevant for Simulator prototype. |
| Features | HIGH | Patreon, Circle, Whop, and Substack verified via official App Store listings and official support documentation. Competitor feature table cross-referenced across multiple sources. Investing-specific regulatory caution (SEC/FINRA/IIROC framing) is well-established. |
| Architecture | HIGH (SwiftUI patterns) / MEDIUM (iOS 26 specifics) | `@Observable`, `NavigationStack`, and environment injection patterns are HIGH confidence with official Apple migration docs and performance benchmarks. iOS 26 Liquid Glass tab bar behavior is MEDIUM confidence — behavior documented but newer and less battle-tested in production codebases. |
| Pitfalls | HIGH (navigation, font, colors) / MEDIUM (iOS 26 insets, concurrency) | Navigation pitfalls backed by official Apple Forums threads and multiple practitioner sources. Font registration failure modes confirmed by two independent how-to sources. Swift 6 concurrency errors and iOS 26 tab bar inset behavior are MEDIUM — correct approach is documented but real-world edge cases in iOS 26 may surface during development. |

**Overall confidence:** HIGH

### Gaps to Address

- **iOS 26 Liquid Glass bottom inset behavior with scrolling lists:** The correct approach (`.safeAreaInset`) is known, but exact behavior with `tabBarMinimizeBehavior` during aggressive scroll in a content feed needs simulator verification in Phase 1 before all feed views are built.
- **Confetti `PhaseAnimator` implementation:** The approach is sound but sourced from a tutorial (MEDIUM confidence). Build and validate a standalone confetti prototype early in Phase 3 before integrating into `PaymentSuccessView`.
- **Inter PostScript name verification:** Known failure mode — actual PostScript names for Inter font weights must be verified via `UIFont.familyNames` debug print at project setup; cannot be assumed from filenames.
- **StoreKit 2 timing:** Apple's November 2026 App Store deadline for in-app purchases is a production concern, not a prototype concern. Note it for the v1.x roadmap phase when real payment processing is implemented.

---

## Sources

### Primary (HIGH confidence)
- Apple Developer — Migrating ObservableObject to @Observable: https://developer.apple.com/documentation/SwiftUI/Migrating-from-the-observable-object-protocol-to-the-observable-macro
- Apple Developer — scrollTransition API: https://developer.apple.com/documentation/swiftui/view/scrolltransition(_:axis:transition:)
- Apple Developer WWDC25 — "Build a SwiftUI app with the new design": https://developer.apple.com/videos/play/wwdc2025/323/
- Swift.org — Swift 6.2 Release notes: https://www.swift.org/blog/swift-6.2-released/
- Patreon — Tier setup guide (official): https://support.patreon.com/hc/en-us/articles/203913559
- Patreon — Community features newsroom (official): https://news.patreon.com/articles/patreon-all-in-on-community
- Circle iOS App Store listing (official): https://apps.apple.com/us/app/circle-communities/id1509651625
- Whop iOS App Store listing (official): https://apps.apple.com/us/app/whop/id1600181492

### Secondary (MEDIUM confidence)
- Hacking with Swift — What's new in SwiftUI for iOS 26: https://www.hackingwithswift.com/articles/278/whats-new-in-swiftui-for-ios-26
- Donny Wals — Exploring tab bars on iOS 26 with Liquid Glass: https://www.donnywals.com/exploring-tab-bars-on-ios-26-with-liquid-glass/
- Donny Wals — Concurrency changes in Swift 6.2: https://www.donnywals.com/exploring-concurrency-changes-in-swift-6-2/
- Antoine van der Lee — @Observable macro performance vs ObservableObject: https://www.avanderlee.com/swiftui/observable-macro-performance-increase-observableobject/
- Sarunw — Custom fonts in SwiftUI: https://sarunw.com/posts/swiftui-custom-font/
- Apple Developer Forums — NavigationStack double-push issue in iOS 18: https://developer.apple.com/forums/thread/759542
- Tanaschita — NavigationPath with TabView: https://tanaschita.com/swiftui-navigation-path-with-tabview/
- Medium (Dinaga119) — Mastering SwiftUI Navigation 2025: https://medium.com/@dinaga119/mastering-navigation-in-swiftui-the-2025-guide-to-clean-scalable-routing-bbcb6dbce929
- Whop — Top trading community data: https://whop.com/blog/top-trading-whops/
- Apphud — Subscription paywall UX best practices: https://apphud.com/blog/design-high-converting-subscription-app-paywalls

### Tertiary (LOW confidence)
- AppCoda — PhaseAnimator tutorial (confetti approach): https://www.appcoda.com/learnswiftui/swiftui-phaseanimator.html — confetti lifecycle needs independent verification
- Medium (Ravi6997) — iOS 26 SDK requirements (Xcode 26 mandatory April 2026): https://ravi6997.medium.com/ios-26-sdk-requirements-what-developers-need-to-know-for-april-2026-16dec793c44d — trade press, treat as directional
- Ko-fi vs Buy Me a Coffee comparison: https://talks.co/p/kofi-vs-buy-me-a-coffee/ — single source, low relevance to this project
- Creator tier levels guide 2026: https://influenceflow.io/resources/creator-tier-levels-the-complete-2026-guide-to-building-your-monetization-strategy/ — single source, used only for tier count guidance

---

*Research completed: 2026-03-10*
*Ready for roadmap: yes*
