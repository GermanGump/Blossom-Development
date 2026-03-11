---
phase: 02-design-system-and-mock-data
plan: 02
subsystem: ui
tags: [swiftui, design-system, components, blossom-theme, blossom-font, inter, xcodeproj]

# Dependency graph
requires:
  - phase: 02-01
    provides: BlossomTheme color tokens and BlossomFont enum with Inter font weights
provides:
  - BlossomCard ViewModifier (cardSurface bg, cardBorder stroke, 12px radius, shadow)
  - BlossomPrimaryButton, BlossomSecondaryButton, BlossomGhostButton ButtonStyles
  - VerifiedBadge teal capsule with checkmark shield
  - TagView pill with .stock/.tier/.category enum styles
  - SectionHeader with optional trailing action
  - EmptyStateView with icon, title, subtitle, optional CTA
  - LockedContentOverlay with blur + scrim + tier upgrade prompt
  - AvatarSize enum with .small/.medium/.large/.xlarge presets
  - AvatarView showVerifiedBadge param for creator profiles
  - All Phase 1 views retrofitted to BlossomFont and BlossomTheme tokens
affects:
  - 02-03 (mock data — hub cards will use BlossomCard, TagView, VerifiedBadge)
  - 03-hubs-feature (hub list, hub detail screens compose from these primitives)
  - 04-feed-feature
  - 05-creator-profile
  - 06-portfolio
  - 07-markets

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "ViewModifier pattern for card styling — use .blossomCard() on any view"
    - "ButtonStyle conformance for consistent press states across all buttons"
    - "TagStyle enum drives both foreground and background opacity from single token"
    - "AvatarSize enum maps to CGFloat rawValue — keeps design intent in one place"
    - "Two separate badge params on AvatarView: showBadge (ambassador bolt) vs showVerifiedBadge (creator)"

key-files:
  created:
    - BlossomHubs/Core/Components/BlossomCard.swift
    - BlossomHubs/Core/Components/BlossomButton.swift
    - BlossomHubs/Core/Components/VerifiedBadge.swift
    - BlossomHubs/Core/Components/TagView.swift
    - BlossomHubs/Core/Components/SectionHeader.swift
    - BlossomHubs/Core/Components/EmptyStateView.swift
    - BlossomHubs/Core/Components/LockedContentOverlay.swift
  modified:
    - BlossomHubs/Core/Components/AvatarView.swift
    - BlossomHubs/Core/Components/PlaceholderTabView.swift
    - BlossomHubs/Features/TabBar/BlossomTabBar.swift
    - BlossomHubs/Features/Hubs/HubsView.swift
    - BlossomHubs/Features/Hubs/HubsTopNavBar.swift
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj

key-decisions:
  - "SF Symbol icon sizing uses .font(.system(size:)) — this is intentional and not a violation of the no-system-fonts rule; BlossomFont tokens apply to text only"
  - "showVerifiedBadge (creator profile) and showBadge (ambassador bolt) are intentionally separate params on AvatarView — they serve different semantic purposes"
  - "LockedContentOverlay uses ignoresSafeArea on the scrim to fully cover the content area"
  - "BlossomGhostButton omits frame(maxWidth: .infinity) — ghost buttons are inline, not full-width CTAs"

patterns-established:
  - "All text in SwiftUI views must use BlossomFont.* — never .font(.system), .font(.title), .font(.headline), etc."
  - "All color references must use BlossomTheme.* tokens — never Color(UIColor.systemGray6), hardcoded hex, or Color.secondary"
  - "Card layouts use .blossomCard() modifier — not manual background/border/shadow chains"
  - "Buttons use named ButtonStyle conformances — not inline styling or overlapping modifiers"

requirements-completed: [FOUND-04]

# Metrics
duration: 15min
completed: 2026-03-11
---

# Phase 2 Plan 02: UI Component Primitives Summary

**7 reusable SwiftUI component primitives (BlossomCard, 3 ButtonStyles, VerifiedBadge, TagView, SectionHeader, EmptyStateView, LockedContentOverlay) and full BlossomFont/BlossomTheme retrofit of all Phase 1 views**

