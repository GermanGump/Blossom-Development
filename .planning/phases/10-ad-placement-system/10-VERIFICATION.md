---
phase: 10-ad-placement-system
verified: 2026-03-17T12:00:00Z
status: human_needed
score: 9/9 automated must-haves verified
re_verification: false
human_verification:
  - test: "Banner ad renders above Featured Hub on discovery screen"
    expected: "BannerAdView appears above the Featured Hub section with advertiser branding, Sponsored or Upgrade label visible, correct accent border color"
    why_human: "Visual rendering and layout position cannot be confirmed without running the Simulator"
  - test: "Inline card ad appears between posts 3-6 in ContentFeedView"
    expected: "InlineCardAdView renders between post cards at the random offset (3-5), left accent stripe visually distinguishes it from organic PostCardView cards"
    why_human: "Visual differentiation from organic cards and correct slot insertion require Simulator observation"
  - test: "Pill ads appear at cadence intervals in CategoryExploreView"
    expected: "PillAdView renders after community cards at every adCadence-th card (6-8 interval), across both real and mock community loops"
    why_human: "Cadence insertion across two ForEach loops requires live data to verify the totalIndex math fires correctly"
  - test: "Tapping any ad opens Safari with the advertiser URL"
    expected: "Link(destination:) opens Safari with the correct URL for each advertiser — confirmed tappable, not just rendered"
    why_human: "Link tap-out to Safari requires Simulator interaction"
  - test: "Dark mode renders correctly for all three ad formats"
    expected: "All three ad formats display correct colors in dark mode using BlossomTheme semantic tokens — no hardcoded colors that break in dark"
    why_human: "Dark mode rendering requires visual inspection in Simulator"
  - test: "Blossom PRO ad shows violet accent and Upgrade label"
    expected: "When Blossom PRO creative is selected by randomElement(), label reads Upgrade (not Sponsored), accent color is BlossomTheme.violet"
    why_human: "Since creative selection is random at view init, human must reload until PRO creative appears, or verify both label paths"
  - test: "No ads on community-internal surfaces"
    expected: "Navigating to community hub landing, forums, FAQ, community preview, search, My Subscriptions, Creator Dashboard shows zero ad views"
    why_human: "Navigating through each surface in Simulator is required to confirm absence of accidental ad injection"
---

# Phase 10: Ad Placement System Verification Report

**Phase Goal:** Banner, inline card, and pill ad formats render on Blossom-owned browsing surfaces (discovery feed, content feed, category explore) with 5 Canadian finance mock advertisers and Blossom PRO house ads — demonstrating where ads live in the product without building ad infrastructure
**Verified:** 2026-03-17T12:00:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | BannerAdView renders full-width card with icon, headline, subtitle, Sponsored label, accent border | VERIFIED | `BannerAdView.swift` lines 9-62: ZStack with HStack (44pt icon circle, VStack headline/subtitle, chevron), `ZStack(alignment: .topTrailing)` Sponsored label overlay, `RoundedRectangle.stroke(accentColor.opacity(0.4), lineWidth: 1.5)` accent border |
| 2 | InlineCardAdView renders feed-integrated card with left accent stripe | VERIFIED | `InlineCardAdView.swift` lines 14-24: `UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 12, ...)` 3pt stripe filled with `creative.accentColor` — asymmetric leading-only radius distinguishes from `blossomCard()` cards |
| 3 | PillAdView renders compact pill with Ad label | VERIFIED | `PillAdView.swift` lines 12-46: single HStack with 20pt icon circle, headline, trailing `adLabel` ("Ad" or "Upgrade"), 8pt corner radius, no `blossomCard()` shadow |
| 4 | Blossom PRO ads show violet accent and Upgrade label instead of Sponsored | VERIFIED | `AdCreative.swift` lines 13-19: `sponsoredLabel` returns "Upgrade" when `isBlossomPro`, `accentColor` returns `BlossomTheme.violet`; `PillAdView.swift` line 8 `adLabel` returns "Upgrade" for PRO |
| 5 | All three formats wrap content in Link(destination:) for Safari tap-out | VERIFIED | `BannerAdView.swift` line 8, `InlineCardAdView.swift` line 12, `PillAdView.swift` line 12: all `Link(destination: creative.destinationURL) { ... }.buttonStyle(.plain)` |
| 6 | Banner ad appears above Featured Hub in HubsDiscoveryView regardless of subscription state | VERIFIED | `HubsDiscoveryView.swift` line 142: `BannerAdView()` inserted as flat `LazyVStack` item, no conditional — immediately before `if let hero = heroCommunity` block at line 145 |
| 7 | Inline card ad appears between posts at seeded-random offset 3-5 in ContentFeedView | VERIFIED | `ContentFeedView.swift` line 11: `@State private var adInsertionIndex: Int = Int.random(in: 3...5)`; line 44: `ForEach(Array(viewModel.filteredPosts.enumerated()), id: \.element.id)`; lines 45-47: `if index == adInsertionIndex { InlineCardAdView() }` |
| 8 | Pill ads appear at cadence intervals in CategoryExploreView, spanning real and mock loops | VERIFIED | `CategoryExploreView.swift` line 8: `@State private var adCadence: Int = Int.random(in: 6...8)`; line 25: `let totalIndex = index`; line 33: `if (totalIndex + 1).isMultiple(of: adCadence) { PillAdView() }`; line 55: `let totalIndex = realCommunities.count + index`; line 64: same cadence check — unified across both ForEach loops |
| 9 | Ads absent from restricted surfaces (forums, FAQ, preview, search, subscriptions, creator dashboard) | VERIFIED | `grep` across `Forums/`, `FAQ/`, `Preview/`, `Search/`, `Subscription/`, `Payment/`, `Creator/`, `Community/` returned zero matches for `BannerAdView`, `InlineCardAdView`, `PillAdView` |

