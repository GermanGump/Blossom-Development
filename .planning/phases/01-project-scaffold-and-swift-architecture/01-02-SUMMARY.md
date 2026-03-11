---
phase: 01-project-scaffold-and-swift-architecture
plan: 02
subsystem: ui
tags: [swift, swiftui, ios26, tabbar, navigation, navigationstack, avatarview, custom-tab-bar]

# Dependency graph
requires:
  - phase: 01-project-scaffold-and-swift-architecture/01-01
    provides: AppTab enum with 6 tabs, BlossomTheme color constants, BlossomHubsApp entry point with UITabBarAppearance suppression
provides:
  - ContentView ZStack architecture with TabView + BlossomTabBar overlay and @State selectedTab
  - BlossomTabBar: custom scrollable horizontal tab bar with teal/gray active/inactive coloring
  - Per-tab independent NavigationStack (6 stacks — one per AppTab case)
  - PlaceholderTabView: branded Coming soon screen for non-Hubs tabs
  - HubsView: Hubs tab root with searchText state, HubsTopNavBar, placeholder body, navigationDestination
  - HubsTopNavBar: AvatarView + search TextField + teal bell with 9+ badge + violet dollar-sign circle
  - AvatarView: reusable circular avatar component with teal ring, optional bolt badge, parameterized size
  - HubsNavigation: HubsRoute enum (communityDetail, communityPreview) for value-based routing
  - Route enum stubs for Home, Markets, Learn, Portfolio, Insights tabs
  - nick-profile-pic image asset registered in Assets.xcassets
affects:
  - All subsequent phases (every feature screen is placed inside this navigation skeleton)
  - Phase 3 (HubsView body gets replaced with discovery feed)
  - Phase 2+ (AvatarView reused across community cards, profiles)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - ZStack(alignment:.bottom) with TabView + custom overlay for full visual control over tab bar
    - NavigationStack INSIDE each tab (never wrapping TabView) — per-tab isolation pattern
    - .toolbar(.hidden, for: .tabBar) on each tab content to suppress native chrome
    - .ignoresSafeArea(edges: .bottom) on TabView so content extends under custom bar
    - connectedScenes API (not deprecated UIApplication.shared.windows) for safe area inset reading
    - BlossomTabItem as a nested struct inside BlossomTabBar for encapsulation
    - AvatarView as parameterized reusable component (image, ringColor, showBadge, size)

key-files:
  created:
    - BlossomHubs/App/ContentView.swift (modified — was placeholder, now full ZStack architecture)
    - BlossomHubs/Features/TabBar/BlossomTabBar.swift
    - BlossomHubs/Core/Components/PlaceholderTabView.swift
    - BlossomHubs/Core/Components/AvatarView.swift
    - BlossomHubs/Features/Hubs/HubsView.swift
    - BlossomHubs/Features/Hubs/HubsTopNavBar.swift
    - BlossomHubs/Features/Hubs/HubsNavigation.swift
    - BlossomHubs/Features/Home/HomeNavigation.swift
    - BlossomHubs/Features/Markets/MarketsNavigation.swift
    - BlossomHubs/Features/Learn/LearnNavigation.swift
    - BlossomHubs/Features/Portfolio/PortfolioNavigation.swift
    - BlossomHubs/Features/Insights/InsightsNavigation.swift
    - BlossomHubs/Assets.xcassets/nick-profile-pic.imageset/Contents.json
  modified:
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj (11 new Swift files + imageset registered)

key-decisions:
  - "NavigationStack is INSIDE each TabView tab (not wrapping it) — enforces per-tab back-stack isolation from day one; would be painful to refactor later"
  - "connectedScenes API used instead of deprecated UIApplication.shared.windows for safe area inset reading — fully compliant with iOS 26"
  - "BlossomTabBar uses UIScreen.main.bounds.width / 5 per tab item for comfortable spacing while enabling horizontal scroll for 6+ tabs"
  - "HubsView does NOT contain a second NavigationStack — ContentView already wraps it; HubsView is the content inside that stack"
  - "AvatarView defaults to BlossomTheme.teal for ring and BlossomTheme.violet for badge — consistent with brand without hardcoding hex values in views"

