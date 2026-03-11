# Roadmap: Blossom Communities

## Overview

Build a Patreon-inspired paid communities feature as a native SwiftUI prototype, integrated as the 6th tab in the Blossom iOS app. The work flows from an unbreakable foundation (architecture, design tokens, mock data) through the subscriber journey (discovery, preview, payment, hub, engagement) and finishes with creator tools and earnings. Each phase delivers a coherent, independently verifiable capability. Phases 1-2 are load-bearing infrastructure; Phases 3-9 are feature delivery following the actual user journey dependency graph.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Project Scaffold and Swift Architecture** - Xcode project, tab bar, per-tab NavigationStack, Swift 6.2 conventions, ComponentsKit SPM (completed 2026-03-11)
- [ ] **Phase 2: Design System and Mock Data** - Brand tokens, Inter font, dark mode, shared components, MockDataService, all seed data and ambassador assets
- [ ] **Phase 3: Discovery and Community Preview** - Splash intro, community browse cards, community preview page, tier listing and benefit expansion
- [ ] **Phase 4: Subscription Flow and Celebration** - Mocked Stripe sheet, payment state machine, confetti animation, subscription transition, subscription management
- [ ] **Phase 5: Community Hub and Navigation Structure** - Community landing page, link-tree navigation, section tab bar, per-community routing
- [ ] **Phase 6: Content Feed and Tier-Gated Access** - Creator content feed, investing-native post types, YouTube deep links, locked-content overlays, content collections
- [ ] **Phase 7: Engagement: Forums and FAQ** - Discussion forums, thread creation and replies, likes, tier badges, FAQ zone, creator answers
- [ ] **Phase 8: Creator Dashboard** - Creator entry point, community setup, tier editor, permissions matrix, content publishing, verified badge
- [ ] **Phase 9: Creator Earnings and Demo Polish** - Earnings view with SwiftUI Charts, end-to-end demo verification, dark mode audit, animation polish

## Phase Details

### Phase 1: Project Scaffold and Swift Architecture
**Goal**: The Xcode project runs in Simulator with the 6-tab Blossom navigation structure, correct per-tab NavigationStack isolation, Swift 6.2 concurrency conventions, and ComponentsKit integrated — every subsequent phase builds on this without refactoring
**Depends on**: Nothing (first phase)
**Requirements**: FOUND-01, FOUND-02, FOUND-03, FOUND-07, FOUND-08
**Success Criteria** (what must be TRUE):
  1. App launches in Xcode Simulator and displays a 6-tab bar with tabs labelled Home, Hubs, Markets, Learn, Portfolio, Insights
  2. Tapping between tabs does not bleed navigation state — each tab maintains its own independent back-stack
  3. All @Observable view model classes are annotated @MainActor and the project compiles with zero Swift 6 strict concurrency warnings
  4. ComponentsKit resolves as an SPM dependency and the project builds cleanly
**Plans:** 2/2 plans complete

Plans:
- [x] 01-01-PLAN.md — Xcode project scaffold, build settings, ComponentsKit SPM, core types (AppTab enum, BlossomTheme)
- [x] 01-02-PLAN.md — Custom scrollable tab bar, per-tab NavigationStack, Hubs top nav bar, placeholder tabs, visual checkpoint

