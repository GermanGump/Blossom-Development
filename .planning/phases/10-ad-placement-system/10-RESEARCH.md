# Phase 10: Ad Placement System - Research

**Researched:** 2026-03-17
**Domain:** SwiftUI ad view components, Link-based tap handling, seeded randomness, LazyVStack insertion patterns
**Confidence:** HIGH

## Summary

Phase 10 adds a visual demonstration of ad placements across three Blossom-owned surfaces. The scope is intentionally narrow: three self-contained SwiftUI view components (`BannerAdView`, `InlineCardAdView`, `PillAdView`) with hardcoded mock data and direct insertion into existing LazyVStack layouts. No store, no service layer, no placement engine.

The phase is low risk because all integration points are already-shipping views with known layout patterns. The main technical questions are (1) how to insert ad views into an enumerated ForEach without breaking index-based offset logic, (2) how to produce a deterministic but visit-varying random offset for the content feed, and (3) how to visually differentiate ad cards from organic content without violating the `blossomCard()` modifier convention.

All three target views (`HubsDiscoveryView`, `ContentFeedView`, `CategoryExploreView`) are read and confirmed in this research. Integration patterns are direct and well-understood.

**Primary recommendation:** Build three isolated ad view files in `Features/Hubs/Ads/`, insert them into the three host views with the exact placement logic specified in CONTEXT.md, use `Link(destination:)` wrapping each ad view for tappability.

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Ad format types:**
- Three formats: Banner, Inline Card, Pill
- Banner: Full-width, prominent — sits right above the featured hub section (anchored to featured hub, not to "My Hubs" — consistent regardless of subscription state)
- Inline Card: Feed-integrated, content-like — uses `blossomCard()` styling with a branded gradient border or accent stripe (option C: distinct but not jarring)
- Pill: Compact, lightweight, single-line or two-line unit — only appears in CategoryExploreView deep-browse lists

**Placement strategy:**
- Discovery feed (HubsDiscoveryView): 1 banner, positioned right above the "Featured Hub" section
- Content feed (ContentFeedView): Inline card ads between posts, appearing at a seeded-random offset between post 3 and 6 — deterministic per visit but feels organic
- Category explore (CategoryExploreView): Pill ads between community cards, consistent cadence every 6th–8th card throughout the entire list
- No ads on: Community hub landing, forums, FAQ, community preview, search, My Subscriptions, Creator Dashboard

**Visual treatment:**
- All three formats show a "Sponsored" / "Ad" label
- Blossom PRO ads: violet accent instead of generic ad border, labeled "Upgrade" instead of "Sponsored"
- External advertiser ads: brand-accurate colors with SF Symbol placeholder icons

**Mock ad data:**
- 5 advertisers: BMO ETFs (teal, `building.columns.fill`), Wealthsimple (black, `chart.line.uptrend.xyaxis`), Questrade (green, `dollarsign.arrow.circlepath`), EQ Bank (blue, `banknote.fill`), Blossom PRO (violet, house icon)
- 2–3 creative variants per advertiser (~10–15 total)
- Data hardcoded directly in ad view components — no AdStore or service layer
- Simple `.randomElement()` pick from hardcoded array for visual variety

**Interaction:**
- All ads tappable via SwiftUI `Link()` — opens advertiser's real website in Safari
- Blossom PRO ads link to internal upgrade prompt or external Blossom website

**Architecture:**
- No AdStore, no ad service, no placement engine
- Ad views are self-contained components with hardcoded data
- Three view components: `BannerAdView`, `InlineCardAdView`, `PillAdView`

### Claude's Discretion
- Exact SF Symbol choices per advertiser (approximating brand identity)
- Exact ad copy (headlines, subtitles) for the 2–3 variants per brand
- Inline card accent stripe/gradient border design details
- Pill sizing and label placement
- Exact random offset algorithm for content feed placement
- Haptic feedback on ad tap (if any)

### Deferred Ideas (OUT OF SCOPE)
- Ads inside community hubs (forums, content feed within a community)
- Ad configuration/management for creators or Blossom admins
- Ad impression tracking or analytics
- Ad frequency capping or user targeting
- Interstitial or full-screen ad formats
</user_constraints>

---

## Standard Stack