patterns-established:
  - "ZStack(.bottom) tab bar overlay: TabView for content switching, custom BlossomTabBar at bottom, .ignoresSafeArea(.bottom) on TabView"
  - "Per-tab Route enum pattern: each feature has its own XxxRoute: Hashable enum + NavigationStack(path: $path)"
  - "Top nav bar pattern: HStack(spacing:12) with left avatar, center search, right icon buttons — all using BlossomTheme colors"

requirements-completed: [FOUND-02, FOUND-03]

# Metrics
duration: 2min
completed: 2026-03-11
---

# Phase 1 Plan 02: Navigation Architecture Summary

**Custom scrollable BlossomTabBar overlaying hidden native TabView with 6 independent NavigationStack tabs, Hubs top nav bar with AvatarView + search + bell badge + violet chat icon, and branded placeholder screens on all non-Hubs tabs**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-11T02:32:18Z
- **Completed:** 2026-03-11T02:34:30Z
- **Tasks:** 2 (+ 1 checkpoint awaiting human verify)
- **Files created:** 13

## Accomplishments

- ContentView fully replaced with ZStack architecture: TabView (6 tabs with independent NavigationStack) + BlossomTabBar overlay at bottom
- BlossomTabBar built as a scrollable horizontal ScrollView/HStack with teal active / gray inactive coloring, Divider separator, and safe area bottom padding via connectedScenes API
- HubsView with full top nav bar: Nick's circular photo with teal ring and violet bolt badge, functional search field, teal bell with red "9+" capsule badge, violet circle with dollarsign.bubble.fill icon
- AvatarView reusable component: circular clipped image, colored ring, optional badge at bottom-leading, fully parameterized
- 5 route enum stubs for non-Hubs tabs (Home, Markets, Learn, Portfolio, Insights) — ready for Phase 3+ feature build-out
- nick-profile-pic.png registered in Assets.xcassets imageset for use in HubsTopNavBar

## Task Commits

Each task was committed atomically:

1. **Task 1: ZStack tab architecture, BlossomTabBar, PlaceholderTabView, NavigationStack isolation, Route stubs** - `8a4c6ba` (feat)
2. **Task 2: Hubs top nav bar, AvatarView, HubsNavigation, nick profile asset** - `ed271de` (feat)

**Plan metadata:** TBD (docs commit below)

## Files Created/Modified

