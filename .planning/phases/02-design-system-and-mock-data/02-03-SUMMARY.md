---
phase: 02-design-system-and-mock-data
plan: 03
subsystem: ui
tags: [swift, swiftui, observable, mock-data, asset-catalog, environment-injection]

requires:
  - phase: 02-01
    provides: BlossomTheme color tokens and Inter font system that ambassadors' profile views will use

provides:
  - Community, Creator, Tier, Post, ForumThread, FAQEntry data model structs in Community.swift
  - CommunityStore @MainActor @Observable class with 6 ambassador communities via makeMockData()
  - 5 ambassador profile photo imagesets (bd, brandon, max, moe, canada-tshirt) in Assets.xcassets
  - 3 Blossom logo imagesets (blossom-logo-light, blossom-logo-dark, blossom-logo-icon) in Assets.xcassets
  - CommunityStore injected at app root via .environment(store) — accessible by all child views

affects:
  - Phase 3 (community detail screen reads Community and its tiers/posts)
  - Phase 4 (payment flow reads Tier data for subscription options)
  - Phase 5 (forum threads screen reads ForumThread data)
  - Phase 6 (content feed reads Post data with PostType enum for rendering)
  - Phase 7 (FAQ screen reads FAQEntry data)

tech-stack:
  added: []
  patterns:
    - "@MainActor @Observable for CommunityStore — synchronous mock data avoids actor isolation complexity"
    - "static makeMockData() factory returns [Community] — keeps store initializer simple"
    - ".environment(store) at WindowGroup level — single source of truth accessible everywhere"
    - "private extension CommunityStore pattern — each ambassador community in its own extension for readability"

key-files:
  created:
    - BlossomHubs/Models/Community.swift
    - BlossomHubs/Models/CommunityStore.swift
    - BlossomHubs/Assets.xcassets/bd-profile-pic.imageset/Contents.json
    - BlossomHubs/Assets.xcassets/brandon-profile-pic.imageset/Contents.json
    - BlossomHubs/Assets.xcassets/max-profile-pic.imageset/Contents.json
    - BlossomHubs/Assets.xcassets/moe-profile-pic.imageset/Contents.json
    - BlossomHubs/Assets.xcassets/canada-tshirt-profile-pic.imageset/Contents.json
    - BlossomHubs/Assets.xcassets/blossom-logo-light.imageset/Contents.json
    - BlossomHubs/Assets.xcassets/blossom-logo-dark.imageset/Contents.json
    - BlossomHubs/Assets.xcassets/blossom-logo-icon.imageset/Contents.json
  modified:
    - BlossomHubs/App/BlossomHubsApp.swift
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj

key-decisions:
  - "PostType enum (.text, .tradeHighlight, .youtubeLink) gives content feed rendering logic a discriminator for Phase 6"
  - "logoImageName on Community reuses creator profileImageName for Phase 2 — Phase 3+ can add real community logo assets"
  - "DEBUG assertion (.task modifier) verifies community count at runtime without blocking init()"
  - "Each community mapped as private extension on CommunityStore — one extension per ambassador, easy to maintain"

patterns-established:
  - "CommunityStore via @Environment(CommunityStore.self) — all views access data this way, never passed as parameter"
  - "Image(creator.profileImageName) pattern — all ambassador avatars resolve from asset catalog name string"

requirements-completed: [FOUND-09, FOUND-10, FOUND-11]

duration: 5min
completed: 2026-03-11
---

# Phase 2 Plan 03: Mock Data and Ambassador Assets Summary

**@MainActor @Observable CommunityStore with 6 ambassador communities (4-6 posts, 3-5 threads, 3-4 FAQs each), 5 profile photo imagesets and 3 logo imagesets registered in Assets.xcassets, and environment injection at app root**

## Performance

- **Duration:** 5 min
- **Started:** 2026-03-11T21:39:06Z
- **Completed:** 2026-03-11T21:44:37Z
- **Tasks:** 2 of 2
- **Files modified:** 20

## Accomplishments

- Created Community.swift with 7 types: Community, Creator, Tier, Post, ForumThread, FAQEntry, and PostType enum
- Created CommunityStore.swift with 6 ambassador communities totaling ~30 posts, ~20 forum threads, and ~18 FAQ entries with realistic investing content and real stock tickers
- Registered 8 new imagesets (5 profile photos + 3 logos) in Assets.xcassets with .png files physically copied from source directories
- Wired CommunityStore into BlossomHubsApp via .environment(store) with DEBUG count assertion

## Task Commits

1. **Task 1: Data models, CommunityStore, asset images, and app wiring** - `552410c` (feat)

## Files Created/Modified

- `BlossomHubs/Models/Community.swift` — PostType enum, Creator, Tier, Post, ForumThread, FAQEntry, Community structs (all Identifiable with UUID ids)
- `BlossomHubs/Models/CommunityStore.swift` — @MainActor @Observable class with 6 communities via static makeMockData(), split into private extensions per ambassador
- `BlossomHubs/Assets.xcassets/bd-profile-pic.imageset/` — BD's profile photo registered as 1x asset
- `BlossomHubs/Assets.xcassets/brandon-profile-pic.imageset/` — Brandon's profile photo registered as 1x asset
- `BlossomHubs/Assets.xcassets/max-profile-pic.imageset/` — Max's profile photo registered as 1x asset
- `BlossomHubs/Assets.xcassets/moe-profile-pic.imageset/` — Moe's profile photo registered as 1x asset
- `BlossomHubs/Assets.xcassets/canada-tshirt-profile-pic.imageset/` — Canadian in a T-shirt profile photo registered as 1x asset
- `BlossomHubs/Assets.xcassets/blossom-logo-light.imageset/` — Blossom light mode logo registered as 1x asset
- `BlossomHubs/Assets.xcassets/blossom-logo-dark.imageset/` — Blossom dark mode logo registered as 1x asset
- `BlossomHubs/Assets.xcassets/blossom-logo-icon.imageset/` — Blossom icon (square) registered as 1x asset
- `BlossomHubs/App/BlossomHubsApp.swift` — Added @State store = CommunityStore(), .environment(store), DEBUG assertion via .task
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` — Added Models group with Community.swift and CommunityStore.swift in PBXGroup, PBXFileReference, and PBXSourcesBuildPhase

## Decisions Made

- PostType enum uses `.text`, `.tradeHighlight`, `.youtubeLink` — gives Phase 6 content feed a discriminator for conditional rendering
- `logoImageName` on Community reuses creator `profileImageName` for now — Phase 3+ can add dedicated community logo assets
- DEBUG assertion placed in `.task {}` modifier on ContentView (not `init()`) because `@State` store isn't accessible from `init`
- Each ambassador community implemented as a `private extension CommunityStore` — clean separation, easy to find and edit individual communities

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- CommunityStore is ready for use via `@Environment(CommunityStore.self)` in any view
- All 6 ambassador profile photos and 3 logo variants available via `Image("asset-name")`
- Phase 3 can immediately build the CommunityDetailView using `Community`, `Creator`, `Tier` types
- Human verification of build success and dark mode rendering: APPROVED 2026-03-11
- Phase 3 is cleared to begin

---
*Phase: 02-design-system-and-mock-data*
*Completed: 2026-03-11*
