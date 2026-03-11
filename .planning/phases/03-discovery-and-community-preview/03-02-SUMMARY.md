---
phase: 03-discovery-and-community-preview
plan: 02
subsystem: ui
tags: [swiftui, navigation, parallax, visualeffect, accordion, bottomsheet, observable, animation]

# Dependency graph
requires:
  - phase: 02-design-system-and-component-library
    provides: BlossomTheme, BlossomFont, AvatarView, TagView, BlossomCard, VerifiedBadge, BlossomPrimaryButton
  - phase: 03-01
    provides: HubsRoute.communityPreview navigation, CommunityStore mock data, HubsView navigationDestination stub

provides:
  - CommunityPreviewView — full preview page with parallax banner, creator bio, social proof, sticky CTA
  - CommunityPreviewViewModel — @MainActor @Observable VM with popularTierIndex heuristic
  - TiersBottomSheet — bottom sheet with tier card list, single-expansion accordion state
  - TierCardView — single tier card with accordion header, benefits list, Subscribe button

affects:
  - 03-03 (subscription confirmation, uses community.tiers and HubsRoute.communityDetail)
  - future phases using the Subscribe button action (Phase 4 wires payment)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - visualEffect(_:) for parallax scroll — reads proxy.frame(in: .scrollView).minY, applies offset(y: -offsetY * 0.4) when pulling down
    - safeAreaInset(edge: .bottom) for sticky CTA — cleaner than ZStack overlay, respects tab bar
    - Accordion expansion via UUID? state — expandedTierID collapses previous automatically (single-match property)
    - withAnimation(.spring(response:dampingFraction:)) on onTap handler for sheet accordion
    - .transition(.opacity.combined(with: .move(edge: .top))) on expanded content
    - Lazy ViewModel init via @State optional + .onAppear — CommunityStore environment not available at struct init

key-files:
  created:
    - BlossomHubs/Features/Hubs/Preview/CommunityPreviewView.swift
    - BlossomHubs/Features/Hubs/Preview/CommunityPreviewViewModel.swift
    - BlossomHubs/Features/Hubs/Preview/TiersBottomSheet.swift
    - BlossomHubs/Features/Hubs/Preview/TierCardView.swift
  modified:
    - BlossomHubs/Features/Hubs/HubsView.swift
    - BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj

key-decisions:
  - "CommunityPreviewViewModel initialized as @State optional in .onAppear — matches Phase 03-01 pattern for deferred @Environment access"
  - "popularTierIndex heuristic: index 1 when 2+ tiers, index 0 when single tier — mock logic, Phase 4 replaces with server data"
  - "Gradient fallback (violet→teal LinearGradient) when bannerImageName is nil — consistent with brand identity"
  - "SocialProofSection uses per-community hardcoded testimonials keyed on community.name — mock data only, Phase 4 replaces"
  - "expandedTierID UUID? state provides single-expansion accordion — no extra toggle logic needed, UUID equality guarantees uniqueness"

# Metrics
duration: 3min
completed: 2026-03-11
---

# Phase 3 Plan 02: Community Preview and Tiers Bottom Sheet Summary

**Community preview sell page with parallax banner and creator bio leading to accordion tier bottom sheet — the full subscriber conversion funnel from discovery tap to Subscribe button**

## Performance

- **Duration:** 3 min
- **Started:** 2026-03-11T23:45:35Z
- **Completed:** 2026-03-11T23:48:08Z
- **Tasks:** 2
- **Files modified:** 6

## Accomplishments

- CommunityPreviewView with `visualEffect(_:)` parallax banner — reads `proxy.frame(in: .scrollView).minY` and applies `offset(y: -offsetY * 0.4)` when positive, providing subtle depth on downward overscroll
- Creator xlarge avatar overlapping banner bottom edge — negative `offset(y: -40)` with white stroke ring provides visual separation from banner image or gradient
- Social proof section with member count, 5-avatar overlapping row, and per-community hardcoded testimonial quote with violet left-border accent card
- Sticky "View Tiers" CTA using `.safeAreaInset(edge: .bottom)` — floats above tab bar without obscuring scroll content
- TiersBottomSheet with manual header (title + X button), ScrollView tier list, single-expansion accordion via `expandedTierID: UUID?` state
- TierCardView accordion with `.transition(.opacity.combined(with: .move(edge: .top)))` and `.animation(.spring(response: 0.35, dampingFraction: 0.8), value: isExpanded)`
- Subscribe button styled with `BlossomPrimaryButton` and empty action body — Phase 4 wires payment

## Task Commits

1. **Task 1: Community preview page** - `eeeea2b` (feat)
2. **Task 2: Tiers bottom sheet** - `5cadbad` (feat)

## Files Created/Modified

- `BlossomHubs/Features/Hubs/Preview/CommunityPreviewView.swift` — Full preview page with parallax, creator bio, social proof, sticky CTA, sheet presentation
- `BlossomHubs/Features/Hubs/Preview/CommunityPreviewViewModel.swift` — @MainActor @Observable VM with popularTierIndex computed property
- `BlossomHubs/Features/Hubs/Preview/TiersBottomSheet.swift` — Bottom sheet with manual header, scrollable TierCardView list, expandedTierID accordion state
- `BlossomHubs/Features/Hubs/Preview/TierCardView.swift` — Single tier card with always-visible header, conditional expanded content with benefits + Subscribe
- `BlossomHubs/Features/Hubs/HubsView.swift` — `.communityPreview(let id)` case now routes to `CommunityPreviewView(communityID: id)`
- `BlossomHubs/BlossomHubs.xcodeproj/project.pbxproj` — Features/Hubs/Preview/ group with all 4 new files registered

## Decisions Made

- ViewModel initialized lazily in `.onAppear` as `@State` optional — same pattern as HubsDiscoveryViewModel from Phase 03-01 (CommunityStore @Environment unavailable at struct init)
- `popularTierIndex` heuristic picks index 1 for 2+ tiers — mock logic matching plan spec, Phase 4 replaces with backend-driven data
- Per-community testimonial quotes hardcoded in `SocialProofSection` keyed on `community.name` — Phase 4 replaces with real member reviews
- `expandedTierID: UUID?` accordion pattern — UUID equality provides single-expansion naturally without additional toggle state

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- CommunityPreviewView fully functional — tapping any community card from discovery navigates to preview page
- TiersBottomSheet wired — "View Tiers" sticky CTA presents sheet with accordion tier cards
- Subscribe button present but no-op — Phase 4 wires payment flow
- HubsRoute.communityDetail still routes to EmptyView — Phase 5 provides CommunityDetailView

---
*Phase: 03-discovery-and-community-preview*
*Completed: 2026-03-11*

## Self-Check: PASSED

- FOUND: BlossomHubs/Features/Hubs/Preview/CommunityPreviewView.swift
- FOUND: BlossomHubs/Features/Hubs/Preview/CommunityPreviewViewModel.swift
- FOUND: BlossomHubs/Features/Hubs/Preview/TiersBottomSheet.swift
- FOUND: BlossomHubs/Features/Hubs/Preview/TierCardView.swift
- FOUND: .planning/phases/03-discovery-and-community-preview/03-02-SUMMARY.md
- COMMIT eeeea2b: feat(03-02): community preview page with parallax banner, creator bio, social proof, and sticky CTA
- COMMIT 5cadbad: feat(03-02): tiers bottom sheet with accordion expansion and Subscribe button
