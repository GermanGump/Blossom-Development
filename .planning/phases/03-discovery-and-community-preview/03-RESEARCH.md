# Phase 3: Discovery and Community Preview - Research

**Researched:** 2026-03-11
**Domain:** SwiftUI discovery UI, animated transitions, parallax scroll, bottom sheets, accordion expansion
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Splash/intro screen**
- One-time intro — shown only on first visit, never again (persist state via @AppStorage or similar)
- Full-screen takeover — hides HubsTopNavBar entirely
- Logo animates briefly (scale up + fade), then auto-transitions to the discovery screen
- Adapts to both light and dark mode — light mode gets white background with light logo, dark mode gets dark background with dark logo variant
- After dismissal, user goes directly to discovery screen with stagger-fade entry animation

**Discovery screen layout**
- Featured hero card at top for BD's community — larger card with "Popular" label badge
- Pulsating Blossom violet (#7361F7) glow/hue effect behind BD's hero card — draws attention
- BD's hero card shows category "Education & Swing Trading" and starting price "$29.99/mo"
- Remaining 5 communities displayed as vertical list of cards below the hero
- Each card shows: community logo, community name, creator profile photo (circular + verified badge), brief description, member count, category, and starting price (if fits cleanly in layout)
- Some cards may have slight style variations, but most use the default/vanilla card style
- Community order below hero: Claude picks sensible order based on mock data (e.g., member count)
- Stagger-fade-in entry animation when discovery screen first appears after splash — cards animate in from bottom sequentially for premium feel

**Search behavior**
- HubsTopNavBar search bar is functional — filters communities by name/creator in real-time
- Search results appear in a dropdown overlay (quick results), not inline replacement of the browse view
- BD's hero card only shows on the main unfiltered page — in search results, BD appears as a normal result card
- When search is cleared/dismissed, full discovery layout returns with hero card

**Community preview page**
- Patreon-style hero: full-width community banner image at top with creator avatar overlapping the bottom edge of the banner
- Parallax scroll effect on the banner (banner scrolls slower than content below)
- Content order below hero: value proposition tagline → creator bio (with photo + verified badge) → full description
- Grouped social proof section with variety — member count, row of member avatars, testimonial-style quote
- Blossom-styled back button for navigation (not just default NavigationStack back arrow)
- Sticky "View Tiers" CTA button at bottom — tiers are NOT inline on the page
- Tapping "View Tiers" presents a bottom sheet with tier cards

**Tier expansion (bottom sheet)**
- Bottom sheet slides up when "View Tiers" is tapped
- Tier cards displayed as vertical stack inside the sheet
- One tier visually emphasized with "Most Popular" label — determined by mock data (not always the second tier)
- Price displayed subtly alongside the tier name (not large/prominent)
- Accordion expansion — tapping a tier card expands it inline to reveal benefits list, included content types, and monthly cost
- Only one tier expandable at a time — expanding one collapses the previously expanded tier
- Expanded tier shows a fully styled, tappable "Subscribe" button — button does nothing in Phase 3 (Phase 4 wires it up)
- Sheet dismissible by swiping down OR tapping outside

### Claude's Discretion
- Exact animation durations and easing curves for splash, stagger-fade, parallax, and accordion
- Hero card dimensions and layout proportions
- Social proof testimonial content and member avatar selection
- Banner image handling when community has no banner (bannerImageName is optional)
- Search dropdown styling and result item layout
- Exact spacing, padding, and margins throughout
- Pulsating glow implementation technique (e.g., PhaseAnimator, withAnimation repeating, or Canvas)

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| DISC-01 | Communities tab splash/intro screen with centered Blossom logo on white background before entering main view | Splash screen with @AppStorage one-time flag, scale+fade animation with withAnimation completion chaining |
| DISC-02 | Community discovery/browse screen with featured communities displayed as scrollable cards | ScrollView + LazyVStack, hero card + list cards, stagger-fade via ForEach with index-based delay |
| DISC-03 | Community preview cards showing: community logo, community name, creator profile picture (circular), verified badge, brief description, member count | CommunityCardView using existing AvatarView, BlossomCard, TagView components |
| DISC-04 | Tapping a community card navigates to that community's preview page | NavigationLink(value: HubsRoute.communityPreview(id:)) with navigationDestination — pushes onto Hubs NavigationStack only |
| SUBS-01 | Community preview page showing full description, value proposition, and creator bio | CommunityPreviewView with parallax banner via ScrollView + visualEffect, sticky CTA via .safeAreaInset |
| SUBS-02 | Flexible 1-4 tier display with creator-defined tier names and monthly prices | TiersBottomSheet presented via sheet(isPresented:), TierCardView list |
| SUBS-03 | Tier detail expansion (tappable tray) showing benefits list, included content types, and monthly cost | Accordion with @State expandedTierID, withAnimation(.spring) height/opacity, single-expansion enforced in view model |
</phase_requirements>

---

## Summary

Phase 3 builds the complete subscriber discovery journey: one-time splash, scrollable browse with a hero card, full-screen community preview, and an expandable tier sheet. The project already has a complete design system (BlossomTheme, BlossomFont, BlossomCard, BlossomButton, AvatarView, TagView, VerifiedBadge, SectionHeader, EmptyStateView) and a fully-populated CommunityStore with six ambassador communities and mock data. All navigation routing (HubsRoute) is already declared.

The main SwiftUI challenges are: (1) the one-time splash with chained animations, (2) stagger-fade card entry, (3) parallax banner using the modern `visualEffect` modifier instead of deprecated `GeometryReader`, (4) a sticky "View Tiers" CTA using `.safeAreaInset`, (5) a bottom sheet with single-expansion accordion tier cards. All of these have well-established SwiftUI patterns on iOS 17+ (iOS 26 deployment target gives access to all of them).

The search dropdown is an overlay pattern — a `ZStack` with a conditional search results panel anchored below `HubsTopNavBar`, not a separate NavigationStack push. The `@AppStorage` one-time-splash flag must live in the view (not an `@Observable` class) because of the known SwiftUI pitfall that `@AppStorage` inside `@Observable` does not trigger view updates.

**Primary recommendation:** Build Phase 3 as five discrete files — `HubsSplashView`, `HubsDiscoveryView`, `CommunityCardView` (hero variant + standard variant), `CommunityPreviewView`, and `TiersBottomSheet` + `TierCardView` — each in its own Swift file under `Features/Hubs/`. Wire them into the existing `HubsView` placeholder and `HubsNavigation`.

---

## Standard Stack

### Core (all already in project)

| Component | Version | Purpose | Status |
|-----------|---------|---------|--------|
| SwiftUI | iOS 26 SDK | All UI construction | Already in use |
| `@Observable` + `@MainActor` | Swift 6.2 | View models for discovery, preview, tiers | Established pattern |
| `@AppStorage` | iOS 26 | One-time splash flag — must be `@State` in view body | Use in view, NOT in @Observable |
| `NavigationStack` + `navigationDestination(for:)` | iOS 16+ | Per-tab routing via `HubsRoute` | Already set up in ContentView |
| `sheet(isPresented:)` | iOS 26 | Tiers bottom sheet | Standard |
| `ScrollView` + `LazyVStack` | iOS 26 | Discovery browse list | Standard |
| `visualEffect(_:)` | iOS 17+ | Parallax banner scroll effect | Modern replacement for GeometryReader |
| `.safeAreaInset(edge:)` | iOS 15+ | Sticky "View Tiers" CTA bar at bottom | Standard |
| `withAnimation` completion chaining | iOS 17+ | Splash: scale up, then fade-out, then show discovery | Chained completion closures |
| `PhaseAnimator` | iOS 17+ | Pulsating glow on hero card | Modern repeating animation API |

### Supporting (project libraries)

| Component | Purpose | Source |
|-----------|---------|--------|
| `AvatarView` | Creator profile photos on cards and preview page | `Core/Components/AvatarView.swift` |
| `BlossomCard` (`.blossomCard()`) | Card styling for community cards | `Core/Components/BlossomCard.swift` |
| `BlossomButton` (Primary/Secondary/Ghost) | "View Tiers" CTA, "Subscribe" button, back button | `Core/Components/BlossomButton.swift` |
| `TagView` | Category tag, tier label, "Popular" badge | `Core/Components/TagView.swift` |
| `VerifiedBadge` | Alongside creator name on cards and preview | `Core/Components/VerifiedBadge.swift` |
| `SectionHeader` | "Communities" heading, "Popular" section label | `Core/Components/SectionHeader.swift` |
| `EmptyStateView` | No search results state | `Core/Components/EmptyStateView.swift` |
| `CommunityStore` | Mock data source for all communities | `Models/CommunityStore.swift` |
| `BlossomTheme` | All semantic color tokens | `Core/Theme/BlossomTheme.swift` |
| `BlossomFont` | Inter type scale (largeTitle → caption) | `Core/Theme/BlossomFont.swift` |

### No new dependencies required

All needed components exist in the project. ComponentsKit is already linked but not needed for this phase. Zero new SPM packages.

---

## Architecture Patterns

### Recommended File Structure

```
BlossomHubs/Features/Hubs/
├── HubsView.swift                   # Replace placeholder — orchestrates splash vs. discovery
├── HubsTopNavBar.swift              # Existing — wire searchText binding to DiscoveryViewModel
├── HubsNavigation.swift             # Existing — wire .communityPreview(id:) to CommunityPreviewView
├── Discovery/
│   ├── HubsSplashView.swift         # One-time full-screen splash, @AppStorage flag
│   ├── HubsDiscoveryView.swift      # ScrollView with hero card + standard card list
│   ├── HubsDiscoveryViewModel.swift # @MainActor @Observable — filtered communities, search
│   ├── CommunityHeroCardView.swift  # BD's large hero card with pulsating glow
│   └── CommunityCardView.swift      # Standard card for 5 remaining communities
├── Search/
│   └── SearchDropdownView.swift     # Overlay search results panel
└── Preview/
    ├── CommunityPreviewView.swift   # Full preview page — parallax banner, sticky CTA
    ├── CommunityPreviewViewModel.swift  # @MainActor @Observable — community, tiers state
    ├── TiersBottomSheet.swift       # sheet(isPresented:) wrapper view
    └── TierCardView.swift           # Single tier card with accordion expansion
```

### Pattern 1: One-Time Splash with @AppStorage

**What:** `@AppStorage` key in the view (not in an @Observable class) controls whether the splash is shown. Splash auto-dismisses after logo animation completes.

**Why `@AppStorage` must be in the view:** The swiftui-pro `data.md` reference explicitly warns: "Never attempt to use `@AppStorage` inside an `@Observable` class, even if marked `@ObservationIgnored` — it will not trigger view updates when a change happens."

**When to use:** One-time first-visit UI gating.

```swift
// Source: swiftui-pro/references/data.md + Apple docs
struct HubsView: View {
    @AppStorage("hasSeenHubsSplash") private var hasSeenSplash = false
    @State private var showDiscovery = false

    var body: some View {
        ZStack {
            if !hasSeenSplash && !showDiscovery {
                HubsSplashView {
                    // called by splash when animation completes
                    withAnimation(.easeOut(duration: 0.3)) {
                        showDiscovery = true
                    } completion: {
                        hasSeenSplash = true
                    }
                }
                .transition(.opacity)
            } else {
                HubsDiscoveryView()
                    .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(for: HubsRoute.self) { route in
            switch route {
            case .communityPreview(let id):
                CommunityPreviewView(communityID: id)
            case .communityDetail(let id):
                EmptyView() // Phase 5
            }
        }
    }
}
```

### Pattern 2: Chained Splash Animation

**What:** Logo scales up, pauses briefly, then fades out — using `withAnimation` completion chaining (the correct iOS 17+ pattern).

**Critical rule from swiftui-pro `views.md`:** "Chaining animations must be done using a `completion` closure passed to `withAnimation()`, rather than trying to execute multiple `withAnimation()` calls using delays."

```swift
// Source: swiftui-pro/references/views.md
struct HubsSplashView: View {
    var onComplete: () -> Void
    @State private var logoScale: CGFloat = 0.7
    @State private var logoOpacity: Double = 0

    var body: some View {
        // ...
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                logoScale = 1.0
                logoOpacity = 1.0
            } completion: {
                // Brief pause then fade-out → triggers parent transition
                withAnimation(.easeIn(duration: 0.3).delay(0.5)) {
                    logoOpacity = 0.0
                } completion: {
                    onComplete()
                }
            }
        }
    }
}
```

### Pattern 3: Stagger-Fade Card Entry

**What:** Cards animate in sequentially from bottom using index-based animation delays. The animation fires once when the discovery view appears.

```swift
// Source: swiftui-pro/references/views.md (animation) + Apple docs
struct HubsDiscoveryView: View {
    @State private var cardsVisible = false
    var communities: [Community]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(communities.enumerated()), id: \.element.id) { index, community in
                    CommunityCardView(community: community)
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                        .animation(
                            .easeOut(duration: 0.35).delay(Double(index) * 0.08),
                            value: cardsVisible
                        )
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            cardsVisible = true
        }
    }
}
```

Note: `animation(_:value:)` is the correct form (not the deprecated `animation(_:)` with no value). Each card gets `index * 0.08s` delay for the sequential stagger effect.

### Pattern 4: Pulsating Glow via PhaseAnimator

**What:** The hero card has a repeating pulsating glow in Blossom violet. `PhaseAnimator` (iOS 17+) is the modern way to drive repeating, multi-phase animations.

```swift
// Source: Apple Developer Documentation — PhaseAnimator
struct CommunityHeroCardView: View {
    var community: Community

    var body: some View {
        PhaseAnimator([false, true]) { isGlowing in
            heroCardContent(community)
                .shadow(
                    color: BlossomTheme.violet.opacity(isGlowing ? 0.6 : 0.15),
                    radius: isGlowing ? 20 : 8
                )
        } animation: { phase in
            .easeInOut(duration: 1.4)
        }
    }
}
```

Alternative (simpler): a `withAnimation(.easeInOut(duration:1.4).repeatForever(autoreverses:true))` on `.onAppear` driving a `@State var glowIntensity` is also valid and easier to reason about. Both approaches are HIGH confidence.

### Pattern 5: Parallax Banner with visualEffect

**What:** The community banner image scrolls at a slower rate than the content below it, creating a parallax effect.

**Critical rule from swiftui-pro `api.md`:** "Do not use `GeometryReader` if a newer alternative works: `containerRelativeFrame()`, `visualEffect()`, or the `Layout` protocol."

```swift
// Source: swiftui-pro/references/api.md — visualEffect is the modern replacement
struct CommunityPreviewView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Banner with parallax
                Color.clear
                    .frame(height: 240)
                    .overlay {
                        bannerImage
                            .resizable()
                            .scaledToFill()
                            .visualEffect { content, proxy in
                                let offsetY = proxy.frame(in: .scrollView).minY
                                return content
                                    .offset(y: offsetY > 0 ? -offsetY * 0.4 : 0)
                                    .clipped()
                            }
                    }
                    .clipped()

                // Content below banner...
            }
        }
        .safeAreaInset(edge: .bottom) {
            viewTiersCTABar
        }
    }
}
```

`visualEffect(_:)` receives a `GeometryProxy` relative to the named coordinate space, making it a clean drop-in for parallax without the layout disruption of `GeometryReader`.

### Pattern 6: Sticky CTA with safeAreaInset

**What:** "View Tiers" button floats above the tab bar and keyboard at all times, without overlapping scroll content.

```swift
// Source: Apple Developer Documentation — safeAreaInset
.safeAreaInset(edge: .bottom) {
    VStack(spacing: 0) {
        Divider()
        Button("View Tiers") { showTiers = true }
            .buttonStyle(BlossomPrimaryButton())
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(BlossomTheme.background)
    }
}
```

`.safeAreaInset` is preferred over a `ZStack` overlay because it correctly pushes scroll content up so the last card is not hidden behind the button.

### Pattern 7: Bottom Sheet with sheet(isPresented:)

**What:** "View Tiers" taps present `TiersBottomSheet` as a standard SwiftUI sheet. Sheet is dismissible by swipe or tap outside.

**Rule from swiftui-pro `navigation.md`:** "If a sheet is designed to present an optional piece of data, prefer `sheet(item:)` over `sheet(isPresented:)`." In this case the sheet doesn't present optional data (all communities have tiers), so `sheet(isPresented:)` is correct.

```swift
// Source: swiftui-pro/references/navigation.md
.sheet(isPresented: $showTiers) {
    TiersBottomSheet(tiers: community.tiers)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
}
```

`.presentationDetents` allows the sheet to start at medium height and expand to large — appropriate for 1-4 tier cards.

### Pattern 8: Single-Expansion Accordion

**What:** Only one tier card is expanded at a time. Tapping an expanded card collapses it; tapping a different card collapses the current and expands the new one.

```swift
// Source: swiftui-pro/references/views.md (animation pattern)
struct TiersBottomSheet: View {
    var tiers: [Tier]
    @State private var expandedTierID: UUID? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(tiers) { tier in
                    TierCardView(
                        tier: tier,
                        isExpanded: expandedTierID == tier.id
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            expandedTierID = expandedTierID == tier.id ? nil : tier.id
                        }
                    }
                }
            }
            .padding(16)
        }
    }
}
```

`@State private var expandedTierID: UUID?` provides clean single-expansion logic: set to new ID to expand, set to nil or same ID to collapse. The `withAnimation(.spring(...), value: expandedTierID)` on the `TierCardView` expansion content handles smooth height animation.

### Pattern 9: Search Dropdown Overlay

**What:** Search results appear as a floating overlay panel anchored below `HubsTopNavBar`, not a NavigationStack push. The main discovery list stays underneath.

```swift
struct HubsView: View {
    @State private var searchText = ""

    var body: some View {
        ZStack(alignment: .top) {
            // Main content (splash or discovery)
            mainContent

            // Overlay anchored below nav bar
            if !searchText.isEmpty {
                VStack(spacing: 0) {
                    // Reserve space equal to nav bar height
                    Color.clear.frame(height: navBarHeight)

                    SearchDropdownView(query: searchText)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }
}
```

The `navBarHeight` can be a constant (estimated 60pt) rather than `GeometryReader` since we know the nav bar height from `HubsTopNavBar`'s padding spec.

### Pattern 10: NavigationLink with Value-Based Routing

**What:** Tapping a community card navigates to the preview page via the already-declared `HubsRoute.communityPreview(id:)`. Uses `navigationDestination(for:)` not the deprecated `NavigationLink(destination:)`.

**Rule from swiftui-pro `navigation.md`:** "Strongly prefer to use `navigationDestination(for:)` to specify destinations; flag all use of the old `NavigationLink(destination:)` pattern."

```swift
// Source: swiftui-pro/references/navigation.md
NavigationLink(value: HubsRoute.communityPreview(id: community.id.uuidString)) {
    CommunityCardView(community: community)
}
.buttonStyle(.plain) // prevents NavigationLink blue highlight on card
```

The `navigationDestination(for: HubsRoute.self)` registration moves to `HubsView` (the root of the Hubs NavigationStack) so it is registered once per data type.

### Anti-Patterns to Avoid

- **GeometryReader for parallax:** Causes layout jank and re-render thrashing. Use `visualEffect(_:)` instead.
- **animation(_:) without value:** The single-argument `animation(_:)` modifier is deprecated. Always provide a `value:` parameter.
- **@AppStorage inside @Observable class:** Does not trigger view updates. Put the splash flag `@AppStorage` in the view struct.
- **Multiple withAnimation calls with delays for chained animation:** Timing drifts. Use `withAnimation { } completion: { withAnimation { } }` chaining instead.
- **foregroundColor():** Deprecated. Use `foregroundStyle()` everywhere.
- **cornerRadius():** Deprecated. Use `clipShape(.rect(cornerRadius:))` or `clipShape(RoundedRectangle(cornerRadius:, style: .continuous))`.
- **GeometryReader for card sizing:** Use `containerRelativeFrame` or fixed frame constants.
- **NavigationLink(destination:):** Deprecated pattern. Use `NavigationLink(value:)` with `navigationDestination(for:)`.
- **overlay(_:alignment:):** Deprecated form. Use `overlay(alignment:) { }` closure form.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Card styling | Custom background+border+shadow view | `.blossomCard()` ViewModifier | Already implemented, consistent with rest of app |
| Creator avatar | Custom circular image + badge | `AvatarView(imageName:preset:showVerifiedBadge:)` | Handles verified badge, ambassador bolt, ring color |
| Category/tier labels | Custom pill views | `TagView(_ text:, style:)` | `.stock`, `.tier`, `.category` styles match brand |
| Verified badge | Custom checkmark badge | `VerifiedBadge` component | Already uses correct teal + capsule styling |
| Section headings | Custom HStack + Text | `SectionHeader(title:actionText:action:)` | Matches all other section headings in app |
| Primary CTA button | Custom button | `BlossomPrimaryButton` ButtonStyle | Consistent violet, correct corner radius, font |
| Empty search state | Custom empty view | `EmptyStateView` | Already implemented |
| Parallax scroll | GeometryReader-based offset | `visualEffect(_:)` modifier | Modern, performant, no layout disruption |
| Sticky bottom button | ZStack overlay | `.safeAreaInset(edge: .bottom)` | Correctly pushes scroll content up |
| Repeating animation | DispatchQueue timer loop | `PhaseAnimator` or `withAnimation(...).repeatForever` | Declarative, respects Reduce Motion |

**Key insight:** Phase 3 should feel like wiring together existing Lego pieces. The design system is already complete. New code is primarily layout composition, view model logic, and animation parameters.

---

## Common Pitfalls

### Pitfall 1: @AppStorage in @Observable
**What goes wrong:** Putting `hasSeenSplash` in an `@Observable` class — the view never re-renders when the key changes, so the splash never dismisses.
**Why it happens:** `@Observable` macro's observation tracking does not cover `@AppStorage`.
**How to avoid:** Declare `@AppStorage("hasSeenHubsSplash") private var hasSeenSplash = false` directly in `HubsView` body (or in whatever View struct owns the splash gate).
**Warning signs:** Splash dismisses but screen stays blank; or `hasSeenSplash` updates but view does not transition.

### Pitfall 2: NavigationDestination Registered in Wrong View
**What goes wrong:** `navigationDestination(for: HubsRoute.self)` is registered inside `HubsDiscoveryView` instead of at the root `HubsView` — causes "multiple registrations" warnings and unpredictable navigation.
**Why it happens:** `navigationDestination` must be registered once per type in the NavigationStack hierarchy. Any descendant view registering the same type overrides the parent's.
**How to avoid:** Register `navigationDestination(for: HubsRoute.self)` only in `HubsView` (the direct child of the Hubs `NavigationStack` in `ContentView`). Remove the stub `.navigationDestination` that is currently in `HubsView.swift` and replace it with the real switch.
**Warning signs:** Console warning "navigationDestination registered multiple times."

### Pitfall 3: NavigationLink Highlight on Custom Cards
**What goes wrong:** Wrapping a custom card in `NavigationLink(value:)` causes a blue flash or dimming overlay on tap.
**Why it happens:** Default `NavigationLink` uses the `automatic` button style which shows highlight.
**How to avoid:** Apply `.buttonStyle(.plain)` to the `NavigationLink`.

### Pitfall 4: Sheet Content Height with accordion
**What goes wrong:** The bottom sheet starts too small to show tier cards; user must manually drag it up.
**Why it happens:** Default sheet detent is `large`. Using `[.medium, .large]` with medium as the default feels cramped for 4 tiers.
**How to avoid:** Use `.presentationDetents([.fraction(0.55), .large])` with `.presentationDragIndicator(.visible)`. Accordion expansion will naturally push content, and the user can expand to large. For communities with 1-2 tiers, `.medium` is sufficient.

### Pitfall 5: Parallax Causing Clipping Issues
**What goes wrong:** The banner image zooms in past the card boundary during parallax, or clips on the wrong axis.
**Why it happens:** `visualEffect` offset is applied before clipping if `.clipped()` is on the wrong view.
**How to avoid:** Apply `visualEffect` to the `Image`, apply `.clipped()` to the container `Color.clear.frame(height:)` that wraps it. The offset should only apply when `offsetY > 0` (scrolling down reveals more) — when scrolling up past banner, disable the effect to avoid gap at top.

### Pitfall 6: Stagger Animation Firing on Every Re-render
**What goes wrong:** The stagger-fade animation replays every time the search text changes or the view re-renders.
**Why it happens:** `onAppear` fires each time the view appears in the hierarchy, including after NavigationStack pops back to discovery.
**How to avoid:** Use a `@State private var cardsVisible = false` that is set once on first `onAppear` with a guard: `guard !cardsVisible else { return }`. Alternatively, use `.task` which only fires once per view lifetime.

### Pitfall 7: HubsTopNavBar Hidden During Splash
**What goes wrong:** The splash is supposed to hide `HubsTopNavBar` entirely, but it still renders underneath.
**Why it happens:** `HubsView` currently wraps both `HubsTopNavBar` and content in a `VStack`. If the splash is added as an overlay or ZStack on top of that, the nav bar still renders and takes up space.
**How to avoid:** Restructure `HubsView.body` so that the splash state replaces the entire view content (nav bar + scroll view), not just the scroll content area. Use a top-level `ZStack` or `if hasSeenSplash { VStack { HubsTopNavBar ... } } else { HubsSplashView }`.

### Pitfall 8: Missing bannerImageName Crash
**What goes wrong:** `CommunityPreviewView` force-unwraps or directly uses `community.bannerImageName` — crashes when nil.
**Why it happens:** `bannerImageName` is declared `String?` on `Community`. Only some mock communities have banners.
**How to avoid:** Use a fallback gradient or solid violet background when `bannerImageName` is nil. Check the mock data: not all 6 communities necessarily have bannerImageName set.

---

## Code Examples

### Discovering Communities Filtered by Search

```swift
// Source: project pattern — HubsDiscoveryViewModel
@MainActor
@Observable
final class HubsDiscoveryViewModel {
    var searchText: String = ""
    private let store: CommunityStore

    var filteredCommunities: [Community] {
        guard !searchText.isEmpty else { return store.communities }
        let query = searchText.lowercased()
        return store.communities.filter {
            $0.name.lowercased().contains(query) ||
            $0.creator.name.lowercased().contains(query) ||
            $0.creator.username.lowercased().contains(query)
        }
    }

    var heroCommuntiy: Community? {
        // BD Investing is always the hero when not searching
        store.communities.first { $0.creator.username == "@bdinvesting" }
    }

    var listCommunities: [Community] {
        // All except hero, sorted by member count descending
        guard let hero = heroCommuntiy else { return store.communities }
        return store.communities
            .filter { $0.id != hero.id }
            .sorted { $0.memberCount > $1.memberCount }
    }

    init(store: CommunityStore) {
        self.store = store
    }
}
```

### Accordion Tier Expansion

```swift
// Source: swiftui-pro/references/views.md pattern
struct TierCardView: View {
    var tier: Tier
    var isPopular: Bool = false
    var isExpanded: Bool
    var onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row — always visible
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(tier.name)
                        .font(BlossomFont.headline)
                        .foregroundStyle(BlossomTheme.primaryText)
                    Text("$\(tier.monthlyPrice, format: .number)/mo")
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                }
                Spacer()
                if isPopular {
                    TagView("Most Popular", style: .tier)
                }
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(BlossomTheme.secondaryText)
                    .font(.system(size: 14, weight: .medium))
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
            .padding(16)

            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    ForEach(tier.benefits, id: \.self) { benefit in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(BlossomTheme.teal)
                                .font(.system(size: 14))
                            Text(benefit)
                                .font(BlossomFont.body)
                                .foregroundStyle(BlossomTheme.primaryText)
                        }
                    }
                    Button("Subscribe") { /* Phase 4 wires this up */ }
                        .buttonStyle(BlossomPrimaryButton())
                        .padding(.top, 8)
                }
                .padding(16)
                .padding(.top, 0)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .blossomCard()
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isExpanded)
    }
}
```

### Blossom-Styled Back Button

Per the context decision, the preview page uses a Blossom-branded back button instead of the default system arrow. The pattern is `.navigationBarBackButtonHidden(true)` + a custom toolbar button.

```swift
// Source: swiftui-pro/references/navigation.md + api.md
struct CommunityPreviewView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView { /* ... */ }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: dismiss.callAsFunction) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Communities")
                                .font(BlossomFont.subhead)
                        }
                        .foregroundStyle(BlossomTheme.violet)
                    }
                }
            }
    }
}
```

Note: `.topBarLeading` is the correct modern placement (not the deprecated `.navigationBarLeading`).

---

## State of the Art

| Old Approach | Current Approach | iOS Version | Impact |
|--------------|------------------|-------------|--------|
| `GeometryReader` for parallax | `visualEffect(_:)` modifier | iOS 17+ | No layout disruption, cleaner code |
| `animation(_:)` no value | `animation(_:value:)` | iOS 17+ | Prevents unintended animations |
| `NavigationLink(destination:)` | `NavigationLink(value:)` + `navigationDestination(for:)` | iOS 16+ | Value-based routing, back-stack safe |
| `foregroundColor()` | `foregroundStyle()` | iOS 17+ | Required in current codebase |
| `cornerRadius()` | `clipShape(.rect(cornerRadius:))` | iOS 17+ | Required in current codebase |
| `overlay(_:alignment:)` | `overlay(alignment:) { }` | iOS 15+ | Required in current codebase |
| `.navigationBarLeading` | `.topBarLeading` | iOS 14+ | `.navigationBarLeading` deprecated |
| `ZStack` sticky button | `.safeAreaInset(edge:)` | iOS 15+ | Correctly adjusts scroll content inset |
| `DispatchQueue` repeating timer for animations | `PhaseAnimator` or `withAnimation.repeatForever` | iOS 17+ | Declarative, composable |
| Manual `PreviewProvider` | `#Preview` macro | iOS 17+ | Required by project convention |

**Deprecated/outdated in this codebase:**
- The existing `HubsView.swift` uses `foregroundColor()` — must be migrated to `foregroundStyle()` when replacing the placeholder
- The existing `HubsView.swift` has a stub `.navigationDestination(for: HubsRoute.self) { _ in EmptyView() }` — replace with the real switch statement

---

## Open Questions

1. **BD's hero card communityID for routing**
   - What we know: `CommunityStore.makeBDInvesting()` creates a community with `UUID()` (random each launch in mock data)
   - What's unclear: The hero card lookup by `creator.username == "@bdinvesting"` is reliable; routing by `community.id.uuidString` is safe since `HubsRoute.communityPreview(id: String)` carries the runtime UUID
   - Recommendation: Look up BD's community by creator username in `HubsDiscoveryViewModel.heroCommuntiy` at runtime — do not hardcode a UUID

2. **Banner images in mock data**
   - What we know: `bannerImageName: String?` is optional — some communities may have nil
   - What's unclear: Which of the 6 mock communities have banner images loaded in `Assets.xcassets`
   - Recommendation: Check `Assets.xcassets` at plan time; implement a fallback gradient for nil banners (violet-to-teal or plain violet matches brand)

3. **HubsTopNavBar search binding ownership**
   - What we know: `HubsTopNavBar` takes `@Binding var searchText: String` — currently bound in `HubsView`
   - What's unclear: After restructuring `HubsView` to handle splash/discovery, where does `searchText` live?
   - Recommendation: `searchText` stays in `HubsDiscoveryViewModel` as a published property; `HubsView` passes it as a binding to both `HubsTopNavBar` and `HubsDiscoveryView`

---

## Validation Architecture

`nyquist_validation` is enabled in `.planning/config.json`.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None detected — SwiftUI prototype, no test target configured |
| Config file | None — see Wave 0 |
| Quick run command | Build via `xcodebuild -scheme BlossomHubs -destination "platform=iOS Simulator,name=iPhone 16 Pro" build` |
| Full suite command | Same (no test targets exist yet) |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DISC-01 | Splash shows once, persists via @AppStorage | Manual-only | Launch simulator, verify splash on first launch; force-quit and relaunch to confirm it does not re-appear | N/A |
| DISC-02 | Discovery screen shows scrollable community cards | Manual-only | Simulator visual inspection — scroll cards, verify hero + 5 list cards | N/A |
| DISC-03 | Cards show logo, name, creator photo, verified badge, description, member count | Manual-only | Simulator visual inspection — compare card fields against mock data | N/A |
| DISC-04 | Tapping card navigates to preview in Hubs tab only | Manual-only | Tap a card, verify preview pushes; switch to another tab, verify that tab is unaffected | N/A |
| SUBS-01 | Preview page shows description, value prop, creator bio | Manual-only | Simulator visual inspection of CommunityPreviewView | N/A |
| SUBS-02 | 1-4 tier cards shown with creator-defined names and prices | Manual-only | Open tiers sheet, verify tier count matches mock data | N/A |
| SUBS-03 | Tier expansion shows benefits, content types, cost | Manual-only | Tap tier card, verify accordion; tap second card, verify first collapses | N/A |

**Manual-only justification:** This is a SwiftUI prototype with no test target. All requirements involve visual layout, animation, and navigation behavior that require simulator or device verification. A unit test for `HubsDiscoveryViewModel.filteredCommunities` is feasible but has no test target to run in.

### Sampling Rate
- **Per task commit:** Build (`xcodebuild build`) — confirms no Swift compilation errors
- **Per wave merge:** Manual smoke test in iOS Simulator: launch → splash → discovery → tap card → preview → "View Tiers" → tier expansion
- **Phase gate:** All 7 requirements manually verified in simulator before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] No test target exists — `xcodebuild test` not available; all validation is build + simulator
- [ ] `xcodebuild` unavailable in execution environment (Xcode not installed on CI machine — same constraint as Phase 1)