**Score:** 9/9 truths verified by static analysis

---

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `BlossomHubs/Features/Hubs/Ads/AdCreative.swift` | Shared data model with 5 advertisers and 15 creative variants | VERIFIED | 171 lines; `struct AdCreative` with all required properties; `bannerCreatives`, `inlineCreatives`, `pillCreatives` each contain 5 entries (15 total confirmed by grep); `sponsoredLabel` and `accentColor` computed properties present |
| `BlossomHubs/Features/Hubs/Ads/BannerAdView.swift` | Full-width banner ad component | VERIFIED | 73 lines; `struct BannerAdView: View` with `@State private var creative = AdCreative.bannerCreatives.randomElement()!`; `Link`, `ZStack`, `#Preview` present |
| `BlossomHubs/Features/Hubs/Ads/InlineCardAdView.swift` | Feed-integrated inline card component | VERIFIED | 86 lines; `struct InlineCardAdView: View` with `@State private var creative = AdCreative.inlineCreatives.randomElement()!`; `UnevenRoundedRectangle` stripe, CTA label, `#Preview` present |
| `BlossomHubs/Features/Hubs/Ads/PillAdView.swift` | Compact pill ad component | VERIFIED | 58 lines; `struct PillAdView: View` with `@State private var creative = AdCreative.pillCreatives.randomElement()!`; lightweight 8pt styling, `#Preview` present |
| `BlossomHubs/Features/Hubs/Discovery/HubsDiscoveryView.swift` | Banner ad integration above Featured Hub | VERIFIED | `BannerAdView()` at line 142 as flat LazyVStack item, unconditional, before `if let hero = heroCommunity` |
| `BlossomHubs/Features/Hubs/Feed/ContentFeedView.swift` | Inline card ad between posts | VERIFIED | `adInsertionIndex` @State at line 11; enumerated ForEach at line 44; `InlineCardAdView()` at line 46; no ScrollView added |
| `BlossomHubs/Features/Hubs/Discovery/CategoryExploreView.swift` | Pill ad at cadence interval | VERIFIED | `adCadence` @State at line 8; `PillAdView()` at lines 34 and 65; totalIndex bridging across both loops; More Communities divider preserved at line 43 |
| `BlossomHubs/Features/Hubs/Community/CommunitySectionPager.swift` | Pager minHeight at 2x to prevent content clipping | VERIFIED | Line 30: `UIScreen.main.bounds.height * 2` — prevents inline ad height from clipping posts in paged TabView |