- `BlossomHubs/App/ContentView.swift` - ZStack + TabView + BlossomTabBar, 6 NavigationStack-wrapped tabs
- `BlossomHubs/Features/TabBar/BlossomTabBar.swift` - Scrollable horizontal tab bar with teal/gray coloring + Divider separator
- `BlossomHubs/Core/Components/PlaceholderTabView.swift` - Branded Coming soon screen (56pt teal icon, semibold name, secondary subtitle)
- `BlossomHubs/Core/Components/AvatarView.swift` - Reusable circular avatar with ring, optional bolt badge
- `BlossomHubs/Features/Hubs/HubsView.swift` - Hubs tab root: searchText state, HubsTopNavBar, placeholder body, navigationBarHidden
- `BlossomHubs/Features/Hubs/HubsTopNavBar.swift` - Full top nav bar: avatar + search + bell badge + violet dollar-sign circle
- `BlossomHubs/Features/Hubs/HubsNavigation.swift` - HubsRoute enum: communityDetail(id:), communityPreview(id:)
- `BlossomHubs/Features/{Home,Markets,Learn,Portfolio,Insights}/XxxNavigation.swift` - Route enum stubs for future features
- `BlossomHubs/Assets.xcassets/nick-profile-pic.imageset/` - Image asset + Contents.json
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` - All 11 new Swift files registered in target build phase

## Decisions Made

- NavigationStack is placed INSIDE each TabView tab content, never wrapping TabView itself — this enforces back-stack isolation per tab (FOUND-03 requirement). Violating this causes navigation bleed between tabs.
- Used `UIApplication.shared.connectedScenes` to read bottom safe area insets (instead of deprecated `UIApplication.shared.windows`) — clean for iOS 26.
- `BlossomTabBar` uses `UIScreen.main.bounds.width / 5` per tab item — gives comfortable touch targets while making horizontal scroll feel natural with 6 tabs.
- `HubsView` does NOT wrap itself in a NavigationStack — ContentView already provides the NavigationStack. HubsView is the content inside it. This is consistent with the research anti-pattern note.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Created HubsView, HubsTopNavBar, HubsNavigation, and AvatarView alongside Task 1 files**
- **Found during:** Task 1 (ContentView build)
- **Issue:** ContentView references HubsView() directly, which in turn references HubsTopNavBar and HubsRoute. All files needed to exist simultaneously for a coherent, compilable state per commit. Plan split them across Task 1 and Task 2, but the Swift type system requires all referenced types to exist.
- **Fix:** Created all Hubs-related files (HubsView, HubsTopNavBar, HubsNavigation, AvatarView) alongside Task 1 files, added all to Xcode project in one pass, then committed them in two separate commits (Task 1: ContentView + TabBar + Placeholders + Route stubs; Task 2: HubsView + HubsTopNavBar + HubsNavigation + AvatarView + asset).
- **Files modified:** All 11 new Swift files + project.pbxproj
- **Verification:** git log shows two distinct commits with appropriate file grouping
- **Committed in:** 8a4c6ba (Task 1) + ed271de (Task 2)

---

**Total deviations:** 1 auto-fixed (1 blocking — type dependency required all files to exist before first commit)
**Impact on plan:** No scope creep. Files match the plan exactly. Only the creation order differs.

## Issues Encountered

- xcodebuild not available (Xcode not installed in environment) — build verification deferred to human visual checkpoint. Project structure validated by xcodeproj gem confirming all 11 source files are in the target Sources build phase.

## User Setup Required

**Open in Xcode to verify and run on simulator:**
1. Open `BlossomHubs/BlossomHubs.xcodeproj` in Xcode 26
2. Resolve ComponentsKit SPM package if prompted
3. Select "BlossomHubs" scheme, "iPhone 16 Pro" simulator (iOS 26)
4. Build (Cmd+B) — should succeed with zero errors and zero warnings
5. Run (Cmd+R) — app launches showing Hubs tab with top nav bar

## Next Phase Readiness

- Navigation skeleton is complete — all subsequent phases can add screens inside the per-tab NavigationStack structures
- HubsView body is a placeholder ready to be replaced with the Phase 3 discovery feed
- AvatarView is reusable for community cards and profile screens in Phase 3+
- Checkpoint: Human visual verification required before marking plan complete (see below)

---
*Phase: 01-project-scaffold-and-swift-architecture*
*Completed: 2026-03-11*

## Self-Check: PASSED

All 13 created/modified files verified present on disk:
- BlossomHubs/App/ContentView.swift ✓
- BlossomHubs/Features/TabBar/BlossomTabBar.swift ✓
- BlossomHubs/Core/Components/PlaceholderTabView.swift ✓
- BlossomHubs/Core/Components/AvatarView.swift ✓
- BlossomHubs/Features/Hubs/HubsView.swift ✓
- BlossomHubs/Features/Hubs/HubsTopNavBar.swift ✓
- BlossomHubs/Features/Hubs/HubsNavigation.swift ✓
- BlossomHubs/Features/Home/HomeNavigation.swift ✓
- BlossomHubs/Features/Markets/MarketsNavigation.swift ✓
- BlossomHubs/Features/Learn/LearnNavigation.swift ✓
- BlossomHubs/Features/Portfolio/PortfolioNavigation.swift ✓
- BlossomHubs/Features/Insights/InsightsNavigation.swift ✓
- BlossomHubs/Assets.xcassets/nick-profile-pic.imageset/Contents.json ✓

Both task commits (8a4c6ba, ed271de) verified in git log.
