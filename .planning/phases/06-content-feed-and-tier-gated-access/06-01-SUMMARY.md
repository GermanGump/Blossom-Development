---
phase: 06-content-feed-and-tier-gated-access
plan: 01
subsystem: ui
tags: [swiftui, content-feed, post-cards, ticker-lookup, tier-gating, youtube-deep-link]

# Dependency graph
requires:
  - phase: 02-design-system-and-mock-data
    provides: "BlossomCard, TagView, AvatarView, LockedContentOverlay, Post model with PostType enum, CommunityStore mock data"
  - phase: 04-subscription-and-payment-flow
    provides: "SubscriptionStore with currentTier(for:) for tier access checks"
  - phase: 05-community-hub-and-navigation-structure
    provides: "CommunitySectionPager with .posts placeholder for feed integration"
provides:
  - "TickerPriceLookup static enum for mock stock price data across 11 tickers"
  - "PostAuthorRow shared component for creator avatar + name + timestamp"
  - "TextPostCard with 4-line truncation and Read more toggle"
  - "TradeHighlightCard with scrollable ticker metrics row (orange tags + price + change)"
  - "YouTubeLinkCard with dark gradient thumbnail, red play button, and deep link"
  - "PostCardView router dispatching to correct card type with locked state support"
  - "ContentFeedViewModel with chronological sorting, collection filtering, tier access logic, and video filter"
affects: [06-02-PLAN, community-hub, content-feed]

# Tech tracking
tech-stack:
  added: []
  patterns: [post-card-routing, static-ticker-lookup, locked-card-metadata-visible]

key-files:
  created:
    - BlossomHubs/Features/Hubs/Feed/TickerPriceLookup.swift
    - BlossomHubs/Features/Hubs/Feed/PostAuthorRow.swift
    - BlossomHubs/Features/Hubs/Feed/TextPostCard.swift
    - BlossomHubs/Features/Hubs/Feed/TradeHighlightCard.swift
    - BlossomHubs/Features/Hubs/Feed/YouTubeLinkCard.swift
    - BlossomHubs/Features/Hubs/Feed/PostCardView.swift
    - BlossomHubs/Features/Hubs/Feed/ContentFeedViewModel.swift
  modified:
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj

key-decisions:
  - "PostCardView shows metadata (author, type indicator, ticker tags) on locked cards before LockedContentOverlay wraps body content"
  - "ClipShape RoundedRectangle applied to locked card container to prevent LockedContentOverlay ignoresSafeArea bleed"
  - "ViewThatFits used for truncation detection in TextPostCard rather than GeometryReader"
  - "ScrollView(.horizontal) on ticker metrics row handles trade highlights with many tickers without clipping"

patterns-established:
  - "Post card routing: PostCardView switch on postType dispatches to dedicated card subview"
  - "Static ticker lookup: TickerPriceLookup.lookup(ticker) provides consistent mock price data app-wide"
  - "Locked card pattern: metadata always visible, body content wrapped in LockedContentOverlay"

requirements-completed: [HUB-03, HUB-04, HUB-05]

# Metrics
duration: 3min
completed: 2026-03-14
---

# Phase 6 Plan 01: Content Feed Building Blocks Summary

**Three investing-native post card types (text with Read more, Bloomberg-lite trade highlights with ticker metrics, YouTube preview with dark gradient and red play button) plus PostCardView router and ContentFeedViewModel with tier-gated access logic**

## Performance

- **Duration:** 3 min
- **Started:** 2026-03-14T19:39:43Z
- **Completed:** 2026-03-14T19:42:42Z
- **Tasks:** 2
- **Files modified:** 8

## Accomplishments
- Three visually distinct post card types: text with expandable Read more, trade highlights with orange ticker tags and price/change metrics, YouTube preview with dark gradient thumbnail and red play button deep link
- TickerPriceLookup covers all 11 tickers used across CommunityStore mock data with consistent mock prices
- PostCardView router with locked state support showing card metadata while blurring body content via LockedContentOverlay
- ContentFeedViewModel with chronological sorting, collection filtering, tier access check (nil = all locked), and filterToVideos parameter for .videos section reuse

## Task Commits

Each task was committed atomically:

1. **Task 1: TickerPriceLookup, PostAuthorRow, and three card views** - `980cb53` (feat)
2. **Task 2: PostCardView router and ContentFeedViewModel** - `b815d52` (feat)

## Files Created/Modified
- `BlossomHubs/Features/Hubs/Feed/TickerPriceLookup.swift` - Static ticker-to-price lookup table for 11 stock symbols
- `BlossomHubs/Features/Hubs/Feed/PostAuthorRow.swift` - Shared author avatar + name + relative timestamp row
- `BlossomHubs/Features/Hubs/Feed/TextPostCard.swift` - Text post card with 4-line truncation and Read more toggle
- `BlossomHubs/Features/Hubs/Feed/TradeHighlightCard.swift` - Bloomberg-lite trade card with scrollable ticker metrics row
- `BlossomHubs/Features/Hubs/Feed/YouTubeLinkCard.swift` - YouTube preview card with dark gradient thumbnail and deep link
- `BlossomHubs/Features/Hubs/Feed/PostCardView.swift` - Router view dispatching to correct card type with locked state
- `BlossomHubs/Features/Hubs/Feed/ContentFeedViewModel.swift` - Feed ViewModel with sorting, filtering, tier access logic
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` - Registered all 7 new files under Feed group

## Decisions Made
- PostCardView shows metadata (author row, type indicator, ticker tags) on locked cards before wrapping body in LockedContentOverlay -- gives users enough context to see what they are missing
- ClipShape RoundedRectangle applied after LockedContentOverlay to prevent ignoresSafeArea bleed outside card bounds (per RESEARCH.md Pitfall 1)
- ViewThatFits used for truncation detection in TextPostCard -- cleaner than GeometryReader for detecting text overflow
- ScrollView(.horizontal) on ticker metrics row ensures trade highlights with many tickers do not clip
- YouTubeLinkCard uses post.content as video title (content describes the video in mock data)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- All 7 feed building block files compile and are ready for assembly into ContentFeedView in Plan 02
- PostCardView router handles all 3 post types plus locked state
- ContentFeedViewModel provides filtering/sorting/access logic ready for view integration
- filterToVideos parameter enables .videos section reuse without duplicate view code

## Self-Check: PASSED

- All 7 created files verified present on disk
- Commit 980cb53 verified in git log (Task 1)
- Commit b815d52 verified in git log (Task 2)
- Build succeeded with all files compiled

---
*Phase: 06-content-feed-and-tier-gated-access*
*Completed: 2026-03-14*
