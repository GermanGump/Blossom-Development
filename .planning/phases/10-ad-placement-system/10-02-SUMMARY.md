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
    - BlossomHubs/Features/Hubs/Community/CommunitySectionPager.swift

key-decisions:
  - "BannerAdView inserted as flat LazyVStack item above Featured Hub — no conditional logic, always present"
  - "adInsertionIndex evaluated once at view init via @State default — deterministic per visit, varies between visits"
  - "For short feeds fewer than adInsertionIndex posts: ad silently absent — if index == adInsertionIndex never fires"
  - "CategoryExploreView preserves two-ForEach structure (real + mock) — totalIndex bridges the gap for cadence tracking"
  - "Pill ad placed AFTER the community card (not before) per plan spec"
  - "ContentFeedView ForEach migrated from identity-based to enumerated — no ScrollView added, outer scroll preserved"
  - "CommunitySectionPager minHeight increased to 2x screen height — inline ad adds height to feed, paged TabView clips content to frame bounds at 1x"

patterns-established:
  - "Index-offset ad injection: @State random init + ForEach enumeration + simple if index == slot"
  - "Multi-loop cadence: totalIndex accumulator spanning multiple ForEach loops for unified ad cadence"

requirements-completed: [AD-PLACE, AD-INTERACT]

# Metrics
duration: 15min
completed: 2026-03-17
---

# Phase 10 Plan 02: Ad Host View Integration Summary

**BannerAdView, InlineCardAdView, and PillAdView wired into HubsDiscoveryView, ContentFeedView, and CategoryExploreView with random-init slot and cadence logic; visually verified in light and dark mode**

## Performance

- **Duration:** ~15 min
- **Started:** 2026-03-17T11:27:12Z
- **Completed:** 2026-03-17T11:42:00Z
- **Tasks:** 2 (1 auto + 1 checkpoint:human-verify — approved)
- **Files modified:** 4

## Accomplishments
- BannerAdView inserted as flat LazyVStack item immediately above the Featured Hub section in HubsDiscoveryView — consistent position regardless of subscription state or creator section visibility
- ContentFeedView ForEach enumerated with adInsertionIndex @State (random 3-5 on init), InlineCardAdView injected before the post at that index — no ScrollView added, outer CommunityHubView scroll preserved
- CategoryExploreView gets adCadence @State (random 6-8), PillAdView injected after each community card at cadence interval across both real and mock ForEach loops using a unified totalIndex accumulator
- CommunitySectionPager minHeight increased to 2x screen height to prevent inline ad height growth from clipping post content within paged TabView frame bounds
- Visual verification passed: all three ad formats render correctly in light and dark mode, all ads tap out to Safari, no ads on community-internal surfaces

## Task Commits

Each task was committed atomically:

1. **Task 1: Integrate ads into HubsDiscoveryView, ContentFeedView, and CategoryExploreView** - `9fc8dcb` (feat)
2. **Task 1 auto-fix: Increase pager minHeight to 2x screen to prevent content clipping** - `a99d481` (fix)
3. **Task 2: Visual verification checkpoint** - Approved by user (no commit needed)

## Files Created/Modified
- `BlossomHubs/Features/Hubs/Discovery/HubsDiscoveryView.swift` - Added BannerAdView() insertion above Featured Hub block
- `BlossomHubs/Features/Hubs/Feed/ContentFeedView.swift` - Added adInsertionIndex @State, enumerated ForEach, InlineCardAdView at slot
- `BlossomHubs/Features/Hubs/Discovery/CategoryExploreView.swift` - Added adCadence @State, PillAdView after cards at cadence in both loops
- `BlossomHubs/Features/Hubs/Community/CommunitySectionPager.swift` - minHeight increased from 1x to 2x screen height

## Decisions Made
- BannerAdView is a flat insertion — no conditional, always shows above Featured Hub per user decision (anchored to featured hub, consistent position)
- ContentFeedView ForEach needed to move from `ForEach(viewModel.filteredPosts)` to `ForEach(Array(viewModel.filteredPosts.enumerated()), id: \.element.id)` to get index — straightforward migration
- CategoryExploreView animation delay for mock communities was already using `Double(realCommunities.count + index) * 0.06` — the same totalIndex variable now unifies the cadence tracking
- Pager minHeight at 2x screen is the correct fix for frame-clip issues when paged TabView content grows beyond 1x screen height

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Increased CommunitySectionPager minHeight to prevent content clipping**
- **Found during:** Task 1 (post-integration visual check before checkpoint)
- **Issue:** Inline ad added height to ContentFeedView. CommunitySectionPager's paged TabView clips content to its frame. With minHeight at 1x screen height, posts below the ad insertion point were cut off.
- **Fix:** Increased pager minHeight from `UIScreen.main.bounds.height` to `UIScreen.main.bounds.height * 2` so the frame accommodates full content height including the ad
- **Files modified:** BlossomHubs/Features/Hubs/Community/CommunitySectionPager.swift
- **Verification:** Posts visible below ad insertion point in Simulator, visual checkpoint approved
- **Committed in:** a99d481

---

**Total deviations:** 1 auto-fixed (Rule 1 — bug)
**Impact on plan:** Required fix for visual correctness — inline ad height growth exposed a latent frame-clip issue in the pager. No scope creep.

## Issues Encountered

None beyond the pager clipping bug documented above, which was auto-fixed before the visual checkpoint.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Ad placement system fully delivered: three formats (banner, inline card, pill) across three surfaces (discovery, content feed, category explore)
- All ads tappable via Link(destination:) for Safari open; Blossom PRO ads show violet accent and Upgrade label
- No ads on community-internal surfaces confirmed in Simulator
- Phase 10 is the final phase — Blossom Communities prototype is demo-ready
- No blockers

---
*Phase: 10-ad-placement-system*
*Completed: 2026-03-17*

## Self-Check: PASSED

- BlossomHubs/Features/Hubs/Discovery/HubsDiscoveryView.swift: modified in 9fc8dcb
- BlossomHubs/Features/Hubs/Feed/ContentFeedView.swift: modified in 9fc8dcb
- BlossomHubs/Features/Hubs/Discovery/CategoryExploreView.swift: modified in 9fc8dcb
- BlossomHubs/Features/Hubs/Community/CommunitySectionPager.swift: modified in a99d481
- .planning/phases/10-ad-placement-system/10-02-SUMMARY.md: FOUND
- Commit 9fc8dcb: FOUND
- Commit a99d481: FOUND
