---
phase: 05-community-hub-and-navigation-structure
plan: 01
subsystem: ui
tags: [swiftui, community-hub, parallax-banner, link-tree, navigation, landing-page]

# Dependency graph
requires:
  - phase: 03-community-discovery-and-preview
    provides: CommunityPreviewView parallax pattern, HubsRoute.communityDetail, CommunityStore
  - phase: 04-subscription-flow-and-payment
    provides: SubscriptionStore with tier lookup, subscription state
provides:
  - CommunityHubView replacing EmptyView at HubsRoute.communityDetail
  - CommunityLandingSection with banner, overlapping logo, info, tier badge, link-tree
  - CommunitySection enum for section-based navigation
  - CommunityHubViewModel with data-driven availableSections
  - CommunityBannerView with category-based gradient parallax
  - CommunityLinkTreeRow iOS Settings-style navigation rows
affects: [06-content-feed, 07-engagement, 05-02-segmented-pager]

# Tech tracking
tech-stack:
  added: []
  patterns: [category-based-gradient-mapping, data-driven-section-filtering, link-tree-navigation]

key-files:
  created:
    - BlossomHubs/Features/Hubs/Community/CommunitySection.swift
    - BlossomHubs/Features/Hubs/Community/CommunityBannerView.swift
    - BlossomHubs/Features/Hubs/Community/CommunityLinkTreeRow.swift
    - BlossomHubs/Features/Hubs/Community/CommunityLandingSection.swift
    - BlossomHubs/Features/Hubs/Community/CommunityHubViewModel.swift
    - BlossomHubs/Features/Hubs/Community/CommunityHubView.swift
  modified:
    - BlossomHubs/Features/Hubs/HubsView.swift
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj

key-decisions:
  - "Section content counts shown in link-tree rows for richer UX (Claude discretion)"
  - "CommunityLandingSection receives availableSections and onSectionSelected closure from parent for Plan 02 pager integration"
  - "Category-based gradient colors per RESEARCH.md Pattern 5 for banner placeholders"

patterns-established:
  - "Category-to-gradient mapping: static func gradientColors(for:) on CommunityBannerView"
  - "Data-driven section availability: CommunityHubViewModel.availableSections computed from community model arrays"
  - "Community group folder structure: Features/Hubs/Community/ for all community hub files"

requirements-completed: [HUB-01, HUB-02]

# Metrics
duration: 4min
completed: 2026-03-14
---

# Phase 5 Plan 1: Community Hub Landing Page Summary

**Community hub landing page with parallax gradient banner, overlapping logo, tier badge, and data-driven link-tree navigation wired into HubsRoute.communityDetail**

## Performance

- **Duration:** 4 min
- **Started:** 2026-03-14T11:33:51Z
- **Completed:** 2026-03-14T11:38:00Z
- **Tasks:** 2
- **Files modified:** 8

## Accomplishments
- Community hub landing page renders for all 6 mock communities via HubsRoute.communityDetail navigation
- Parallax banner with category-based gradient colors (6 unique gradients mapped to community categories)
- Overlapping community logo with white ring stroke matching CommunityPreviewView pattern
- Data-driven link-tree rows showing only sections with content, with section counts
- Tier badge via TagView(.tier) appears for subscribed communities
- CommunityHubView replaces EmptyView placeholder, completing the navigation chain

## Task Commits

Each task was committed atomically:

1. **Task 1: CommunitySection enum, banner, link-tree row, and landing section components** - `6a07308` (feat)
2. **Task 2: CommunityHubView, view model, and navigation wiring** - `2cbc6fe` (feat)

## Files Created/Modified
- `BlossomHubs/Features/Hubs/Community/CommunitySection.swift` - Enum with 5 cases (landing, posts, discussions, faq, videos) and SF Symbol icons
- `BlossomHubs/Features/Hubs/Community/CommunityBannerView.swift` - Parallax banner with category-based gradient color mapping
- `BlossomHubs/Features/Hubs/Community/CommunityLinkTreeRow.swift` - iOS Settings-style row with icon, label, optional count, chevron
- `BlossomHubs/Features/Hubs/Community/CommunityLandingSection.swift` - Assembled landing content: banner + overlapping logo + info + tier badge + link-tree
- `BlossomHubs/Features/Hubs/Community/CommunityHubViewModel.swift` - @MainActor @Observable view model with data-driven availableSections
- `BlossomHubs/Features/Hubs/Community/CommunityHubView.swift` - Main hub container with lazy init, custom toolbar, ScrollView landing
- `BlossomHubs/Features/Hubs/HubsView.swift` - Replaced EmptyView with CommunityHubView at .communityDetail route
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` - Registered 6 new files in Community group

## Decisions Made
- Section content counts shown in link-tree rows (Claude discretion -- richer UX feedback)
- Category-based gradient colors mapped per RESEARCH.md Pattern 5 specification
- CommunityLandingSection takes availableSections and onSectionSelected closure externally for clean Plan 02 integration
- Dividers between link-tree rows use 56pt left padding to align with text (past icon frame)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Landing page skeleton ready for Plan 02 segmented control and pager integration
- onSectionSelected closure wired and updating viewModel.selectedSection state
- availableSections computed property ready to drive both Picker and TabView bindings
- Plan 03 welcome overlay can be added as .overlay on CommunityHubView

---
*Phase: 05-community-hub-and-navigation-structure*
*Completed: 2026-03-14*
