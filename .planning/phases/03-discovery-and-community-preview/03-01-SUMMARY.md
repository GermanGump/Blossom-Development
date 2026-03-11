---
phase: 03-discovery-and-community-preview
plan: 01
subsystem: ui
tags: [swiftui, navigation, phaseanimator, appstorage, observable, animation]

# Dependency graph
requires:
  - phase: 02-design-system-and-component-library
    provides: BlossomTheme, BlossomFont, AvatarView, TagView, BlossomCard, EmptyStateView, VerifiedBadge
  - phase: 01-project-scaffold-and-swift-architecture
    provides: HubsRoute navigation enum, HubsView skeleton, CommunityStore with mock data

provides:
  - HubsSplashView — one-time animated splash with spring scale+fade using @AppStorage gate
  - HubsDiscoveryView — ScrollView with hero + stagger-fade card list
  - HubsDiscoveryViewModel — @MainActor @Observable with search filtering and hero/list separation
  - CommunityHeroCardView — BD hero card with PhaseAnimator pulsating violet glow and Popular badge
  - CommunityCardView — standard community card with NavigationLink(value:) routing
  - SearchDropdownView — overlay search results panel with filtered list and EmptyStateView fallback
  - Updated BD mock data — category "Education & Swing Trading", Basic tier $29.99/mo

affects:
  - 03-02-community-preview (CommunityPreviewView stub routing in HubsView)
  - future phases using HubsRoute.communityPreview navigation

# Tech tracking
tech-stack:
  added: []
  patterns:
    - PhaseAnimator for continuous looping animation (pulsating glow)
    - @AppStorage in SwiftUI struct (NOT in @Observable class) for one-time state persistence
    - withAnimation completion chaining for sequential animation steps
    - Stagger-fade via index-based .animation(.delay()) on opacity+offset modifiers
    - @State var viewModel: ViewModel? initialized in .onAppear to avoid CommunityStore access before environment is ready

key-files:
  created:
    - BlossomHubs/Features/Hubs/Discovery/HubsSplashView.swift
    - BlossomHubs/Features/Hubs/Discovery/HubsDiscoveryView.swift
    - BlossomHubs/Features/Hubs/Discovery/HubsDiscoveryViewModel.swift
    - BlossomHubs/Features/Hubs/Discovery/CommunityHeroCardView.swift
    - BlossomHubs/Features/Hubs/Discovery/CommunityCardView.swift
    - BlossomHubs/Features/Hubs/Search/SearchDropdownView.swift
  modified:
    - BlossomHubs/Features/Hubs/HubsView.swift
    - BlossomHubs/Models/CommunityStore.swift
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj

key-decisions:
  - "@AppStorage('hasSeenHubsSplash') lives in HubsView struct body — not in @Observable class — AppStorage properties require SwiftUI lifecycle"
  - "HubsDiscoveryViewModel initialized lazily in .onAppear as @State optional — avoids CommunityStore @Environment not yet available at struct init time"
  - "PhaseAnimator([false, true]) used for pulsating glow — cleaner than withAnimation repeating, built-in phase coordination"
  - "SearchDropdownView takes CommunityStore directly and filters internally — avoids prop-drilling filtered arrays through multiple view layers"
  - "CommunityHeroCardView stub stubs communityPreview route to EmptyView — Plan 03-02 provides CommunityPreviewView"

patterns-established:
  - "Discovery: NavigationLink(value: HubsRoute.communityPreview(id:)) on every community card — consistent tap target routing"
  - "Stagger-fade: .opacity + .offset with .animation(.easeOut.delay(index * 0.08)) guards by cardsVisible @State"
  - "Hero lookup: store.communities.first { $0.creator.username == '@bdinvesting' } — runtime lookup, never hardcoded UUID"

requirements-completed: [DISC-01, DISC-02, DISC-03, DISC-04]

# Metrics
duration: 25min
completed: 2026-03-11
---

# Phase 3 Plan 01: Discovery and Community Preview Summary

**One-time animated splash, BD hero card with PhaseAnimator pulsating violet glow, stagger-fade community card list, and functional search dropdown overlay using NavigationLink(value:) routing throughout**

## Performance

- **Duration:** 25 min
- **Started:** 2026-03-11T22:51:14Z
- **Completed:** 2026-03-11T23:16:00Z
- **Tasks:** 2
- **Files modified:** 9

## Accomplishments

- HubsSplashView with chained withAnimation completion — spring scale-up then easeIn fade-out — @AppStorage gate ensures one-time display only
- BD hero card with PhaseAnimator([false, true]) pulsating violet glow (opacity 0.15 to 0.6, radius 8 to 20), Popular badge, and "From $29.99/mo" starting price
- Discovery screen with stagger-fade entry animation — each card offsets 20pt with index-based delay (0.08s increments) animating to 0 on first appear
- SearchDropdownView as overlay in HubsView ZStack — appears below nav bar when searchText is non-empty, dismisses on clear

## Task Commits

1. **Task 1: Splash screen, HubsView rewrite, and mock data update** - `deec6f2` (feat)
2. **Task 2: Discovery view, hero card, standard card, search dropdown, and view model** - `a22cced` (feat)

## Files Created/Modified

- `BlossomHubs/Features/Hubs/Discovery/HubsSplashView.swift` — Full-screen splash with colorScheme-aware logo, chained spring+fade animation
- `BlossomHubs/Features/Hubs/Discovery/HubsDiscoveryView.swift` — ScrollView with LazyVStack, hero card + list, stagger-fade via cardsVisible
- `BlossomHubs/Features/Hubs/Discovery/HubsDiscoveryViewModel.swift` — @MainActor @Observable VM with heroCommunity, listCommunities, filteredCommunities
- `BlossomHubs/Features/Hubs/Discovery/CommunityHeroCardView.swift` — Hero card with PhaseAnimator glow, Popular badge, NavigationLink(value:)
- `BlossomHubs/Features/Hubs/Discovery/CommunityCardView.swift` — Standard card with HStack layout, NavigationLink(value:)
- `BlossomHubs/Features/Hubs/Search/SearchDropdownView.swift` — Search overlay with filtered NavigationLink rows, EmptyStateView fallback
- `BlossomHubs/Features/Hubs/HubsView.swift` — Rewritten with @AppStorage gate, ZStack orchestration, navigationDestination(for: HubsRoute.self)
- `BlossomHubs/Models/CommunityStore.swift` — BD category changed to "Education & Swing Trading", Basic tier $29.99/mo
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` — New Discovery/ and Search/ groups with all 6 new files registered

## Decisions Made

- @AppStorage in struct not @Observable class — AppStorage requires SwiftUI property wrapper lifecycle
- ViewModel initialized lazily in .onAppear as @State optional — CommunityStore @Environment not available at struct init
- PhaseAnimator([false, true]) for glow — clean bidirectional animation without manual withAnimation(repeatForever:)
- SearchDropdownView filters internally from CommunityStore — avoids threading filtered arrays through HubsView

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- HubsView `navigationDestination(for: HubsRoute.self)` registered with stub `EmptyView()` for `.communityPreview` — Plan 03-02 replaces with `CommunityPreviewView(communityID: id)`
- All community cards tap to `.communityPreview` route — ready for Plan 03-02 to provide destination view
- BD mock data updated with final values used in hero card display

---
*Phase: 03-discovery-and-community-preview*
*Completed: 2026-03-11*