### Core (no new dependencies)
| Component | What it does | Why standard |
|-----------|-------------|--------------|
| SwiftUI `Link(destination:)` | Opens URL in system browser (Safari) | Already used for YouTube deep links in YouTubeLinkCard.swift — same pattern |
| `blossomCard()` modifier | Base card styling | Established project-wide convention — ad cards extend this |
| `BlossomTheme.*` color tokens | Semantic color adaptation (light/dark) | Project-wide convention — all UI uses these |
| `BlossomFont.*` type tokens | Inter font sizes | Project-wide convention |
| Swift `Array.randomElement()` | Pick random ad creative | Built-in, no dependencies |

No new SPM packages. ComponentsKit is already integrated but not needed for this phase.

**Installation:** None required.

---

## Architecture Patterns

### Recommended Project Structure
```
BlossomHubs/Features/Hubs/Ads/
├── BannerAdView.swift        # Full-width banner for HubsDiscoveryView
├── InlineCardAdView.swift    # Feed-integrated card for ContentFeedView
└── PillAdView.swift          # Compact pill for CategoryExploreView
```

Ad views live in `Features/Hubs/Ads/` alongside other Hubs features. No new folder outside Features is needed.

### Pattern 1: Self-Contained Ad View with Hardcoded Data

**What:** Each ad view file defines its own `AdCreative` struct and a static array of creatives. No external data source. The view picks a creative once in `onAppear` or via `@State` initialized from `.randomElement()`.

**When to use:** Always — per CONTEXT.md decision, no AdStore.

**Key insight on initialization timing:** `.randomElement()` on a static array is safe at struct init time, but the result must be captured in `@State` to avoid re-evaluation on every redraw. Use `@State private var creative: AdCreative = AdCreatives.all.randomElement() ?? AdCreatives.all[0]` as a default value in the `@State` declaration. This is idiomatic SwiftUI for "pick once, display always."

```swift
// Pattern: self-contained ad view
struct BannerAdView: View {
    // Creative picked once at view creation — stable across redraws
    @State private var creative: AdCreative = AdCreative.allBannerCreatives.randomElement()!

    var body: some View {
        Link(destination: creative.destinationURL) {
            // layout here
        }
        .buttonStyle(.plain)
    }
}

struct AdCreative {
    let brandName: String
    let headline: String
    let subtitle: String
    let brandColor: Color
    let iconName: String     // SF Symbol name
    let destinationURL: URL
    let isBlossomPro: Bool

    static let allBannerCreatives: [AdCreative] = [
        // BMO ETFs variants
        AdCreative(
            brandName: "BMO ETFs",
            headline: "Build a diversified portfolio",
            subtitle: "Canada's #1 ETF provider",
            brandColor: Color(hex: "009A44"),   // BMO teal/green
            iconName: "building.columns.fill",
            destinationURL: URL(string: "https://www.bmo.com/etfs")!,
            isBlossomPro: false
        ),
        // ... additional creatives
    ]
}
```

### Pattern 2: Inserting a Banner into HubsDiscoveryView

**What:** The banner inserts into the existing `LazyVStack(spacing: 22)` directly above the "Featured Hub" section. The LazyVStack uses a series of `if` blocks and `ForEach` — the banner is a simple view placed in sequence before the Featured Hub `if let hero = heroCommunity` block.

**Confirmed from HubsDiscoveryView.swift (lines 142–155):**
```swift
// BEFORE the Featured Hub block — insert here:
BannerAdView()

// Featured Hub (already exists)
if let hero = heroCommunity {
    VStack(alignment: .leading, spacing: 8) {
        Text("Featured Hub") ...
        CommunityHeroCardView(community: hero) ...
    }
}
```

No enumeration complexity. The banner is a flat insertion at a fixed position in the VStack sequence.

### Pattern 3: Inserting an Inline Ad into ContentFeedView

**What:** ContentFeedView uses `ForEach(viewModel.filteredPosts)` in a `LazyVStack(spacing: 16)`. The inline card must appear at a seeded-random offset between index 3 and 5 (post 4, 5, or 6 in 0-based terms).

**CRITICAL CONSTRAINT:** ContentFeedView has no ScrollView — it participates in the outer CommunityHubView scroll context (documented in STATE.md decision log). Do not add a ScrollView.

**Approach:** Replace the `ForEach` with an `enumerated` version. Compute the insertion index once as `@State`:

