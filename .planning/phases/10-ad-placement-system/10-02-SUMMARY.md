---
phase: 10-ad-placement-system
plan: 02
subsystem: ui
tags: [swift, swiftui, ads, discovery, feed, category]

# Dependency graph
requires:
  - phase: 10-ad-placement-system-01
    provides: BannerAdView, InlineCardAdView, PillAdView, AdCreative model

provides:
  - BannerAdView integrated above Featured Hub in HubsDiscoveryView
  - InlineCardAdView integrated between posts in ContentFeedView
  - PillAdView integrated at cadence intervals in CategoryExploreView

affects: []

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "@State private var adInsertionIndex: Int = Int.random(in: 3...5) — one-shot random on view init for deterministic-per-visit ad slot"
    - "@State private var adCadence: Int = Int.random(in: 6...8) — one-shot random cadence for pill ad insertion interval"
    - "Pill ad inserted AFTER community card using if (totalIndex + 1).isMultiple(of: adCadence)"
    - "ForEach enumeration pattern: Array(collection.enumerated()), id: \.element.id for index-based ad insertion"
    - "Cross-loop totalIndex = realCommunities.count + index for unified cadence across two separate ForEach loops"

key-files:
  created: []
  modified:
    - BlossomHubs/Features/Hubs/Discovery/HubsDiscoveryView.swift
    - BlossomHubs/Features/Hubs/Feed/ContentFeedView.swift
    - BlossomHubs/Features/Hubs/Discovery/CategoryExploreView.swift

key-decisions:
  - "BannerAdView inserted as flat LazyVStack item above Featured Hub — no conditional logic, always present"
  - "adInsertionIndex evaluated once at view init via @State default — deterministic per visit, varies between visits"
  - "For short feeds fewer than adInsertionIndex posts: ad silently absent — if index == adInsertionIndex never fires"
  - "CategoryExploreView preserves two-ForEach structure (real + mock) — totalIndex bridges the gap for cadence tracking"
  - "Pill ad placed AFTER the community card (not before) per plan spec"
  - "ContentFeedView ForEach migrated from identity-based to enumerated — no ScrollView added, outer scroll preserved"

patterns-established:
  - "Index-offset ad injection: @State random init + ForEach enumeration + simple if index == slot"
  - "Multi-loop cadence: totalIndex accumulator spanning multiple ForEach loops for unified ad cadence"

requirements-completed: [AD-PLACE, AD-INTERACT]

# Metrics
duration: 2min
completed: 2026-03-17
---

# Phase 10 Plan 02: Ad Host View Integration Summary

**BannerAdView, InlineCardAdView, and PillAdView wired into HubsDiscoveryView, ContentFeedView, and CategoryExploreView with random-init slot and cadence logic**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-17T11:27:12Z
- **Completed:** 2026-03-17T11:28:27Z
- **Tasks:** 1 of 2 (Task 2 is human-verify checkpoint)
- **Files modified:** 3

## Accomplishments
- BannerAdView inserted as flat LazyVStack item immediately above the Featured Hub section in HubsDiscoveryView — consistent position regardless of subscription state
- ContentFeedView ForEach enumerated with adInsertionIndex @State (random 3-5 on init), InlineCardAdView injected before the post at that index — no ScrollView added, outer CommunityHubView scroll preserved
- CategoryExploreView gets adCadence @State (random 6-8), PillAdView injected after each community card at cadence interval across both real and mock ForEach loops using a unified totalIndex accumulator

## Task Commits

Each task was committed atomically:

1. **Task 1: Integrate ads into HubsDiscoveryView, ContentFeedView, and CategoryExploreView** - `9fc8dcb` (feat)

## Files Created/Modified
- `BlossomHubs/Features/Hubs/Discovery/HubsDiscoveryView.swift` - Added BannerAdView() insertion above Featured Hub block
- `BlossomHubs/Features/Hubs/Feed/ContentFeedView.swift` - Added adInsertionIndex @State, enumerated ForEach, InlineCardAdView at slot
- `BlossomHubs/Features/Hubs/Discovery/CategoryExploreView.swift` - Added adCadence @State, PillAdView after cards at cadence in both loops

## Decisions Made
- BannerAdView is a flat insertion — no conditional, always shows above Featured Hub per user decision (anchored to featured hub, consistent position)
- ContentFeedView ForEach needed to move from `ForEach(viewModel.filteredPosts)` to `ForEach(Array(viewModel.filteredPosts.enumerated()), id: \.element.id)` to get index — straightforward migration
- CategoryExploreView animation delay for mock communities was already using `Double(realCommunities.count + index) * 0.06` — the same totalIndex variable now unifies the cadence tracking

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Ad placement system complete: all three ad formats wired into their host browsing surfaces
- Visual verification required via Simulator (Task 2 checkpoint): banner on discovery, inline card in content feed, pill in category explore
- All ads tappable via Link(destination:) for Safari open
- No ads present on community-internal surfaces (hub landing, forums, FAQ, preview, search, subscriptions, creator dashboard)

---
*Phase: 10-ad-placement-system*
*Completed: 2026-03-17*
