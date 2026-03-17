# Phase 10: Ad Placement System - Context

**Gathered:** 2026-03-17
**Status:** Ready for planning

<domain>
## Phase Boundary

Banner ads and display ad slots across Blossom-owned browsing surfaces — discovery feed, content feed, and category explore — with mock ad data and configurable placement logic. This is a **visual demonstration** of where ads can live, not a functional ad service. No AdStore, no placement engine, no rotation logic. Ads stay out of community-internal surfaces (hub landing, forums, FAQ, preview pages).

</domain>

<decisions>
## Implementation Decisions

### Ad format types
- **Three formats:** Banner, Inline Card, Pill
- **Banner:** Full-width, prominent, high-visibility — sits at the top of visual hierarchy in a tactical position (not literal first pixel, but first prominent break before main content)
- **Inline Card:** Feed-integrated, content-like — uses `blossomCard()` styling but with a branded gradient border or accent stripe to distinguish from organic content (option C: distinct but not jarring)
- **Pill:** Compact, lightweight, single-line or two-line unit — only appears in category explore deep-browse lists, not on main surfaces

### Placement strategy
- **Discovery feed (HubsDiscoveryView):** 1 banner, positioned right above the featured hub (anchored to featured hub, not to "My Hubs" section — consistent position regardless of subscription state)
- **Content feed (ContentFeedView):** Inline card ads between posts, appearing at a seeded-random offset between post 3 and 6 — deterministic per visit but feels organic
- **Category explore (CategoryExploreView):** Pill ads between community cards, consistent cadence every 6th-8th card throughout the entire list
- **No ads on:** Community hub landing, forums, FAQ, community preview, search, My Subscriptions, Creator Dashboard
- Philosophy: ads on **Blossom-owned browsing surfaces**, not inside individual communities

### Visual treatment
- All three formats show a "Sponsored" / "Ad" label
- **Blossom PRO** ads get slightly different treatment: violet accent instead of generic ad border, labeled "Upgrade" instead of "Sponsored"
- External advertiser ads use brand-accurate colors with SF Symbol placeholder icons (designed for asset swap later — user will provide exact graphics after seeing size specs)

### Mock ad data
- **5 advertisers**, all Canadian finance-relevant:
  - BMO ETFs (teal brand color, `building.columns.fill`)
  - Wealthsimple (black brand color, `chart.line.uptrend.xyaxis`)
  - Questrade (green brand color, `dollarsign.arrow.circlepath`)
  - EQ Bank (blue brand color, `banknote.fill`)
  - Blossom PRO (violet brand color, Blossom logo icon — house promo)
- **2-3 creative variants per advertiser** (~10-15 total ad creatives)
- Ad data hardcoded directly in ad view components — no AdStore or service layer
- Simple `.randomElement()` pick from hardcoded array for visual variety in demo

### Interaction
- All ads are **tappable** via SwiftUI `Link()` — opens advertiser's real website in Safari (not in-app browser)
- Blossom PRO ads can link to an internal upgrade prompt or external Blossom website

### Architecture approach
- **No AdStore, no ad service, no placement engine** — user explicitly requested not to waste time building infrastructure
- Ad views are self-contained components with hardcoded data
- Three view components: `BannerAdView`, `InlineCardAdView`, `PillAdView`
- Each surface that shows ads just embeds the relevant ad view component directly

### Claude's Discretion
- Exact SF Symbol choices per advertiser (approximating brand identity)
- Exact ad copy (headlines, subtitles) for the 2-3 variants per brand
- Inline card accent stripe/gradient border design details
- Pill sizing and label placement
- Exact random offset algorithm for content feed placement
- Haptic feedback on ad tap (if any)

</decisions>

<specifics>
## Specific Ideas

- Reference: live Blossom app has a teal BMO ETFs banner ad sitting between nav tabs and content — full-width, prominent but not intrusive
- Reference: live Blossom app has an inline referral/promo card that blends between posts in the feed — card-styled, promotional CTA
- User wants to provide real brand graphics later — build with SF Symbols now but spec exact dimensions per format so assets can be swapped in via asset catalog
- Blossom PRO is a "house ad" — slightly different visual treatment (violet accent, "Upgrade" label) to distinguish from third-party ads
- Ads should be frequent enough to demonstrate profit potential but not swamp the platform

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `blossomCard()` modifier: Standard card styling used across all surfaces — inline card ads should use this as base with accent modification
- `BlossomTheme.violet`: Blossom PRO ad accent color
- `BlossomFont` tokens: All ad text should use these for brand consistency
- `blossom-logo-icon` asset: Available for Blossom PRO ad branding

### Established Patterns
- `LazyVStack(spacing: 22)` in HubsDiscoveryView — banner ad inserts into this flow
- `LazyVStack(spacing: 16)` in ContentFeedView — inline card ads insert between post cards
- `LazyVStack(spacing: 12)` in CategoryExploreView — pill ads insert between community cards
- All views use 16pt horizontal padding consistently
- `Link()` + `URL` for external navigation already used in YouTube card deep links

### Integration Points
- **HubsDiscoveryView.swift** — Insert `BannerAdView` above featured hub section
- **ContentFeedView.swift** — Insert `InlineCardAdView` at random offset in post list enumeration
- **CategoryExploreView.swift** — Insert `PillAdView` at cadence interval in community card list

</code_context>

<deferred>
## Deferred Ideas

- Ads inside community hubs (forums, content feed within a community) — user wants to keep communities ad-free for now, can add later
- Ad configuration/management for creators or Blossom admins — no admin tooling in this phase
- Ad impression tracking or analytics — out of scope for visual demo
- Ad frequency capping or user targeting — out of scope
- Interstitial or full-screen ad formats — not discussed, not needed

</deferred>

---

*Phase: 10-ad-placement-system*
*Context gathered: 2026-03-17*