```swift
// In ContentFeedView body — replace the LazyVStack ForEach:
@State private var adInsertionIndex: Int = Int.random(in: 3...5)

LazyVStack(spacing: 16) {
    ForEach(Array(viewModel.filteredPosts.enumerated()), id: \.element.id) { index, post in
        // Insert ad BEFORE this post when index matches
        if index == adInsertionIndex {
            InlineCardAdView()
        }
        PostCardView(...)
    }
}
```

`@State private var adInsertionIndex: Int = Int.random(in: 3...5)` is evaluated once at view initialization — deterministic per ContentFeedView lifetime (per visit), which is the "seeded-random but consistent" behavior the user wants.

**Guard for short feeds:** If `filteredPosts.count <= adInsertionIndex`, no ad renders. This is a natural guard — the `if index == adInsertionIndex` condition simply never fires.

### Pattern 4: Inserting Pill Ads into CategoryExploreView

**What:** CategoryExploreView has two separate ForEach loops — real communities and mock communities. Pill ads should appear at every 6th–8th card across both lists combined.

**Approach:** Merge real and mock community enumeration into a single indexed loop, inserting a `PillAdView` whenever `(index + 1) % cadence == 0` where cadence is a @State value set once to Int.random(in: 6...8):

```swift
// CategoryExploreView: combine real + mock, single indexed ForEach
@State private var adCadence: Int = Int.random(in: 6...8)

let allCommunities = realCommunities + mockCommunities

LazyVStack(spacing: 12) {
    ForEach(Array(allCommunities.enumerated()), id: \.element.id) { index, community in
        // Render card (real or mock)
        communityCardView(for: community, index: index)

        // Insert pill after every Nth card
        if (index + 1).isMultiple(of: adCadence) {
            PillAdView()
        }
    }
}
```

Note: This requires refactoring the existing two-ForEach structure into a single loop. The "More Communities" divider between real and mock can still render by checking if the current community is the last real community.

### Pattern 5: `Link()` for Ad Taps

**What:** Wrapping ad view content in `Link(destination:)` opens the URL in Safari. This is already used for YouTube deep links in `YouTubeLinkCard.swift`.

```swift
Link(destination: creative.destinationURL) {
    // ad layout
}
.buttonStyle(.plain)  // suppress default button highlight
```

Blossom PRO ads use `NavigationLink(value: HubsRoute.someUpgradeRoute)` OR a simple `Link` to `https://www.blossom.ca` — the internal upgrade prompt route may not exist yet. Use external URL for PRO ads unless an upgrade route exists in `HubsNavigation`.

### Pattern 6: Branded Gradient Border for Inline Cards

**What:** Inline card ads use `blossomCard()` as a base but add a visual differentiator. The chosen treatment (CONTEXT.md option C: distinct but not jarring) is a 2pt left-side accent stripe using the advertiser's brand color.

```swift
// Inline card ad visual treatment
HStack(spacing: 0) {
    // Left accent stripe
    Rectangle()
        .fill(creative.brandColor)
        .frame(width: 3)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 12, bottomLeadingRadius: 12,
                bottomTrailingRadius: 0, topTrailingRadius: 0
            )
        )

    // Card content
    VStack(alignment: .leading, spacing: ...) { ... }
        .padding(14)
}
.blossomCard()
```

Alternatively, a top-edge color stripe is simpler but a left stripe better communicates "this is different from the main card list."

### Pattern 7: "Sponsored" Label Treatment

All three formats show a label distinguishing ad from organic content:

| Format | Label | Position | Color |
|--------|-------|----------|-------|
| Banner | "Sponsored" | Top-right corner, small caption | `BlossomTheme.secondaryText` |
| Inline Card | "Sponsored" | Top of card, right-aligned | `BlossomTheme.secondaryText` |
| Pill | "Ad" (abbreviated) | Trailing label | `BlossomTheme.secondaryText` |
| Blossom PRO variant | "Upgrade" | Same position as Sponsored | `BlossomTheme.violet` |

### Anti-Patterns to Avoid