---

### Key Link Verification

**Plan 01 — Component to Data Model links:**

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `BannerAdView.swift` | `AdCreative.swift` | `AdCreative.bannerCreatives.randomElement()!` | WIRED | Line 5: `@State private var creative = AdCreative.bannerCreatives.randomElement()!` |
| `InlineCardAdView.swift` | `AdCreative.swift` | `AdCreative.inlineCreatives.randomElement()!` | WIRED | Line 5: `@State private var creative = AdCreative.inlineCreatives.randomElement()!` |
| `PillAdView.swift` | `AdCreative.swift` | `AdCreative.pillCreatives.randomElement()!` | WIRED | Line 5: `@State private var creative = AdCreative.pillCreatives.randomElement()!` |

**Plan 02 — Host View to Ad Component links:**

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `HubsDiscoveryView.swift` | `BannerAdView.swift` | `BannerAdView()` in LazyVStack | WIRED | Line 142: `BannerAdView()` flat insertion, unconditional |
| `ContentFeedView.swift` | `InlineCardAdView.swift` | `InlineCardAdView()` at adInsertionIndex | WIRED | Line 46: `InlineCardAdView()` inside `if index == adInsertionIndex` guard |
| `CategoryExploreView.swift` | `PillAdView.swift` | `PillAdView()` at cadence interval | WIRED | Lines 34 and 65: `PillAdView()` in both real and mock ForEach loops |

---

### Requirements Coverage

The five requirement IDs declared in the plan frontmatter (AD-COMP, AD-DATA, AD-VISUAL, AD-PLACE, AD-INTERACT) are **phase-internal identifiers** — they do not appear in `.planning/REQUIREMENTS.md`. This is expected and intentional: REQUIREMENTS.md covers the v1 community platform requirements (FOUND, DISC, SUBS, HUB, ENGR, CRTR) that were the original product scope. Phase 10 is an additive demo layer (ad placement for investor pitch purposes) added after the v1 requirement set was locked, and REQUIREMENTS.md was not updated to include AD-* requirements.

No orphaned v1 requirements are mapped to Phase 10 in REQUIREMENTS.md — the traceability table maps Phase 10 to no v1 requirements, which is consistent with the phase being demo-layer infrastructure rather than a v1 product requirement.

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| AD-COMP | 10-01-PLAN | Ad view components (BannerAdView, InlineCardAdView, PillAdView) | SATISFIED | All three structs exist with substantive implementations |
| AD-DATA | 10-01-PLAN | AdCreative data model with 5 advertisers and 15 creative variants | SATISFIED | AdCreative.swift: 5 advertisers x 3 arrays = 15 creatives confirmed by grep |
| AD-VISUAL | 10-01-PLAN | Visual design: brand accent, Sponsored/Upgrade label, format-specific styling | SATISFIED | All three views use BlossomFont/BlossomTheme tokens, foregroundStyle(), #Preview blocks; PRO violet path verified |
| AD-PLACE | 10-02-PLAN | Ad placement in HubsDiscoveryView, ContentFeedView, CategoryExploreView | SATISFIED | All three host views modified with correct insertion logic |
| AD-INTERACT | 10-02-PLAN | Link(destination:) for Safari tap-out on all ad views | SATISFIED | Link wrapping confirmed in BannerAdView line 8, InlineCardAdView line 12, PillAdView line 12 |

---

### Anti-Patterns Found

No anti-patterns detected across any of the six phase 10 files (AdCreative.swift, BannerAdView.swift, InlineCardAdView.swift, PillAdView.swift, HubsDiscoveryView.swift, ContentFeedView.swift, CategoryExploreView.swift, CommunitySectionPager.swift):

- Zero TODO/FIXME/HACK/PLACEHOLDER comments
- No `return null`, `return []`, or empty closures
- No `foregroundColor()` (deprecated API) — all views use `foregroundStyle()`
- No AdStore or service layer created (per plan constraint)
- No ScrollView added to ContentFeedView (outer scroll preserved)

---

### Human Verification Required

All 9 automated must-haves pass static analysis. The following require Simulator verification before the phase is considered fully complete:

