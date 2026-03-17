---
phase: 10-ad-placement-system
plan: 01
subsystem: ui
tags: [swiftui, ads, link, blossomcard, canadian-finance]

# Dependency graph
requires:
  - phase: 02-brand-system-and-design-tokens
    provides: BlossomTheme color tokens, BlossomFont typography tokens, blossomCard() modifier
  - phase: 06-content-feed
    provides: Link() + URL Safari tap-out pattern from YouTubeLinkCard

provides:
  - AdCreative data model with 5 advertisers and 15 total creative variants across three static arrays
  - BannerAdView — full-width card ad component for HubsDiscoveryView
  - InlineCardAdView — feed-integrated inline card ad component with left accent stripe for ContentFeedView
  - PillAdView — compact pill ad component for CategoryExploreView
  - Ads group registered in Xcode project.pbxproj

affects: [10-02-ad-integration, discovery, content-feed, category-explore]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "@State private var creative = AdCreative.xxxCreatives.randomElement()! — each ad view picks one creative at init, no external state needed"
    - "UnevenRoundedRectangle for InlineCardAdView left accent stripe — asymmetric corner radius only on leading side"
    - "ZStack(alignment: .topTrailing) for Sponsored label overlay on BannerAdView — avoids layout interference with main content"

key-files:
  created:
    - BlossomHubs/Features/Hubs/Ads/AdCreative.swift
    - BlossomHubs/Features/Hubs/Ads/BannerAdView.swift
    - BlossomHubs/Features/Hubs/Ads/InlineCardAdView.swift
    - BlossomHubs/Features/Hubs/Ads/PillAdView.swift
  modified:
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj

key-decisions:
  - "AdCreative is a plain struct with hardcoded static arrays — no AdStore, no service layer, per user decision"
  - "BannerAdView uses ZStack(alignment: .topTrailing) for Sponsored label so it floats over the card without disturbing HStack layout"
  - "InlineCardAdView uses UnevenRoundedRectangle for left accent stripe with 12pt leading radius matching blossomCard() corner radius"
  - "PillAdView uses its own lighter styling (8pt corner radius, no shadow) rather than blossomCard() — pill format is lighter weight than full cards"

patterns-established:
  - "Ad view pattern: @State private var creative = AdCreative.xxxCreatives.randomElement()! picks one creative at struct creation"
  - "All ad views wrap in Link(destination: creative.destinationURL).buttonStyle(.plain) for Safari tap-out"
  - "Sponsored/Upgrade label distinction: creative.sponsoredLabel and creative.isBlossomPro drive both label text and accent color"

requirements-completed: [AD-COMP, AD-DATA, AD-VISUAL]

# Metrics
duration: 8min
completed: 2026-03-17
---

# Phase 10 Plan 01: Ad Components Summary

**Three self-contained SwiftUI ad view components (BannerAdView, InlineCardAdView, PillAdView) backed by hardcoded AdCreative model with 5 Canadian finance advertisers and 15 creative variants**

## Performance

- **Duration:** ~8 min
- **Started:** 2026-03-17T07:23:00Z
- **Completed:** 2026-03-17T07:31:00Z
- **Tasks:** 2
- **Files modified:** 5 (4 created, 1 modified)

## Accomplishments

- AdCreative struct with 5 advertisers (BMO ETFs, Wealthsimple, Questrade, EQ Bank, Blossom PRO), 15 total creatives across bannerCreatives, inlineCreatives, pillCreatives static arrays
- BannerAdView: full-width card with circular brand icon (44x44), headline/subtitle, chevron, 1.5pt accent border, Sponsored/Upgrade overlay label
- InlineCardAdView: feed-integrated card with 3pt left accent stripe (UnevenRoundedRectangle), brand row, headline, subtitle, Learn More/Upgrade Now CTA
- PillAdView: compact 20pt icon circle, single-line headline, Ad/Upgrade trailing label — lighter styling than full cards
- All views: Link(destination:) for Safari tap-out, foregroundStyle() throughout, BlossomFont/BlossomTheme tokens, #Preview blocks, project builds clean

## Task Commits

1. **Task 1: AdCreative model with 5 advertisers and creative variants** - `abfb3d9` (feat)
2. **Task 2: BannerAdView, InlineCardAdView, PillAdView components** - `5489f82` (feat)

## Files Created/Modified

- `BlossomHubs/Features/Hubs/Ads/AdCreative.swift` - Shared data model, 5 advertisers, 15 creatives across 3 static arrays, sponsoredLabel and accentColor computed properties
- `BlossomHubs/Features/Hubs/Ads/BannerAdView.swift` - Full-width banner card for HubsDiscoveryView
- `BlossomHubs/Features/Hubs/Ads/InlineCardAdView.swift` - Feed-integrated card with left accent stripe for ContentFeedView
- `BlossomHubs/Features/Hubs/Ads/PillAdView.swift` - Compact pill for CategoryExploreView
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` - Ads group and 4 file references added

## Decisions Made

- AdCreative uses hardcoded static arrays — no AdStore or service layer, as specified in CONTEXT.md decisions
- BannerAdView Sponsored label uses ZStack(alignment: .topTrailing) overlay so it floats without displacing the HStack content
- InlineCardAdView uses UnevenRoundedRectangle with leading radius 12pt to match blossomCard() corner radius on the left accent stripe
- PillAdView intentionally skips blossomCard() — uses 8pt corner radius and no shadow for lighter visual weight appropriate to pill format

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None — first build attempt failed only because the view files were registered in project.pbxproj before being created on disk (expected behavior). Resolved immediately by creating the three view files.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- All four Ads files are in BlossomHubs/Features/Hubs/Ads/ and registered in the Xcode project
- Plan 02 integration can import BannerAdView into HubsDiscoveryView, InlineCardAdView into ContentFeedView, and PillAdView into CategoryExploreView directly
- No blockers

---
*Phase: 10-ad-placement-system*
*Completed: 2026-03-17*

## Self-Check: PASSED

- BlossomHubs/Features/Hubs/Ads/AdCreative.swift: FOUND
- BlossomHubs/Features/Hubs/Ads/BannerAdView.swift: FOUND
- BlossomHubs/Features/Hubs/Ads/InlineCardAdView.swift: FOUND
- BlossomHubs/Features/Hubs/Ads/PillAdView.swift: FOUND
- .planning/phases/10-ad-placement-system/10-01-SUMMARY.md: FOUND
- Commit abfb3d9: FOUND
- Commit 5489f82: FOUND