- **Do not introduce a Store or ViewModel for ads:** User explicitly rejected infrastructure. Ad components are fully self-contained.
- **Do not add `ScrollView` to `ContentFeedView`:** This view deliberately participates in the outer scroll context (STATE.md decision). Adding a ScrollView will break the scroll behavior.
- **Do not use `ForEach(0..<count)` with integer indices:** SwiftUI best practice (and project convention) is `ForEach(enumerated, id: \.element.id)` with Identifiable types.
- **Do not place ad picking logic in `body`:** `body` re-evaluates frequently. Creative selection lives in `@State` declaration default value (evaluated once at init) or in `.task {}` / `.onAppear {}`.
- **Do not use `foregroundColor()`:** Project uses `foregroundStyle()` throughout (confirmed in all existing views).

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| External URL navigation | Custom in-app browser | `Link(destination:)` | Safari handles auth, cookies, history — already proven in YouTubeLinkCard |
| Ad creative selection | Custom weighted random picker | `Array.randomElement()` | No weighting needed for demo; `.randomElement()` is sufficient |
| Dark/light brand color adaptation | Custom color resolution | `BlossomTheme` tokens + per-advertiser `Color(hex:)` | Theme already handles semantic tokens; ad brand colors can use `Color(hex:)` extension already in BlossomTheme.swift |

---

## Common Pitfalls

### Pitfall 1: Ad Insertion Breaking LazyVStack Diffing
**What goes wrong:** Inserting a non-Identifiable view into a `ForEach` loop can cause SwiftUI identity confusion, leading to animation glitches or incorrect view recycling.
**Why it happens:** `ForEach` tracks identity by the `id:` parameter. Ad views are not part of the posts array.
**How to avoid:** The ad insertion pattern uses a conditional `if index == adInsertionIndex { InlineCardAdView() }` inside the ForEach — the ad is rendered as a sibling, not injected into the ForEach identity pool. This is safe because the ad's identity is tracked by its position in the VStack, not by a ForEach ID.
**Warning signs:** Posts jumping positions or animations triggering unexpectedly after ad insertion.

### Pitfall 2: `@State` Default Value Evaluated More Than Once
**What goes wrong:** If `@State private var creative = AdCreative.allCreatives.randomElement()!` somehow re-evaluates (e.g. if the parent view is destroyed and recreated), the creative changes mid-session.
**Why it happens:** SwiftUI destroys and recreates views when they leave the view hierarchy.
**How to avoid:** This is acceptable for demo purposes — the creative changing on re-navigation is fine. If stability across navigation is needed, hoist the creative pick to the parent view. For this phase, do NOT hoist — keep it local.
**Warning signs:** Only relevant if user reports "ad changes every time I come back."

### Pitfall 3: CategoryExploreView Refactor Breaking Divider
**What goes wrong:** Merging the two ForEach loops into one combined array requires reproducing the "More Communities" divider that appears between real and mock communities.
**Why it happens:** The divider currently depends on both arrays being non-empty and renders between them. In a merged loop, the divider position must be recomputed.
**How to avoid:** Track `realCommunities.count` separately. When `index == realCommunities.count - 1` and `!mockCommunities.isEmpty`, append the divider after the last real community card before the mock loop continues.
**Warning signs:** Divider missing or appearing in wrong position.

### Pitfall 4: UnevenRoundedRectangle Availability
**What goes wrong:** `UnevenRoundedRectangle` was added in iOS 17. The project targets iOS 26, so this is available.
**Why it happens:** Sometimes mistaken for iOS 16-only availability.
**How to avoid:** Use freely — iOS 26 target means iOS 17+ shapes are unconditionally available.

### Pitfall 5: `Link` Inside `NavigationStack` Context
**What goes wrong:** `Link(destination:)` opens Safari for external URLs — correct behavior. However, if the link URL is a custom scheme or deep link, it would navigate in-app instead.
**Why it happens:** URL scheme routing.
**How to avoid:** All advertiser URLs are `https://` external URLs. Blossom PRO ad links should also use `https://www.blossom.ca` unless an internal HubsRoute exists for upgrade. Confirm before using `NavigationLink` for PRO ads.

---

## Code Examples

### Ad Creative Model

```swift
// Features/Hubs/Ads/AdCreative.swift
import SwiftUI

struct AdCreative {
    let brandName: String
    let headline: String
    let subtitle: String
    let brandColor: Color
    let iconName: String          // SF Symbol
    let destinationURL: URL
    let isBlossomPro: Bool        // true → violet accent, "Upgrade" label

    var sponsoredLabel: String {
        isBlossomPro ? "Upgrade" : "Sponsored"
    }

    var accentColor: Color {
        isBlossomPro ? BlossomTheme.violet : brandColor
    }
}
```

### BannerAdView Skeleton

