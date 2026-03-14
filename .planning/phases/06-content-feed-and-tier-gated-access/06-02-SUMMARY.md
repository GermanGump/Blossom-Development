---
phase: 06-content-feed-and-tier-gated-access
plan: 02
subsystem: ui
tags: [swiftui, content-feed, tier-gating, collection-filter, locked-content, upgrade-prompt]

# Dependency graph
requires:
  - phase: 06-content-feed-and-tier-gated-access
    provides: "PostCardView router, ContentFeedViewModel, TextPostCard, TradeHighlightCard, YouTubeLinkCard, PostAuthorRow, TickerPriceLookup"
  - phase: 04-subscription-and-payment-flow
    provides: "SubscriptionStore with currentTier(for:), TiersBottomSheet for upgrade flow"
  - phase: 05-community-hub-and-navigation-structure
    provides: "CommunitySectionPager with .posts/.videos EmptyStateView placeholders"
provides:
  - "ContentFeedView assembling post cards with tier-gated locked overlays and TiersBottomSheet upgrade"
  - "CollectionFilterPicker dropdown for narrowing feed by collection category"
  - "CommunitySectionPager wired to ContentFeedView for .posts and .videos sections"
affects: [community-hub, content-feed, subscriber-experience]

# Tech tracking
tech-stack:
  added: []
  patterns: [lazy-viewmodel-init, no-nested-scrollview, menu-dropdown-filter]

key-files:
  created:
    - BlossomHubs/Features/Hubs/Feed/ContentFeedView.swift
    - BlossomHubs/Features/Hubs/Feed/CollectionFilterPicker.swift
  modified:
    - BlossomHubs/Features/Hubs/Community/CommunitySectionPager.swift
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj

key-decisions:
  - "ContentFeedView uses no ScrollView -- participates in outer CommunityHubView scroll context per RESEARCH.md Pitfall 3"
  - "CollectionFilterPicker hidden in Videos section since filterToVideos already constrains to YouTube posts"
  - "TiersBottomSheet reused from Phase 4 with popularTierIndex heuristic matching CommunityPreviewViewModel pattern"
  - "Binding to @Observable viewModel.selectedCollection created via Binding(get:set:) to avoid @Bindable wrapper"

patterns-established:
  - "Feed view reuse: .videos section reuses ContentFeedView with filterToVideos=true rather than duplicating view code"
  - "Menu-based filter: CollectionFilterPicker uses Menu with checkmark labels for dropdown collection selection"

requirements-completed: [HUB-03, HUB-06, HUB-07]

# Metrics
duration: 2min
completed: 2026-03-14
---

# Phase 6 Plan 02: Content Feed Assembly and Tier-Gated Access Summary

**ContentFeedView with tier-gated locked post overlays, collection dropdown filter, and CommunitySectionPager wiring for Posts and Videos sections**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-14T19:46:29Z
- **Completed:** 2026-03-14T19:48:48Z
- **Tasks:** 1
- **Files modified:** 4

## Accomplishments
- ContentFeedView renders all 3 post card types in chronological order with per-post tier access checks via SubscriptionStore
- Locked posts show blurred body with upgrade prompt naming the specific required tier; tapping Upgrade opens TiersBottomSheet
- CollectionFilterPicker dropdown narrows feed by collection category with All Posts default
- CommunitySectionPager .posts and .videos cases now render ContentFeedView, replacing EmptyStateView placeholders
- Videos section reuses ContentFeedView with filterToVideos=true, showing only YouTube link posts

## Task Commits

Each task was committed atomically:

1. **Task 1: ContentFeedView, CollectionFilterPicker, and CommunitySectionPager wiring** - `66be16d` (feat)

## Files Created/Modified
- `BlossomHubs/Features/Hubs/Feed/ContentFeedView.swift` - Main feed view with tier-gated card rendering and TiersBottomSheet upgrade flow
- `BlossomHubs/Features/Hubs/Feed/CollectionFilterPicker.swift` - Menu-based dropdown picker for collection filtering
- `BlossomHubs/Features/Hubs/Community/CommunitySectionPager.swift` - Replaced .posts and .videos EmptyStateView with ContentFeedView
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` - Registered 2 new files under Feed group

## Decisions Made
- ContentFeedView has no ScrollView of its own -- it participates in the outer CommunityHubView ScrollView to avoid nested scroll jank (per RESEARCH.md Pitfall 3)
- CollectionFilterPicker is hidden when filterToVideos is true since the Videos section already constrains to YouTube posts only
- TiersBottomSheet reused from Phase 4 with the same popularTierIndex heuristic (second tier when 2+ exist)
- Binding(get:set:) used to bind to @Observable viewModel.selectedCollection since @Bindable wrapper is not needed at this scope

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Content feed is fully functional with all 3 post types, tier gating, collection filtering, and video section
- Phase 6 complete -- ready for Phase 7 (discussions and FAQ sections in CommunitySectionPager)
- All HUB requirements (HUB-03 through HUB-07) satisfied across Plans 01 and 02

---
*Phase: 06-content-feed-and-tier-gated-access*
*Completed: 2026-03-14*