---

## Sources

### Primary (HIGH confidence)
- `swiftui-pro/references/api.md` — deprecated API replacements: `foregroundStyle`, `visualEffect`, `clipShape`, `topBarLeading`, `overlay` closure form
- `swiftui-pro/references/views.md` — animation chaining via completion closures, `animation(_:value:)`, extracted View structs, `#Preview`
- `swiftui-pro/references/navigation.md` — `navigationDestination(for:)` pattern, `sheet(item:)` vs `sheet(isPresented:)`, toolbar placement
- `swiftui-pro/references/data.md` — `@AppStorage` must be in view not `@Observable`, `@State` private ownership
- Project source code: `AvatarView.swift`, `BlossomCard.swift`, `BlossomButton.swift`, `TagView.swift`, `BlossomTheme.swift`, `BlossomFont.swift`, `Community.swift`, `CommunityStore.swift`, `HubsView.swift`, `HubsNavigation.swift`, `ContentView.swift`, `HubsTopNavBar.swift`

### Secondary (MEDIUM confidence)
- Apple Developer Documentation: `PhaseAnimator` (iOS 17+), `visualEffect(_:)` modifier, `safeAreaInset(edge:)`, `presentationDetents`

### Tertiary (LOW confidence — training knowledge, verified against swiftui-pro references)
- `withAnimation(...) completion:` chaining pattern — confirmed by swiftui-pro views.md
- `animation(_:value:)` deprecation of valueless form — confirmed by swiftui-pro views.md

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all components already exist in the project; no new dependencies
- Architecture: HIGH — patterns verified against swiftui-pro skill references and project conventions
- Pitfalls: HIGH — most derived from swiftui-pro warnings and existing project decisions in STATE.md
- Animation specifics: MEDIUM — exact durations are Claude's discretion; APIs are HIGH confidence

**Research date:** 2026-03-11
**Valid until:** 2026-06-11 (stable APIs; iOS 26 SDK is the target so no near-term deprecation risk)