```swift
// Features/Hubs/Ads/BannerAdView.swift
import SwiftUI

struct BannerAdView: View {
    @State private var creative: AdCreative = AdCreative.bannerCreatives.randomElement()!

    var body: some View {
        Link(destination: creative.destinationURL) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(creative.accentColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: creative.iconName)
                        .font(.system(size: 20))
                        .foregroundStyle(creative.accentColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(creative.headline)
                        .font(BlossomFont.subhead)
                        .fontWeight(.semibold)
                        .foregroundStyle(BlossomTheme.primaryText)
                    Text(creative.subtitle)
                        .font(BlossomFont.caption)
                        .foregroundStyle(BlossomTheme.secondaryText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(BlossomTheme.secondaryText)
            }
            .padding(14)
            .blossomCard()
            .overlay(alignment: .topTrailing) {
                Text(creative.sponsoredLabel)
                    .font(.system(size: 10))
                    .foregroundStyle(BlossomTheme.secondaryText)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(BlossomTheme.cardSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(6)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(creative.accentColor.opacity(0.4), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}
```

### Content Feed Insertion

```swift
// In ContentFeedView.swift — replace the LazyVStack ForEach
@State private var adInsertionIndex: Int = Int.random(in: 3...5)

LazyVStack(spacing: 16) {
    ForEach(Array(viewModel.filteredPosts.enumerated()), id: \.element.id) { index, post in
        if index == adInsertionIndex {
            InlineCardAdView()
        }

        let isLocked = !viewModel.canAccess(post: post, userTierIndex: userTierIndex)
        let requiredTierName = viewModel.tierName(for: post.requiredTierIndex)
        PostCardView(
            community: community,
            post: post,
            isLocked: isLocked,
            requiredTierName: requiredTierName,
            onUpgrade: { showTierSheet = true }
        )
    }
}
```

### Pill Ad Cadence (CategoryExploreView)

```swift
@State private var adCadence: Int = Int.random(in: 6...8)

// Combined array — real first, then mock
let allCommunities: [Community] = realCommunities + mockCommunities
let dividerIndex = realCommunities.isEmpty ? -1 : realCommunities.count - 1

LazyVStack(spacing: 12) {
    ForEach(Array(allCommunities.enumerated()), id: \.element.id) { index, community in
        // Render card (real or mock styling based on index < realCommunities.count)
        if index < realCommunities.count {
            CommunityCardView(community: community)
        } else {
            mockCommunityCard(community)
        }

        // Divider between real and mock
        if index == dividerIndex && !mockCommunities.isEmpty {
            // existing divider HStack
        }

        // Pill ad at cadence
        if adCadence > 0 && (index + 1).isMultiple(of: adCadence) {
            PillAdView()
        }
    }
}
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `foregroundColor()` | `foregroundStyle()` | iOS 17 | All existing project code uses `foregroundStyle()` — ad views must match |
| `UIApplication.shared.openURL()` | `Link(destination:)` | iOS 14 | SwiftUI-native, no UIKit needed for URL opening |
| `animation(_:)` without value | `.animation(.easeOut, value: x)` | iOS 15 | Project uses value-based animations throughout |

**Not applicable to this phase:**
- No networking (all mock)
- No persistence (all in-memory @State)
- No new SwiftUI APIs needed beyond what the project already uses

---

## Open Questions

1. **Does a Blossom PRO upgrade route exist in HubsNavigation?**
   - What we know: HubsNavigation.swift exists, routes include `communityDetail`, `communityPreview`, `creatorDashboard`, `categoryExplore`. No "upgrade" or "pro" route is visible.
   - What's unclear: Whether the planner should create a new HubsRoute case for PRO upgrade, or use `https://www.blossom.ca` as the PRO ad destination.
   - Recommendation: Use `https://www.blossom.ca` as PRO ad URL — avoids creating navigation infrastructure for a destination that doesn't exist.

2. **ContentFeedView: community-owned vs. Blossom-owned feed**
   - What we know: ContentFeedView is used inside CommunityHubView (community-owned surface) — ads are NOT supposed to appear there per CONTEXT.md.
   - What's unclear: The CONTEXT.md placement table says "Content feed (ContentFeedView)" gets inline ads. But ContentFeedView is inside a community hub. Re-reading CONTEXT.md: it says ads go on "Blossom-owned browsing surfaces." ContentFeedView inside a community is a community surface.
   - Recommendation: Clarify whether ContentFeedView receives ads when viewed from inside a community hub, or whether "Content feed" in CONTEXT.md refers to a different/future surface. Given the explicit "no ads in community-internal surfaces" rule, skip ContentFeedView inline ads and only deliver the banner on HubsDiscoveryView and pills on CategoryExploreView. **Treat this as a clarification needed before planning the inline card task.**
   - Alternative reading: "Content feed" may refer to a home/discovery feed, not ContentFeedView. Ask the user to confirm before including InlineCardAdView integration.

