---
phase: 07-engagement-forums-and-faq
plan: 02
subsystem: ui
tags: [swiftui, faq, accordion, tier-gating, observable]

# Dependency graph
requires:
  - phase: 07-engagement-forums-and-faq
    provides: "CommunitySectionPager with .faq placeholder, FAQEntry model, teal tint pattern from forums"
provides:
  - "FAQListView with tier-gated inline ask field and accordion entry list"
  - "FAQEntryRow with answered/unanswered states and teal tint creator attribution"
  - "FAQViewModel with sorted entries and question submission"
affects: [08-creator-tools]

# Tech tracking
tech-stack:
  added: []
  patterns: ["FAQ accordion with expandedEntryID UUID? single-expansion", "Teal tint opacity(0.08) reuse for creator answer attribution"]

key-files:
  created:
    - BlossomHubs/Features/Hubs/FAQ/FAQViewModel.swift
    - BlossomHubs/Features/Hubs/FAQ/FAQEntryRow.swift
    - BlossomHubs/Features/Hubs/FAQ/FAQListView.swift
  modified:
    - BlossomHubs/Features/Hubs/Community/CommunitySectionPager.swift
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj

key-decisions:
  - "FAQ accordion uses expandedEntryID UUID? pattern matching TiersBottomSheet for single-expansion"
  - "Teal tint opacity(0.08) reused from forum creator replies for answered FAQ entry backgrounds (ENGR-06 consistency)"
  - "FAQListView follows ContentFeedView pattern: no own ScrollView, lazy init viewModel, TiersBottomSheet reuse"

patterns-established:
  - "FAQ accordion with single-expansion via expandedEntryID UUID?"
  - "Inline ask field with tier-gated disable and orange upgrade prompt"

requirements-completed: [ENGR-04, ENGR-05, ENGR-06]

# Metrics
duration: 2min
completed: 2026-03-15
---

# Phase 7 Plan 02: FAQ Zone Summary

**FAQ accordion with tier-gated question submission, expandable answered entries with teal tint creator attribution, and CommunitySectionPager integration**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-15T14:37:56Z
- **Completed:** 2026-03-15T14:40:07Z
- **Tasks:** 1
- **Files modified:** 5

## Accomplishments
- Accordion FAQ list with answered entries sorted first (green checkmark) and unanswered below (clock icon)
- Expandable answered entries show answer text with teal tint background and creator attribution badge
- Inline ask field at top with tier-gated permission and orange upgrade prompt linking to TiersBottomSheet
- CommunitySectionPager .faq case replaced from EmptyStateView to FAQListView

## Task Commits

Each task was committed atomically:

1. **Task 1: FAQViewModel, FAQEntryRow, FAQListView with pager wiring** - `a50a43f` (feat)

## Files Created/Modified
- `BlossomHubs/Features/Hubs/FAQ/FAQViewModel.swift` - FAQ state management with sorted entries, tier-gated question submission
- `BlossomHubs/Features/Hubs/FAQ/FAQEntryRow.swift` - Expandable FAQ row with answered/unanswered states, teal tint creator attribution
- `BlossomHubs/Features/Hubs/FAQ/FAQListView.swift` - Top-level FAQ view with inline ask field, accordion list, upgrade sheet
- `BlossomHubs/Features/Hubs/Community/CommunitySectionPager.swift` - Replaced .faq EmptyStateView with FAQListView
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` - Registered 3 FAQ files under FAQ group

## Decisions Made
- FAQ accordion uses expandedEntryID UUID? pattern matching TiersBottomSheet for single-expansion
- Teal tint opacity(0.08) reused from forum creator replies for answered FAQ entry backgrounds (ENGR-06 consistency)
- FAQListView follows ContentFeedView pattern: no own ScrollView, lazy init viewModel, TiersBottomSheet reuse

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Phase 7 complete -- all engagement features (forums + FAQ) are built
- Ready for Phase 8 (creator tools)
- FAQ entries use mock data from CommunityStore, ready for creator answer management in Phase 8

## Self-Check: PASSED

All 3 created files verified on disk. Commit a50a43f verified in git log. Build succeeded with zero errors.

---
*Phase: 07-engagement-forums-and-faq*
*Completed: 2026-03-15*