### Phase 2: Design System and Mock Data
**Goal**: Every visual building block needed by feature screens exists as a reusable, brand-compliant component — color tokens, typography, card modifiers, shared UI primitives, and a fully seeded mock data layer — so no feature phase introduces inline hex values or raw mock arrays
**Depends on**: Phase 1
**Requirements**: FOUND-04, FOUND-05, FOUND-06, FOUND-09, FOUND-10, FOUND-11
**Success Criteria** (what must be TRUE):
  1. Switching the device between light and dark mode causes every screen to adapt correctly — no white cards on white backgrounds, no invisible text
  2. All body text and headlines render in Inter (Regular, Medium, Semi-Bold) — confirmed via UIFont.familyNames debug output and visual inspection against brand reference
  3. The mock data layer provides at least 3 communities with creators, tiers, posts, forum threads, and FAQ entries accessible via CommunityStore — no feature screen imports raw mock arrays directly
  4. All 6 ambassador profile photos (BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt) and all 3 Blossom logo variants load from the asset catalog without placeholder images
  5. Brand colors (Violet #7361F7, Orange #FF7833, Teal #35C7B2, Dark Navy #1E222A, Slate #565E76) are defined as named Asset Catalog color sets with light/dark variants — zero inline hex Color values in feature views
**Plans:** 3/3 plans executed (awaiting human-verify checkpoint)

Plans:
- [x] 02-01-PLAN.md — Asset Catalog color sets (10 colors with light/dark), Inter font registration, BlossomFont enum, BlossomTheme refactor (completed 2026-03-11)
- [x] 02-02-PLAN.md — Shared UI components (BlossomCard, BlossomButton, VerifiedBadge, TagView, SectionHeader, EmptyStateView, LockedContentOverlay), AvatarView enhancement, Phase 1 view retrofit (completed 2026-03-11)
- [x] 02-03-PLAN.md — Data models (Community, Creator, Tier, Post, ForumThread, FAQEntry), CommunityStore with 6 communities, ambassador photos, logo assets, environment injection (completed 2026-03-11, visual checkpoint pending)

### Phase 3: Discovery and Community Preview
**Goal**: A subscriber opening the Communities tab can browse available communities, see enough information on each card to choose one, and view a full preview page with tier options that makes the value proposition clear before committing to subscribe
**Depends on**: Phase 2
**Requirements**: DISC-01, DISC-02, DISC-03, DISC-04, SUBS-01, SUBS-02, SUBS-03
**Success Criteria** (what must be TRUE):
  1. Opening the Communities tab shows a splash/intro screen with the centered Blossom logo before transitioning to the browse view
  2. The discovery screen displays scrollable community cards — each card shows the community logo, name, creator profile photo (circular with verified badge), brief description, and member count
  3. Tapping a community card navigates to that community's preview page without navigating in any other tab
  4. The community preview page shows the full description, creator bio, and value proposition, with 1-4 tier options listed at their creator-defined names and monthly prices
  5. Tapping a tier expands a tray showing that tier's benefit list, included content types, and monthly cost
**Plans**: TBD

### Phase 4: Subscription Flow and Celebration
**Goal**: A subscriber can complete a mock payment for any tier, experience a celebratory confetti moment, and arrive inside the subscribed community — and the app correctly reflects their active subscription with the ability to change or cancel it
**Depends on**: Phase 3
**Requirements**: SUBS-04, SUBS-05, SUBS-06, SUBS-07, SUBS-08
**Success Criteria** (what must be TRUE):
  1. Tapping "Subscribe" on a tier sheet presents a mock Stripe payment sheet with card number, expiry, and CVC fields — no real network call is made
  2. Submitting payment triggers a visible loading state followed by a success state — the app never stays on a permanent spinner
  3. A confetti animation plays with the Blossom logo centered on screen after successful payment — the confetti clears cleanly and does not re-trigger on subsequent navigation
  4. After celebration, the user lands on the subscribed community landing page — not the discovery screen
  5. A subscribed user can upgrade tier, downgrade tier, or cancel their subscription from within the app — these actions update the in-memory UserSession state immediately
**Plans**: TBD

### Phase 5: Community Hub and Navigation Structure
**Goal**: A subscribed user can navigate the inside of a community via a clear landing page and section-switching controls — the structural skeleton that all content and engagement screens attach to
**Depends on**: Phase 4
**Requirements**: HUB-01, HUB-02, HUB-08
**Success Criteria** (what must be TRUE):
  1. The community landing page displays the community logo, banner image, title, and a 1-2 sentence description for every community in the mock data set
  2. The link-tree style navigation on the landing page shows tappable section buttons (Discussion, Videos, FAQ, etc.) that navigate to the correct community section
  3. A segmented control or tab switcher at the top of the community allows switching between Posts, Discussions, FAQ, and Videos without leaving the community
**Plans**: TBD

### Phase 6: Content Feed and Tier-Gated Access
**Goal**: A subscribed user can browse the creator's content feed, see investing-native post types including trade highlights, tap YouTube links to open the YouTube app, and see locked-content prompts when accessing content above their tier — with content organized by collection
**Depends on**: Phase 5
**Requirements**: HUB-03, HUB-04, HUB-05, HUB-06, HUB-07
**Success Criteria** (what must be TRUE):
  1. The content feed displays creator posts in chronological order, including text posts, trade highlight cards with stock ticker tags, and YouTube link cards
  2. Tapping a YouTube link card opens the YouTube app (or Safari fallback) — no inline video player appears
  3. A subscriber on a lower tier sees locked post previews for above-tier content with a specific upgrade prompt naming the required tier (not a generic padlock)
  4. Content is browseable by named collection — tapping "Swing Trade Alerts" or "Education" filters the feed to that collection
**Plans**: TBD

### Phase 7: Engagement: Forums and FAQ
**Goal**: Subscribed users can participate in tier-gated discussion forums — creating threads, replying, and liking — and access the FAQ zone to submit questions that creators can answer, with all creator replies visually distinguished
**Depends on**: Phase 6
**Requirements**: ENGR-01, ENGR-02, ENGR-03, ENGR-04, ENGR-05, ENGR-06
**Success Criteria** (what must be TRUE):
  1. The forums section shows discussion threads and each post displays the poster's tier badge — a user without forum access sees a locked state naming the required tier
  2. A subscribed user with forum access can create a new discussion thread, reply to an existing thread, and like a post — all interactions update the in-memory state immediately without a network call
  3. The FAQ zone is visible to all subscribed users, but only users with the correct tier permission can tap "Ask a Question" — users without permission see a prompt naming the required tier
  4. Submitted FAQ questions can be answered by the creator, and answered entries appear as persistent discoverable records in the FAQ view
  5. Creator and ambassador replies in both forums and FAQ have a distinct visual treatment (highlighted background or badge) that distinguishes them from member posts
**Plans**: TBD

### Phase 8: Creator Dashboard
**Goal**: A user identified as a community creator can access a dashboard to set up their community, define tiers with names and prices, configure permissions per tier, publish posts to collections, and see their verified creator badge throughout the app
**Depends on**: Phase 7
**Requirements**: CRTR-01, CRTR-02, CRTR-03, CRTR-04, CRTR-05, CRTR-07
**Success Criteria** (what must be TRUE):
  1. A creator can reach the Creator Dashboard via a role toggle or dedicated entry point — non-creator users do not see this entry point
  2. The creator can edit their community's logo, banner, title, description, and link-tree section configuration, and changes are reflected immediately in the subscriber-facing community landing page
  3. The tier editor lets the creator define 1-4 tiers with custom names, monthly prices, and benefit descriptions — saving updates are reflected across all tier display surfaces
  4. The permissions matrix shows a grid of content sections versus tier levels — the creator can grant or revoke access per cell, and those changes drive the PermissionGate evaluations seen by subscribers
  5. The creator can write and publish a new post, assign it to a named collection, and set a tier-gate level — the post appears in the content feed with the correct gating applied
  6. A verified badge appears on creator/ambassador profiles throughout the app — discovery cards, forum posts, FAQ entries
**Plans**: TBD

### Phase 9: Creator Earnings and Demo Polish
**Goal**: The creator earnings view presents a clear revenue breakdown with a SwiftUI Charts visualization, and the complete subscriber demo flow runs end-to-end without dark mode gaps, font rendering issues, or broken permission states — the prototype is demo-ready
**Depends on**: Phase 8
**Requirements**: CRTR-06
**Success Criteria** (what must be TRUE):
  1. The earnings view displays gross earnings, the 10% Blossom platform fee deduction, and net payout — the math is correct across all mock data scenarios
  2. The earnings view includes a SwiftUI Charts bar chart or line chart showing revenue trend over time
  3. The complete subscriber demo flow runs without visible errors: discovery splash -> browse communities -> community preview -> tier expansion -> mock payment -> confetti -> community landing -> content feed -> locked content prompt -> forum thread -> FAQ submission
  4. Every screen in the subscriber demo flow passes a dark mode check — no invisible text, no white-on-white cards, no unthemed system colors
  5. Inter font renders at the correct weight on all text styles across the full demo flow — no silent fallback to SF Pro
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Project Scaffold and Swift Architecture | 2/2 | Complete   | 2026-03-11 |
| 2. Design System and Mock Data | 3/3 | Checkpoint |  |
| 3. Discovery and Community Preview | 0/TBD | Not started | - |
| 4. Subscription Flow and Celebration | 0/TBD | Not started | - |
| 5. Community Hub and Navigation Structure | 0/TBD | Not started | - |
| 6. Content Feed and Tier-Gated Access | 0/TBD | Not started | - |
| 7. Engagement: Forums and FAQ | 0/TBD | Not started | - |
| 8. Creator Dashboard | 0/TBD | Not started | - |
| 9. Creator Earnings and Demo Polish | 0/TBD | Not started | - |