3. **Haptic feedback on ad tap**
   - What we know: Claude's discretion per CONTEXT.md.
   - Recommendation: Skip haptics for this phase. Ad taps open Safari — the system provides its own feedback. Adding UIImpactFeedbackGenerator would require UIKit import for marginal benefit.

---

## Validation Architecture

`workflow.nyquist_validation` is `true` in config.json — this section is required.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None detected — iOS prototype, no XCTest suites found in project |
| Config file | None |
| Quick run command | Build in Xcode simulator: `xcodebuild -project BlossomHubs/BlossomHubs.xcodeproj -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build 2>&1 | tail -5` |
| Full suite command | Same as quick — no automated test suite exists |

### Phase Requirements → Test Map

This phase has no formal requirement IDs (new phase added post-milestone). Validation is behavioral/visual.

| Behavior | Test Type | Verification Method |
|----------|-----------|-------------------|
| BannerAdView renders above Featured Hub | Visual | Simulator inspection of HubsDiscoveryView |
| BannerAdView picks a creative on launch | Visual | Confirm non-empty ad content renders |
| Tapping banner opens Safari | Manual | Tap in simulator — confirm Safari launches |
| InlineCardAdView renders between posts (if scoped in) | Visual | Simulator inspection of ContentFeedView |
| PillAdView renders at cadence in CategoryExploreView | Visual | Simulator — scroll category list, confirm pills appear |
| Blossom PRO ad shows violet accent and "Upgrade" label | Visual | Simulator inspection |
| Third-party ads show "Sponsored" label | Visual | Simulator inspection |
| No ads appear in community hub, forums, FAQ, preview | Visual | Navigate to each surface, confirm no ad views render |
| Dark mode renders correctly | Visual | Toggle dark mode in simulator |

### Sampling Rate
- **Per task commit:** Build succeeds, no compiler errors or warnings
- **Per wave merge:** Full simulator smoke test across all three surfaces
- **Phase gate:** All visual behaviors confirmed before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] No test infrastructure exists — all validation is manual simulator inspection
- [ ] No XCTest target in project — appropriate for prototype; do not create one in this phase

---

## Sources

### Primary (HIGH confidence)
- HubsDiscoveryView.swift — confirmed LazyVStack structure and insertion point for banner
- ContentFeedView.swift — confirmed ForEach pattern, confirmed no ScrollView (participates in outer scroll)
- CategoryExploreView.swift — confirmed two-ForEach structure and existing divider pattern
- BlossomCard.swift — confirmed `blossomCard()` modifier API
- BlossomTheme.swift — confirmed color token names (`violet`, `teal`, `cardSurface`, `cardBorder`, `primaryText`, `secondaryText`, `background`)
- BlossomFont.swift — confirmed type token names (`subhead`, `caption`, `body`, `headline`)
- STATE.md — confirmed per-phase decisions including ContentFeedView no-ScrollView constraint (Phase 06-02)
- 10-CONTEXT.md — all locked decisions

### Secondary (MEDIUM confidence)
- SwiftUI `Link(destination:)` — confirmed used in YouTubeLinkCard.swift (same project)
- `UnevenRoundedRectangle` — iOS 17+ API, project targets iOS 26, confirmed available

### Tertiary (LOW confidence)
- BMO brand color (#009A44 green/teal) — approximated from brand knowledge, should be verified against BMO's design assets if exact accuracy matters
- Wealthsimple brand color (near-black) — approximated; Wealthsimple uses black/dark charcoal primary

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — no new dependencies, all patterns confirmed from existing code
- Architecture: HIGH — insertion patterns confirmed from reading actual view files
- Pitfalls: HIGH — derived from existing STATE.md decisions and confirmed code review
- Open questions: 1 significant (ContentFeedView scope ambiguity), 2 minor

**Research date:** 2026-03-17
**Valid until:** 2026-04-17 (stable SwiftUI APIs — no churn expected)