## Performance

- **Duration:** 15 min
- **Started:** 2026-03-11T17:45:00Z
- **Completed:** 2026-03-11T18:00:00Z
- **Tasks:** 2 of 2
- **Files modified:** 13

## Accomplishments
- Created all 7 shared UI primitives — feature phases (3-9) can now compose screens from these building blocks without inline styling
- Enhanced AvatarView with AvatarSize enum presets and showVerifiedBadge parameter while maintaining full backward compatibility with existing `size: 44` callers
- Retrofitted all Phase 1 views (PlaceholderTabView, BlossomTabBar, HubsView, HubsTopNavBar) to BlossomFont text tokens and BlossomTheme semantic color tokens — no SF Pro, no raw system colors
- Registered all 7 new files in project.pbxproj source build phase via xcodeproj gem

## Task Commits

Each task was committed atomically:

1. **Task 1: Create 7 shared UI component primitives** - `d84f91e` (feat)
2. **Task 2: Enhance AvatarView and retrofit Phase 1 views** - `98561b5` (feat)

**Plan metadata:** (docs commit follows)

## Files Created/Modified
- `BlossomHubs/Core/Components/BlossomCard.swift` - ViewModifier with cardSurface/cardBorder/shadow; `.blossomCard()` extension
- `BlossomHubs/Core/Components/BlossomButton.swift` - BlossomPrimaryButton, BlossomSecondaryButton, BlossomGhostButton ButtonStyles
- `BlossomHubs/Core/Components/VerifiedBadge.swift` - Teal capsule with checkmark.shield.fill + "Verified" text
- `BlossomHubs/Core/Components/TagView.swift` - Pill labels with TagStyle enum (.stock/.tier/.category)
- `BlossomHubs/Core/Components/SectionHeader.swift` - Title + optional trailing teal action button
- `BlossomHubs/Core/Components/EmptyStateView.swift` - SF symbol + title + subtitle + optional CTA
- `BlossomHubs/Core/Components/LockedContentOverlay.swift` - Blur + scrim + lock icon + tier upgrade CTA
- `BlossomHubs/Core/Components/AvatarView.swift` - Added AvatarSize enum, imageName init, showVerifiedBadge
- `BlossomHubs/Core/Components/PlaceholderTabView.swift` - Retrofitted to BlossomFont/BlossomTheme
- `BlossomHubs/Features/TabBar/BlossomTabBar.swift` - Tab labels now use BlossomFont.caption
- `BlossomHubs/Features/Hubs/HubsView.swift` - Retrofitted to BlossomFont/BlossomTheme
- `BlossomHubs/Features/Hubs/HubsTopNavBar.swift` - Search field, badge text, and icon colors now use BlossomTheme tokens
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` - 7 new files registered in Components group and Sources build phase

## Decisions Made
- SF Symbol icon sizing via `.font(.system(size:))` is intentional and correct — the no-system-fonts rule applies to text rendering, not SF Symbol point-size control. SwiftUI has no BlossomFont equivalent for icon sizing.
- `showVerifiedBadge` and `showBadge` are separate params: verified badge = creator profile identity; bolt badge = ambassador/highlight status. Different semantic purposes, coexist independently.
- `BlossomGhostButton` omits `frame(maxWidth: .infinity)` — ghost buttons are inline action links, not full-width submit buttons.
- Search bar background in HubsTopNavBar changed from `Color(UIColor.systemGray6)` to `BlossomTheme.cardSurface` — adapts correctly in dark mode.

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness
- All component primitives available for Plan 02-03 (mock data) and all feature phases
- Hub cards in Plan 02-03 should use `.blossomCard()`, `TagView`, `VerifiedBadge`, `SectionHeader`
- `LockedContentOverlay` will be wired to real tier data in Phase 3-7 (currently accepts any `tierName: String`)
- `EmptyStateView` ready for Hubs empty state once real data layer exists

## Self-Check: PASSED

All 9 expected files exist. Both task commits (d84f91e, 98561b5) verified in git log.

---
*Phase: 02-design-system-and-mock-data*
*Completed: 2026-03-11*