#### 1. Banner Ad Visual Rendering

**Test:** Build and run in Simulator. Open the Hubs tab. Scroll down past the header and My Hubs section.
**Expected:** A full-width card with a circular brand icon, headline, subtitle, Sponsored or Upgrade label at top-trailing corner, and a colored accent border appears immediately above the "Featured Hub" label and card.
**Why human:** Layout position and visual rendering cannot be confirmed programmatically.

#### 2. Inline Card Ad Visual Differentiation

**Test:** Subscribe to a community, navigate to its Posts tab, scroll through the post list.
**Expected:** At post index 3-5, an InlineCardAdView appears with a visible 3pt left accent stripe in the brand color. The stripe must visually distinguish the ad from organic PostCardView cards which have uniform left edges.
**Why human:** The visual distinction between organic cards and the ad card requires human judgment.

#### 3. Pill Ad Cadence in CategoryExploreView

**Test:** From discovery, tap "Explore more" on any category. Scroll through the full community list.
**Expected:** A compact pill ad (icon + headline + "Ad" label) appears after every 6th-8th community card, including across the "More Communities" divider between real and mock communities.
**Why human:** Requires live data and scrolling to verify cadence fires correctly across both ForEach loops.

#### 4. Safari Tap-Out on All Ad Formats

**Test:** Tap the banner ad, tap the inline card ad, tap a pill ad.
**Expected:** Each tap opens Safari with the advertiser's URL (e.g., https://www.bmo.com/etfs for BMO ETFs, https://www.blossom.ca for Blossom PRO).
**Why human:** Link tap behavior requires Simulator interaction.

#### 5. Dark Mode Rendering

**Test:** Toggle dark mode in Simulator (Settings > Developer > Dark Mode or via Control Center). Navigate through all three ad surfaces.
**Expected:** All three ad formats render correctly — card surfaces, text, and borders use semantic theme tokens that adapt to dark mode. No hardcoded white backgrounds or black text visible against dark surfaces.
**Why human:** Color adaptation requires visual inspection in dark mode.

#### 6. Blossom PRO Variant Labels

**Test:** Reload each ad surface several times until a Blossom PRO creative appears (it is 1-of-5 in each array, selected randomly at view init).
**Expected:** The PRO creative shows "Upgrade" label (not "Sponsored"), violet (#7C3AED) accent color on the icon, border, and CTA, and crown.fill SF Symbol.
**Why human:** Random creative selection requires multiple reloads to observe the PRO path.

#### 7. No Ads on Restricted Surfaces

**Test:** Navigate to: community hub landing page, Forums section, FAQ section, community preview/tiers sheet, search screen, My Subscriptions screen, Creator Dashboard.
**Expected:** Zero ad views appear on any of these surfaces.
**Why human:** Static grep confirmed zero usage, but navigating each surface in Simulator provides complete confidence.

---

### Commits Verified

All commits referenced in SUMMARY.md confirmed in git log:

| Commit | Description | Plan |
|--------|-------------|------|
| `abfb3d9` | feat(10-01): AdCreative model with 5 advertisers and 15 creative variants | 10-01 |
| `5489f82` | feat(10-01): BannerAdView, InlineCardAdView, PillAdView ad components | 10-01 |
| `9fc8dcb` | feat(10-02): integrate ad views into host browsing surfaces | 10-02 |
| `a99d481` | fix(10): increase pager minHeight to 2x screen to prevent content clipping | 10-02 auto-fix |

---

### Gaps Summary

No automated gaps found. All 9 observable truths pass static analysis. The phase is blocked on human visual verification before final sign-off, as required by the `checkpoint:human-verify` gate in Plan 02.

The one noteworthy finding: AD-COMP, AD-DATA, AD-VISUAL, AD-PLACE, and AD-INTERACT are not registered in REQUIREMENTS.md. This is not a defect — Phase 10 is an additive demo layer added after the v1 requirement set was locked. However, if these requirements are to be tracked formally, REQUIREMENTS.md should be updated to include them with a Phase 10 mapping.

---

_Verified: 2026-03-17T12:00:00Z_
_Verifier: Claude (gsd-verifier)_
